/**********************************************
Script maintained by NCDPI, PSU Technology Systems Section.
See https://github.com/NCSIS/ncdpi-state-extracts.
**********************************************/
DECLARE @asof datetime2 = SYSDATETIME();
select 
	 distinct CAST(d.number as varchar) + CASE WHEN RIGHT(scl.number,3) = '296' THEN CAST(RIGHT(ISNULL(cal.number,scl.number),3) as varchar) ELSE RIGHT(scl.number,3) END as 'Institution'
	,stu.stateID as 'Primary Student ID'
	,REPLACE(stu.firstName,',','') as 'First Name' 
	,REPLACE(stu.lastName,',','') as 'Last Name' 
	,REPLACE(stu.middleName,',','') as 'Middle Name' 
	,REPLACE(stu.Suffix,',','') as 'Suffix' 
	,CASE --WHEN ar.personID IS NOT NULL THEN '3'
		  WHEN stu.stateGrade like 'K%' THEN 'K'
		  WHEN stu.stateGrade like '0%' THEN REPLACE(stu.stateGrade,'0','')
		  ELSE stu.stateGrade END as 'Grade' 
	,FORMAT(stu.birthdate,'dd-MMM-yy') as 'Date of Birth (DOB)'
	,COALESCE(stu.legalGender,stu.gender) as 'Gender' 
	,REPLACE(sc.email,',','') as 'email'
	,CASE WHEN ISNULL(stu.hispanicEthnicity,'N') = 'Y' THEN 'H'
		  WHEN stu.raceEthnicityFed = 2 THEN 'AI'
		  WHEN stu.raceEthnicityFed = 3 THEN 'AS'
		  WHEN stu.raceEthnicityFed = 4 THEN 'B'
		  WHEN stu.raceEthnicityFed = 5 THEN 'J'
		  WHEN stu.raceEthnicityFed = 6 THEN 'W'
		  WHEN stu.raceEthnicityFed = 7 THEN 'M'
		  ELSE 'NS' END as 'Race/Ethnicity'
	,CASE WHEN ses.primaryArea IS NOT NULL AND ses.primaryArea <> '' THEN 'Yes' ELSE 'No' END as 'Student with Disabilities' --pull from ECATS screen
	,ses.primaryArea 'Specific Disability' --pull from ECATS screen
	,'' as 'Title I' 
	,CASE WHEN mig.personID IS NOT NULL THEN 'Y' ELSE 'N' END as 'Migrant'
	,CASE WHEN el.programStatus = 'LEP' THEN 'LEP'
		  ELSE 'NS'
		  END
		  as 'English Proficiency' 
	,CASE WHEN el.programStatus = 'LEP' THEN 'Y' ELSE 'N' END as 'ESL'
	,stu.homePrimaryLanguage as 'Language Spoken at Home'
	,CASE WHEN ar.personID IS NOT NULL THEN 'Y' ELSE '' END as 'Reading Retained'
from dbo.District d
join dbo.SchoolYear sy ON sy.active = 1
join dbo.Calendar cal ON cal.districtID = d.districtID and cal.endYear = sy.endYear
cross apply (select top 1 date from dbo.day dy where dy.calendarID = cal.calendarID and dy.schoolDay = 1 order by date asc) dy
cross apply (select top 1 date from dbo.day dy where dy.calendarID = cal.calendarID and dy.schoolDay = 1 order by date desc) dyl
join dbo.School scl ON scl.schoolID = cal.schoolID
join dbo.Student stu WITH(NOEXPAND) ON stu.calendarID = cal.calendarID
left outer join dbo.contact sc ON sc.personID = stu.personID and sc.districtID = d.districtID
outer apply (select 1 as charter where ISNUMERIC(SUBSTRING(d.number,3,1)) = 0) psu_type
outer apply (select top 1 personID
				from dbo.section504 s
				where s.personID = stu.personID
				and s.districtID = d.districtID
				and s.startDate <= @asof
				and (s.endDate IS NULL OR s.endDate >= @asof)
				) s504
