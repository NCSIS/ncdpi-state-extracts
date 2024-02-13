SELECT
[stateID] as PUPIL_NUMBER,
[lastName] as LAST_NAME,
[firstName] as FIRST_NAME,
[middleName] as MIDDLE_NAME,
[suffix] as NAME_SUFFIX,
CAST([birthDate] as DATE) as BIRTH_DATE,
[stateGrade] as GRADE,
[districtID] as LEA_CODE,
NULL as LEA_DESC,
[schoolID] as SCHOOL_CODE,
[calendarName] as SCHOOL_DESC,
NULL as EMAIL,
NULL as TEACHER_STAFF_ID,
NULL as LEA_ID
FROM [Training].[dbo].[student] WHERE stateID is not null AND activeYear=1 AND endStatus is null AND enrollmentStateExclude=0;