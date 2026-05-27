select distinct
	 stu.stateID as 'sourceChildID'
	,d.number + LEFT(crs.number,4) + '-' + CAST(crs.sectionID as varchar) as 'sourceClassID'
	,FORMAT(stu.birthDate,'yyyy-MM-dd') as 'Birthdate'
	,CASE WHEN stu.raceEthnicityFed = 1 THEN '38' --Hispanic
		  WHEN stu.raceEthnicityFed = 2 THEN '37' --American Indian
		  WHEN stu.raceEthnicityFed = 3 THEN '45' --Asian
		  WHEN stu.raceEthnicityFed = 4 THEN '2' --Black
		  WHEN stu.raceEthnicityFed = 5 THEN '23' --Hawaiian
		  WHEN stu.raceEthnicityFed = 6 THEN '1' --White
		  WHEN stu.raceEthnicityFed = 7 THEN '44' --two or more
		  ELSE '43' --unknown
	 END as 'RaceID'
	,CASE WHEN ISNULL(stu.hispanicEthnicity,'N') = 'Y' THEN '23' ELSE '1' END as 'EthID'
	,stu.lastName as 'LastName'
	,stu.firstName as 'FirstName'
	,'0' as 'SpanishObj_fl' --defaulting this - no definition in specs
	,FORMAT(stu.startDate,'yyyy-MM-dd') as 'FirstDayinProgram'
	,'6' as 'ColorID' 
	,CASE WHEN stu.gender = 'M' THEN '1' WHEN stu.gender = 'F' THEN '2' ELSE '' END as 'GenderID'
	,CASE WHEN homePrimaryLanguage='eng' THEN '1'
			WHEN homePrimaryLanguage='spa' THEN '2'
			WHEN homePrimaryLanguage='cmn' THEN '5'
			WHEN homePrimaryLanguage='nan' THEN '5'
			WHEN homePrimaryLanguage='zho' THEN '5'
			WHEN homePrimaryLanguage='deu' THEN '7'
			WHEN homePrimaryLanguage='tgl' THEN '8'
			WHEN homePrimaryLanguage='vie' THEN '9'
			WHEN homePrimaryLanguage='ita' THEN '10'
			WHEN homePrimaryLanguage='rus' THEN '11'
			WHEN homePrimaryLanguage='pol' THEN '12'
			WHEN homePrimaryLanguage='afr' THEN '16'
			WHEN homePrimaryLanguage='amh' THEN '20'
			WHEN homePrimaryLanguage='ben' THEN '24'
			WHEN homePrimaryLanguage='bul' THEN '26'
			WHEN homePrimaryLanguage='mya' THEN '27'
			WHEN homePrimaryLanguage='cha' THEN '29'
			WHEN homePrimaryLanguage='chr' THEN '30'
			WHEN homePrimaryLanguage='hrv' THEN '31'
			WHEN homePrimaryLanguage='ces' THEN '33'
			WHEN homePrimaryLanguage='dan' THEN '34'
			WHEN homePrimaryLanguage='nld' THEN '35'
			WHEN homePrimaryLanguage='fin' THEN '36'
			WHEN homePrimaryLanguage='ell' THEN '39'
			WHEN homePrimaryLanguage='guj' THEN '40'
			WHEN homePrimaryLanguage='haw' THEN '41'
			WHEN homePrimaryLanguage='heb' THEN '42'
			WHEN homePrimaryLanguage='hin' THEN '43'
			WHEN homePrimaryLanguage='hun' THEN '46'
			WHEN homePrimaryLanguage='ind' THEN '48'
			WHEN homePrimaryLanguage='gle' THEN '49'
			WHEN homePrimaryLanguage='jam' THEN '50'
			WHEN homePrimaryLanguage='jpn' THEN '51'
			WHEN homePrimaryLanguage='kan' THEN '52'
			WHEN homePrimaryLanguage='kor' THEN '54'
			WHEN homePrimaryLanguage='kur' THEN '56'
			WHEN homePrimaryLanguage='lao' THEN '57'
			WHEN homePrimaryLanguage='lit' THEN '59'
			WHEN homePrimaryLanguage='mkd' THEN '60'
			WHEN homePrimaryLanguage='mal' THEN '62'
			WHEN homePrimaryLanguage='mar' THEN '64'
			WHEN homePrimaryLanguage='npi' THEN '67'
			WHEN homePrimaryLanguage='nor' THEN '68'
			WHEN homePrimaryLanguage='ron' THEN '78'
			WHEN homePrimaryLanguage='smo' THEN '80'
			WHEN homePrimaryLanguage='srp' THEN '81'
			WHEN homePrimaryLanguage='hbs' THEN '82'
			WHEN homePrimaryLanguage='slk' THEN '84'
			WHEN homePrimaryLanguage='swa' THEN '86'
			WHEN homePrimaryLanguage='swe' THEN '87'
			WHEN homePrimaryLanguage='tam' THEN '89'
			WHEN homePrimaryLanguage='tel' THEN '90'
			WHEN homePrimaryLanguage='tha' THEN '91'
			WHEN homePrimaryLanguage='tur' THEN '93'
			WHEN homePrimaryLanguage='ukr' THEN '94'
			WHEN homePrimaryLanguage='som' THEN '97'
			WHEN homePrimaryLanguage IS NULL THEN '3'
			ELSE '0' END as 'LanguageID' 
	,LEFT(stu.middleName,1) as 'MiddleInitial'
