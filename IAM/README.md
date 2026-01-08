
# Identity and Access Management Scripts for Infinite Campus

These scripts are designed to be run from the NCSIS State Edition to populate data in the NCEdCloud IAM Service.

## students.sql

This script pulls student account data in the same format as the old student extract. Primary enrollments are noted with a "P" for further filtering by IDAuto.

## student_sn_roles.sql

This script assembles student Schoolnet roles based off their currently enrolled schools.

## staff_email.sql

This script pulls the UID and email address of all currently active employees.

## staff_sn_roles.sql

This script uses a series of nested queries to pull out assigned staff Schoolnet roles from the custom fields on the Infinite Campus District Assignments screen. The script filters invalid role combinations when "Leadership" is assigned.

## Random Notes

### Email Addresses
Email addresses in the State Edition database are stored in the __Contact__ table for students and staff. If a staff member is also a parent, the email may be in the __StudentContact__ table instead. The Contact table is a simple join on personID and districtID. The StudentContact table needs a join on personID, districtID, and a relationship value of "self."

This value also fills the Alias ID field for Students and Staff unless the PSU has opted-out.

### Alias ID

This enables alias ID for all PSUs. Alias ID will fill with student or staff emails. Previously, this was determined by an opt-in table at SAS. With Infinite Campus, everyone is opted-in by default and each PSU can choose whether or not to advertise or use it. In the future, we hope to make this configurable in the Infinite Campus District Edition UI.

### Multivalued Teacher UID Field

Each student record has a field that is a list of their teachers' UIDs separated by double colons. The script uses the student personID to look up their sectionIDs in the roster table. For each sectionID, it looks in the sections table to get the teacherPersonID. Finally, for each teacherPersonID, it searches the Person table by ID to get the staffStateID. If a student has more than one active enrollment, all current teachers from all active enrollments are included on every line.

### Staff Email File

This file is delivered to the NC Staff UID System server. [Scripts there join it with Staff UID data to produce the staff source data files for both IAM and NCEES.](https://github.com/ncdpi-operations/ncdpi_scripts_v1/tree/main/staff/staff_source_extracts)
