SELECT
    s.[stateID] as PUPIL_NUMBER,
    s.[lastName] as LAST_NAME,
    s.[firstName] as FIRST_NAME,
    s.[middleName] as MIDDLE_NAME,
    s.[suffix] as NAME_SUFFIX,
    FORMAT(s.[birthdate],'MM/dd/yyyy') as BIRTH_DATE,
    s.[stateGrade] as GRADE,
    d.[number] as PSU_CODE,
    d.[name] as PSU_DESC,
    sch.[number] as SCHOOL_CODE,
    sch.[name] as SCHOOL_DESC,
    sc.[email] as EMAIL,
    STUFF(
        (
            SELECT DISTINCT
                '::' + p.[staffStateID]
            FROM
                [student] s2
                LEFT OUTER JOIN [Roster] r ON r.[personID]=s2.[personID]
                LEFT OUTER JOIN [Section] sec ON sec.[sectionID]=r.[sectionID]
                LEFT OUTER JOIN [Person] p ON sec.[teacherPersonID] = p.[personID]
            WHERE
                s2.[stateID] = s.[stateID]
                AND (
                    CAST(r.startDate AS DATE) <= CAST(CURRENT_TIMESTAMP AS DATE)
                ) --started roster enrollments only
                AND (
                    CAST(r.endDate AS DATE) >= CAST(CURRENT_TIMESTAMP AS DATE)
                    OR r.endDate IS NULL
                ) --non-ended roster enrollments only
            FOR XML PATH ('')
        ), 1, 2, ''
    ) as TEACHER_STAFF_ID,
    sc.[email] as ALIAS_ID,
    FORMAT(s.[modifiedDate],'MM/dd/yyyy') as MOD_DATE

FROM
    [student] s --student view
    LEFT OUTER JOIN [school] sch ON sch.[schoolID] = s.[schoolID] --to get school num and name
    LEFT OUTER JOIN [district] d ON d.[districtID] = s.[districtID] --to get district num and name
    LEFT OUTER JOIN [StudentContact] sc ON sc.[personID] = s.[personID] AND sc.[relationship] = 'Self' --to get student email

WHERE
    s.[stateID] is not null --UID populated
    AND s.[enrollmentStateExclude]=0 --not state excluded
    --AND s.[startDate] <= getdate() --start date is today or prior
    AND (s.[endDate] IS NULL OR s.[endDate] >= getdate()) --end date is null or future
    AND s.[activeYear] = 1 --is an active enrollment
    AND s.[serviceType] = 'P' --student service type is primary

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
    sc.[email],
    s.[modifiedDate]