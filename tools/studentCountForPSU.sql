/* Throw this at the Data Extract Utility in the IC: State Edition and an IC: District Edition to compare counts. */

select count([student].stateID) from dbo.[Student] left join [school] on [school].schoolID = [Student].schoolID where left([school].number,3)='120';