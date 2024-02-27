SELECT
    s.[stateID] as PUPIL_NUMBER,
    s.[lastName] as LAST_NAME,
    s.[firstName] as FIRST_NAME,
    s.[middleName] as MIDDLE_NAME,
    s.[suffix] as NAME_SUFFIX,
    CONVERT(VARCHAR(8), s.[birthdate], 112) as BIRTH_DATE,
    s.[stateGrade] as GRADE,
    s.[districtID] as PSU_CODE,
    d.[name] as PSU_DESC,
    CONCAT(s.[districtID],s.[schoolID]) as SCHOOL_CODE, /* in IC, school code will be 3-digit without the PSU code first. This adds PSU code. */
    sch.[name] as SCHOOL_DESC,
    c.[email] as EMAIL,
    STRING_AGG(p.[staffStateID],'::') as TEACHER_STAFF_ID,
    CASE
        WHEN c.[email] is null THEN u.[username]
        ELSE c.[email]
    END as LOCAL_ID, /*alias ID -- pulls email or username if null*/
    CONVERT(VARCHAR(8), s.[modifiedDate], 112) as MOD_DATE

FROM
    [Training].[dbo].[student] s /*student view*/
    JOIN [Training].[dbo].[school] sch ON sch.[schoolID] = s.[schoolID] /*to get school name*/
    JOIN [Training].[dbo].[district] d ON d.[districtID] = s.[districtID] /*to get district name*/
    JOIN [Training].[dbo].[Contact] c ON c.[personID] = s.[personID] /*to get student email*/
    JOIN [Training].[dbo].[UserAccount] u ON u.[personID] = s.[personID] /*to get student username*/
    JOIN [Training].[dbo].[Roster] r ON r.[personID]=s.[personID] /* to get rosters */
    JOIN [Training].[dbo].[Section] sec ON sec.[sectionID]=r.[sectionID] /* to get sections */
    JOIN [Training].[dbo].[Person] p ON sec.[teacherPersonID] = p.[personID] /* to get teacher UIDs */

WHERE
    s.stateID is not null /* QA: UID populated */
    AND s.activeYear=1 /* QA: Current year */
    AND s.endStatus is null /* QA: Not exited */
    AND s.enrollmentStateExclude=0 /* QA: State included */

GROUP BY
    s.[stateID],
    s.[lastName],
    s.[firstName],
    s.[middleName],
    s.[suffix],
    s.[birthdate],
    s.[stateGrade],
    s.[districtID],
    d.[name],
    s.[schoolID],
    sch.[name],
    c.[email],
    u.[username],
    s.[modifiedDate]