/**********************************************
Script maintained by NCDPI, PSU Technology Systems Section.
See https://github.com/NCSIS/ncdpi-state-extracts.
**********************************************/
select distinct
	 d.number as 'sourceProgramID'
	,CASE
	      WHEN LEN(s.number) = 3 THEN d.number + s.number 
		  ELSE s.number 
		  END as 'sourceSiteID'
	,LEFT(s.name,50) as 'name'
	,COALESCE(LEFT(s.address,30),'None') as 'address1'
	,COALESCE(LEFT(s.city,20),'None') as 'city'
	,COALESCE(s.state,'NC') as 'state'
	,COALESCE(s.zip,'00000') as 'zip'
	,'US' as 'countryID'
	,REPLACE(REPLACE(REPLACE(REPLACE(COALESCE(s.phone,d.phone,'5555555555'),'(',''),')',''),'-',''),' ','') as 'phone'
	,'2' as 'siteAffiliationID'
from dbo.District d
join dbo.School s ON s.districtID = d.districtID
join dbo.SchoolYear sy ON sy.active = 1
join dbo.Calendar cal ON cal.endYear = sy.endYear and cal.schoolID = s.schoolID
where 1=1
and d.number<>'920'
and ISNUMERIC(d.number) = 1
and (
	exists(
			select 1
			from dbo.Course crs
			where crs.calendarID = cal.calendarID
			and crs.stateCode = '99329P0' --only PK Courses
			and crs.active = 1
			) --"schools using this course code"
	or exists(
		select 1 from GradeLevel where stateGrade in ('IT','PR','PK') and GradeLevel.calendarID=cal.calendarID
	) --"schools with PreK grade level per EDDIE"
)
/*and exists(
	select 1 from GradeLevel where stateGrade in ('IT','PR','PK') and GradeLevel.calendarID=cal.calendarID
) */ --3538 "schools that say they have PreK"
/* and exists(
	select top 1 personID from Student where stateGrade in ('IT','PR','PK') and calendarID=cal.calendarID
) */ --1273 "schools that actually have PreK students"
--and RIGHT(s.number,3) >= '300'
	