from dbo.District d
join dbo.School s ON s.districtID = d.districtID
join dbo.SchoolYear sy ON sy.active = 1
join dbo.Calendar cal ON cal.endYear = sy.endYear and cal.schoolID = s.schoolID
join dbo.student stu WITH(NOEXPAND) ON stu.calendarID = cal.calendarID
join dbo.Trial trl ON trl.calendarID = cal.calendarID and trl.active = 1
/*changed below cross apply on 9/10/2025 to get top 1 - 1050, 1001 or 1151 - only send ONE record in this order*/
cross apply (select top 1 crs.number,sec.sectionID
			from dbo.Course crs 
			join dbo.Section sec ON sec.trialID = trl.trialID and sec.courseID = crs.courseID
			cross apply (select top 1 *
						from dbo.Roster ros 
						where ros.personID = stu.personID 
						and ros.trialID = trl.trialID 
						and ros.sectionID = sec.sectionID
						order by ISNULL(ros.startDate,stu.startDate) desc, CASE WHEN ros.endDate IS NULL THEN 1 WHEN ros.endDate > getdate() THEN 2 ELSE 3 END asc, ros.rosterID asc
						) ros
				where crs.calendarID = cal.calendarID 
				and (LEFT(crs.stateCode,4) IN('1050') OR crs.stateCode ='11512Z0') --only KG ELA courses --JBM updated 11/18/25, remove course 1001 per Dan Tetreault
				and (ros.startDate IS NULL OR ros.startDate <= getdate())
				and (ros.endDate IS NULL OR ros.endDate >= getdate())
order by CASE WHEN crs.stateCode like '1050%' THEN 1 WHEN crs.stateCode like '1001%' THEN 2 ELSE 3 END
			) crs
cross apply (select top 1 date from dbo.day d where d.calendarID = cal.calendarID and ISNULL(d.schoolDay,0) = 1 order by date asc) dy
where 1=1
and (stu.startDate <= getdate()
	or getdate() < dy.date
	)
and (
	(stu.endDate IS NULL OR stu.endDate >= getdate())
	)
/*9/10/2025 MAY be changing below when PK, 1, 2, 3 grades are added*/
and ISNUMERIC(s.number) = 1
and ISNUMERIC(d.number) = 1
and (RIGHT(s.number,3) >= '300'
	--OR
	--ISNUMERIC(SUBSTRING(d.number,3,1)) = 0
	)
and stu.stateID IS NOT NULL

