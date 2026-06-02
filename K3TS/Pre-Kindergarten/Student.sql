/**********************************************
Script maintained by NCDPI, PSU Technology Systems Section.
See https://github.com/NCSIS/ncdpi-state-extracts.
**********************************************/

IF OBJECT_ID('tempdb..#PKTScounties') IS NOT NULL DROP TABLE #PKTScounties;
CREATE TABLE #PKTScounties(
  LEA_CODE      varchar(3)   NOT NULL,
  COUNTY_CODE	varchar(3)           NOT NULL,
);
insert into #PKTScounties (LEA_CODE,COUNTY_CODE) values
	('010','001'),('020','002'),('030','003'),('040','004'),('050','005'),('060','006'),('070','007'),('080','008'),('090','009'),('100','010'),('110','011'),('111','011'),('120','012'),('130','013'),('132','013'),('140','014'),('150','015'),('160','016'),('170','017'),('180','018'),('181','018'),('182','018'),('190','019'),('200','020'),('209','087'),('210','021'),('220','022'),('230','023'),('240','024'),('241','024'),('250','025'),('260','026'),('269','026'),('270','027'),('280','028'),('290','029'),('291','029'),('292','029'),('296','098'),('297','012'),('298','999'),('299','999'),('300','030'),('310','031'),('320','032'),('330','033'),('340','034'),('350','035'),('360','036'),('370','037'),('380','038'),('390','039'),('400','040'),('410','041'),('420','042'),('421','042'),('422','042'),('430','043'),('440','044'),('450','045'),('460','046'),('470','047'),('480','048'),('486','999'),('490','049'),('491','049'),('500','050'),('510','051'),('520','052'),('530','053'),('540','054'),('550','055'),('560','056'),('570','057'),('580','058'),('590','059'),('600','060'),('610','061'),('620','062'),('630','063'),('640','064'),('650','065'),('660','066'),('670','067'),('679','026'),('680','068'),('681','068'),('690','069'),('700','070'),('710','071'),('720','072'),('730','073'),('740','074'),('750','075'),('760','076'),('761','076'),('770','077'),('780','078'),('790','079'),('800','080'),('810','081'),('820','082'),('821','082'),('830','083'),('840','084'),('850','085'),('860','086'),('861','086'),('862','086'),('870','087'),('880','088'),('890','089'),('900','090'),('910','091'),('920','092'),('930','093'),('940','094'),('950','095'),('960','096'),('970','097'),('980','098'),('990','099'),('995','100'),('996','999'),('997','999'),('998','092')
;

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
	,CASE stu.stateGrade
		WHEN 'IT' then '4'
		WHEN 'PR' then '4'
		WHEN 'PK' then '5'
	END as 'ColorID' 
	,'0' as 'SpanishObj_fl' --specs say hardcode 0
	,stu.lastName as 'LastName'
	,stu.firstName as 'FirstName'
	,FORMAT(stu.startDate,'yyyy-MM-dd') as 'FirstDayinProgram'
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
	,CASE WHEN eLNCPK.bool=1 THEN '1' ELSE '0' END as 'customResponseValue2' --if Enroll is NC Pre-K, 1. Else 0.
	,CASE WHEN eLHS.bool=1 THEN '2' ELSE '3' END as 'customResponseValue3' --if Enroll is Head Start, 2. Else 3.
	,#PKTScounties.COUNTY_CODE as 'customResponseValue4' -- county code from TeachingStrategies crosswalk.
	,'1' as 'customResponseValue5' --if Enroll is in an LEA operated classroom, 1. So hardcode 1 from NCSIS.
from dbo.District d
join dbo.School s ON s.districtID = d.districtID
join dbo.SchoolYear sy ON sy.active = 1
join dbo.Calendar cal ON cal.endYear = sy.endYear and cal.schoolID = s.schoolID
join dbo.student stu WITH(NOEXPAND) ON stu.calendarID = cal.calendarID
join dbo.Trial trl ON trl.calendarID = cal.calendarID and trl.active = 1
join #PKTScounties ON d.number=#PKTScounties.LEA_CODE
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
				and crs.stateCode ='99329P0' --only PK Courses
				and (ros.startDate IS NULL OR ros.startDate <= getdate())
				and (ros.endDate IS NULL OR ros.endDate >= getdate())
			) crs
cross apply (select top 1 date from dbo.day d where d.calendarID = cal.calendarID and ISNULL(d.schoolDay,0) = 1 order by date asc) dy
outer apply (select 1 as bool from EarlyLearningEnrollmentType join EarlyLearning on EarlyLearning.earlyLearningID=EarlyLearningEnrollmentType.earlyLearningID where EarlyLearning.personID=stu.personID and EarlyLearning.districtID=stu.districtID and value=6) eLNCPK --is student NC Pre-K?
outer apply (select 1 as bool from EarlyLearningEnrollmentType join EarlyLearning on EarlyLearning.earlyLearningID=EarlyLearningEnrollmentType.earlyLearningID where EarlyLearning.personID=stu.personID and EarlyLearning.districtID=stu.districtID and value=4) eLHS --is student Head Start?
where 1=1
and (stu.startDate <= getdate()
	or getdate() < dy.date
	)
and (
	(stu.endDate IS NULL OR stu.endDate >= getdate())
	)
and ISNUMERIC(s.number) = 1
and ISNUMERIC(d.number) = 1
--and (RIGHT(s.number,3) >= '300')
and stu.stateID > '1000000000';

IF OBJECT_ID('tempdb..#PKTScounties') IS NOT NULL DROP TABLE #PKTScounties;