-- HR Case
-- Variables Transformation

-- [sex] > [sex(numeric)]

-- [age_calc] > [Age new (cleaned up)]

with Age_ex AS  
(
SELECT candidate_id, age_calc 
	from dataHR 
	where age_calc is not null
)
update dataHR set [age_calc_2] =  Age_ex.age_calc
	INNER JOIN dataHR on dataHR.candidate_id = Age_ex.candidate_id


-- НОВО: [age_squared]

-- НОВО: [Native check (native_1/non_native_0)]

-- [Nationality] > [Nationality / Native]

-- НОВО: [Nationality / Native_bin]

alter table [dbo].[221810] add [Nationality / Native_bin] float null

with NvN AS
(
Select [rec_id],
	case when [Nationality / Native] = 'Native Bulgarian Position native speaker' then 0.4
		when [Nationality / Native] = 'Foreigner Position native speaker' then 0.2105
		when [Nationality / Native] = 'Foreigner Non-native to the position' then 0.146
		when [Nationality / Native] = 'Native Bulgarian Non-native to the position' then 0.1715
	else 0 end AS NVNBin
from [dbo].[221810]
)
update [dbo].[221810] set [Nationality / Native_bin] = NVNBin
from [dbo].[221810]
inner join NvN on [dbo].[221810].[rec_id]=NvN.rec_id

--[experience] >   [experience_new_cleanup]

-- [salary] >      [salary_new_cleanup]

-- НОВО: [salary/native]

-- НОВО: [salary per 1 lg grade]

-- [available_to_start] >   [available_to_start_bin]

alter table [dbo].[2043] add [available_to_start_bin] float null

with ATS as
(
Select [rec_id],
	case when [available_to_start] in (0,1) then 1
		when [available_to_start] in (2,3,4) then 2
		when [available_to_start] >5 then 3
		else NULL end as ATSB
from [dbo].[2043]
)
update [dbo].[2043] set available_to_start_bin = ATSB
from [dbo].[2043]
inner join ATS on [dbo].[2043].[rec_id]=ATS.rec_id

-- [source_name] > source_name by group]
alter table [dbo].[2043] add [available_to_start_bin] NVARCHAR(255) null

update [dbo].[dataHR] set [source_name_2] = [source_name]

update [dbo].[dataHR] set [source_name] = 'Other' where source_name = 'Personal contact'
update [dbo].[dataHR] set [source_name] = 'Other' where source_name = 'hunt'
update [dbo].[dataHR] set [source_name] = 'Other' where source_name = 'event'
update [dbo].[dataHR] set [source_name] = 'Other' where source_name = 'Referral'
update [dbo].[dataHR] set [source_name] = 'Other' where source_name = 'Inbox'

-- [grade_name] > [senior_dummy_logit]
-- step 1 - [grade_name_bin]
alter table add [grade_name_bin] nvarchar (255) null

with gnbin as
(select [rec_id]
, case when grade_name = 'Team Leader' then 'senior'
		when grade_name = 'Manager' then 'senior'
		when grade_name = 'Senior' then 'senior'
		when grade_name = 'Junior' then 'non-senior'
		when grade_name = 'Regular' then 'non-senior'
		else null end AS GNB
		FROM [dbo].[HRData_2]
)
update [dbo].[HRData_2] set grade_name_bin = gnbin.GNB
from [dbo].[HRData_2] inner join gnbin  on [dbo].[HRData_2].rec_id = gnbin.rec_id
-- step 2 - [senior_dummy_logit]

-- НОВО: [Num_Successes]

-- НОВО: [Num_Failures]

-- [lang_1] > [lang_1_bin]

alter table [dbo].[2043] add [lang_1_bin] nvarchar (255) null

with L1B AS
(
Select [rec_id],
	case when [lang_1] = 'German' then 'German'
		when [lang_1] = 'French' then 'French'
		when [lang_1] = 'English' then 'English'
		when [lang_1] = 'Spanish' then 'Spanish'
		when [lang_1] = 'Italian' then 'Italian'
	else 'Other' end as L1Bin
from [dbo].[2043]
)
update [dbo].[2043] set lang_1_bin = L1Bin
from [dbo].[2043]
inner join L1B on [dbo].[2043].[rec_id]=L1B.rec_id


--[lang_1_grade]
-- НОВО: [lang_2_grade]
-- НОВО: [lang_3_grade]
-- Step 1
ALTER TABLE [dbo].[dataHR] ADD lang_1_grade nvarchar(255) null;
ALTER TABLE [dbo].[dataHR] ADD lang_2_grade nvarchar(255) null;
ALTER TABLE [dbo].[dataHR] ADD lang_3_grade nvarchar(255) null;

--- Step 2 - установяваме кои езици са посочени като първи, втори и трети (result - 25)
select distinct [lang_1] from [dbo].[dataHR]
UNION
select distinct [lang_2] from [dbo].[dataHR]
UNION
select distinct [lang_2] from [dbo].[dataHR]

--- Step 3 - пренасяме оценката от съответния език в новата колона
--- lang 1 grade

