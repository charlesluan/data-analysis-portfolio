/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [REF_DATE]
      ,[GEO]
      ,[DGUID]
      ,[Age group]
      ,[Sex]
      ,[Income source]
      ,[Statistics]
      ,[UOM]
      ,[UOM_ID]
      ,[SCALAR_FACTOR]
      ,[SCALAR_ID]
      ,[VECTOR]
      ,[COORDINATE]
      ,[VALUE]
      ,[STATUS]
      ,[SYMBOL]
      ,[TERMINATED]
      ,[DECIMALS]
  FROM [RealProject1].[dbo].[CanadaIncome]

  --------Check the year range in the table------
  Select Distinct(REF_DATE)
  From CanadaIncome
  Order By REF_DATE asc

  -------Check how many different locations were listed ------
  Select Distinct(GEO)
  From CanadaIncome
  
  ------Delete useless rows by locations, Keep Provincial and National avg data only-------
  Select GEO
  From CanadaIncome
  Where GEO IN ('Montréal, Quebec' , 'Prairie provinces','Ottawa-Gatineau','Ontario/Quebec',
				'Atlantic provinces','Calgary, Alberta','Toronto, Ontario','Edmonton, Alberta','Vancouver, British Columbia','Québec, Quebec','Winnipeg, Manitoba')

 Delete From CanadaIncome
  Where GEO IN ('Montréal, Quebec' , 'Prairie provinces','Ottawa-Gatineau','Ontario/Quebec',
				'Atlantic provinces','Calgary, Alberta','Toronto, Ontario','Edmonton, Alberta',
				'Vancouver, British Columbia','Québec, Quebec','Winnipeg, Manitoba','Ottawa-Gatineau, Ontario/Quebec')

 ----Validate the delete query ------
 Select Distinct(GEO)
 From CanadaIncome

 ----Select National Average Income by individuals over 16 years old on 1976 ------
 Select [REF_DATE],[GEO],[Income source],[Statistics],[VALUE],[UOM],[Age group]
 From CanadaIncome
 Where [GEO] = 'Canada' 
		AND [REF_DATE] = '1976' 
		AND [Income source]='Total income'
		AND [Statistics]='Average income (excluding zeros)'
		AND [Age group]='16 years and over'
		AND [Sex]='Both sexes'
 Order By REF_DATE,GEO

 
 ----Select National Median Income by individuals over 16 years old on 2018 ------
 Select [REF_DATE],[GEO],[Income source],[Statistics],[VALUE],[UOM],[Age group]
 From CanadaIncome
 Where [GEO] = 'Canada' 
		AND [REF_DATE] = '2018' 
		AND [Income source]='Total income'
		AND [Statistics]='Median income (excluding zeros)'
		AND [Age group]='16 years and over'
		AND [Sex]='Both sexes'
 Order By REF_DATE,GEO


 -----SELF JOIN TO Show Median and Average In a single Row, from 1976 to 2019----------------

 Select a.REF_DATE,a.GEO,a.[Income source],a.[VALUE] as 'Average income (excluding zeros)',  b.[VALUE] as 'Median income (excluding zeros)',b.Sex,b.[Age group],a.UOM
 From CanadaIncome a
	JOIN CanadaIncome b
	 ON a.REF_DATE = b.REF_DATE 
		AND a.GEO = b.GEO
		AND a.[Income source] = b.[Income source]
		AND a.[Age group] = b.[Age group]
		AND a.Sex = b.Sex
 Where	a.[Income source]='Total income'
		AND a.[Statistics]='Average income (excluding zeros)'
		AND a.[Age group]='16 years and over'
		AND a.[Sex]='Both sexes'
		AND b.[Statistics]='Median income (excluding zeros)'
Order By REF_DATE, GEO