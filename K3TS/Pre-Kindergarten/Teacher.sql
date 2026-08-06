/**********************************************
Script maintained by NCDPI, PSU Technology Systems Section.
See https://github.com/NCSIS/ncdpi-state-extracts.
**********************************************/
DECLARE @asof datetime2 = SYSDATETIME();
select distinct
	i.staffStateID as 'sourceUserID'
	,CASE WHEN s.number = '296' THEN d.number + ISNULL(cal.number,s.number)
	      WHEN LEN(s.number) = 3 THEN d.number + s.number 
		  ELSE s.number 
		  END as 'sourceSiteID'
	,i.lastName as 'lastName'
	,i.firstName as 'firstName'
	,c.email as 'username'
	,COALESCE(c.email,i.staffStateID+'@'+d.number+'.ncsis.gov') as 'email'
	,'1' as 'userTypeID' --1 = teacher, 3 = admin
	,'0' as 'adminTypeID' -- always 0 unless userTypeID is 3
	,REPLACE(REPLACE(REPLACE(COALESCE(c.workPhone,c.cellPhone,'5555555555'),'(',''),')',''),'-','') as 'phone'
	,'3' as 'currTypeID'
from dbo.District d
join dbo.School s ON s.districtID = d.districtID
join dbo.SchoolYear sy ON sy.active = 1
join dbo.Calendar cal ON cal.endYear = sy.endYear and cal.schoolID = s.schoolID
join dbo.Trial trl ON trl.calendarID = cal.calendarID and trl.active = 1
join dbo.Course crs ON crs.calendarID = cal.calendarID and crs.stateCode ='99329P0' --only PK Courses
join dbo.Section sec ON sec.trialID = trl.trialID and sec.courseID = crs.courseID
join dbo.SectionStaffHistory ssh ON ssh.trialID = trl.trialID and ssh.sectionID = sec.sectionID
join dbo.Individual i ON i.personID = ssh.personID
join dbo.Contact c ON c.personID = ssh.personID and c.districtID = d.districtID
OUTER APPLY (select top 1 startDate from Term join TermSchedule on TermSchedule.termScheduleID=Term.termScheduleID where TermSchedule.structureID=trl.structureID order by Term.startDate asc) sterm --find startDate of first term for the year
OUTER APPLY (select top 1 endDate from Term join TermSchedule on TermSchedule.termScheduleID=Term.termScheduleID where TermSchedule.structureID=trl.structureID order by Term.endDate desc) eterm --find endDate of last term for the year
where 1=1
--and ssh.staffType = 'P'
and (ssh.startDate IS NULL OR ssh.startDate <= @asof or @asof < sterm.startDate)
and (ssh.endDate IS NULL OR ssh.endDate >= @asof OR ssh.endDate=eterm.endDate)
and ISNUMERIC(d.number) = 1
and d.number<>'920'
--and RIGHT(s.number,3) >= '300'
and LEN(i.staffStateID) = 10