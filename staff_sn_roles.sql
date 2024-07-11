SELECT
    sm.[staffStateID],
    se.[SchoolNumber],
    se.[schoolnetRole],
    se.[schoolnetAddRoles]
FROM [v_SchoolEmployment] se
LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
WHERE
sm.[staffStateID] is not null
AND se.[schoolnetRole] is not null
AND se.[schoolnetAddRoles] is not null;

--this is kind of a non-starter... or at least is beyond my current SQL and mental capacity at this moment.