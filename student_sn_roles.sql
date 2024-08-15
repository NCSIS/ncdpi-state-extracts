SELECT
    s.[stateID] as PUPIL_NUMBER,
    CASE
        WHEN TRY_CAST(sch.[number] as int) IS NOT NULL THEN CAST(sch.[number]*1 as varchar)
        ELSE sch.[number]
    END + ':Student' as SCHOOLNET_ROLE
FROM
    [student] s --student view
    LEFT OUTER JOIN [school] sch ON sch.[schoolID] = s.[schoolID] --to get school num and name
WHERE
    len(s.[stateID]) between 5 and 10 --UID is between 5 and 10 characters in length.
    AND s.[enrollmentStateExclude] = 0 --not state excluded
    AND (s.[endDate] IS NULL OR s.[endDate] >= getdate()) --end date is null or future
    AND s.[activeYear] = 1 --is an active enrollment
    AND s.[noShow] = 0 --isn't a no-show
    AND s.[serviceType] = 'P' --student service type is primary