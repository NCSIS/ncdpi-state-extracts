WITH snr AS (
    SELECT DISTINCT
        sm.[staffStateID] as staff_uid,
        CASE se.[SchoolNumber]
            WHEN RIGHT(se.[SchoolNumber],3) = '810' THEN LEFT(se.[SchoolNumber],3)
            WHEN TRY_CAST(se.[SchoolNumber] as int) IS NOT NULL THEN CAST(se.[SchoolNumber]*1 as varchar)
            ELSE se.[SchoolNumber]
        END as school_number,
        se.[schoolnetRole] as schoolnet_role,
        se.[schoolnetAddRoles] as schoolnet_add_roles
    FROM  [v_SchoolEmployment] se
        LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
    WHERE
        len(sm.[staffStateID])=10 --UID is 10 characters in length.
        AND sm.[startDate] <= getdate() --start date is today or prior
        AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future
        AND se.[schoolnetRole] IS NOT NULL --has a primary Schoolnet role
) --pull out all the active roles...

--extract Leadership roles
SELECT
    snr.staff_uid as STAFF_UID,
    snr.school_number + ':Leadership' AS SCHOOLNET_ROLE,
    '01' as ROLE_NUM
WHERE se.[schoolnetRole]=2

UNION ALL

--extract Teacher roles
SELECT
    snr.staff_uid as STAFF_UID,
    snr.school_number + ':Teacher' AS SCHOOLNET_ROLE,
    '02' as ROLE_NUM
WHERE se.[schoolnetRole]=1

UNION ALL

--extract Leadership roles
SELECT
    snr.staff_uid as STAFF_UID,
    snr.school_number + ':Staff' AS SCHOOLNET_ROLE,
    '03' as ROLE_NUM
WHERE se.[schoolnetRole]=3;

/* doesn't work yet... idk if it's better anyway... whatever.