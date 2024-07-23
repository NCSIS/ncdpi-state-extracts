SELECT
    STAFF_UID,
    SCHOOLNET_ROLE
from (
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        se.[SchoolNumber] + ':Leadership' as SCHOOLNET_ROLE,
        1 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        isNumeric(sm.[staffStateID])=1 --UID is numeric. Because a blank UID isn't actually null for some reason. Idk. Whatever.
        AND len(sm.[staffStateID])=10 --UID is 10 characters in length. Because why not?! If a null isn't null, I'm making no more assumptions.
        AND se.[schoolnetRole]=2

    UNION ALL
    -- now Teacher roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        se.[SchoolNumber] + ':Teacher' as SCHOOLNET_ROLE,
        2 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        isNumeric(sm.[staffStateID])=1 --UID is numeric. Because a blank UID isn't actually null for some reason. Idk. Whatever.
        AND len(sm.[staffStateID])=10 --UID is 10 characters in length. Because why not?! If a null isn't null, I'm making no more assumptions.
        AND se.[schoolnetRole]=1

    UNION ALL

    -- now Staff roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        se.[SchoolNumber] + ':Staff' as SCHOOLNET_ROLE,
        3 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        isNumeric(sm.[staffStateID])=1 --UID is numeric. Because a blank UID isn't actually null for some reason. Idk. Whatever.
        AND len(sm.[staffStateID])=10 --UID is 10 characters in length. Because why not?! If a null isn't null, I'm making no more assumptions.
        AND se.[schoolnetRole]=3

    UNION ALL

    -- now Access to Teacher and Section Level Data roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        se.[SchoolNumber] + ':Access to Teacher and Section Level Data' as SCHOOLNET_ROLE,
        11 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        isNumeric(sm.[staffStateID])=1 --UID is numeric. Because a blank UID isn't actually null for some reason. Idk. Whatever.
        AND len(sm.[staffStateID])=10 --UID is 10 characters in length. Because why not?! If a null isn't null, I'm making no more assumptions.
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 1
        AND se.[schoolnetAddRoles] like '%Access to Teacher and Section Level Data%'

    UNION ALL

    -- now Access to Aggregate Level Data roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        se.[SchoolNumber] + ':Access to Aggregate Level Data' as SCHOOLNET_ROLE,
        12 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        isNumeric(sm.[staffStateID])=1 --UID is numeric. Because a blank UID isn't actually null for some reason. Idk. Whatever.
        AND len(sm.[staffStateID])=10 --UID is 10 characters in length. Because why not?! If a null isn't null, I'm making no more assumptions.
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 1
        AND se.[schoolnetAddRoles] like '%Access to Aggregate Level Data%'

    UNION ALL

    -- now Access to Assessment Management roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        se.[SchoolNumber] + ':Access to Assessment Management' as SCHOOLNET_ROLE,
        13 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        isNumeric(sm.[staffStateID])=1 --UID is numeric. Because a blank UID isn't actually null for some reason. Idk. Whatever.
        AND len(sm.[staffStateID])=10 --UID is 10 characters in length. Because why not?! If a null isn't null, I'm making no more assumptions.
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 1
        AND se.[schoolnetAddRoles] like '%Access to Assessment Management%'

    UNION ALL

    -- now Access to Curriculum Management roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        se.[SchoolNumber] + ':Access to Curriculum Management' as SCHOOLNET_ROLE,
        14 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        isNumeric(sm.[staffStateID])=1 --UID is numeric. Because a blank UID isn't actually null for some reason. Idk. Whatever.
        AND len(sm.[staffStateID])=10 --UID is 10 characters in length. Because why not?! If a null isn't null, I'm making no more assumptions.
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 1
        AND se.[schoolnetAddRoles] like '%Access to Curriculum Management%'

    UNION ALL

    -- now Access to Teacher Lesson Planner roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        se.[SchoolNumber] + ':Access to Teacher Lesson Planner' as SCHOOLNET_ROLE,
        15 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        isNumeric(sm.[staffStateID])=1 --UID is numeric. Because a blank UID isn't actually null for some reason. Idk. Whatever.
        AND len(sm.[staffStateID])=10 --UID is 10 characters in length. Because why not?! If a null isn't null, I'm making no more assumptions.
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 1
        AND se.[schoolnetAddRoles] like '%Access to Teacher Lesson Planner%'

    UNION ALL

    -- now Test Item Administrator roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        se.[SchoolNumber] + ':Test Item Administrator' as SCHOOLNET_ROLE,
        16 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        isNumeric(sm.[staffStateID])=1 --UID is numeric. Because a blank UID isn't actually null for some reason. Idk. Whatever.
        AND len(sm.[staffStateID])=10 --UID is 10 characters in length. Because why not?! If a null isn't null, I'm making no more assumptions.
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 1
        AND se.[schoolnetAddRoles] like '%Test Item Administrator%'

    UNION ALL

    -- now Access to Report Manage roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        se.[SchoolNumber] + ':Access to Report Manage' as SCHOOLNET_ROLE,
        17 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        isNumeric(sm.[staffStateID])=1 --UID is numeric. Because a blank UID isn't actually null for some reason. Idk. Whatever.
        AND len(sm.[staffStateID])=10 --UID is 10 characters in length. Because why not?! If a null isn't null, I'm making no more assumptions.
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 1
        AND se.[schoolnetAddRoles] like '%Access to Report Manage%'

    UNION ALL

    -- now Access to Approve Instructional Materials roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        se.[SchoolNumber] + ':Access to Approve Instructional Materials' as SCHOOLNET_ROLE,
        18 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        isNumeric(sm.[staffStateID])=1 --UID is numeric. Because a blank UID isn't actually null for some reason. Idk. Whatever.
        AND len(sm.[staffStateID])=10 --UID is 10 characters in length. Because why not?! If a null isn't null, I'm making no more assumptions.
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 1
        AND se.[schoolnetAddRoles] like '%Access to Approve Instructional Materials%'

    UNION ALL

    -- now Access to Approve Assessment Items roles...
    SELECT DISTINCT
        sm.[staffStateID] as STAFF_UID,
        se.[SchoolNumber] + ':Access to Approve Assessment Items' as SCHOOLNET_ROLE,
        19 as ROLE_NUM
    FROM [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        isNumeric(sm.[staffStateID])=1 --UID is numeric. Because a blank UID isn't actually null for some reason. Idk. Whatever.
        AND len(sm.[staffStateID])=10 --UID is 10 characters in length. Because why not?! If a null isn't null, I'm making no more assumptions.
        AND se.[schoolnetRole] is not null
        AND se.[schoolnetRole] != 1
        AND se.[schoolnetAddRoles] like '%Access to Approve Assessment Items%') ssnr
WHERE STAFF_UID is not null
ORDER BY STAFF_UID, ROLE_NUM;