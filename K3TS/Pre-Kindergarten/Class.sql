select distinct
	 d.number + LEFT(crs.number,4) + '-' + CAST(sec.sectionID as varchar) as 'sourceClassID'
	,d.number as 'SourceProgramID'
	,i.staffStateID as 'sourceUserID'
	,i.lastName as 'name'
	,'5' as 'colorIDList' --hard coded 5 for PK
	,'2' as 'CurrTypeID' --hard coded 2 for PK
	,MAX(CASE WHEN ssh2.rn = 1 THEN ssh2.staffStateID ELSE '' END) as SectionTeacher2ID
	,MAX(CASE WHEN ssh2.rn = 1 THEN ssh2.teacherName ELSE '' END) as Teacher2CoTeacher_FL
	,MAX(CASE WHEN ssh2.rn = 2 THEN ssh2.staffStateID ELSE '' END) as SectionTeacher3ID
	,MAX(CASE WHEN ssh2.rn = 2 THEN ssh2.teacherName ELSE '' END) as Teacher3CoTeacher_FL
	,MAX(CASE WHEN ssh2.rn = 3 THEN ssh2.staffStateID ELSE '' END) as SectionTeacher4ID
	,MAX(CASE WHEN ssh2.rn = 3 THEN ssh2.teacherName ELSE '' END) as Teacher4CoTeacher_FL
	,MAX(CASE WHEN ssh2.rn = 4 THEN ssh2.staffStateID ELSE '' END) as SectionTeacher5ID
	,MAX(CASE WHEN ssh2.rn = 4 THEN ssh2.teacherName ELSE '' END) as Teacher5CoTeacher_FL
	,MAX(CASE WHEN ssh2.rn = 5 THEN ssh2.staffStateID ELSE '' END) as SectionTeacher6ID
	,MAX(CASE WHEN ssh2.rn = 5 THEN ssh2.teacherName ELSE '' END) as Teacher6CoTeacher_FL
from dbo.District d
join dbo.School s ON s.districtID = d.districtID
join dbo.SchoolYear sy ON sy.active = 1
join dbo.Calendar cal ON cal.endYear = sy.endYear and cal.schoolID = s.schoolID
join dbo.Trial trl ON trl.calendarID = cal.calendarID and trl.active = 1
join dbo.Course crs ON crs.calendarID = cal.calendarID and crs.stateCode ='99329P0' --only PK Courses
join dbo.Section sec ON sec.trialID = trl.trialID and sec.courseID = crs.courseID
join dbo.SectionStaffHistory ssh ON ssh.trialID = trl.trialID and ssh.sectionID = sec.sectionID
join dbo.Individual i ON i.personID = ssh.personID
outer apply (select top 5 i2.staffStateID,i2.firstname + ' ' + i2.lastname as teacherName,ROW_NUMBER() OVER(PARTITION BY ssh2.sectionID ORDER BY ssh2.personID asc) rn
			from dbo.SectionStaffHistory ssh2 
			join dbo.individual i2 ON i2.personID = ssh2.personID
			where ssh2.sectionID = sec.sectionID
			and ssh2.trialID = trl.trialID
			and ssh2.staffType <> 'P'
			) ssh2
where 1=1
and ssh.staffType = 'P'
and ISNUMERIC(d.number) = 1
and (ssh.startDate IS NULL OR ssh.startDate <= getdate())
and (ssh.endDate IS NULL OR ssh.endDate >= getdate())
and ISNUMERIC(s.number) = 1
and ISNUMERIC(d.number) = 1
--and RIGHT(s.number,3) >= '300'
group by sec.sectionID,i.staffStateID,i.lastName,d.number,s.number,cal.number,crs.number
