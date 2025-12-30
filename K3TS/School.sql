select 
	 d.number as 'sourceProgramID'
	,CASE WHEN s.number = '296' THEN d.number + ISNULL(cal.number,s.number)
	      WHEN LEN(s.number) = 3 THEN d.number + s.number 
		  ELSE s.number 
		  END as 'sourceSiteID'
	,CASE WHEN s.number like '%296' THEN cal.name ELSE LEFT(s.name,50) END as 'name'
	,LEFT(s.address,30) as 'address1'
	,LEFT(s.city,20) as 'city'
	,s.state as 'state'
	,s.zip as 'zip'
	,'US' as 'countryID'
	,REPLACE(REPLACE(REPLACE(REPLACE(s.phone,'(',''),')',''),'-',''),' ','') as 'phone'
	,'2' as 'siteAffiliationID'
from dbo.District d
join dbo.School s ON s.districtID = d.districtID
join dbo.SchoolYear sy ON sy.active = 1
join dbo.Calendar cal ON cal.endYear = sy.endYear and cal.schoolID = s.schoolID
where 1=1
and ISNUMERIC(d.number) = 1
and exists(
			select 1
			from dbo.Course crs
			where crs.calendarID = cal.calendarID
			and (LEFT(crs.stateCode,4) IN('1050') OR crs.stateCode = '11512Z0') --only KG ELA courses --JBM updated 11/18/25, remove course 1001 per Dan Tetreault
			and crs.active = 1
			)
and (RIGHT(s.number,3) >= '300'
	--OR
	--ISNUMERIC(SUBSTRING(d.number,3,1)) = 0
	)
	