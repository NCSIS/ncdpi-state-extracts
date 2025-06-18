-- Find SAML-enabled DPI users and bypass any IC 2fa requirements.

-- To find:
-- select * from [UserAccount] where [username] like '%@dpi.nc.gov' and [isSAMLAccount]=1 and [bypass2fa]=0;

-- To update:
update [UserAccount] set [bypass2fa]=1 where [username] like '%@dpi.nc.gov' and [isSAMLAccount]=1 and [bypass2fa]=0;