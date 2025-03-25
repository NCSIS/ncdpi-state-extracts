WITH AliasIDPreferences AS (
    SELECT
        districtID,
        value
    FROM (
        SELECT
            districtID,
            value,
            row_number() over(partition by districtID order by date desc) as rn
        FROM [CustomDistrict]
        WHERE
            attributeID = (select attributeID from [CampusAttribute] where element = 'aliasIDstaff')
            AND date<=getdate()
    ) as T
    where rn=1
)

SELECT DISTINCT
    sm.[staffStateID] as STAFF_UID,
    CASE
        WHEN RIGHT(sm.[schoolNumber],3)='810' THEN LEFT(sm.[schoolNumber],3) + '000'
        ELSE sm.[schoolNumber]
    END as SCHOOL_CODE,
    COALESCE(c.[email],sc.[email]) as EMAIL,
    CASE
        WHEN a.value='DISABLE' THEN null
        WHEN LEFT(sm.[schoolNumber],3)='260' THEN null --260 requested opt-out via email
        ELSE COALESCE(c.[email],sc.[email])
    END as ALIAS_ID

FROM
    [staffMember] sm
    LEFT OUTER JOIN [School] ON sm.[schoolID] = [School].[schoolID]
    LEFT OUTER JOIN [StudentContact] sc ON
        sc.[personID] = sm.[personID]
        AND sc.[relationship] = 'Self' --only get this person's own contact
        AND sc.[districtID] = [School].[districtID] --only get contacts from the active PSU
    LEFT OUTER JOIN [Contact] c ON c.[personID] = sm.[personID] AND c.[districtID] = [School].[districtID]
    LEFT OUTER JOIN AliasIDPreferences a ON a.districtID = [School].[districtID]

WHERE
    LEN(sm.[staffStateID]) = 10 --UID length is 10
    AND (sc.[email] IS NOT NULL OR c.[email] IS NOT NULL) --email populated
    AND sm.[startDate] <= (getdate()+1) --start date is tomorrow or prior
    AND (sm.[endDate] IS NULL OR sm.[endDate] >= (getdate()+1)) --end date is null or future as of tomorrow