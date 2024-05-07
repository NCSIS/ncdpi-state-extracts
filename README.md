
# Identity and Access Management SQL Scripts for Infinite Campus

## Students_t1.sql

This is a script to pull student data from IC:State Edition in the same format as the existing student source data file. This has been developed against ncse-test.infinitecampus.org.

### Random Notes

#### Student Emails
Student emails __do not exist__ in the State Edition database. This value will be *null* if this script is run at the state level. This script __must__ be run from the PSU level.

This value also fills the Alias ID field.

#### Alias ID

This would opt-in everyone to alias ID. Alias ID will fill with student emails. Currently, this is determined by an opt-in table at SAS. Moving forward, everyone would be opted-in by default and each PSU can choose whether or not to advertise or use it.

#### Multivalued Teacher UID Field

Each student record has a field that is a list of their teachers' UIDs separated by double colons. We use the student personID to look up their sectionIDs in the roster table. For each sectionID, look in the sections table to get the teacherPersonID. Finally, for each teacherPersonID, search the Person table by ID to get the staffStateID. We're using STUFF with a nested query to accomplish this.

## Staff

This will be a NEW file for IDAuto. Staff will be initially provisioned by the existing Staff jobs at SAS. The data source for those jobs is Staff UID. Nothing about that will change. This NEW file will serve to feed employee emails from Infinite Campus to IDAuto.

## Parents

This will match the format of the existing parent file. Should be based on parents with active accounts in IC.

## Schoolnet Roles

IC will build this extract as part of the Schoolnet integration work.