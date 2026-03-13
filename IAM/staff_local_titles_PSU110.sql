SELECT DISTINCT
    sm.[staffStateID] as STAFF_UID,
    CASE
        WHEN RIGHT(sm.[schoolNumber],3)='810' THEN LEFT(sm.[schoolNumber],3) + '000'
        ELSE sm.[schoolNumber]
    END as SCHOOL_CODE,
    sm.[title] as IC_TITLE
FROM
    [staffMember] sm
    LEFT OUTER JOIN [School] ON sm.[schoolID] = [School].[schoolID]
WHERE 1=1
    AND LEN(sm.[staffStateID]) = 10 --UID length is 10
    AND sm.[staffStateID] > '1000000000' --UID is in valid range
    AND sm.[title] is not null --IC title field is not null
    AND sm.[startDate] <= (getdate()+1) --start date is tomorrow or prior
    AND (sm.[endDate] IS NULL OR sm.[endDate] >= (getdate()+1)) --end date is null or future as of tomorrow
    AND LEFT(sm.[schoolNumber],3)='110'; --PSU 110 only