SELECT
    sm.[staffStateID] as STAFF_UID,
    c.[email] as EMAIL,
    c.[email] as ALIAS_ID

FROM
    [staffMember] sm
    JOIN [Contact] c ON c.[personID] = sm.[personID]

WHERE
    sm.[staffStateID] IS NOT NULL /* JM: UID populated */
    AND c.[email] IS NOT NULL /* JM: email populated */
    AND c.[email] NOT LIKE '%dpi.nc.gov' /* JM: email not NCDPI */
    AND c.[email] NOT LIKE '%ncpublicschools.gov' /* JM: email not NCDPI */
    AND sm.[startDate] <= getdate() /* contractor: start date is today or prior */
    AND (sm.[endDate] IS NULL OR sm.[endDate] >= getdate()) /* contractor: end date is null or future */