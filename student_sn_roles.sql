SELECT
    s.[stateID] as PUPIL_NUMBER,
    sch.[number] + ':Student' as SCHOOLNET_ROLE
FROM
    [student] s --student view
    LEFT OUTER JOIN [school] sch ON sch.[schoolID] = s.[schoolID] --to get school num and name
WHERE
    s.[stateID] is not null --UID populated
    AND s.[enrollmentStateExclude]=0 --not state excluded
    --AND s.[startDate] <= getdate() --start date is today or prior
    AND (s.[endDate] IS NULL OR s.[endDate] >= getdate()) --end date is null or future
    AND s.[activeYear] = 1 --is an active enrollment
    AND s.[serviceType] = 'P' --student service type is primary