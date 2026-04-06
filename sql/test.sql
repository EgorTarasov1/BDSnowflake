-- тест 1: сверка общего количества строк (должно быть 10 000)
-- результат: 10000 в обеих колонках.
select 
    (select count(*) from mock_data) as raw_count, 
    (select count(*) from fact_sales) as fact_count;



-- тест 2: сверка итоговой выручки (разница должна быть 0)
-- результат: 0.00.
select 
    sum(sale_total_price) as raw_sum, 
    (select sum(total_price) from fact_sales) as fact_sum,
    sum(sale_total_price) - (select sum(total_price) from fact_sales) as difference
from mock_data;



-- тест 3: проверка уникальности покупателей по email
-- результат: 10000 в обеих колонках (так как email в твоих файлах уникален для каждой строки).
select 
    (select count(distinct customer_email) from mock_data) as raw_emails, 
    (select count(*) from dim_customers) as dim_customers_count;



-- тест 4: проверка на наличие ссылок "в никуда".
-- результат: 0. если больше 0, значит данные потерялись при джоинах.
select count(*) as orphans 
from fact_sales 
where customer_id not in (select customer_id from dim_customers) 
   or product_id not in (select product_id from dim_products)
   or store_id not in (select store_id from dim_stores);



-- тест 5: проверка средней цены продажи
-- результат: значения должны совпадать до копеек.
select 
    round(avg(sale_total_price), 2) as raw_avg, 
    (select round(avg(total_price), 2) from fact_sales) as fact_avg 
from mock_data;



-- тест 6: проверка глубины снежинки (выручка по категориям животных)
-- результат: список категорий (cats, dogs и т.д.) с суммами выручки.
select 
    c.pet_category, 
    sum(f.total_price) as revenue
from fact_sales f
join dim_products p on f.product_id = p.product_id
join dim_categories c on p.category_id = c.category_id
group by c.pet_category
order by revenue desc;



-- тест 7: проверка географии (количество уникальных стран)
-- результат: число стран в dim_geography должно быть >= числу стран в mock_data.
select 
    (select count(distinct customer_country) from mock_data) as raw_countries, 
    (select count(distinct country) from dim_geography) as dim_countries_count;



-- исправленный тест 8: проверка связей продавцов (выручка по конкретному продавцу)
-- результат: суммы должны быть идентичны.
with top_seller as (select email from dim_sellers limit 1) -- здесь было seller_email, заменили на email
select 
    (select sum(sale_total_price) from mock_data where seller_email = (select email from top_seller)) as raw_total,
    (select sum(f.total_price) from fact_sales f join dim_sellers s on f.seller_id = s.seller_id where s.email = (select email from top_seller)) as fact_total;



-- тест 9: проверка поставщиков
-- результат: количество уникальных поставщиков должно совпадать.
select 
    (select count(distinct supplier_name) from mock_data) as raw_suppliers, 
    (select count(*) from dim_suppliers) as dim_suppliers_count;



-- тест 10: джоин всех таблиц снежинки
-- результат: ровно 10000. это доказывает идеальную целостность всей модели.
select count(*) 
from fact_sales f
join dim_customers c on f.customer_id = c.customer_id
join dim_sellers sel on f.seller_id = sel.seller_id
join dim_products p on f.product_id = p.product_id
join dim_stores s on f.store_id = s.store_id
join dim_categories cat on p.category_id = cat.category_id
join dim_suppliers sup on p.supplier_id = sup.supplier_id
join dim_geography g on s.geo_id = g.geo_id;