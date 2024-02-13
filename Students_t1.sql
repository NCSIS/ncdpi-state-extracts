SELECT
s.[stateID] as PUPIL_NUMBER,
s.[lastName] as LAST_NAME,
s.[firstName] as FIRST_NAME,
s.[middleName] as MIDDLE_NAME,
s.[suffix] as NAME_SUFFIX,
CONVERT(VARCHAR(8), s.[birthdate], 112) as BIRTH_DATE,
s.[stateGrade] as GRADE,
s.[districtID] as LEA_CODE,
d.[name] as LEA_DESC,
s.[schoolID] as SCHOOL_CODE,
sch.[name] as SCHOOL_DESC,
c.[email] as EMAIL,
NULL as TEACHER_STAFF_ID,
c.[email] as LEA_ID /*alias ID*/

FROM
[Training].[dbo].[student] s,
[Training].[dbo].[school] sch,
[Training].[dbo].[district] d,
[Training].[dbo].[Contact] c

WHERE
/* Make sure it's an active student who isn't exited in the active calendar */
s.stateID is not null
AND s.activeYear=1
AND s.endStatus is null
AND s.enrollmentStateExclude=0
/* Table links */
AND sch.[schoolID] = s.[schoolID]
AND d.[districtID] = s.[districtID]
AND s.[personID] = c.[personID]