outer apply (select top 1 personID
				from dbo.Migrant m
				where m.lastQualifyingArrivalDate <= @asof
				and (m.eligibilityExpirationDate IS NULL OR m.eligibilityExpirationDate >= @asof)
				and m.personID = stu.personID
				and m.districtID = stu.districtID
				) mig
outer apply (select top 1 programStatus
				from dbo.lep 
				where lep.personID = stu.personID
				and lep.districtID = stu.districtID
				order by lep.identifiedDate desc
				) el
outer apply (select top 1 
			CASE WHEN ses.primaryDisability = 'AU' THEN 'Aut'
				 WHEN ses.primaryDisability = 'DD' THEN 'Dev'
				 WHEN ses.primaryDisability = 'ED' THEN 'Emot'
				 WHEN ses.primaryDisability = 'HI' THEN 'Hear'
				 WHEN ses.primaryDisability IN('IDMO','IDMI') THEN 'Int'
				 WHEN ses.primaryDisability = 'LD' THEN 'Spec'
				 WHEN ses.primaryDisability = 'MU' THEN 'Mult'
				 WHEN ses.primaryDisability = 'OH' THEN 'Oth'
				 WHEN ses.primaryDisability = 'SI' THEN 'Lang'
				 WHEN ses.primaryDisability = 'TB' THEN 'Trau'
				 WHEN ses.primaryDisability = 'VI' THEN 'Vis'
				 WHEN ses.primaryDisability IN('DF','DB') THEN 'Deaf'
				 ELSE '' END as primaryArea
				from dbo.SpecialEdState ses
				where ses.personID = stu.personID
				and ses.districtID = stu.districtID
				and (ses.startDate <= @asof OR ses.startDate IS NULL)
				and (ses.endDate IS NULL OR ses.endDate >= @asof)
				and (ses.exitReason IS NULL OR LTRIM(RTRIM(ses.exitReason)) = '')
				order by ses.specialEDStateID asc) ses
outer apply (select top 1 r.personID
				from dbo.AtRisk r
				where r.personID = stu.personID
				and r.districtID = stu.districtID
				and r.[status] = 'RRET'
				and r.startDate <= @asof
				and (r.endDate IS NULL OR r.endDate >= @asof)
				and r.endYear = stu.endYear
				and r.grade = '04'
				) ar
where 1=1
and exists(select 1
			from (select trialID
					from dbo.Trial trl 
					where trl.calendarID = cal.calendarID and trl.active = 1
					) trl
			join dbo.Section sec ON sec.trialID = trl.trialID
			join dbo.Course crs ON crs.courseID = sec.courseID and crs.calendarID = cal.calendarID and crs.active = 1
			join dbo.Roster ros ON ros.personID = stu.personID and ros.trialID = trl.trialID and ros.sectionID = sec.sectionID
			and (ros.startDate IS NULL OR ros.startDate <= @asof or @asof < dy.date)
			and (
				(ros.endDate IS NULL OR ros.endDate >= @asof OR ros.endDate=dyl.date)
				)
			and (
				LEFT(crs.stateCode,4) IN('1050','1051','1052','1053') -- "regular" K-3 ELA for all
				or crs.stateCode IN('11512Z0','11512Z1','11512Z2','11512Z3') -- "DL/I" K-3 ELA for all
				or (psu_type.charter is null and LEFT(crs.stateCode,4) IN('1054','1055')) -- "regular" 4/5 ELA for LEAs
				OR (psu_type.charter=1 and exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade4 = 1) and LEFT(crs.stateCode,4) IN('1054')) --opt-in "regular" 4 ELA for charters
				OR (psu_type.charter=1 and exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade5 = 1) and LEFT(crs.stateCode,4) IN('1055')) --opt-in "regular" 5 ELA for charters
				)
			)
and (stu.startDate <= @asof
	or
	@asof < dy.date
	)
and (
	stu.endDate IS NULL OR stu.endDate >= @asof OR stu.endDate=dyl.date
	)
and stu.serviceType = 'P'
and (RIGHT(scl.number,3) >= '300'
	OR
	psu_type.charter=1
	)
and stu.stateGrade IN('KG','01','02','03','04','05')