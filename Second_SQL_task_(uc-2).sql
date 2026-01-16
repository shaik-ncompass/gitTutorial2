use sys;

-- CREATING TABLES 

-- STUDENT TABLE
create table STUDENT (
	ID CHAR(4) primary key,
	NAME VARCHAR(30),
	DEPARTMENT VARCHAR(30),
	CGPA FLOAT
);

-- COMPANY TABLE
create table COMPANY (
	ID CHAR(4) primary key,
	NAME VARCHAR(30),
	LOCATION VARCHAR(30),
	INTERVIEW_DATE DATE
);

-- PLACEMENTS TABLE
create table PLACEMENTS (
	S_ID CHAR(4),
	C_ID CHAR(4),
	PACKAGE INT,
	foreign key (S_ID) references STUDENT(ID),
	foreign key  (C_ID) references COMPANY(ID)
);

-- INSERTING VALUES INTO TABLES
insert into STUDENT (ID,NAME,DEPARTMENT,CGPA) values 
('S001','ARUN','CS',8),
('S002','GITA','CS',7.5),
('S003','KUMAR','IT',6),
('S004','ROHIT','IT',8.5),
('S005','YAMUNA','ECE',9),
('S006','YOGESH','ECE',9);

insert into COMPANY (ID,NAME,LOCATION,INTERVIEW_DATE) values 
('C001','MICROSOFT','BANGALORE','2020-08-01'),
('C002','AMAZON','CHENNAI','2020-09-10'),
('C003','FLIPKART','BANGALORE','2020-09-15'),
('C004','HONEYWELL','HYDERABAD','2020-10-30'),
('C005','ACCENTURE','CHENNAI','2020-11-30'),
('C006','WIPRO','NOIDA','2020-12-31');

insert into PLACEMENTS (S_ID,C_ID,PACKAGE) values 
('S001','C001',2000000),
('S002','C001',2000000),
('S003','C002',1200000),
('S004','C004',700000),
('S004','C006',400000),
('S006','C004',700000);

select *from PLACEMENTS;

-- QUESTION 1
-- with CTE as (
-- 	select p.S_ID, p.PACKAGE, c.NAME
--  	from COMPANY c join PLACEMENTS p on c.ID=p.C_ID
--  	where p.PACKAGE=(select MAX(PACKAGE) from PLACEMENTS)
-- )
-- select s.NAME as STUDENT, c.NAME as COMPANY, c.PACKAGE 
-- from STUDENT s join CTE c on s.ID = c.S_ID;
select s.NAME as STUDENT,c.NAME as COMPANY,p.PACKAGE
from PLACEMENTS p join STUDENT s on p.S_ID=s.ID
join COMPANY c on p.C_ID=c.ID
where p.PACKAGE=(select MAX(PACKAGE) from PLACEMENTS);

-- QUESTION 2
-- with CTE as (
-- 	select s.ID,s.NAME as STUDENT,s.DEPARTMENT,
-- 	ifnull(p.C_ID,'-') as CID,
-- 	case
-- 		when p.PACKAGE is null then 'NO'
-- 		else 'YES'
-- 	end as PLACED,
-- 	IFNULL(p.PACKAGE,'-') as PACKAGE
-- 	from STUDENT s left join PLACEMENTS p on s.ID = p.S_ID
-- 	where s.DEPARTMENT='ECE'
-- )
-- select ct.STUDENT, ct.DEPARTMENT, ct.PLACED, 
-- IFNULL(c.NAME,'-') as COMPANY,ct.PACKAGE
-- from CTE ct left join COMPANY c on ct.CID=c.ID;

select s.NAME as STUDENT, s.DEPARTMENT,
case 
	when p.PACKAGE is null then 'NO'
	else 'YES'
end as PLACED,
c.NAME as COMPANY , p.PACKAGE as PACKAGE
from STUDENT s left join PLACEMENTS p on s.ID=p.S_ID
left join COMPANY c on c.ID=p.C_ID
where s.DEPARTMENT='ECE';


	

-- QUESTION 3
-- with CTE as (
-- 	select C_ID, COUNT(*) as NO_OF_STUDENTS from PLACEMENTS group by C_ID
-- )
-- select c.NAME,IFNULL(ct.NO_OF_STUDENTS,0) 
-- from COMPANY c left join CTE ct on c.ID=ct.C_ID;
select c.NAME as COMPANY,COUNT(p.C_ID) as NO_OF_STUDENTS
from COMPANY c left join PLACEMENTS p on c.ID=p.C_ID
group by c.NAME;

-- QUESTION 4
select MONTHNAME(INTERVIEW_DATE) as `MONTH`, NAME as COMPANY 
from COMPANY where MONTHNAME(INTERVIEW_DATE)='SEPTEMBER';

-- QUESTION 5
select NAME as COMPANY, INTERVIEW_DATE as `DATE`
from COMPANY
where INTERVIEW_DATE<CURDATE();

-- QUESTION 6
-- select s.NAME as STUDENT,c.NAME as COMPANY
-- from PLACEMENTS p join STUDENT s on s.ID = p.S_ID
-- join COMPANY c on c.ID=p.C_ID
-- where s.ID in
-- (select distinct p.S_ID from PLACEMENTS p group by p.S_ID having COUNT(p.S_ID)>1);
select s.NAME as STUDENT, c.NAME as COMPANY
from STUDENT s left join PLACEMENTS p on s.ID=p.S_ID
join COMPANY c on p.C_ID=c.ID 
where s.ID in (select p.S_ID from PLACEMENTS p group by p.S_ID having count(p.S_ID)>1);


-- QUESTION 7
select NAME as STUDENT, DEPARTMENT, CGPA
from STUDENT where CGPA>7 and ID not in 
(select distinct(S_ID) from PLACEMENTS);

-- QUESTION 8
select NAME as COMPANY, LOCATION from COMPANY
where LOCATION LIKE 'B%';


