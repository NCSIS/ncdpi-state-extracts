/*
SQL Snippets to find and correct "orphaned" person records in IC.

Per Chris Peterson, sometimes combining a person makes it lose the association between the person table and the identity table. And sometimes the merge may have deleted the identity. A person record with no identity is invisible in the UI.
Code refined and reviewed for NCDPI by John Mairs.
*/

-- Run this one to see any Person records where there's no current identity. These are invisible in the UI:
select * from Person where currentIdentityID is NULL

-- Run this one to populate their current identity ID. Sometimes they'll have an identity + it just needs to be associated:
UPDATE p
set p.currentIdentityID = i.identityID
FROM person p
JOIN [identity] i on p.personID = i.personID
WHERE p.currentIdentityID IS NULL

-- If that fails to update any, run this one to create insert statements that create a temporary identity for those orphaned persons. Then, run the previous snippet again to associate it with the person record. You can then use the Combine Person Wizard in the UI to merge the duplicate.
SELECT
    'insert into [Identity] (personID, lastName, firstName, districtID, gender) values (' + convert(varchar, personID) + ', DPI_ID_CLEANUP, DO_NOT_USE,1,F)' from Person where currentIdentityID is null