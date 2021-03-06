create table sourcetable(
	id int,
	name varchar(40),
	age int
)
insert into sourcetable values(1,'likoi',20),(2,'loki',20),(3,'vin',20),(4,'vai',20),(5,'taru',20)

create table trgttable(
	id int,
	name varchar(40)
)
insert into trgttable values(1,'likoi'),(2,'loki'),(3,'vin'),(4,'vai'),(5,'tanu'),(11,'aritosh'),(6,'paritosh'),(7,'kaleen'),(8,'gaitunde'),(9,'ruking')
----------
go
----------
DECLARE @MergeOutput TABLE
(
  ActionType NVARCHAR(10)
);
 

Merge trgttable as trgt
using sourcetable as src
on trgt.id=src.id

when matched and src.name<>trgt.name
then 
	update set trgt.name = src.name
	 --OUTPUT
  -- $action
   --,
	  --inserted.*,
   --deleted.*;
when not matched BY TARGET
then
 insert (id,name) values(src.id,src.name)
WHEN NOT MATCHED BY SOURCE THEN 
DELETE
OUTPUT
    $action
  INTO @MergeOutput;
--OUTPUT src.id, $action into @MergeLog;

select * from trgttable

--// TO SEE THE CHANGES
SELECT * FROM @MergeOutput;