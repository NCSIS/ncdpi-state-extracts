/*SELECT
    s.[stateID],
    d.[number],
    REPLACE(d.[name],'"',''),
    sch.[number],
    REPLACE(sch.[name],'"',''),
    c.[email]*/
SELECT
    d.[number] AS 'PSU Code',
    d.[name] AS 'PSU Name',
    count(s.[stateID]) AS 'Students with UID in Email'
FROM
    [student] s --student view
    LEFT OUTER JOIN [school] sch ON sch.[schoolID] = s.[schoolID] --to get school num and name
    LEFT OUTER JOIN [district] d ON d.[districtID] = s.[districtID] --to get PSU num and name
    LEFT OUTER JOIN [contact] c ON c.[personID] = s.[personID] AND c.[districtID] = s.[districtID] --to get student email from current PSU only
WHERE
    s.[activeYear] = 1
    AND c.[email] is not null
    AND c.email <> ' '
    AND c.[email] like s.[stateID]+'%'
GROUP BY
    d.[number],
    d.[name]
ORDER BY d.[number]