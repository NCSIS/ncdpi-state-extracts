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

FROM [Training].[dbo].[student] s
INNER JOIN [Training].[dbo].[school] sch ON sch.[schoolID] = s.[schoolID]
INNER JOIN [Training].[dbo].[district] d ON d.[districtID] = s.[districtID]
INNER JOIN [Training].[dbo].[Contact] c ON c.[personID] = s.[personID]

WHERE
/* Make sure it's a student with a UID who's active in an active calendar */
s.stateID is not null
AND s.activeYear=1
AND s.endStatus is null
AND s.enrollmentStateExclude=0