/*
Name: (NC) Schoolnet - Effective Staff Roles
Description: This validation lists the effective assigned Schoolnet roles for staff. Note, for Leadership, the only additional role pulled is "Test Item Administrator."
Group Name: (NC) Schoolnet - Staff Roles
Group Description:  This validation group lists active staff with effective Schoolnet roles, active staff with no Schoolnet roles, and active staff with invalid Schoolnet roles.
Created by: John Mairs
Created Date: 1/28/2026
Last Published Date: 
Revision History: See GitHub -- https://github.com/NCSIS/ncdpi-state-extracts/tree/main/IAM/data_validations
*/

DECLARE @schoolID INT = NULLIF ({selectedSchool}, 0)  --Selected School from Context Menu in UI
;
DECLARE @asof datetime2 = SYSDATETIME();
DECLARE @asofEnd datetime2 = dateadd(day,-1,@asof);

WITH IAMStaffSNRolesVal AS (
    SELECT DISTINCT
            sm.[staffStateID] as STAFF_UID,
            sm.[lastName] as LAST_NAME,
            sm.[firstName] as FIRST_NAME,
            se.[schoolName] as SCHOOL_NAME,
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
            AND se.[SchoolNumber] IS NOT NULL
            AND se.schoolID = ISNULL(@schoolID, sm.schoolID)
)
--Pull Primary Roles
SELECT DISTINCT
    STAFF_UID as STAFF_UID,
    LAST_NAME as LAST_NAME,
    FIRST_NAME as FIRST_NAME,
    SCHOOL_NAME as SCHOOL_NAME,
    SCHOOL_CODE + ':' + SCHOOLNET_ROLE as SCHOOLNET_ROLE
FROM IAMStaffSNRolesVal

--Pull Test Item Admin roles for all
UNION ALL
SELECT DISTINCT
    STAFF_UID as STAFF_UID,
    LAST_NAME as LAST_NAME,
    FIRST_NAME as FIRST_NAME,
    SCHOOL_NAME as SCHOOL_NAME,
    SCHOOL_CODE + ':' + SCHOOLNET_ADD_ROLE as SCHOOLNET_ROLE
FROM IAMStaffSNRolesVal
WHERE SCHOOLNET_ADD_ROLE='Test Item Administrator'

--Pull other additional roles for teachers/staff only
UNION ALL
SELECT DISTINCT
    STAFF_UID as STAFF_UID,
    LAST_NAME as LAST_NAME,
    FIRST_NAME as FIRST_NAME,
    SCHOOL_NAME as SCHOOL_NAME,
    SCHOOL_CODE + ':' + SCHOOLNET_ADD_ROLE as SCHOOLNET_ROLE
FROM IAMStaffSNRolesVal
WHERE SCHOOLNET_ADD_ROLE <> 'Test Item Administrator' AND SCHOOLNET_ROLE <> 'Leadership'
ORDER BY LAST_NAME asc, FIRST_NAME asc, SCHOOL_NAME asc, SCHOOLNET_ROLE desc;