select 
	 distinct CAST(d.number as varchar) + CASE WHEN RIGHT(scl.number,3) = '296' THEN CAST(RIGHT(ISNULL(cal.number,scl.number),3) as varchar) ELSE RIGHT(scl.number,3) END as 'Institution'
	,stu.stateID as 'Primary Student ID'
	,REPLACE(stu.firstName,',','') as 'First Name' 
	,REPLACE(stu.lastName,',','') as 'Last Name' 
	,REPLACE(stu.middleName,',','') as 'Middle Name' 
	,REPLACE(stu.Suffix,',','') as 'Suffix' 
	,CASE --WHEN ar.personID IS NOT NULL THEN '3'
		  WHEN gl.stateGrade like 'K%' THEN 'K'
		  WHEN gl.stateGrade like '0%' THEN REPLACE(gl.stateGrade,'0','')
		  ELSE gl.stateGrade END as 'Grade' 
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
join dbo.School scl ON scl.schoolID = cal.schoolID
join dbo.Student stu WITH(NOEXPAND) ON stu.calendarID = cal.calendarID
join dbo.GradeLevel gl ON gl.calendarID = cal.calendarID and gl.name = stu.grade and gl.structureID = stu.structureID
left outer join dbo.contact sc ON sc.personID = stu.personID and sc.districtID = d.districtID
outer apply (select top 1 personID
				from dbo.section504 s
				where s.personID = stu.personID
				and s.districtID = d.districtID
				and s.startDate <= getdate()
				and (s.endDate IS NULL OR s.endDate >= getdate())
				) s504
outer apply (select top 1 personID
				from dbo.Migrant m
				where m.lastQualifyingArrivalDate <= getdate()
				and (m.eligibilityExpirationDate IS NULL OR m.eligibilityExpirationDate >= getdate())
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
				and (ses.startDate <= getdate() OR ses.startDate IS NULL)
				and (ses.endDate IS NULL OR ses.endDate >= getdate())
				and (ses.exitReason IS NULL OR LTRIM(RTRIM(ses.exitReason)) = '')
				order by ses.specialEDStateID asc) ses
outer apply (select top 1 r.personID
				from dbo.AtRisk r
				where r.personID = stu.personID
				and r.districtID = stu.districtID
				and r.[status] = 'RRET'
				and r.startDate <= getdate()
				and (r.endDate IS NULL OR r.endDate >= getdate())
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
			and (ros.startDate IS NULL OR ros.startDate <= getdate() or getdate() < dy.date)
			and (
				(ros.endDate IS NULL OR ros.endDate >= getdate())
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
			)
and (stu.startDate <= getdate()
	or
	getdate() < dy.date
	)
and (
	stu.endDate IS NULL OR stu.endDate >= getdate()
	)
and stu.serviceType = 'P'
and (RIGHT(scl.number,3) >= '300'
	OR
	ISNUMERIC(SUBSTRING(d.number,3,1)) = 0
	)
and (gl.stateGrade IN('KG','01','02','03')
	OR (ar.personID IS NOT NULL and gl.stateGrade = '04')
	OR (exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade4 = 1) and gl.stateGrade = '04')
	OR (exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade5 = 1) and gl.stateGrade = '05')
	--OR (exists(select 1 from cust.ncdpi_amplify_456_schools s2 where s2.schoolNumber = scl.number and grade6 = 1) and gl.stateGrade = '06')
	)
