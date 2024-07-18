SELECT
    sm.[staffStateID],
    se.[SchoolNumber],
    se.[schoolnetRole],
    se.[schoolnetAddRoles]
FROM [v_SchoolEmployment] se
    LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
WHERE
    isNumeric(sm.[staffStateID])=1 --UID is numeric. Because a blank UID isn't actually null for some reason. Idk. Whatever.
    AND len(sm.[staffStateID])=10 --UID is 10 characters in length. Because why not?! If a null isn't null, I'm making no more assumptions.
    AND se.[schoolnetRole] is not null
    AND se.[schoolnetAddRoles] is not null;

--this is kind of a non-starter... or at least is beyond my current SQL and mental capacity at this moment. We need to decode the main snRole from numeric, then also split out the AddRoles field to separate lines.