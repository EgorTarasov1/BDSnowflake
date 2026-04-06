create table dim_geography (
    geo_id serial primary key,
    country text,
    city text,
    state text,
    postal_code text
);


create table dim_categories (
    category_id serial primary key,
    product_category text,
    pet_category text
);


create table dim_suppliers (
    supplier_id serial primary key,
    supplier_name text,
    contact_name text,
    geo_id int references dim_geography(geo_id)
);


create table dim_customers (
    customer_id serial primary key,
    email text unique,
    first_name text,
    last_name text,
    age int,
    pet_type text,
    geo_id int references dim_geography(geo_id)
);


create table dim_sellers (
    seller_id serial primary key,
    email text unique,
    first_name text,
    last_name text,
    geo_id int references dim_geography(geo_id)
);


create table dim_stores (
    store_id serial primary key,
    store_name text,
    geo_id int references dim_geography(geo_id)
);


create table dim_products (
    product_id serial primary key,
    original_product_id int,
    product_name text,
    brand text,
    price decimal(12, 2),
    category_id int references dim_categories(category_id),
    supplier_id int references dim_suppliers(supplier_id)
);


create table fact_sales (
    sale_id serial primary key,
    sale_date date,
    customer_id int references dim_customers(customer_id),
    seller_id int references dim_sellers(seller_id),
    product_id int references dim_products(product_id),
    store_id int references dim_stores(store_id),
    quantity int,
    total_price decimal(12, 2)
);