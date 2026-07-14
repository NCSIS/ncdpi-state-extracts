/**********************************************
Script maintained by NCDPI, PSU Technology Systems Section.
See https://github.com/NCSIS/ncdpi-state-extracts.
**********************************************/
DECLARE @asof datetime2 = SYSDATETIME();
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
cross apply (select top 1 date from dbo.day dy where dy.calendarID = cal.calendarID and dy.schoolDay = 1 order by date asc) dy
cross apply (select top 1 date from dbo.day dy where dy.calendarID = cal.calendarID and dy.schoolDay = 1 order by date desc) dyl
outer apply (select 1 as charter where ISNUMERIC(SUBSTRING(d.number,3,1)) = 0) psu_type
outer apply (select top 1 r.personID
				from dbo.AtRisk r
				where r.personID = stu.personID
				and r.[status] = 'RRET'
				and r.startDate <= @asof
				and (r.endDate IS NULL OR r.endDate >= @asof)
				and r.endYear = stu.endYear
				and r.grade = '04'
				) ar
where 1=1
and (stu.startDate <= @asof
	or @asof < dy.date)
and (
	(stu.endDate IS NULL OR stu.endDate >= @asof OR stu.endDate=dyl.date)
	)
and stu.serviceType = 'P'
and (ros.startDate IS NULL OR ros.startDate <= @asof or @asof < dy.date)
and (
	(ros.endDate IS NULL OR ros.endDate >= @asof OR ros.endDate=dyl.date)
	)
and (RIGHT(scl.number,3) >= '300'
	OR
	psu_type.charter=1
	)
and (
	LEFT(crs.stateCode,4) IN('1050','1051','1052','1053') -- "regular" K-3 ELA for all
	or crs.stateCode IN('11512Z0','11512Z1','11512Z2','11512Z3') -- "DL/I" K-3 ELA for all
	or (psu_type.charter is null and LEFT(crs.stateCode,4) IN('1054','1055')) -- "regular" 4/5 ELA for LEAs
	OR (psu_type.charter=1 and exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade4 = 1) and LEFT(crs.stateCode,4) IN('1054')) --opt-in "regular" 4 ELA for charters
	OR (psu_type.charter=1 and exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade5 = 1) and LEFT(crs.stateCode,4) IN('1055')) --opt-in "regular" 5 ELA for charters
	)
and stu.stateGrade IN('KG','01','02','03','04','05')