
# Identity and Access Management SQL Scripts for Infinite Campus

These scripts are designed to be run in each local PSU schema by the NCSIS Batch Query Utility. While these scripts *can* be run from the State Edition schema, several required fields are not present in State Edition. Identity Automation will continue to receive their current daily source data files as-is. These new files will be sent as an addendum.

## students.sql

This script pulls student account data in the same format as the old student extract. Note that it only pulls a student's "Primary" enrollment record. Secondary enrollments are not included at this time.

## staff_email.sql

This script pulls the UID and email address of all currently active employees.

## parents.sql

This script pulls user account records in Infinite Campus where the account type is SAML, the assigned IdP contains "NCEdCloud," the username value is equal to the email address value, and the Infinite Campus homepage is set to the Parent Portal. This *may or may not* work.

### Random Notes

#### Email Addresses
Email addresses __do not exist__ in the State Edition database. This value will be *null* if these scripts are run at the state level. These scripts __must__ be run from the PSU level.

This value also fills the Alias ID field for Students and Staff.

#### Alias ID

This would opt-in everyone to alias ID. Alias ID will fill with student or staff emails. Currently, this is determined by an opt-in table at SAS. Moving forward, everyone would be opted-in by default and each PSU can choose whether or not to advertise or use it.

#### Multivalued Teacher UID Field

Each student record has a field that is a list of their teachers' UIDs separated by double colons. We use the student personID to look up their sectionIDs in the roster table. For each sectionID, look in the sections table to get the teacherPersonID. Finally, for each teacherPersonID, search the Person table by ID to get the staffStateID. We're using STUFF with a nested query to accomplish this.

## Staff Email File

This will be a NEW file for IDAuto. Staff will be initially provisioned by the existing Staff jobs at SAS. The data source for those jobs is Staff UID. Nothing about that will change. This NEW file will serve to feed employee emails from Infinite Campus to IDAuto.

## Schoolnet Roles

IC will build this extract as part of the Schoolnet integration work.