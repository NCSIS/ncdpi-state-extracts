/*
This script finds users who were disabled due to having local accounts + where the username is a UID, sets those accounts to use SAML: NCEdCloud, then re-enables them.
John Mairs, 8/7/2025
*/

with UsersToFix as(
    select * from UserAccount where isSAMLAccount=0 and legacyKey='8072025' and userID>1 and LEN(username)=10 and ISNUMERIC(username)=1
)
update UserAccount set disable=0,lock=0,isSAMLAccount=1,samlConfigurationID=(select configID from SAMLSPConfig where idpName='NCEdCloud'),legacyKey=null where userID in (select userID from UsersToFix);


with findOtherUsers as (
    select * from UserAccount where legacyKey='8072025'
)
select
    p.personID,
    p.staffStateID,
    f.userID,
    f.username,
    'update UserAccount set username='+CAST(p.staffStateID as varchar)+',isSAMLAccount=0 where userID='+CAST(f.userID as varchar) as sqlstate
from findOtherUsers f inner join Person p on p.personID=f.personID;

/*
select * from SAMLSPConfig;
*/