select distinct
	 i.staffStateID as 'sourceUserID'
	,CASE WHEN s.number = '296' THEN d.number + ISNULL(cal.number,s.number)
	      WHEN LEN(s.number) = 3 THEN d.number + s.number 
		  ELSE s.number 
		  END as 'sourceSiteID'
	,i.lastName as 'lastName'
	,i.firstName as 'firstName'
	,i.staffStateID as 'username'
	,c.email as 'email'
	,'1' as 'userTypeID' --1 = teacher, 3 = admin
	,'1' as 'adminTypeID' --is this correct for teachers?
	,REPLACE(REPLACE(REPLACE(COALESCE(c.workPhone,c.cellPhone),'(',''),')',''),'-','') as 'phone'
	,'3' as 'currTypeID'
from dbo.District d
join dbo.School s ON s.districtID = d.districtID
join dbo.SchoolYear sy ON sy.active = 1
join dbo.Calendar cal ON cal.endYear = sy.endYear and cal.schoolID = s.schoolID
join dbo.Trial trl ON trl.calendarID = cal.calendarID and trl.active = 1
join dbo.Course crs ON crs.calendarID = cal.calendarID and (LEFT(crs.stateCode,4) IN('1050') OR crs.stateCode = '11512Z0') --only KG ELA courses --JBM updated 11/18/25, remove course 1001 per Dan Tetreault
join dbo.Section sec ON sec.trialID = trl.trialID and sec.courseID = crs.courseID
join dbo.SectionStaffHistory ssh ON ssh.trialID = trl.trialID and ssh.sectionID = sec.sectionID
join dbo.Individual i ON i.personID = ssh.personID
join dbo.Contact c ON c.personID = ssh.personID and c.districtID = d.districtID --JBM updated 11/10/25, more reliable.
--outer apply (select top 1 * from dbo.StudentContact c where c.districtID = d.districtID and c.email IS NOT NULL and c.personID = i.personID and c.relationship = 'Self' order by contactID desc) c
where 1=1
and ssh.staffType = 'P'
and (ssh.startDate IS NULL OR ssh.startDate <= getdate())
and (ssh.endDate IS NULL OR ssh.endDate >= getdate())
and ISNUMERIC(s.number) = 1
and (RIGHT(s.number,3) >= '300'
	OR
	ISNUMERIC(SUBSTRING(d.number,3,1)) = 0
	)

UNION ALL

--anyone with principal in the title for admins

select distinct
	 i.staffStateID as 'sourceUserID'
	,CASE WHEN s.number = '296' THEN d.number + ISNULL(cal.number,s.number)
	      WHEN LEN(s.number) = 3 THEN d.number + s.number 
		  ELSE s.number 
		  END as 'sourceSiteID'
	,i.lastName as 'lastName'
	,i.firstName as 'firstName'
	,i.staffStateID as 'username'
	,c.email as 'email'
	,'3' as 'userTypeID' --1 = teacher, 3 = admin
	--,eav.value as 'adminTypeID' --is this correct for teachers?
	,ea.k3TSAdminRole as 'adminTypeID' --is this correct for teachers?
	,REPLACE(REPLACE(REPLACE(COALESCE(c.workPhone,c.cellPhone),'(',''),')',''),'-','') as 'phone'
	,'3' as 'currTypeID'
from dbo.District d
join dbo.School s ON s.districtID = d.districtID
join dbo.SchoolYear sy ON sy.active = 1
join dbo.Calendar cal ON cal.endYear = sy.endYear and cal.schoolID = s.schoolID
join dbo.EmploymentAssignment ea ON ea.schoolID = s.schoolID --and ISNULL(ea.title,'') = 'Principal'
join dbo.Individual i ON i.personID = ea.personID
join dbo.Contact c ON c.personID = i.personID and c.districtID = d.districtID --JBM updated 11/10/25, more reliable.
--outer apply (select top 1 * from dbo.StudentContact c where c.districtID= d.districtID and c.email IS NOT NULL and c.personID = i.personID and c.relationship = 'Self' order by contactID desc) c
--join dbo.CampusAttribute ca ON ca.object = 'Employment Assignment' and ca.element = 'k3TSAdminRole'
--join dbo.EmploymentAssignmentValue eav ON eav.assignmentID = ea.assignmentID and eav.attributeID = ca.attributeID
where 1=1
and ISNUMERIC(d.number) = 1
and ea.startDate <= getdate()
and (ea.endDate IS NULL OR ea.endDate >= getdate())
and exists(select 1
			from dbo.Course crs
			where crs.calendarID = cal.calendarID
			and (LEFT(crs.stateCode,4) IN('1050') OR crs.stateCode = '11512Z0') --only KG ELA courses --JBM updated 11/18/25, remove course 1001 per Dan Tetreault
			)
and ISNUMERIC(s.number) = 1
and (RIGHT(s.number,3) >= '300'
	--OR
	--ISNUMERIC(SUBSTRING(d.number,3,1)) = 0
	)
and ea.k3TSAdminRole IS NOT NULL
