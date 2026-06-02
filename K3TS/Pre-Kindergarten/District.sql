/**********************************************
Script maintained by NCDPI, PSU Technology Systems Section.
See https://github.com/NCSIS/ncdpi-state-extracts.
**********************************************/
select d.number as 'sourceProgramID'
	,LEFT(d.name,50) as 'name'
	,COALESCE(LEFT(d.address,30),'None') as 'address1'
	,COALESCE(LEFT(d.city,20),'None') as 'city'
	,COALESCE(d.state,'NC') as 'state'
	,COALESCE(d.zip,'00000') as 'zip'
	,'US' as countryID
	,REPLACE(REPLACE(REPLACE(REPLACE(COALESCE(d.phone,'5555555555'),'(',''),')',''),'-',''),' ','') as 'phone'
from dbo.District d
where 1=1
and ISNUMERIC(d.number) = 1
and exists(select 1 
			from dbo.calendar cal 
			where cal.districtID = d.districtID 
			and cal.endYear = (select endYear from schoolYear where active = 1)
			)