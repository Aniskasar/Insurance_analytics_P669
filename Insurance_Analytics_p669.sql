SHOW DATABASES;
CREATE DATABASE Insurance_DB;
USE insurance_db;
show tables;

select * from brokerage;
select * from fees;
select * from `individual budgets`;
select * from invoice;
select * from meeting;
select * from opportunity;

desc opportunity;

alter table opportunity 
modify column closing_date date;

UPDATE opportunity
SET closing_date
 = STR_TO_DATE(closing_date, '%m/%d/%Y')
WHERE closing_date LIKE '%/%/%';

update meeting
set meeting_date = STR_TO_DATE(meeting_date,'%m%d%y')
where meeting_date like '%/%/%/';

desc meeting;

alter table meeting 
modify column meeting_date date;

UPDATE meeting
SET meeting_date = 
STR_TO_DATE(meeting_date, '%m/%d/%Y')
WHERE meeting_date LIKE '%/%/%';

select * from brokerage;
alter table brokerage modify column 
policy_start_date date;


UPDATE brokerage
SET policy_start_date = 
STR_TO_DATE(policy_start_date, '%m/%d/%Y')
WHERE policy_start_date LIKE '%/%/%';

alter table brokerage 
modify column policy_start_date date;
desc brokerage;

alter table brokerage modify column 
policy_end_date  date;

UPDATE brokerage
SET policy_end_date = STR_TO_DATE(policy_end_date, '%m/%d/%Y')
WHERE policy_end_date LIKE '%/%/%';

select distinct policy_end_date from brokerage;

desc brokerage;
select distinct income_due_date from brokerage;

alter table brokerage 
modify column income_due_date date;

UPDATE brokerage
SET  income_due_date
= STR_TO_DATE(income_due_date, '%m/%d/%Y')
WHERE income_due_date LIKE '%/%/%';
 
UPDATE brokerage
SET income_due_date = NULL
WHERE income_due_date = '';

desc brokerage;
select  last_updated_date from brokerage;

alter table brokerage modify column
last_updated_date date;

UPDATE brokerage
SET last_updated_date
= STR_TO_DATE(last_updated_date, '%m/%d/%Y')
WHERE last_updated_date LIKE '%/%/%';

desc fees;

select  income_due_date
from brokerage;

desc fees;
alter table fees modify column income_due_date date;
select distinct income_due_date from fees;

select * from brokerage;

UPDATE fees
SET income_due_date
= STR_TO_DATE(income_due_date, '%m/%d/%Y')
WHERE income_due_date LIKE '%/%/%';

desc fees;
alter table fees modify column income_due_date date;


show tables;
rename table `individual budgets` to Ind_budget;
select * from `individual budgets`;
select * from ind_budget;

show tables;
select * from invoice;

alter table invoice 
modify column income_due_date date;

update invoice
set income_due_date =
str_to_date(income_due_date, '%m/%d/%Y')
where income_due_date like '%/%/%';

UPDATE invoice
SET income_due_date
= STR_TO_DATE(income_due_date, '%m/%d/%Y')
WHERE income_due_date LIKE '%/%/%';



update invoice
set income_due_date = null
where income_due_date = "";

alter table invoice
modify column invoice_date date;

update invoice
set invoice_date 
= str_to_date(invoice_date, '%m/%d/%Y')
where invoice_date like '%/%/%';

select * from invoice;

alter table invoice 
modify column invoice_date date;

desc invoice;
show tables;

select * from meeting;
desc meeting;
show databases;
use insurance_db;
show tables;
select * from brokerage;
select * from fees;
select * from invoice;
select * from opportunity;
select * from meeting;
select  * from ind_budget;

select income_class,round(sum(Amount),2) 
as Bro_Amount
from brokerage
where income_class = 'Cross Sell'
or income_class = 'New'
or income_class = 'Renewal'
group by income_class;

select income_class,sum(Amount) 
as Fees_amount
from fees
where income_class = 'cross sell'
or income_class = 'new'
or income_class = 'renewal'
group by income_class;

/* Income project */ 

select * from fees;

SELECT 
    a.income_class,
    ROUND(SUM(a.Bro_amount), 2) 
    + ROUND(SUM(b.fees_amount), 2) 
    AS Achievement_sales
FROM  
(
    SELECT 
        income_class,
        ROUND(SUM(amount), 2) AS Bro_amount
    FROM 
        brokerage
    WHERE 
        income_class IN ('cross sell', 'new', 'renewal')
    GROUP BY 
        income_class
) a
INNER JOIN 
(
    SELECT 
        income_class,
        ROUND(SUM(amount), 2) AS fees_amount
    FROM 
        fees
    WHERE 
        income_class IN ('cross sell', 'new', 'renewal')
    GROUP BY 
        income_class
) b ON a.income_class = b.income_class
GROUP BY a.income_class
order by Achievement_sales;

select a.income_class,
CONCAT(ROUND((SUM(a.Bro_amount) + SUM(b.fee_amount)) / 1000000, 2), ' M')
as Achive_placed_sales
from 
(
select income_class,round(sum(amount),2) 
as Bro_amount 
from brokerage 
where income_class in ('cross sell','new','renewal')
group by income_class
)a 
inner join 
(
select income_class,round(sum(amount),2) 
as fee_amount 
from fees 
where income_class in ('cross sell','new','renewal')
group by income_class)b
on a.income_class = b.income_class
group by a.income_class
order by Achive_placed_sales;

select * from invoice;

select income_class,
concat(round(sum((Amount)/1000000),2),"M") 
as Invoice_placed_sales
from invoice
where income_class in ('cross sell','new','renewal')
group by income_class;
 
 
 
 
 
 
 
select a.income,
b.category
from brokerage a 
join fees b
on a.income_class = b.income_class 