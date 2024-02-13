
# Identity and Access Management SQL Scripts for Infinite Campus

## Students_t1.sql

This is an initial attempt of a script to pull student data from IC:State Edition in the same format as the existing student source data file.

### Random Notes

#### PSU and School Codes and Names

These are being pulled out of the IC database as-is. Need to determine whether they'll be stored there as the standard EDDIE values or whether it'll be something different like with PS. If the data is in IC as it is in EDDIE, this script no longer needs to consult EDDIE. Opportunity to simplify.

#### Alias ID

This would opt-in everyone to alias ID. But honestly, I don't think that's a problem and it would remove a ton of complexity. Alias ID will fill with student emails. If student email is null, it'll fill with the IC username value.

#### Multivalued Teacher UID Field

Each student record has a field that is a list of their teachers' UIDs separated by double colons. I have not yet been successful in making this work. Basically, we will need to use the student personID to look up their sectionIDs in the roster table. For each sectionID, look in the sections table to get the teacherPersonID. Finally, for each teacherPersonID, search the Person table by ID to get the staffStateID.

## Staff

To be written + need to consult with IDAuto. The purpose of this file would be to grab employee emails out of the SIS. Not sure what the resulting file would be exactly; likely just UID and email address. This would be an addendum to the current SAS jobs for staff.

As an aside: this is one job that does NOT work well at SAS. What if the SIS was the primary source instead of Staff UID? I'd love to get this job away from SAS completely simply because it doesn't work + they don't know why.

## Schoolnet Roles

Need to determine where Schoolnet roles will live / whether we need to find a home for them in IC + write a script to send to IAM.