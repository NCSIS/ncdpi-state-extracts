SET NOCOUNT ON;

IF OBJECT_ID('tempdb..#IAMStudents') IS NOT NULL DROP TABLE #IAMStudents;
IF OBJECT_ID('tempdb..#IAMRosters') IS NOT NULL DROP TABLE #IAMRosters;

DECLARE @asof datetime2 = SYSDATETIME();
DECLARE @asofEnd datetime2 = dateadd(day,-1,@asof);

DECLARE @StudentAliasAttrID int =
(SELECT attributeID FROM dbo.CampusAttribute WHERE element = 'aliasIDstudents');

CREATE TABLE #IAMStudents(
  PUPIL_NUMBER      varchar(10)   NOT NULL,
  PERSON_ID         int           NOT NULL,
  CALENDAR_ID       int           NOT NULL,
  LAST_NAME         varchar(50)   NULL,
  FIRST_NAME        varchar(50)   NULL,
  MIDDLE_NAME       varchar(50)   NULL,
  NAME_SUFFIX       varchar(50)   NULL,
  BIRTH_DATE        char(10)      NULL,
  GRADE             varchar(3)    NULL,
  PSU_CODE          varchar(3)   NULL,
  PSU_DESC          varchar(254)  NULL,
  SCHOOL_CODE       varchar(6)   NULL,
  SCHOOL_DESC       varchar(254)  NULL,
  EMAIL             varchar(254)  NULL,
  ALIAS_ID          varchar(254)  NULL,
  MOD_DATE          char(10)      NULL,
  SERVICE_TYPE      varchar(1)   NULL,
  PICK_ROW          int           NOT NULL
);

WITH AliasIDPreferences AS (
    SELECT
        districtID,
        value
    FROM (
        SELECT
            districtID,
            value,
            row_number() over(partition by districtID order by date desc) as rn
        FROM [CustomDistrict]
        WHERE
            attributeID = @StudentAliasAttrID
            AND date<=@asof
    ) as T
    where rn=1
)
INSERT INTO #IAMStudents
SELECT
    s.[stateID] as PUPIL_NUMBER,
    s.[personID] as PERSON_ID,
    s.[calendarID] as CALENDAR_ID,
    REPLACE(s.[lastName],'"','') as LAST_NAME,
    REPLACE(s.[firstName],'"','') as FIRST_NAME,
    REPLACE(s.[middleName],'"','') as MIDDLE_NAME,
    REPLACE(s.[suffix],'"','') as NAME_SUFFIX,
    CONVERT(varchar(10), s.[birthdate], 101) as BIRTH_DATE,
    CASE s.[stateGrade] 
        WHEN 'XG' THEN '-9'
        WHEN 'ABE' THEN '-8'
        WHEN 'UG' THEN '-7'
        WHEN 'IT' THEN '-3'
        WHEN 'PR' THEN '-2'
        WHEN 'PK' THEN '-1'
        WHEN 'KG' THEN '0'
        WHEN '01' THEN '1'
        WHEN '02' THEN '2'
        WHEN '03' THEN '3'
        WHEN '04' THEN '4'
        WHEN '05' THEN '5'
        WHEN '06' THEN '6'
        WHEN '07' THEN '7'
        WHEN '08' THEN '8'
        WHEN '09' THEN '9'
        ELSE s.[stateGrade]
    END as GRADE,
    d.[number] as PSU_CODE,
    REPLACE(d.[name],'"','') as PSU_DESC,
    sch.[number] as SCHOOL_CODE,
    REPLACE(sch.[name],'"','') as SCHOOL_DESC,
    c.[email] as EMAIL,
    CASE
        WHEN a.value='DISABLE' THEN null
        WHEN d.[number] in ('280','260','120','862') THEN null
        ELSE REPLACE(c.[email],'`','')
    END as ALIAS_ID,
    CONVERT(varchar(10), s.[modifiedDate], 101) as MOD_DATE,
    s.[serviceType] as SERVICE_TYPE,
    ROW_NUMBER() OVER(PARTITION BY s.[stateID],s.[schoolID] ORDER BY s.[serviceType] ASC) as PICK_ROW
