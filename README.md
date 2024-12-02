
# Identity and Access Management SQL Scripts for Infinite Campus

These scripts are designed to be run from the NCSIS State Edition.

## students.sql

This script pulls student account data in the same format as the old student extract. Note that it only pulls a student's "Primary" enrollment record. Secondary enrollments are not included at this time.

## student_sn_roles.sql

This script assembles student Schoolnet roles based off their currently enrolled school.

## staff_email.sql

This script pulls the UID and email address of all currently active employees.

## staff_sn_roles.sql

This script uses a series of nested queries to pull out assigned staff Schoolnet roles from the custom fields on the Infinite Campus District Assignments screen.

## staff_sn_roles_TEMP-JM.sql

This script was a temporary solution to assemble teacher Schoolnet roles based off their District Assignments where the "Teacher" box is checked.

## parents.sql

~~This script was written for the PSU level instances and pulls user account records in Infinite Campus where the account type is SAML, the assigned IdP contains "NCEdCloud," the username value is equal to the email address value, and the Infinite Campus homepage is set to the Parent Portal.~~ __This script needs to be rewritten for the State Edition schema. Logic may change. This feature / file is on hold until post-implementation.__

## Random Notes

### Email Addresses
Email addresses in the State Edition database are stored in the __Contact__ table for students and in the __StudentContact__ table for staff. The Contact table can be a simple join on personID. The StudentContact table needs a join on personID and a relationship value of "self." At the District Edition level, all emails are in __StudentContact__ with a relationship value of "self."

This value also fills the Alias ID field for Students and Staff.

### Alias ID

This would opt-in everyone to alias ID. Alias ID will fill with student or staff emails. Currently, this is determined by an opt-in table at SAS. Moving forward, everyone will be opted-in by default and each PSU can choose whether or not to advertise or use it.

### Multivalued Teacher UID Field

Each student record has a field that is a list of their teachers' UIDs separated by double colons. The script uses the student personID to look up their sectionIDs in the roster table. For each sectionID, it looks in the sections table to get the teacherPersonID. Finally, for each teacherPersonID, it searches the Person table by ID to get the staffStateID. It's using STUFF with a nested query to accomplish this.

### Staff Email File

This will be a NEW file for IDAuto. Staff will be initially provisioned by the existing Staff jobs at SAS. The data source for those jobs is Staff UID. Nothing about that will change. This new file serves only to feed employee emails from Infinite Campus to IDAuto.