/*original before email 11/19/2024
select distinct
	 stu.stateID as 'sourceChildID'
	,d.number + LEFT(crs.number,4) + '-' + CAST(sec.sectionID as varchar) as 'sourceClassID'
	,FORMAT(stu.birthDate,'yyyy-MM-dd') as 'Birthdate'
	,CASE WHEN stu.raceEthnicityFed = 1 THEN '38' --Hispanic
		  WHEN stu.raceEthnicityFed = 2 THEN '37' --American Indian
		  WHEN stu.raceEthnicityFed = 3 THEN '45' --Asian
		  WHEN stu.raceEthnicityFed = 4 THEN '2' --Black
		  WHEN stu.raceEthnicityFed = 5 THEN '23' --Hawaiian
		  WHEN stu.raceEthnicityFed = 6 THEN '1' --White
		  WHEN stu.raceEthnicityFed = 7 THEN '44' --two or more
		  ELSE '43' --unknown
	 END as 'RaceID'
	,CASE WHEN ISNULL(stu.hispanicEthnicity,'N') = 'Y' THEN '23' ELSE '1' END as 'EthID'
	,stu.lastName as 'LastName'
	,stu.firstName as 'FirstName'
	,'0' as 'SpanishObj_fl' --defaulting this - no definition in specs
	,FORMAT(stu.startDate,'yyyy-MM-dd') as 'FirstDayinProgram'
	,'6' as 'ColorID' 
	,CASE WHEN stu.gender = 'M' THEN '1' WHEN stu.gender = 'F' THEN '2' ELSE '' END as 'GenderID'
	,CASE WHEN homePrimaryLanguage='eng' THEN '1'
			WHEN homePrimaryLanguage='spa' THEN '2'
			WHEN homePrimaryLanguage='cmn' THEN '5'
			WHEN homePrimaryLanguage='nan' THEN '5'
			WHEN homePrimaryLanguage='zho' THEN '5'
			WHEN homePrimaryLanguage='deu' THEN '7'

			WHEN homePrimaryLanguage='tgl' THEN '8'
			WHEN homePrimaryLanguage='vie' THEN '9'
			WHEN homePrimaryLanguage='ita' THEN '10'
			WHEN homePrimaryLanguage='rus' THEN '11'
			WHEN homePrimaryLanguage='pol' THEN '12'
			WHEN homePrimaryLanguage='afr' THEN '16'
			WHEN homePrimaryLanguage='amh' THEN '20'
			WHEN homePrimaryLanguage='ben' THEN '24'
			WHEN homePrimaryLanguage='bul' THEN '26'
			WHEN homePrimaryLanguage='mya' THEN '27'
			WHEN homePrimaryLanguage='cha' THEN '29'
			WHEN homePrimaryLanguage='chr' THEN '30'
			WHEN homePrimaryLanguage='hrv' THEN '31'
			WHEN homePrimaryLanguage='ces' THEN '33'
			WHEN homePrimaryLanguage='dan' THEN '34'
			WHEN homePrimaryLanguage='nld' THEN '35'
			WHEN homePrimaryLanguage='fin' THEN '36'
			WHEN homePrimaryLanguage='ell' THEN '39'
			WHEN homePrimaryLanguage='guj' THEN '40'
			WHEN homePrimaryLanguage='haw' THEN '41'
			WHEN homePrimaryLanguage='heb' THEN '42'
			WHEN homePrimaryLanguage='hin' THEN '43'
			WHEN homePrimaryLanguage='hun' THEN '46'
			WHEN homePrimaryLanguage='ind' THEN '48'
			WHEN homePrimaryLanguage='gle' THEN '49'
			WHEN homePrimaryLanguage='jam' THEN '50'
			WHEN homePrimaryLanguage='jpn' THEN '51'
			WHEN homePrimaryLanguage='kan' THEN '52'
			WHEN homePrimaryLanguage='kor' THEN '54'
			WHEN homePrimaryLanguage='kur' THEN '56'
			WHEN homePrimaryLanguage='lao' THEN '57'
			WHEN homePrimaryLanguage='lit' THEN '59'
			WHEN homePrimaryLanguage='mkd' THEN '60'
			WHEN homePrimaryLanguage='mal' THEN '62'
			WHEN homePrimaryLanguage='mar' THEN '64'
			WHEN homePrimaryLanguage='npi' THEN '67'
			WHEN homePrimaryLanguage='nor' THEN '68'
			WHEN homePrimaryLanguage='ron' THEN '78'
			WHEN homePrimaryLanguage='smo' THEN '80'
			WHEN homePrimaryLanguage='srp' THEN '81'
			WHEN homePrimaryLanguage='hbs' THEN '82'
			WHEN homePrimaryLanguage='slk' THEN '84'
			WHEN homePrimaryLanguage='swa' THEN '86'
			WHEN homePrimaryLanguage='swe' THEN '87'
			WHEN homePrimaryLanguage='tam' THEN '89'
			WHEN homePrimaryLanguage='tel' THEN '90'
			WHEN homePrimaryLanguage='tha' THEN '91'
			WHEN homePrimaryLanguage='tur' THEN '93'
			WHEN homePrimaryLanguage='ukr' THEN '94'
			WHEN homePrimaryLanguage='som' THEN '97'
			WHEN homePrimaryLanguage IS NULL THEN '3'
			ELSE '0' END as 'LanguageID' 
	,LEFT(stu.middleName,1) as 'MiddleInitial'
from dbo.District d
join dbo.School s ON s.districtID = d.districtID
join dbo.SchoolYear sy ON sy.active = 1
join dbo.Calendar cal ON cal.endYear = sy.endYear and cal.schoolID = s.schoolID
join dbo.student stu WITH(NOEXPAND) ON stu.calendarID = cal.calendarID
join dbo.Trial trl ON trl.calendarID = cal.calendarID and trl.active = 1
join dbo.Course crs ON crs.calendarID = cal.calendarID and (LEFT(crs.stateCode,4) IN('1050','1001') OR crs.stateCode ='11512Z0') --only KG ELA courses
join dbo.Section sec ON sec.trialID = trl.trialID and sec.courseID = crs.courseID
join dbo.Roster ros ON ros.personID = stu.personID and ros.trialID = trl.trialID and ros.sectionID = sec.sectionID
cross apply (select top 1 date from dbo.day d where d.calendarID = cal.calendarID and ISNULL(d.schoolDay,0) = 1 order by date asc) dy
where 1=1
and (stu.startDate <= getdate()
	or getdate() < dy.date
	)
and (
	(stu.endDate IS NULL OR stu.endDate >= getdate())
	)
and ISNUMERIC(s.number) = 1
and ISNUMERIC(d.number) = 1
and (RIGHT(s.number,3) >= '300'
	--OR
	--ISNUMERIC(SUBSTRING(d.number,3,1)) = 0
	)
and stu.stateID IS NOT NULL
*/
	