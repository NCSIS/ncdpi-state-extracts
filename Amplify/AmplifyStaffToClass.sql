/**********************************************
Script maintained by NCDPI, PSU Technology Systems Section.
See https://github.com/NCSIS/ncdpi-state-extracts.
**********************************************/
DECLARE @asof datetime2 = SYSDATETIME();
select distinct
	 d.number + CASE WHEN RIGHT(scl.number,3) = '296' THEN RIGHT(ISNULL(cal.number,scl.number),3) ELSE RIGHT(scl.number,3) END as 'Institution'
	,sec.sectionID as 'Primary Class ID'
	,i.staffStateID as 'Primary Staff ID'
	,CASE WHEN ssh.staffType = 'P' THEN 'Yes' ELSE 'No' END as 'Is Primary Staff'
from dbo.District d
join dbo.SchoolYear sy ON sy.active = 1
join dbo.Calendar cal ON cal.districtID = d.districtID and cal.endYear = sy.endYear
join dbo.School scl ON scl.schoolID = cal.schoolID
join dbo.Trial trl ON trl.calendarID = cal.calendarID and trl.active = 1
join dbo.Section sec ON sec.trialID = trl.trialID
join dbo.Course crs ON crs.courseID = sec.courseID and crs.calendarID = cal.calendarID and crs.active = 1
join dbo.SectionStaffHistory ssh ON ssh.trialID = trl.trialID and ssh.sectionID = sec.sectionID and ssh.staffType = 'P' and (ssh.endDate is null or ssh.endDate>=@asof) --JBM updated 12/12/25, add filter on ssh.endDate
join dbo.EmploymentAssignment ea ON ea.personID = ssh.personID and ea.schoolID = scl.schoolID
join dbo.individual i ON i.personID = ea.personID
outer apply (select 1 as charter where ISNUMERIC(SUBSTRING(d.number,3,1)) = 0) psu_type
where 1=1
and ea.startDate <= @asof
and (ea.endDate IS NULL OR ea.endDate >= @asof)
and exists(select 1 
			from dbo.Roster ros
			where ros.trialID = trl.trialID
			and ros.sectionID = sec.sectionID)
and (RIGHT(scl.number,3) >= '300'
	OR
	psu_type.charter=1
	)
and exists(select 1 
			from dbo.Roster ros
			where ros.trialID = trl.trialID
			and ros.sectionID = sec.sectionID)
and (
	LEFT(crs.stateCode,4) IN('1050','1051','1052','1053') -- "regular" K-3 ELA for all
	or crs.stateCode IN('11512Z0','11512Z1','11512Z2','11512Z3') -- "DL/I" K-3 ELA for all
	or (psu_type.charter is null and LEFT(crs.stateCode,4) IN('1054','1055')) -- "regular" 4/5 ELA for LEAs
	OR (psu_type.charter=1 and exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade4 = 1) and LEFT(crs.stateCode,4) IN('1054')) --opt-in "regular" 4 ELA for charters
	OR (psu_type.charter=1 and exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade5 = 1) and LEFT(crs.stateCode,4) IN('1055')) --opt-in "regular" 5 ELA for charters
	)