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
    AND sc.[email] IS NOT NULL --email populated
    AND sm.[startDate] <= getdate() --start date is today or prior
    AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future
    AND sc.[districtID] = (select [school].[districtID] from [school] where [school].[schoolID] = sm.[schoolID]) --only get contacts from the active PSU
    AND sc.[contactID] = (select max([contactID]) from [StudentContact] where [personID]=sm.[personID]) --only get the max contact ID