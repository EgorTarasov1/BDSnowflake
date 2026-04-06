insert into dim_geography (country, city, state, postal_code)
select distinct customer_country, null, null, customer_postal_code from mock_data
union
select distinct store_country, store_city, store_state, null from mock_data
union
select distinct seller_country, null, null, seller_postal_code from mock_data
union
select distinct supplier_country, supplier_city, null, null from mock_data;


insert into dim_categories (product_category, pet_category)
select distinct product_category, pet_category from mock_data;


insert into dim_suppliers (supplier_name, contact_name, geo_id)
select distinct on (supplier_name)
    supplier_name,
    supplier_contact,
    g.geo_id
from mock_data m
join dim_geography g on g.country = m.supplier_country 
                    and g.city = m.supplier_city
order by supplier_name;


insert into dim_customers (email, first_name, last_name, age, pet_type, geo_id)
select distinct on (customer_email)
    customer_email, 
    customer_first_name, 
    customer_last_name, 
    customer_age, 
    customer_pet_type, 
    g.geo_id
from mock_data m
join dim_geography g on g.country = m.customer_country 
                    and g.postal_code = m.customer_postal_code
order by customer_email;


insert into dim_sellers (email, first_name, last_name, geo_id)
select distinct on (seller_email)
    seller_email, 
    seller_first_name, 
    seller_last_name, 
    g.geo_id
from mock_data m
join dim_geography g on g.country = m.seller_country 
                    and g.postal_code = m.seller_postal_code
order by seller_email;


insert into dim_stores (store_name, geo_id)
select distinct on (store_name, store_country, store_city)
    store_name, 
    g.geo_id
from mock_data m
join dim_geography g on g.country = m.store_country 
                    and g.city = m.store_city
order by store_name, store_country, store_city;


insert into dim_products (original_product_id, product_name, brand, price, category_id, supplier_id)
select distinct on (sale_product_id, product_name, product_brand, product_price)
    sale_product_id, 
    product_name, 
    product_brand, 
    product_price, 
    c.category_id, 
    s.supplier_id
from mock_data m
join dim_categories c on c.product_category = m.product_category 
                     and c.pet_category = m.pet_category
join dim_suppliers s on s.supplier_name = m.supplier_name
order by sale_product_id, product_name, product_brand, product_price;


insert into fact_sales (sale_date, customer_id, seller_id, product_id, store_id, quantity, total_price)
select
    m.sale_date,
    c.customer_id,
    sel.seller_id,
    p.product_id,
    st.store_id,
    m.sale_quantity,
    m.sale_total_price
from mock_data m
join dim_customers c on c.email = m.customer_email
join dim_sellers sel on sel.email = m.seller_email
join dim_products p on p.original_product_id = m.sale_product_id
                   and p.product_name = m.product_name
                   and p.brand = m.product_brand
                   and p.price = m.product_price
join dim_stores st on st.store_name = m.store_name
join dim_geography g_st on st.geo_id = g_st.geo_id
                       and g_st.country = m.store_country
                       and g_st.city = m.store_city;