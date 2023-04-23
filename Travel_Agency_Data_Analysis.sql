-- Write an sql query to find total user count segment wise and total count who booked flight on April 2022 --
select u.segment,count(distinct u.user_id) as total_users,
count(case when b.line_of_business='Flight' and b.booking_date between '2022-04-01' and '2022-04-30' then b.user_id end) as user_count_booked_flight
from booking_table b right join user_table u on b.user_id=u.user_id group by u.segment;

-- Find the total count of users who booked flights and hotels. --
select line_of_business,count(user_id) as users_booked from booking_table group by Line_of_business;

-- Find the total count of users who booked flights in march and may only. --
select sum(u_count) as cnt from
(select count(user_id) as u_count from booking_table where Line_of_business='Flight' 
and booking_date between '2022-03-01' and '2022-03-31' group by Line_of_business
union all
select count(user_id) as u_count from booking_table where Line_of_business='Flight' 
and booking_date between '2022-05-01' and '2022-05-31' group by Line_of_business) as t1;

-- Find the repeated users from booking table(same user who booked flights/hotels multiple times) --
select user_id,Line_of_business,count(*) from booking_table group by user_id,Line_of_business having count(*)>1 order by user_id;

-- Find the number of hotels and flights booked in month of April. --
select line_of_business,count(*) from booking_table where booking_date between '2022-04-01' and '2022-04-30' group by line_of_business;

-- Find the details of user whose very first booking is in a hotel. --
select * from
(select *,rank()over(partition by user_id order by booking_date) as rnk from booking_table) as t1
where rnk=1 and line_of_business='Hotel';

-- Find the number of users whose very first booking is for flight. --
select count(user_id) from
(select *,rank()over(partition by user_id order by booking_date) as rnk from booking_table) as t1
where rnk=1 and line_of_business='Flight';

-- Find booking id of the last booking of every month. --
select booking_id from(
select booking_id,booking_date,rank()over(partition by month(booking_date) order by booking_date desc) as rnk from booking_table) as t1
where rnk=1;

-- Find all booking ids of months March and May. --
select booking_id from booking_table where month(booking_date) in (3,5);

-- Find the difference of days between first and last booking of each user. --
select user_id,datediff(max(booking_date),min(booking_date)) as days from booking_table group by user_id;

-- Find the total number of flight and hotel bookings done by each user. --
select user_id,sum(
case when line_of_business='Flight' then 1 else 0 end) as flight_bookings,sum(case when line_of_business='Hotel' then 1 else 0 end) as hotel_bookings
from booking_table group by user_id;
select * from user_table;

-- Find the total number of flight and hotel bookings each segment wise. --
select segment,sum(
case when line_of_business='Flight' then 1 else 0 end) as flight_bookings,sum(case when line_of_business='Hotel' then 1 else 0 end) as hotel_bookings 
from booking_table b inner join user_table u on b.user_id=u.user_id
group by segment;
