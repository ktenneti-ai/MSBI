-------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------- T-SQL Tasks -------------------------------------------------------
--------------------SP to populate the a given table with random data with their respective data types.------------------ 

create procedure rand_tablefill
@table_name varchar(50),
@num_records int
as
begin
if exists(select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @table_name)
			begin
				print 'Table Exists'
				declare @get varchar(100)
				while(@num_records>0)
				begin
				set @get = ''
					select 
					@get = @get +
					case
							WHEN ((select columnproperty(object_id(SCHEMA_NAME()+'.'+@table_name),COLUMN_NAME,'IsIdentity')) = 1) THEN '' --Check for identity column
							WHEN DATA_TYPE= 'int' THEN  cast(FLOOR(RAND()*(10)) as varchar)+','
							WHEN DATA_TYPE='smallint' THEN  cast(FLOOR(RAND()*(10)) as varchar)+','
							WHEN DATA_TYPE='varchar' THEN  ''''+(SELECT SUBSTRING(CONVERT(varchar(MAX), NEWID()),0,9))+''','
							WHEN DATA_TYPE='nchar' THEN ''''+(SELECT SUBSTRING(CONVERT(varchar(MAX), NEWID()),0,9))+''','
							WHEN DATA_TYPE='char' THEN ''''+(SELECT SUBSTRING(CONVERT(varchar(MAX), NEWID()),0,9))+''','
							WHEN DATA_TYPE='nvarchar' THEN ''''+(SELECT SUBSTRING(CONVERT(varchar(MAX), NEWID()),0,9))+''','
							WHEN DATA_TYPE='datetime' THEN (SELECT CONVERT(varchar, getdate(), 23))+','
							WHEN DATA_TYPE='tinyint' THEN cast(FLOOR(RAND()*(10)) as varchar)+','
							WHEN DATA_TYPE= 'bigint' THEN  cast(FLOOR(RAND()*(100)) as varchar)+','
							WHEN DATA_TYPE= 'numeric' THEN  cast(FLOOR(RAND()*(1000)) as varchar)+','
							When DATA_TYPE='bit' THEN CAST(FLOOR(RAND()) AS CHAR(1))+','
							else cast(FLOOR(RAND()) as varchar)+','
						end
						from INFORMATION_SCHEMA.COLUMNS s
						where s.TABLE_NAME=@table_name and s.TABLE_SCHEMA=SCHEMA_NAME()
					
						set @get = SUBSTRING ( @get ,0 , LEN(@get) )
						print @get
						set @num_records = @num_records - 1
						declare @ins varchar(500)
						set @ins = 'insert into '+@table_name+' values('+@get+')'
						exec (@ins)
				end
			end

-- FOR TEMP TABLES
if OBJECT_ID('tempdb..'+@table_name) IS NOT NULL
begin
	begin
				print 'Temp Table Exists'
				declare @get_d varchar(1000)
				while(@num_records>0)
				begin
				set @get_d = ''
					select 
					@get_d = @get_d +
					case
							WHEN ((select columnproperty(object_id(SCHEMA_NAME()+'.'+@table_name),c.name,'IsIdentity')) = 1) THEN ''
							WHEN t.name= 'int' THEN  cast(FLOOR(RAND()*(10)) as varchar)+','
							WHEN t.name='smallint' THEN  cast(FLOOR(RAND()*(10)) as varchar)+','
							WHEN t.name='varchar' THEN  ''''+(SELECT SUBSTRING(CONVERT(varchar(MAX), NEWID()),0,9))+''','
							WHEN t.name='nchar' THEN ''''+(SELECT SUBSTRING(CONVERT(varchar(MAX), NEWID()),0,9))+''','
							WHEN t.name='char' THEN ''''+(SELECT SUBSTRING(CONVERT(varchar(MAX), NEWID()),0,9))+''','
							WHEN t.name='nvarchar' THEN ''''+(SELECT SUBSTRING(CONVERT(varchar(MAX), NEWID()),0,9))+''','
							WHEN t.name='datetime' THEN (SELECT CONVERT(varchar, getdate(), 23))+','
							WHEN t.name='tinyint' THEN cast(FLOOR(RAND()) as varchar)+','
							WHEN t.name= 'bigint' THEN  cast(FLOOR(RAND()*(100)) as varchar)+','
							WHEN t.name= 'numeric' THEN  cast((RAND()*(1000)) as varchar)+','
							When t.name='bit' THEN CAST(FLOOR(RAND()) AS CHAR(1))+','
							else cast(FLOOR(RAND()) as varchar)+','
					end
					from tempdb.sys.columns c
					inner join tempdb.sys.types t 
					on (c.system_type_id=t.system_type_id)
					where c.object_id = OBJECT_ID('tempdb..'+@table_name);

					
					set @get_d = SUBSTRING ( @get_d ,0 , LEN(@get_d) )
					print @get_d
					set @num_records = @num_records - 1
					declare @ins_temp varchar(5000)
					set @ins_temp = 'insert into '+@table_name+' values('+@get_d+');'
					exec (@ins_temp)
				end
	end
end
else
		print 'Table Does Not Exist' 
end
go


		--------------------------------------------- 	Execution Statements   ------------------------------------------------------			

declare @table_name varchar(50);
exec rand_tablefill @table_name = '#temptable3' ,@num_records=35;
go