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
			from dbo.Section sec
			join dbo.Trial trl on sec.trialID=trl.trialID and trl.active=1
			join dbo.Course crs on sec.courseID=crs.courseID
			where
			crs.stateCode='99329P0'
			and trl.calendarID=cal.calendarID
			) --"schools with sections of this course"
	or exists(
		select 1
		from dbo.student
		where
		student.stateGrade in ('PR','PK','IT')
		and student.calendarID=cal.calendarID
		) --"schools with PK enrolls"
)