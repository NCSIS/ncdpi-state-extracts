/*
This is a John Mairs Reinvents the Wheel While In Motion script...

If a Person has the "Teacher" box checked on the District Assignment screen, give them the SN role of Teacher.

Admins cannot be supported with this. Staff cannot be supported with this. Additional roles cannot be supported with this.
*/
SELECT DISTINCT
    sm.[staffStateID] as STAFF_UID,
    se.[SchoolNumber] + ':Teacher' as SCHOOLNET_ROLE
FROM [v_SchoolEmployment] se
LEFT OUTER JOIN [staffMember] sm ON sm.[personID]=se.[personID]
WHERE
sm.[staffStateID] is not NULL
AND se.[Teacher]=1
AND (se.[assignmentEndDate] IS NULL OR se.[assignmentEndDate] >= getdate()) --end date is null or future
AND se.[active]=1;