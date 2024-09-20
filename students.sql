SELECT
    s.[stateID] as PUPIL_NUMBER,
    s.[lastName] as LAST_NAME,
    s.[firstName] as FIRST_NAME,
    s.[middleName] as MIDDLE_NAME,
    s.[suffix] as NAME_SUFFIX,
    FORMAT(s.[birthdate],'MM/dd/yyyy') as BIRTH_DATE,
    CASE s.[stateGrade] 
        WHEN 'XG' THEN '-9'
        WHEN 'UG' THEN '-7'
        WHEN 'IT' THEN '-3'
        WHEN 'PR' THEN '-2'
        WHEN 'PK' THEN '-1'
        WHEN 'KG' THEN '0'
        WHEN '01' THEN '1'
        WHEN '02' THEN '2'
        WHEN '03' THEN '3'
        WHEN '04' THEN '4'
        WHEN '05' THEN '5'
        WHEN '06' THEN '6'
        WHEN '07' THEN '7'
        WHEN '08' THEN '8'
        WHEN '09' THEN '9'
        ELSE s.[stateGrade]
    END as GRADE,
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
                LEFT OUTER JOIN [Roster] r ON r.[personID]=s2.[personID]
                LEFT OUTER JOIN [Section] sec ON sec.[sectionID]=r.[sectionID]
                LEFT OUTER JOIN [Person] p ON sec.[teacherPersonID] = p.[personID]
            WHERE
                s2.[stateID] = s.[stateID]
                AND (r.[startDate] <= getdate()) --started roster enrollments only
                AND (r.[endDate] >= getdate()) --non-ended roster enrollments only
                AND len(p.[staffStateID])=10 --Staff UID is 10 characters in length.
            FOR XML PATH ('')
        ), 1, 2, ''
    ) as TEACHER_STAFF_ID,
    c.[email] as ALIAS_ID,
    FORMAT(s.[modifiedDate],'MM/dd/yyyy') as MOD_DATE

FROM
    [student] s --student view
    LEFT OUTER JOIN [school] sch ON sch.[schoolID] = s.[schoolID] --to get school num and name
    LEFT OUTER JOIN [district] d ON d.[districtID] = s.[districtID] --to get district num and name
    LEFT OUTER JOIN [contact] c ON c.[personID] = s.[personID] --to get student email

WHERE
    len(s.[stateID]) between 5 and 10 --UID is between 5 and 10 characters in length.
    AND s.[enrollmentStateExclude] = 0 --not state excluded
    AND (s.[endDate] IS NULL OR s.[endDate] >= getdate()) --end date is null or future
    AND s.[activeYear] = 1 --is an active enrollment

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