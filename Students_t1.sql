SELECT
    s.[stateID] as PUPIL_NUMBER,
    s.[lastName] as LAST_NAME,
    s.[firstName] as FIRST_NAME,
    s.[middleName] as MIDDLE_NAME,
    s.[suffix] as NAME_SUFFIX,
    CONVERT(VARCHAR(8), s.[birthdate], 112) as BIRTH_DATE,
    s.[stateGrade] as GRADE,
    d.[number] as PSU_CODE,
    d.[name] as PSU_DESC,
    sch.[number] as SCHOOL_CODE,
    sch.[name] as SCHOOL_DESC,
    c.[email] as EMAIL,
    /* Available in MSSQL 2017 as an alternative... */
    --STRING_AGG(p.[staffStateID],'::') as TEACHER_STAFF_ID,
    TEACHER_STAFF_ID = STUFF(
        (
            SELECT DISTINCT
                '::' + p.[staffStateID]
            FROM
                [ncse_staging].[dbo].[student] s2
                JOIN [ncse_staging].[dbo].[Roster] r ON r.[personID]=s2.[personID]
                JOIN [ncse_staging].[dbo].[Section] sec ON sec.[sectionID]=r.[sectionID]
                JOIN [ncse_staging].[dbo].[Person] p ON sec.[teacherPersonID] = p.[personID]
            WHERE
                s2.[stateID] = s.[stateID]
                AND (
                    CAST(r.startDate AS DATE) <= CAST(CURRENT_TIMESTAMP AS DATE)
                ) /* started roster enrollments only */
                AND (
                    CAST(r.endDate AS DATE) >= CAST(CURRENT_TIMESTAMP AS DATE)
                ) /* non-ended roster enrollments only */
            FOR XML PATH ('')
        ), 1, 2, ''
    ),
    c.[email] as LOCAL_ID, /*alias ID*/
    CONVERT(VARCHAR(8), s.[modifiedDate], 112) as MOD_DATE

FROM
    [ncse_staging].[dbo].[student] s /*student view*/
    JOIN [ncse_staging].[dbo].[school] sch ON sch.[schoolID] = s.[schoolID] /*to get school num and name*/
    JOIN [ncse_staging].[dbo].[district] d ON d.[districtID] = s.[districtID] /*to get district num and name*/
    JOIN [ncse_staging].[dbo].[Contact] c ON c.[personID] = s.[personID] /*to get student email*/
    /* These lines would be for the STRING_AGG function... */
    --JOIN [ncse_staging].[dbo].[Roster] r ON r.[personID]=s.[personID] /* to get rosters */
    --JOIN [ncse_staging].[dbo].[Section] sec ON sec.[sectionID]=r.[sectionID] /* to get sections */
    --JOIN [ncse_staging].[dbo].[Person] p ON sec.[teacherPersonID] = p.[personID] /* to get teacher UIDs */

WHERE
    s.stateID is not null /* QA: UID populated */
    AND s.activeYear=1 /* QA: Current year */
    AND s.endStatus is null /* QA: Not exited */
    AND s.enrollmentStateExclude=0 /* QA: State included */
    /* These lines would be for the STRING_AGG function... */
    --AND (
    --    CAST(r.startDate AS DATE) <= CAST(CURRENT_TIMESTAMP AS DATE)
    --    ) /* started roster enrollments only */
    --AND (
    --    CAST(r.endDate AS DATE) >= CAST(CURRENT_TIMESTAMP AS DATE)
    --    ) /* non-ended roster enrollments only */

GROUP BY
    s.[stateID],
    s.[lastName],
    s.[firstName],
    s.[middleName],
    s.[suffix],
    s.[birthdate],
    s.[stateGrade],
    d.[number],
    d.[name],
    sch.[number],
    sch.[name],
    c.[email],
    s.[modifiedDate]