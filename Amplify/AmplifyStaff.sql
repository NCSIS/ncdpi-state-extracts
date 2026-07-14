/**********************************************
Script maintained by NCDPI, PSU Technology Systems Section.
See https://github.com/NCSIS/ncdpi-state-extracts.
**********************************************/
DECLARE @asof datetime2 = SYSDATETIME();
select distinct *
from (select distinct 
	 d.number + CASE WHEN RIGHT(scl.number,3) = '296' THEN RIGHT(ISNULL(cal.number,scl.number),3) 
					 WHEN RIGHT(scl.number,3) = '810' THEN '000' 
					 ELSE RIGHT(scl.number,3) END as 'Institution'
	,i.staffStateID as 'Primary Staff ID'
	,REPLACE(i.lastName,',','') as 'Last Name'
	,REPLACE(i.firstName,',','') as 'First Name'
	,CASE WHEN ea.amplifyRole IS NULL OR ea.amplifyRole = 'RTA-T' THEN 'Standard' 
		  WHEN ea.amplifyRole = 'RTA-A' THEN 'System' 
		  ELSE 'Full' END 
		  as 'Access Privileges'
	,CASE WHEN ea.amplifyRole IS NULL THEN 'Teacher'
		  WHEN ea.amplifyRole = 'RTA-A' THEN 'School/District Administrator'
		  WHEN ea.amplifyRole = 'RTA-S' THEN 'Specialist'
		  WHEN ea.amplifyRole = 'RTA-T' THEN 'Teacher'
		  ELSE 'Teacher' END as 'User Type'
	,COALESCE(c.email,c2.email) as 'Email'
from dbo.District d
join dbo.SchoolYear sy ON sy.active = 1
join dbo.Calendar cal ON cal.districtID = d.districtID and cal.endYear = sy.endYear
join dbo.School scl ON scl.schoolID = cal.schoolID
join dbo.EmploymentAssignment ea ON ea.schoolID = scl.schoolID and ea.districtID = d.districtID
join dbo.individual i ON i.personID = ea.personID
outer apply (select top 1 * from dbo.StudentContact c where c.districtID = d.districtID and c.personID = i.personID and c.relationship = 'Self' and c.email IS NOT NULL order by contactID desc) c
outer apply (select top 1 * from dbo.contact c where c.personID = i.personID and c.districtID = d.districtID) c2
outer apply (select 1 as charter where ISNUMERIC(SUBSTRING(d.number,3,1)) = 0) psu_type
where 1=1
and ea.startDate <= @asof
and (ea.endDate IS NULL OR ea.endDate >= @asof)
and RIGHT(scl.number,3) <> '810'
and (RIGHT(scl.number,3) >= '300'
	OR
	psu_type.charter=1
	)
and exists(select 1
			from dbo.trial trl 
			join dbo.sectionStaffHistory ssh ON ssh.trialID = trl.trialID and ssh.personID = i.personID and ssh.staffType = 'P'
			join dbo.section sec ON sec.trialID = trl.trialID and sec.sectionID = ssh.sectionID
			join dbo.course crs ON crs.courseID = sec.courseID
			where trl.calendarID = cal.calendarID
			and (
				LEFT(crs.stateCode,4) IN('1050','1051','1052','1053') -- "regular" K-3 ELA for all
				or crs.stateCode IN('11512Z0','11512Z1','11512Z2','11512Z3') -- "DL/I" K-3 ELA for all
				or (psu_type.charter is null and LEFT(crs.stateCode,4) IN('1054','1055')) -- "regular" 4/5 ELA for LEAs
				OR (psu_type.charter=1 and exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade4 = 1) and LEFT(crs.stateCode,4) IN('1054')) --opt-in "regular" 4 ELA for charters
				OR (psu_type.charter=1 and exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade5 = 1) and LEFT(crs.stateCode,4) IN('1055')) --opt-in "regular" 5 ELA for charters
				)
			)

UNION ALL

