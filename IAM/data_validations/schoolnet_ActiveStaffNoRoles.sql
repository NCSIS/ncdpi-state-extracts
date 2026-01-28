/*
Name: (NC) Schoolnet - Active Staff Without Roles
Description: This validation lists active staff with no assigned Schoolnet roles.
Group Name: (NC) Schoolnet - Staff Roles
Group Description:  This validation group lists active staff with effective Schoolnet roles, active staff with no Schoolnet roles, and active staff with invalid Schoolnet roles.
Created by: John Mairs
Created Date: 1/28/2026
Last Published Date: 
Revision History: See GitHub
*/
DECLARE @schoolID INT = NULLIF ({selectedSchool}, 0)  --Selected School from Context Menu in UI
;

DECLARE @asof datetime2 = SYSDATETIME();
DECLARE @asofEnd datetime2 = dateadd(day,-1,@asof);

SELECT DISTINCT
    sm.[staffStateID] as STAFF_UID,
    sm.[lastName] as LAST_NAME,
    sm.[firstName] as FIRST_NAME,
    se.[schoolName] as SCHOOL_NAME,
    CASE
        WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
        WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
        ELSE se.[SchoolNumber]
    END as SCHOOL_CODE
FROM [v_SchoolEmployment] se
    LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
WHERE
    len(sm.[staffStateID])=10 --UID is 10 characters in length.
    AND LEFT(sm.[staffStateID],1) not in ('0','a','c','d','l')
    AND sm.[staffStateID]<>'9999999999'
    AND se.[assignmentStartDate] <= @asof --start date is today or prior
    AND (se.[assignmentEndDate] IS NULL OR se.[assignmentEndDate] >= @asofEnd) --end date is null or future
    AND se.[schoolnetRole] IS NULL
    AND se.[schoolnetAddRoles] IS NULL
    AND se.[SchoolNumber] IS NOT NULL
    AND se.[schoolID] = ISNULL(@schoolID, sm.[schoolID])
ORDER BY LAST_NAME asc, FIRST_NAME asc, SCHOOL_NAME asc;