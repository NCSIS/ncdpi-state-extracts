SELECT
    STAFF_UID,
    SCHOOLNET_ROLE
from (
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        CASE
            WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
            WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
            ELSE se.[SchoolNumber]
        END + ':Leadership' as SCHOOLNET_ROLE,
        01 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        len(sm.[staffStateID])=10 --UID is 10 characters in length.
        AND sm.[startDate] <= getdate() --start date is today or prior
        AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future
        AND se.[schoolnetRole]=2

    UNION ALL
    -- now Teacher roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        CASE
            WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
            WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
            ELSE se.[SchoolNumber]
        END + ':Teacher' as SCHOOLNET_ROLE,
        02 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        len(sm.[staffStateID])=10 --UID is 10 characters in length.
        AND sm.[startDate] <= getdate() --start date is today or prior
        AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future
        AND se.[schoolnetRole]=1

    UNION ALL

    -- now Staff roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        CASE
            WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
            WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
            ELSE se.[SchoolNumber]
        END + ':Staff' as SCHOOLNET_ROLE,
        03 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        len(sm.[staffStateID])=10 --UID is 10 characters in length.
        AND sm.[startDate] <= getdate() --start date is today or prior
        AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future
        AND se.[schoolnetRole]=3

    UNION ALL

    -- now Access to Teacher and Section Level Data roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        CASE
            WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
            WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
            ELSE se.[SchoolNumber]
        END + ':Access to Teacher and Section Level Data' as SCHOOLNET_ROLE,
        11 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        len(sm.[staffStateID])=10 --UID is 10 characters in length.
        AND sm.[startDate] <= getdate() --start date is today or prior
        AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 2
        AND se.[schoolnetAddRoles] like '%Access to Teacher and Section Level Data%'

    UNION ALL

    -- now Access to Aggregate Level Data roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        CASE
            WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
            WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
            ELSE se.[SchoolNumber]
        END + ':Access to Aggregate Level Data' as SCHOOLNET_ROLE,
        12 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        len(sm.[staffStateID])=10 --UID is 10 characters in length.
        AND sm.[startDate] <= getdate() --start date is today or prior
        AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 2
        AND se.[schoolnetAddRoles] like '%Access to Aggregate Level Data%'

    UNION ALL

    -- now Access to Assessment Management roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        CASE
            WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
            WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
            ELSE se.[SchoolNumber]
        END + ':Access to Assessment Management' as SCHOOLNET_ROLE,
        13 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        len(sm.[staffStateID])=10 --UID is 10 characters in length.
        AND sm.[startDate] <= getdate() --start date is today or prior
        AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 2
        AND se.[schoolnetAddRoles] like '%Access to Assessment Management%'

    UNION ALL

    -- now Access to Curriculum Management roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        CASE
            WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
            WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
            ELSE se.[SchoolNumber]
        END + ':Access to Curriculum Management' as SCHOOLNET_ROLE,
        14 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        len(sm.[staffStateID])=10 --UID is 10 characters in length.
        AND sm.[startDate] <= getdate() --start date is today or prior
        AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 2
        AND se.[schoolnetAddRoles] like '%Access to Curriculum Management%'

    UNION ALL

    -- now Access to Teacher Lesson Planner roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        CASE
            WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
            WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
            ELSE se.[SchoolNumber]
        END + ':Access to Teacher Lesson Planner' as SCHOOLNET_ROLE,
        15 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        len(sm.[staffStateID])=10 --UID is 10 characters in length.
        AND sm.[startDate] <= getdate() --start date is today or prior
        AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 2
        AND se.[schoolnetAddRoles] like '%Access to Teacher Lesson Planner%'

    UNION ALL

    -- now Test Item Administrator roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        CASE
            WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
            WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
            ELSE se.[SchoolNumber]
        END + ':Test Item Administrator' as SCHOOLNET_ROLE,
        16 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        len(sm.[staffStateID])=10 --UID is 10 characters in length.
        AND sm.[startDate] <= getdate() --start date is today or prior
        AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetAddRoles] like '%Test Item Administrator%'

    UNION ALL

    -- now Access for Teachers to Share Assessments roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        CASE
            WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
            WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
            ELSE se.[SchoolNumber]
        END + ':Access for Teachers to Share Assessments' as SCHOOLNET_ROLE,
        17 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        len(sm.[staffStateID])=10 --UID is 10 characters in length.
        AND sm.[startDate] <= getdate() --start date is today or prior
        AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 2
        AND se.[schoolnetAddRoles] like '%Access for Teachers to Share Assessments%'

    UNION ALL

    -- now Access to Report Manage roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        CASE
            WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
            WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
            ELSE se.[SchoolNumber]
        END + ':Access to Report Manager' as SCHOOLNET_ROLE,
        18 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        len(sm.[staffStateID])=10 --UID is 10 characters in length.
        AND sm.[startDate] <= getdate() --start date is today or prior
        AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 2
        AND se.[schoolnetAddRoles] like '%Access to Report Manage%' --this is a typo in IC

    UNION ALL

    -- now Access to Approve Instructional Materials roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        CASE
            WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
            WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
            ELSE se.[SchoolNumber]
        END + ':Access to Approve Instructional Materials' as SCHOOLNET_ROLE,
        19 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        len(sm.[staffStateID])=10 --UID is 10 characters in length.
        AND sm.[startDate] <= getdate() --start date is today or prior
        AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 2
        AND se.[schoolnetAddRoles] like '%Access to Approve Instructional Materials%'

    UNION ALL

    -- now Access to Approve Assessment Items roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        CASE
            WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
            WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
            ELSE se.[SchoolNumber]
        END + ':Access to Approve Assessment Items' as SCHOOLNET_ROLE,
        20 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        len(sm.[staffStateID])=10 --UID is 10 characters in length.
        AND sm.[startDate] <= getdate() --start date is today or prior
        AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 2
        AND se.[schoolnetAddRoles] like '%Access to Approve Assessment Items%'

    /*UNION ALL

    -- now make up Teacher roles if they're missing...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        CASE
            WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
            WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
            ELSE se.[SchoolNumber]
        END + ':Teacher' as SCHOOLNET_ROLE,
        02.5 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        len(sm.[staffStateID])=10 --UID is 10 characters in length.
        AND sm.[startDate] <= getdate() --start date is today or prior
        AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future
        AND se.[schoolnetRole] IS NULL
        AND se.[schoolnetAddRoles] IS NULL
        AND se.[Teacher] = 1*/
) ssnr
WHERE STAFF_UID IS NOT NULL AND LEFT(STAFF_UID,1)<>'0'
ORDER BY STAFF_UID, ROLE_NUM;