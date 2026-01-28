SET NOCOUNT ON;

IF OBJECT_ID('tempdb..#IAMStaffSNRoles') IS NOT NULL DROP TABLE #IAMStaffSNRoles;

DECLARE @asof datetime2 = SYSDATETIME();
DECLARE @asofEnd datetime2 = dateadd(day,-1,@asof);

CREATE TABLE #IAMStaffSNRoles(
    STAFF_UID   varchar(10) NOT NULL,
    SCHOOL_CODE varchar(6)  NOT NULL,
    SCHOOLNET_ROLE  varchar(15)    NOT NULL,
    SCHOOLNET_ADD_ROLE nvarchar(max)    NULL
);

INSERT INTO #IAMStaffSNRoles
SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        CASE
            WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
            WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
            ELSE se.[SchoolNumber]
        END as SCHOOL_CODE,
        CASE se.[schoolnetRole]
            WHEN 1 THEN 'Teacher'
            WHEN 2 THEN 'Leadership'
            WHEN 3 THEN 'Staff'
        END as SCHOOLNET_ROLE,
        LTRIM(RTRIM(value)) as SCHOOLNET_ADD_ROLE
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
        OUTER APPLY STRING_SPLIT(se.[schoolnetAddRoles], ',')
    WHERE
        len(sm.[staffStateID])=10 --UID is 10 characters in length.
        AND LEFT(sm.[staffStateID],1) not in ('0','a','c','d','l')
        AND sm.[staffStateID]<>'9999999999'
        AND se.[assignmentStartDate] <= @asof --start date is today or prior
        AND (se.[assignmentEndDate] IS NULL OR se.[assignmentEndDate] >= @asofEnd) --end date is null or future
        AND se.[schoolnetRole] between 1 and 3
        AND se.[SchoolNumber] IS NOT NULL;

--Pull Primary Roles
SELECT DISTINCT
    STAFF_UID as STAFF_UID,
    SCHOOL_CODE + ':' + SCHOOLNET_ROLE as SCHOOLNET_ROLE
FROM #IAMStaffSNRoles

--Pull Test Item Admin roles for all
UNION ALL
SELECT DISTINCT
    STAFF_UID as STAFF_UID,
    SCHOOL_CODE + ':' + SCHOOLNET_ADD_ROLE as SCHOOLNET_ROLE
FROM #IAMStaffSNRoles
WHERE SCHOOLNET_ADD_ROLE='Test Item Administrator'

--Pull other additional roles for teachers/staff only
UNION ALL
SELECT DISTINCT
    STAFF_UID as STAFF_UID,
    SCHOOL_CODE + ':' + SCHOOLNET_ADD_ROLE as SCHOOLNET_ROLE
FROM #IAMStaffSNRoles
WHERE SCHOOLNET_ADD_ROLE <> 'Test Item Administrator' AND SCHOOLNET_ROLE <> 'Leadership'
ORDER BY STAFF_UID asc,SCHOOLNET_ROLE desc;

IF OBJECT_ID('tempdb..#IAMStaffSNRoles') IS NOT NULL DROP TABLE #IAMStaffSNRoles;