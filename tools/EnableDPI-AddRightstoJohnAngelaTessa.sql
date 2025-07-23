update [UserAccount] set [disable]=0 where [disable]=1 and ([Username]='DPIadmin' or [Username] like '%@dpi.nc.gov');
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