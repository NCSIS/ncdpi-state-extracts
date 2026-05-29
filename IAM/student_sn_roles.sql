/**********************************************
Script maintained by NCDPI, PSU Technology Systems Section.
See https://github.com/NCSIS/ncdpi-state-extracts.
**********************************************/

DECLARE @asof datetime2 = SYSDATETIME();
DECLARE @asofEnd datetime2 = dateadd(day,-1,@asof);

SELECT DISTINCT
    s.[stateID] as PUPIL_NUMBER,
    CASE
        WHEN TRY_CAST(sch.[number] as int) IS NOT NULL THEN CAST(sch.[number]*1 as varchar)
        ELSE sch.[number]
    END + ':Student' as SCHOOLNET_ROLE
FROM
    [student] s --student view
    LEFT OUTER JOIN [school] sch ON sch.[schoolID] = s.[schoolID] --to get school num and name
    OUTER APPLY (select top 1 endDate from Term join TermSchedule on TermSchedule.termScheduleID=Term.termScheduleID where TermSchedule.structureID=s.structureID order by Term.endDate desc) term --find last day of last term for the year
WHERE 1=1
    AND len(s.[stateID]) between 5 and 10 --UID is between 5 and 10 characters in length.
    AND s.[enrollmentStateExclude] = 0 --not state excluded
    AND (
        s.[endDate] IS NULL
        OR s.[endDate] >= @asofEnd
        OR (s.[endDate] = term.endDate AND s.[activeYear] = 1)
    ) --end date is null or future or equal to last day of final term within activeYear
    AND (
        s.[activeYear] = 1
        OR (s.startStatus = 'S1' and s.[startDate] <= @asof)
    ); --is an activeYear or active Summer enrollment