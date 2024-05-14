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
    STUFF(
        (
            SELECT DISTINCT
                '::' + p.[staffStateID]
            FROM
                [student] s2
                JOIN [Roster] r ON r.[personID]=s2.[personID]
                JOIN [Section] sec ON sec.[sectionID]=r.[sectionID]
                JOIN [Person] p ON sec.[teacherPersonID] = p.[personID]
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
    ) as TEACHER_STAFF_ID,
    c.[email] as ALIAS_ID, /*alias ID*/
    CONVERT(VARCHAR(8), s.[modifiedDate], 112) as MOD_DATE

FROM
    [student] s /*student view*/
    JOIN [school] sch ON sch.[schoolID] = s.[schoolID] /*to get school num and name*/
    JOIN [district] d ON d.[districtID] = s.[districtID] /*to get district num and name*/
    JOIN [Contact] c ON c.[personID] = s.[personID] /*to get student email*/

WHERE
    s.[stateID] is not null /* JM: UID populated */
    AND s.[enrollmentStateExclude]=0 /* JM: not state excluded */
    AND s.[startDate] <= getdate() /* contractor: start date is today or prior */
    AND (s.[endDate] IS NULL OR s.[endDate] >= getdate()) /* contractor: end date is null or future */
    AND s.[serviceType] = 'P' /* contractor: student service type is primary */

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