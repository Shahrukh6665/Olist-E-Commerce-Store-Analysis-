create database OlistStoreAnalysis;

use OlistStoreAnalysis;

select * from olist_customers_dataset;

select * from olist_order_items_dataset;

select * from olist_order_payments_dataset;

select * from olist_order_reviews_dataset;

select * from olist_orders_dataset;

select * from olist_products_dataset;

----------------------------------------------------------------------

# Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

select 
case 
when dayofweek(order_purchase_timestamp) IN (5,6) Then "Weekend"
else "Weekday"
end as 'day_type',
count(*) as total_orders,
round(sum(payment_value), 2) as total_payment_amount
from olist_orders_dataset od
left join olist_order_payments_dataset opd on od.order_id = opd.order_id
group by day_type;

------------------------------------------------------------------------
# Number of Orders with review score 5 and payment type as credit card.

select count(distinct oord.order_id) as total_no_of_orders
from olist_order_reviews_dataset as oord
left join olist_order_payments_dataset opd on  oord.order_id = opd.order_id
where oord.review_score = 5 and opd.payment_type ='credit_card';

select count(*) from olist_order_payments_dataset as Payments inner join
olist_order_reviews_dataset as Reviews on Payments.order_id = Reviews.order_id
where Reviews.review_score = 5 and Payments.payment_type = 'credit_card';

-----------------------------------------------------------------------------

# Average number of days taken for order_delivered_customer_date for pet_shop

select round(avg(datediff(o.order_delivered_customer_date, o.order_purchase_timestamp)),2) as avg_delivery_days
from olist_orders_dataset as o
join olist_order_items_dataset as oi on o.order_id = oi.order_id
join olist_products_dataset as p on oi.product_id = p.product_id
where product_category_name = 'pet_shop';

--------------------------------------------------------------------------------

# Average price and payment values from customers of sao paulo city

select round((a.price),2) as avg_price, round(avg(b.payment_value),2) as avg_payment
from olist_order_items_dataset as a
join olist_order_payments_dataset as b on a.order_id = b.order_id
join olist_orders_dataset as c on a.order_id = c.order_id
join olist_customers_dataset AS d ON c.customer_id = d.customer_id
WHERE d.customer_city = 'Sao Paulo';

---------------------------------------------------------------------------

# Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

select 
  avg(datediff(o.order_delivered_customer_date, o.order_purchase_timestamp)) as shipping_days,
  r.review_score
from 
  olist_orders_dataset o
join 
  olist_order_reviews_dataset r ON o.order_id = r.order_id
where 
  o.order_status = 'delivered'
group by 
  r.review_score;
