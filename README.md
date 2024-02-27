
# Identity and Access Management SQL Scripts for Infinite Campus

## Students_t1.sql

This is an initial attempt of a script to pull student data from IC:State Edition in the same format as the existing student source data file.

### Random Notes

#### PSU and School Codes and Names

These are being pulled out of the IC database as-is. Need to determine whether they'll be stored there as the standard EDDIE values or whether it'll be something different like with PS. If the data is in IC as it is in EDDIE, this script no longer needs to consult EDDIE. Opportunity to simplify.

#### Alias ID

This would opt-in everyone to alias ID. But honestly, I don't think that's a problem and it would remove a ton of complexity. Alias ID will fill with student emails. If student email is null, it'll fill with the IC username value.

#### Multivalued Teacher UID Field

Each student record has a field that is a list of their teachers' UIDs separated by double colons. We use the student personID to look up their sectionIDs in the roster table. For each sectionID, look in the sections table to get the teacherPersonID. Finally, for each teacherPersonID, search the Person table by ID to get the staffStateID.

We may be pulling teachers from concluded section enrollments. Need to verify once we can see real data in the database.

## Staff

To be written + need to consult with IDAuto. The purpose of this file would be to grab employee emails out of the SIS. Not sure what the resulting file would be exactly; likely just UID and email address. This would be an addendum to the current SAS jobs for staff.

As an aside: This is a job that is NOT working well at SAS. Part of the process to pull employee emails into this file is broken + SAS is not capable of helping us monitor or determine why. Looking forward, maybe the best answer is to position the SIS as the authoritative source for downstream systems. This will still require a valid Staff UID in that system as controlled by HR, but it removes a pain point and reduces complexity.

## Schoolnet Roles

Pearson to confirm the data flow / logic. But it sounds like these will live in Infinite Campus + that IC will assist with this extract.