FROM
    [student] s --student view
    LEFT JOIN [school] sch ON sch.[schoolID] = s.[schoolID] --to get school num and name
    LEFT JOIN [district] d ON d.[districtID] = s.[districtID] --to get PSU num and name
    LEFT JOIN [contact] c ON c.[personID] = s.[personID] AND c.[districtID] = s.[districtID] --to get student email from current PSU only
    LEFT JOIN AliasIDPreferences a on a.districtID = s.[districtID]
WHERE 1=1
    AND len(s.[stateID]) between 5 and 10 --UID is between 5 and 10 characters in length.
    AND s.[enrollmentStateExclude] = 0 --not state excluded
    AND (s.[endDate] IS NULL OR s.[endDate] >= @asofEnd /*OR s.[endStatus] NOT IN ('W1','W2','W2T','W3','W4','W6') OR s.[endStatus] IS NULL*/) --end date is null or future or end status isn't real, but temp removed end status logic for BOY 25-26
    AND s.[activeYear] = 1; --is an active enrollment

CREATE CLUSTERED INDEX IXc_Students ON #IAMStudents (PERSON_ID, SCHOOL_CODE);

SELECT DISTINCT
    ist.PERSON_ID as PERSON_ID, p.[staffStateID] as TEACHER_STAFF_ID
INTO #IAMRosters
FROM
    #IAMStudents ist
    LEFT JOIN [activeTrial] actr ON actr.[calendarID] = ist.CALENDAR_ID --we need activeTrial to filter Rosters to current PSU
    LEFT JOIN [Roster] r ON r.[personID] = ist.PERSON_ID AND r.[trialID] = actr.[trialID] --rosters matching the student -and- their activeTrial
    LEFT JOIN [Section] sec ON sec.[sectionID] = r.[sectionID] --to get teacher
    LEFT JOIN [Person] p ON p.[personID] = sec.[teacherPersonID] --and to get that teacher's UID
WHERE 1=1
    AND r.[startDate] <= @asof --started roster enrollments only
    AND r.[endDate] >= @asofEnd --non-ended roster enrollments only
    AND len(p.[staffStateID])=10; --Staff UID is 10 characters in length.

CREATE NONCLUSTERED INDEX IX_Rosters_Person ON #IAMRosters (PERSON_ID)
INCLUDE (TEACHER_STAFF_ID);

SELECT
    PUPIL_NUMBER,
    LAST_NAME,
    FIRST_NAME,
    MIDDLE_NAME,
    NAME_SUFFIX,
    BIRTH_DATE,
    GRADE,
    PSU_CODE,
    PSU_DESC,
    SCHOOL_CODE,
    SCHOOL_DESC,
    EMAIL,
    STRING_AGG(TEACHER_STAFF_ID,'::') within group (order by TEACHER_STAFF_ID) as TEACHER_STAFF_ID,
    ALIAS_ID,
    MOD_DATE
    /*,CASE SERVICE_TYPE
        WHEN 'P' THEN 'P'
        ELSE NULL
    END as SERVICE_TYPE*/
FROM #IAMStudents s
LEFT JOIN #IAMRosters r ON s.PERSON_ID = r.PERSON_ID
WHERE s.PICK_ROW=1
GROUP BY
    PUPIL_NUMBER,
    LAST_NAME,
    FIRST_NAME,
    MIDDLE_NAME,
    NAME_SUFFIX,
    BIRTH_DATE,
    GRADE,
    PSU_CODE,
    PSU_DESC,
    SCHOOL_CODE,
    SCHOOL_DESC,
    EMAIL,
    ALIAS_ID,
    MOD_DATE
    /*,SERVICE_TYPE*/;