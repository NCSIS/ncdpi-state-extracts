--select 'use '+name+';' from sys.databases where left(name,3)='psu' and name not like '%_Cache' and name not like '%_input%' and name not like '%_conv1' and name not like '%_sandbox' and name not like '%_staging' and name not like '%_backup' and name not like '%_K12_%'

go
print 'Enabling all NCDPI users.';
update [UserAccount] set [disable]=0 where ([disable]=1 and ([Username]='DPIadmin' or [Username] like '%@dpi.nc.gov'));

print 'Making John an admin.';
WITH UserIDToImpact AS (
    SELECT [UserAccount].[userID] FROM dbo.[UserAccount] where [UserAccount].[username] in ('john.mairs@dpi.nc.gov')
)
INSERT dbo.[UserGroupMember] ([userID],[groupID],[addContent],[ownerRights])
SELECT userID,1,1,0 FROM UserIDToImpact
WHERE NOT EXISTS (
    SELECT 1
    FROM UserIDToImpact
    JOIN dbo.[UserGroupMember] ON UserIDToImpact.userID = [UserGroupMember].[userID]
    WHERE [UserGroupMember].[groupID]=1
);

print 'Adding Combine Person to John.';
WITH UserIDToImpact AS (
    SELECT [UserAccount].[userID] FROM dbo.[UserAccount] where [UserAccount].[username] in ('john.mairs@dpi.nc.gov')
)
INSERT dbo.[UserToolRights] ([toolID],[userID],[read],[write],[add],[delete])
SELECT 1955,userID,1,1,1,1 FROM UserIDToImpact
WHERE NOT EXISTS (
    SELECT 1
    FROM UserIDToImpact
    JOIN dbo.[UserToolRights] ON UserIDToImpact.userID = [UserToolRights].[userID]
    WHERE [UserToolRights].[toolID]=1955
);

print 'Making Tessa an admin.';
WITH UserIDToImpact AS (
    SELECT [UserAccount].[userID] FROM dbo.[UserAccount] where [UserAccount].[username] in ('tessa.hine@dpi.nc.gov')
)
INSERT dbo.[UserGroupMember] ([userID],[groupID],[addContent],[ownerRights])
SELECT userID,1,1,0 FROM UserIDToImpact
WHERE NOT EXISTS (
    SELECT 1
    FROM UserIDToImpact
    JOIN dbo.[UserGroupMember] ON UserIDToImpact.userID = [UserGroupMember].[userID]
    WHERE [UserGroupMember].[groupID]=1
);

print 'Adding Combine Person to Tessa.';
WITH UserIDToImpact AS (
    SELECT [UserAccount].[userID] FROM dbo.[UserAccount] where [UserAccount].[username] in ('tessa.hine@dpi.nc.gov')
)
INSERT dbo.[UserToolRights] ([toolID],[userID],[read],[write],[add],[delete])
SELECT 1955,userID,1,1,1,1 FROM UserIDToImpact
WHERE NOT EXISTS (
    SELECT 1
    FROM UserIDToImpact
    JOIN dbo.[UserToolRights] ON UserIDToImpact.userID = [UserToolRights].[userID]
    WHERE [UserToolRights].[toolID]=1955
);

print 'Making Angela an admin.';
WITH UserIDToImpact AS (
    SELECT [UserAccount].[userID] FROM dbo.[UserAccount] where [UserAccount].[username] in ('angela.coats@dpi.nc.gov')
)
INSERT dbo.[UserGroupMember] ([userID],[groupID],[addContent],[ownerRights])
SELECT userID,1,1,0 FROM UserIDToImpact
WHERE NOT EXISTS (
    SELECT 1
    FROM UserIDToImpact
    JOIN dbo.[UserGroupMember] ON UserIDToImpact.userID = [UserGroupMember].[userID]
    WHERE [UserGroupMember].[groupID]=1
);

print 'Adding Combine Person to Angela.';
WITH UserIDToImpact AS (
    SELECT [UserAccount].[userID] FROM dbo.[UserAccount] where [UserAccount].[username] in ('angela.coats@dpi.nc.gov')
)
INSERT dbo.[UserToolRights] ([toolID],[userID],[read],[write],[add],[delete])
SELECT 1955,userID,1,1,1,1 FROM UserIDToImpact
WHERE NOT EXISTS (
    SELECT 1
    FROM UserIDToImpact
    JOIN dbo.[UserToolRights] ON UserIDToImpact.userID = [UserToolRights].[userID]
    WHERE [UserToolRights].[toolID]=1955
);

print 'Making Russell an admin.';
WITH UserIDToImpact AS (
    SELECT [UserAccount].[userID] FROM dbo.[UserAccount] where [UserAccount].[username] in ('russell.dixon@dpi.nc.gov')
)
INSERT dbo.[UserGroupMember] ([userID],[groupID],[addContent],[ownerRights])
SELECT userID,1,1,0 FROM UserIDToImpact
WHERE NOT EXISTS (
    SELECT 1
    FROM UserIDToImpact
    JOIN dbo.[UserGroupMember] ON UserIDToImpact.userID = [UserGroupMember].[userID]
    WHERE [UserGroupMember].[groupID]=1
);