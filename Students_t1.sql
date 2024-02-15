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
    'To do soon :)' as TEACHER_STAFF_ID,
    CASE
        WHEN c.[email] is null THEN u.[username]
        ELSE c.[email]
    END as LEA_ID, /*alias ID -- pulls email or username if null*/
    CONVERT(VARCHAR(8), s.[modifiedDate], 112) as MOD_DATE


FROM
    [Training].[dbo].[student] s, /*student view*/
    [Training].[dbo].[school] sch, /*to get school name*/
    [Training].[dbo].[district] d, /*to get district name*/
    [Training].[dbo].[Contact] c, /*to get student email*/
    [Training].[dbo].[UserAccount] u /*to get student username*/

WHERE
    s.[schoolID]=sch.[schoolID]
    AND s.[districtID]=d.[districtID]
    AND s.[personID]=c.[personID]
    AND s.[personID]=u.[personID]

    AND s.stateID is not null /* QA: UID populated */
    AND s.activeYear=1 /* QA: Current year */
    AND s.endStatus is null /* QA: Not exited */
    AND s.enrollmentStateExclude=0 /* QA: State included */