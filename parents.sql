SELECT
    i.[firstName] as FIRST_NAME,
    i.[lastName] as LAST_NAME,
    c.[email] as EMAIL,
    d.[number] as PSU_CODE,
    u.[modifiedDate] as MOD_DATE

FROM
    [UserAccount] u
    JOIN [Identity] i on i.[personID]=u.[personID] /* get names */
    JOIN [Contact] c on c.[personID]=u.[personID] /* get emails */
    JOIN [District] d on d.[districtID]=i.[districtID] /* get PSU codes */

WHERE
    u.[isSAMLAccount] = 1 /* is a SAML account */
    AND u.[samlConfigurationID] = (SELECT [configID] FROM [SAMLSPConfig] where [idpName] like 'NCEdCloud%') /* is set to NCEdCloud IdP */
    AND u.[username] = c.[email] /* username and email must be the same */
    AND u.[homepage] = 'nav-wrapper/parent/portal/parent'; /* look for accounts set to the parent homepage */