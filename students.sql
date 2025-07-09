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
            attributeID = (select attributeID from [CampusAttribute] where element = 'aliasIDstudents')
            AND date<=getdate()
    ) as T
    where rn=1
)

SELECT
    s.[stateID] as PUPIL_NUMBER,
    REPLACE(s.[lastName],'"','') as LAST_NAME,
    REPLACE(s.[firstName],'"','') as FIRST_NAME,
    REPLACE(s.[middleName],'"','') as MIDDLE_NAME,
    REPLACE(s.[suffix],'"','') as NAME_SUFFIX,
    CONVERT(varchar(10), s.[birthdate], 101) as BIRTH_DATE,
    CASE s.[stateGrade] 
        WHEN 'XG' THEN '-9'
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
    STUFF(
        (
            SELECT DISTINCT
                '::' + p.[staffStateID]
            FROM
                [activeTrial] actr --we need activeTrial to filter Rosters to current PSU
                LEFT OUTER JOIN [Roster] r ON r.[personID] = s.[personID] AND r.[trialID] = actr.[trialID] --rosters matching the student -and- their activeTrial
                LEFT OUTER JOIN [Section] sec ON sec.[sectionID] = r.[sectionID] --to get teacher
                LEFT OUTER JOIN [Person] p ON p.[personID] = sec.[teacherPersonID] --and to get that teacher's UID
            WHERE
                actr.[calendarID] = s.[calendarID]
                AND (r.[startDate] <= getdate()) --started roster enrollments only
                AND (r.[endDate] >= getdate()) --non-ended roster enrollments only
                AND len(p.[staffStateID])=10 --Staff UID is 10 characters in length.
            FOR XML PATH ('')
        ), 1, 2, ''
    ) as TEACHER_STAFF_ID,
    CASE
        WHEN a.value='DISABLE' THEN null
        WHEN d.[number] in ('280','260','120') THEN null
        ELSE REPLACE(c.[email],'`','')
    END as ALIAS_ID,
    CONVERT(varchar(10), s.[modifiedDate], 101) as MOD_DATE

FROM
    [student] s --student view
    LEFT OUTER JOIN [school] sch ON sch.[schoolID] = s.[schoolID] --to get school num and name
    LEFT OUTER JOIN [district] d ON d.[districtID] = s.[districtID] --to get PSU num and name
    LEFT OUTER JOIN [contact] c ON c.[personID] = s.[personID] AND c.[districtID] = s.[districtID] --to get student email from current PSU only
    LEFT OUTER JOIN AliasIDPreferences a on a.districtID = s.[districtID]

WHERE
    len(s.[stateID]) between 5 and 10 --UID is between 5 and 10 characters in length.
    AND s.[enrollmentStateExclude] = 0 --not state excluded
    AND (s.[endDate] IS NULL OR s.[endDate] >= getdate() OR s.[endStatus] NOT IN ('W1','W2','W2T','W3','W4','W6') OR s.[endStatus] IS NULL) --end date is null or future or end status isn't real
    AND s.[activeYear] = 1 --is an active enrollment

GROUP BY
    s.[personID],
    s.[calendarID],
    s.[stateID],
    s.[lastName],
    s.[firstName],
    s.[middleName],
    s.[suffix],
    s.[birthdate],
    s.[stateGrade],
    d.[number],
    d.[name],
    sch.[number],
    sch.[name],
    c.[email],
    s.[modifiedDate],
    a.value