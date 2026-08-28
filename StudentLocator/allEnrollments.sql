/**********************************************
Script maintained by NCDPI, PSU Technology Systems Section.
See https://github.com/NCSIS/ncdpi-state-extracts.
**********************************************/
SELECT 
	p.studentNumber,
	d.number as districtNumber,
	d.name as districtName,
	s.number as schoolNumber,
	s.name as schoolName,
	i.lastName,
	i.firstName,
	i.birthdate,
	i.gender,
	grade,
	e.startDate,
	e.startStatus,
	IIF(e.noshow=1, e.startDate, e.endDate) as end_date,
	iif(e.noshow=1, 'NS', e.endStatus) as end_status,
	CASE WHEN EXISTS (
	 SELECT * from Graduation WHERE personId=p.personId AND districtId=d.districtId AND diplomaType IS NOT NULL AND diplomaDate IS NOT NULL
	)
	THEN '1'
	ELSE '0'
	END
	AS graduated
FROM
	enrollment e,
	calendar c,
	person p,
	[Identity] i,
	school s,
	district d
WHERE
	c.calendarID = e.calendarID
	AND p.personID = e.personID
	AND i.identityId = p.currentIdentityID
	AND s.schoolId = c.schoolId
	AND d.districtId=s.districtID
	AND d.number not in ('997','998');