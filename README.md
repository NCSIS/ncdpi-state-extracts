
# Identity and Access Management SQL Scripts for Infinite Campus

## Students_t1.sql

This is a script to pull student data from IC:State Edition in the same format as the existing student source data file. This has been developed against ncse-test.infinitecampus.org.

### Random Notes

#### Student Emails
Need to find these in the State Edition database! This is a __critical__ issue.

#### PSU and School Codes and Names

These are being pulled out of the IC database as-is. Since we have proper state codes in IC, we don't need to consult EDDIE.

#### Alias ID

This would opt-in everyone to alias ID. But honestly, I don't think that's a problem and it would remove some complexity. Alias ID will fill with student emails.

#### Multivalued Teacher UID Field

Each student record has a field that is a list of their teachers' UIDs separated by double colons. We use the student personID to look up their sectionIDs in the roster table. For each sectionID, look in the sections table to get the teacherPersonID. Finally, for each teacherPersonID, search the Person table by ID to get the staffStateID.

This is easy with STRING_AGG in MSSQL 2017+ as was available in the IC Training site. However, our staging site is running an earlier version. As a result, the script has to use STUFF with a nested query to accomplish this.

## Staff

To be written + need to consult with IDAuto. The purpose of this file would be to grab employee emails out of the SIS. Not sure what the resulting file would be exactly; likely just UID and email address. This would be an addendum to the current SAS jobs for staff.

As an aside: This is a job that is NOT working well at SAS. Part of the process to pull employee emails into this file is broken + SAS is not capable of helping us monitor or determine why. Looking forward, maybe the best answer is to position the SIS as the authoritative source for downstream systems. This will still require a valid Staff UID in that system as controlled by HR, but it removes a pain point and reduces complexity.

## Schoolnet Roles

Pearson to confirm the data flow / logic. But it sounds like these will live in Infinite Campus + that IC will assist with this extract.