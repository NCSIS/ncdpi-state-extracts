/*
This is a John Mairs Reinvents the Wheel While In Motion script...

If a Person has the "Teacher" box checked on the District Assignment screen, give them the SN role of Teacher.

Admins cannot be supported with this. Staff cannot be supported with this. Additional roles cannot be supported with this. This is a very temporary stop-gap.
*/
SELECT DISTINCT
    sm.[staffStateID] as STAFF_UID,
    se.[SchoolNumber] + ':Teacher' as SCHOOLNET_ROLE
FROM [v_SchoolEmployment] se
    LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
WHERE
    isNumeric(sm.[staffStateID])=1 --UID is numeric. Because a blank UID isn't actually null for some reason. Idk. Whatever.
    AND len(sm.[staffStateID])=10 --UID is 10 characters in length. Because why not?! If a null isn't null, I'm making no more assumptions.
    AND se.[Teacher]=1
    AND (se.[assignmentEndDate] IS NULL OR se.[assignmentEndDate] >= getdate()) --end date is null or future
    AND se.[active]=1;