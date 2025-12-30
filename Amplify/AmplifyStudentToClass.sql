select distinct
	 d.number + CASE WHEN RIGHT(scl.number,3) = '296' THEN RIGHT(ISNULL(cal.number,scl.number),3) ELSE RIGHT(scl.number,3) END as 'Institution'
	,sec.sectionID as 'Primary Class ID'
	,stu.stateID as 'Primary Student ID'
	,'Yes' as 'Is Official Class'
from dbo.District d
join dbo.SchoolYear sy ON sy.active = 1
join dbo.Calendar cal ON cal.districtID = d.districtID and cal.endYear = sy.endYear
join dbo.Student stu WITH(NOEXPAND) ON stu.calendarID = cal.calendarID
join dbo.School scl ON scl.schoolID = cal.schoolID
join dbo.Trial trl ON trl.calendarID = cal.calendarID and trl.active = 1
join dbo.Section sec ON sec.trialID = trl.trialID
join dbo.Course crs ON crs.courseID = sec.courseID and crs.calendarID = cal.calendarID and crs.active = 1
join dbo.Roster ros ON ros.personID = stu.personID and ros.trialID = trl.trialID and ros.sectionID = sec.sectionID
join dbo.GradeLevel gl ON gl.calendarID = cal.calendarID and gl.name = stu.grade and gl.structureID = stu.structureID
cross apply (select top 1 date from dbo.day dy where dy.calendarID = cal.calendarID and dy.schoolDay = 1 order by date asc) dy
outer apply (select top 1 r.personID
				from dbo.AtRisk r
				where r.personID = stu.personID
				and r.[status] = 'RRET'
				and r.startDate <= getdate()
				and (r.endDate IS NULL OR r.endDate >= getdate())
				and r.endYear = stu.endYear
				and r.grade = '04'
				) ar
where 1=1
and (stu.startDate <= getdate()
	or getdate() < dy.date)
and (
	(stu.endDate IS NULL OR stu.endDate >= getdate())
	)
and stu.serviceType = 'P'
and (ros.startDate IS NULL OR ros.startDate <= getdate() or getdate() < dy.date)
and (
	(ros.endDate IS NULL OR ros.endDate >= getdate())
	)
and (RIGHT(scl.number,3) >= '300'
	OR
	ISNUMERIC(SUBSTRING(d.number,3,1)) = 0
	)
and (
	LEFT(crs.stateCode,4) IN('1050','1051','1052','1053')--,'1054','1055')
	or crs.stateCode IN('11512Z0','11512Z1','11512Z2','11512Z3')
	OR (ar.personID IS NOT NULL and LEFT(crs.stateCode,4) = '1054')
	OR (exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade4 = 1) and LEFT(crs.stateCode,4) IN('1054'))
	OR (exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade5 = 1) and LEFT(crs.stateCode,4) IN('1055'))
	--OR (exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade6 = 1) and LEFT(crs.stateCode,4) IN('1056'))
	OR (exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade4 = 1) and d.number='681' and crs.stateCode='11512Z4') --enable 4th DLI course for 681 enabled schools only
	OR (exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade5 = 1) and d.number='681' and crs.stateCode='11512Z5') --enable 5th DLI course for 681 enabled schools only
	)
and (gl.stateGrade IN('KG','01','02','03')
	OR (ar.personID IS NOT NULL and gl.stateGrade = '04')
	OR (exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade4 = 1) and gl.stateGrade = '04')
	OR (exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade5 = 1) and gl.stateGrade = '05')
	--OR (exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade6 = 1) and gl.stateGrade = '06')
	)