with LangGrade as  
(
	select 
	[rec_id]
	, [lang_1] -- тази колона не се ползва в update-a, тя е само за информация
	, case when [lang_1] = 'Arabic' then [Arabic]
			when [lang_1] = 'Chinese' then [Chinese]
			when [lang_1] = 'Czech' then [Czech]
			when [lang_1] = 'Danish' then [Danish]
			when [lang_1] = 'Dutch' then [Dutch]
			when [lang_1] = 'English' then [English]
			when [lang_1] = 'Estonian' then [Estonian]
			when [lang_1] = 'French' then [French]
			when [lang_1] = 'German' then [German]
			when [lang_1] = 'Greek' then [Greek]
			when [lang_1] = 'Hungarian' then [Hungarian]
			when [lang_1] = 'Italian' then [Italian]
			when [lang_1] = 'Japanese' then [Japanese]
			when [lang_1] = 'Latvian' then [Latvian]
			when [lang_1] = 'Nordics' then [Nordics]
			when [lang_1] = 'Norwegian' then [Norwegian]
			when [lang_1] = 'Polish' then [Polish]
			when [lang_1] = 'Portuguese' then [Portuguese]
			when [lang_1] = 'Romanian' then [Romanian]
			when [lang_1] = 'Russian' then [Russian]
			when [lang_1] = 'Serbian' then [Serbian]
			when [lang_1] = 'Slovenian' then [Slovenian]
			when [lang_1] = 'Spanish' then [Spanish]
			when [lang_1] = 'Swedish' then [Swedish]
			when [lang_1] = 'Turkish' then [Turkish]
				else null end AS LGrade
	from [dbo].[dataHR]
)
Update dataHR 
	set [lang_1_grade] = LangGrade.LGrade
FROM dataHR
	INNER JOIN LangGrade 
		ON dataHR.rec_id = LangGrade.rec_id

--- lang 2 grade

with LangGrade as  
(
	select 
	[rec_id]
	, [lang_2] -- тази колона не се ползва в update-a, тя е само за информация
	, case when [lang_2] = 'Arabic' then [Arabic]
			when [lang_2] = 'Chinese' then [Chinese]
			when [lang_2] = 'Czech' then [Czech]
			when [lang_2] = 'Danish' then [Danish]
			when [lang_2] = 'Dutch' then [Dutch]
			when [lang_2] = 'English' then [English]
			when [lang_2] = 'Estonian' then [Estonian]
			when [lang_2] = 'French' then [French]
			when [lang_2] = 'German' then [German]
			when [lang_2] = 'Greek' then [Greek]
			when [lang_2] = 'Hungarian' then [Hungarian]
			when [lang_2] = 'Italian' then [Italian]
			when [lang_2] = 'Japanese' then [Japanese]
			when [lang_2] = 'Latvian' then [Latvian]
			when [lang_2] = 'Nordics' then [Nordics]
			when [lang_2] = 'Norwegian' then [Norwegian]
			when [lang_2] = 'Polish' then [Polish]
			when [lang_2] = 'Portuguese' then [Portuguese]
			when [lang_2] = 'Romanian' then [Romanian]
			when [lang_2] = 'Russian' then [Russian]
			when [lang_2] = 'Serbian' then [Serbian]
			when [lang_2] = 'Slovenian' then [Slovenian]
			when [lang_2] = 'Spanish' then [Spanish]
			when [lang_2] = 'Swedish' then [Swedish]
			when [lang_2] = 'Turkish' then [Turkish]
				else null end AS LGrade
	from [dbo].[dataHR]
)
Update dataHR 
	set [lang_2_grade] = LangGrade.LGrade
FROM dataHR
	INNER JOIN LangGrade 
		ON dataHR.rec_id = LangGrade.rec_id

--- lang 3 grade

with LangGrade as  
(
	select 
	[rec_id]
	, [lang_3] -- тази колона не се ползва в update-a, тя е само за информация
	, case when [lang_3] = 'Arabic' then [Arabic]
			when [lang_3] = 'Chinese' then [Chinese]
			when [lang_3] = 'Czech' then [Czech]
			when [lang_3] = 'Danish' then [Danish]
			when [lang_3] = 'Dutch' then [Dutch]
			when [lang_3] = 'English' then [English]
			when [lang_3] = 'Estonian' then [Estonian]
			when [lang_3] = 'French' then [French]
			when [lang_3] = 'German' then [German]
			when [lang_3] = 'Greek' then [Greek]
			when [lang_3] = 'Hungarian' then [Hungarian]
			when [lang_3] = 'Italian' then [Italian]
			when [lang_3] = 'Japanese' then [Japanese]
			when [lang_3] = 'Latvian' then [Latvian]
			when [lang_3] = 'Nordics' then [Nordics]
			when [lang_3] = 'Norwegian' then [Norwegian]
			when [lang_3] = 'Polish' then [Polish]
			when [lang_3] = 'Portuguese' then [Portuguese]
			when [lang_3] = 'Romanian' then [Romanian]
			when [lang_3] = 'Russian' then [Russian]
			when [lang_3] = 'Serbian' then [Serbian]
			when [lang_3] = 'Slovenian' then [Slovenian]
			when [lang_3] = 'Spanish' then [Spanish]
			when [lang_3] = 'Swedish' then [Swedish]
			when [lang_3] = 'Turkish' then [Turkish]
				else null end AS LGrade
	from [dbo].[dataHR]
)
Update dataHR 
	set [lang_3_grade] = LangGrade.LGrade
FROM dataHR
	INNER JOIN LangGrade 
		ON dataHR.rec_id = LangGrade.rec_id

-- НОВО: [Languages zusammen]

-- НОВО: [Number of languages spoken]

-- НОВО: [Number of languages spoken_bin]
alter table [dbo].[2043] add [Number of languages spoken_bin] float null
with NLSp AS
(
Select [rec_id],
	case when [Number of languages spoken] in (0,1) then 0 else 1 end AS NLS
from [dbo].[2043]
)
update [dbo].[2043] set [Number of languages spoken_bin] = NLS
from [dbo].[2043]
inner join NLSp on [dbo].[2043].[rec_id]=NLSp.rec_id

--НОВО: [Average grade of spoken languages]


-- НОВО: [Average score of other languages (not lang_name)


-- НОВО: [result_lag]







