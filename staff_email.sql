SELECT DISTINCT
    sm.[staffStateID] as STAFF_UID,
    CASE
        WHEN RIGHT(sm.[schoolNumber],3)='810' THEN LEFT(sm.[schoolNumber],3) + '000'
        ELSE sm.[schoolNumber]
    END as SCHOOL_CODE,
    CASE
        WHEN sm.[staffStateID] = '3448648418' THEN 'aspen.simmons@carteretk12.org'
        WHEN sc.[email] IS NOT NULL THEN sc.[email]
        ELSE c.[email]
    END as EMAIL,
    CASE
        WHEN sm.[staffStateID] = '3448648418' THEN 'aspen.simmons@carteretk12.org'
        WHEN sc.[email] IS NOT NULL THEN sc.[email]
        ELSE c.[email]
    END as ALIAS_ID

FROM
    [staffMember] sm
    LEFT OUTER JOIN [StudentContact] sc ON
        sc.[personID] = sm.[personID]
        AND sc.[relationship] = 'Self' --only get this person's own contact
        AND sc.[districtID] = (select [school].[districtID] from [school] where [school].[schoolID] = sm.[schoolID]) --only get contacts from the active PSU
        AND sc.[contactID] = (select max([contactID]) from [StudentContact] where [personID]=sm.[personID] and [relationship]='Self') --only get the max contact ID
    LEFT OUTER JOIN [Contact] c ON c.[personID] = sm.[personID]

WHERE
    LEN(sm.[staffStateID]) = 10 --UID length is 10
    AND (sc.[email] IS NOT NULL OR c.[email] IS NOT NULL) --email populated
    AND sm.[startDate] <= getdate() --start date is today or prior
    AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) --end date is null or future