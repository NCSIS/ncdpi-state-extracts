/*
This script finds users who were disabled due to having local accounts + where the username is a UID, sets those accounts to use SAML: NCEdCloud, then re-enables them.
John Mairs, 8/7/2025
*/

with UsersToFix as(
    select * from UserAccount where isSAMLAccount=0 and legacyKey='8072025' and userID>1 and LEN(username)=10 and ISNUMERIC(username)=1
)
update UserAccount set disable=0,lock=0,isSAMLAccount=1,samlConfigurationID=1,legacyKey=null where userID in (select userID from UsersToFix)