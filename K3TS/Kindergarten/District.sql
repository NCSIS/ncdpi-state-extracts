select d.number as 'sourceProgramID'
	,LEFT(d.name,50) as 'name'
	,LEFT(d.address,30) as 'address1'
	,LEFT(d.city,20) as 'city'
	,d.state as 'state'
	,d.zip as 'zip'
	,'US' as countryID
	,REPLACE(REPLACE(REPLACE(REPLACE(d.phone,'(',''),')',''),'-',''),' ','') as 'phone'
from dbo.District d
where 1=1
and ISNUMERIC(d.number) = 1
and exists(select 1 
			from dbo.calendar cal 
			where cal.districtID = d.districtID 
			and cal.endYear = (select endYear from schoolYear where active = 1)
			)