select distinct 
	 d.number + CASE WHEN RIGHT(scl.number,3) = '296' THEN RIGHT(ISNULL(cal.number,scl.number),3) 
					 WHEN RIGHT(scl.number,3) = '810' THEN '000' 
					 ELSE RIGHT(scl.number,3) END as 'Institution'
	,i.staffStateID as 'Primary Staff ID'
	,REPLACE(i.lastName,',','') as 'Last Name'
	,REPLACE(i.firstName,',','') as 'First Name'
	,CASE WHEN ea.amplifyRole IS NULL OR ea.amplifyRole = 'RTA-T' THEN 'Standard' WHEN ea.amplifyRole = 'RTA-A' THEN 'System' ELSE 'Full' END as 'Access Privileges'
	,CASE WHEN ea.amplifyRole = 'RTA-A' THEN 'School/District Administrator'
		  WHEN ea.amplifyRole = 'RTA-S' THEN 'Specialist'
		  WHEN ea.amplifyRole = 'RTA-T' THEN 'Teacher'
		  ELSE 'Teacher' END as 'User Type'
	,COALESCE(c.email,c2.email) as 'Email'
from dbo.District d
join dbo.SchoolYear sy ON sy.active = 1
join dbo.Calendar cal ON cal.districtID = d.districtID and cal.endYear = sy.endYear
join dbo.School scl ON scl.schoolID = cal.schoolID
join dbo.EmploymentAssignment ea ON ea.schoolID = scl.schoolID and ea.districtID = d.districtID
join dbo.individual i ON i.personID = ea.personID
outer apply (select top 1 * from dbo.StudentContact c where c.districtID = d.districtID and c.personID = i.personID and c.relationship = 'Self' and c.email IS NOT NULL order by contactID desc) c
outer apply (select top 1 * from dbo.contact c where c.personID = i.personID and c.districtID = d.districtID) c2
outer apply (select 1 as charter where ISNUMERIC(SUBSTRING(d.number,3,1)) = 0) psu_type
where 1=1
and ea.startDate <= @asof
and (ea.endDate IS NULL OR ea.endDate >= @asof)
and RIGHT(scl.number,3) <> '810'
and (RIGHT(scl.number,3) >= '300'
	OR
	psu_type.charter=1
	)
and ea.amplifyRole IS NOT NULL

UNION ALL

select distinct 
	 d.number + '000' as 'Institution'
	,i.staffStateID as 'Primary Staff ID'
	,REPLACE(i.lastName,',','') as 'Last Name'
	,REPLACE(i.firstName,',','') as 'First Name'
	,CASE WHEN ea.amplifyRole IS NULL OR ea.amplifyRole = 'RTA-T' THEN 'Standard' WHEN ea.amplifyRole = 'RTA-A' THEN 'System' ELSE 'Full' END as 'Access Privileges'
	,CASE WHEN ea.amplifyRole = 'RTA-A' THEN 'School/District Administrator'
		  WHEN ea.amplifyRole = 'RTA-S' THEN 'Specialist'
		  WHEN ea.amplifyRole = 'RTA-T' THEN 'Teacher'
		  ELSE 'Teacher' END as 'User Type'
	,COALESCE(c.email,c2.email) as 'Email'
from dbo.District d
join dbo.SchoolYear sy ON sy.active = 1
join dbo.School scl ON scl.districtID = d.districtID and scl.number like '%810'
join dbo.EmploymentAssignment ea ON ea.districtID = d.districtID and scl.schoolID = ea.schoolID
join dbo.individual i ON i.personID = ea.personID
outer apply (select top 1 * from dbo.StudentContact c where c.districtID = d.districtID and c.personID = i.personID and c.relationship = 'Self' and c.email IS NOT NULL order by contactID desc) c
outer apply (select top 1 * from dbo.contact c where c.personID = i.personID and c.districtID = d.districtID) c2
where 1=1
and ea.startDate <= @asof
and (ea.endDate IS NULL OR ea.endDate >= @asof)
and (RIGHT(scl.number,3) = '810')
and ea.amplifyRole IS NOT NULL
and ea.amplifyRole IN('RTA-A','RTA-S')

UNION ALL

select distinct 
	 institution as 'Institution'
	,primaryStaffID as 'Primary Staff ID'
	,REPLACE(lastName,',','') as 'Last Name'
	,REPLACE(firstName,',','') as 'First Name'
	,accessPrivileges as 'Access Privileges'
	,userType as 'User Type'
	,email as 'Email'
from cust.ncdpiAmplifyAdditionalPeople
) r
