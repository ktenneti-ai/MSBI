-------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- LeetCode Problems ----------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------

--Combine 2 tables
select FirstName, LastName, City, State
from Person p
left join Address a on p.PersonId=a.PersonId

--Second highest
declare @Salary int;
SELECT @Salary = Salary
FROM (
       SELECT
         [Salary],
         (DENSE_RANK()
         OVER
         (
           ORDER BY [Salary] DESC)) AS rnk
       FROM Employee
       GROUP BY Salary
     ) AS A
WHERE A.rnk = 2

select 
case 
when @Salary is not null then @Salary
else null 
end as 'SecondHighestSalary'

--Nth highest Salary
CREATE FUNCTION getNthHighestSalary(@N INT) RETURNS INT AS
BEGIN
    RETURN (
     select distinct Salary
          from 
           (select dense_rank() over (order by salary desc) as Ranks, ID, Salary
            from Employee) as a
            where a.Ranks = @N
    )    
END

--Not boring movies
select * from cinema
where description <> 'boring'
and id % 2 <> 0 
order by rating desc

--Rank Scores
select Score,dense_rank() over(order by Score desc) Rank
from Scores
order by Score desc

--Consecutive Numbers
select distinct Num as consecutiveNums
from 
(
    select Num,sum(c) over (order by Id) as step 
    from 
        (
            select id, num, 
            case 
            when LAG(Num) OVER     (order by id)- Num = 0 then 0 
            else 1
            end as c
            from logs
        ) i
) o
group by Num,step
having count(*)>=3

--Employees Earning More Than Their Managers
select m.Name as 'Employee' from Employee e
join Employee m on e.Id=m.ManagerId
where m.Salary>e.Salary

--Duplicate Emails
select distinct p.Email from Person p
join Person t on p.Id <> T.Id
where p.Email=t.Email

--Customers Who Never Order
select Name as 'Customers' from Customers c
left join Orders o on c.Id = o.CustomerId
where o.Id is null