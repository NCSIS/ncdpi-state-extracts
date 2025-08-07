/*
This script finds users who were migrated into IC via conversion + whose accounts are set to local and disabled, sets those accounts to use SAML: NCEdCloud, then re-enables them.
This was necessary after NCDPI ran a script to disable all non-SSO users statewide.
John Mairs, 8/7/2025
*/

with UsersToFix as(
    select userID from UserAccount where isSAMLAccount=0 and legacyKey is not null and userID>1
)
update UserAccount set disable=0,lock=0,isSAMLAccount=1,samlConfigurationID=1 where userID in (select userID from UsersToFix)