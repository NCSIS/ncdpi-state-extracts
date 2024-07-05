SELECT DISTINCT
    sm.[staffStateID] as STAFF_UID,
    sm.[schoolNumber] as SCHOOL_CODE,
    sc.[email] as EMAIL,
    sc.[email] as ALIAS_ID

FROM
    [staffMember] sm
    LEFT OUTER JOIN [StudentContact] sc ON sc.[personID] = sm.[personID] AND sc.[relationship] = 'Self'

WHERE
    LEN(sm.[staffStateID]) = 10 --UID length is 10
    AND TRY_CONVERT(int, sm.[staffStateID]) IS NOT NULL --UID is numeric
    AND sc.[email] IS NOT NULL --email populated
    AND sm.[startDate] <= getdate() --start date is today or prior
    AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future