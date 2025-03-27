drop table if exists goldusers_signup

create table goldusers_signup 
(
user_id int,
Membership Date)
insert into goldusers_signup values(1, '2017-01-20'),(3, '2017-03-20');

select * from goldusers_signup

drop table if exists users
create table users
(
user_id int,
Signup_Date Date
)
insert into users values(1, '2019-11-10'),(2, '2019-04-28'),(3, '2021-03-20');

select * from  users

drop table if exists products
create table products 
(
product_id int,
product_name Varchar(20),
price int
)
insert into products values('11', 'Biryani', 680),('12', 'Pasta', 400),('13', 'Pizza', 360);

select * from products

drop table if exists sales;
create table sales(
user_id int,
Order_Date date,
Product_id int
)
insert into sales values(1, '2017-04-19', 12),(3, '2019-12-18', 11),(2, '2020-07-20', 13),(1, '2019-10-23', 12),(1, '2018-03-19', 13),(3, '2016-12-20', 12),(1, '2016-11-09', 12),(1, '2016-05-20', 13),(2, '2017-09-24', 11),(1, '2017-03-11', 12),(1, '2016-03-11', 11),(3, '2016-11-10', 11),(3, '2017-12-07', 12),(3, '2016-12-15', 12),(2, '2017-11-08', 12);

select * from sales;
select * from products;
select * from goldusers_signup;
select * from users;


----------1. SQL Query to find the total amount each customer spent on Zomato?
select sales.user_id, sum(products.price) TotalAmount_Spent from sales inner join products on sales.product_id = products.product_id
group by sales.user_id;

----------2. SQL Query to find How Many Days has each customer visited Zomato?
select user_id, count(distinct Order_date) as Visited_days from sales
group by user_id;

----------3. SQL Query to find first product purchased of each customer?
select * from 
         (select *, rank() over(partition by user_id order by Order_date) as rnk from sales) 
a where rnk = 1;

----------4. SQL Query to find the most purchased item on the menu and how many times it was purchased by the customers

select user_id, count(product_id) from sales where product_id = (select top 1 product_id from  sales
group by Product_id 
order by count(Product_id) desc)
group by user_id

----------5. SQL Query to find the most popular item for each customer?

select c.*, rank() over(partition by user_id order by cnt desc) from 
(select user_id, product_id, count(product_id) as cnt from sales
group by user_id,Product_id) c;

----------6. SQL Query to find which item was purchased after becoming gold member?

select * from (select *, rank()over(partition by user_id order by Order_date) rnk from 
(select sales.user_id, sales.Order_Date, sales.Product_id, goldusers_signup.Membership from sales
inner join goldusers_signup on sales.user_id = goldusers_signup.user_id and Order_Date >= Membership) a)b where rnk = 1;


----------7. SQL Query to find which item was purchased before the customer has become goldmember?

select * from 
(select *, rank() over(partition by user_id order by Order_date desc) rnk from
(select sales.user_id, sales.Order_Date, sales.Product_id, goldusers_signup.Membership from sales
inner join goldusers_signup on sales.user_id = goldusers_signup.user_id and Order_Date <= Membership) a) b where rnk = 1;


---------8. SQL Query to find the total orders and total amount spent for each member before they become goldmember


select c.*, products.price from (select sales.user_id, sales.Order_Date, sales.Product_id, goldusers_signup.user_id from sales
inner join goldusers_signup on sales.user_id = goldusers_signup.user_id and Order_Date <= Membership)c inner join sales on products.product_id = sales.Product_id;
