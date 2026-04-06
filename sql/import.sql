create table mock_data (
    id int,
    customer_first_name varchar(255),
    customer_last_name varchar(255),
    customer_age int,
    customer_email varchar(255),
    customer_country varchar(255),
    customer_postal_code varchar(100),
    customer_pet_type varchar(100),
    customer_pet_name varchar(100),
    customer_pet_breed varchar(100),
    seller_first_name varchar(255),
    seller_last_name varchar(255),
    seller_email varchar(255),
    seller_country varchar(255),
    seller_postal_code varchar(100),
    product_name varchar(255),
    product_category varchar(255),
    product_price decimal(12, 2),
    product_quantity int,
    sale_date date,
    sale_customer_id int,
    sale_seller_id int,
    sale_product_id int,
    sale_quantity int,
    sale_total_price decimal(12, 2),
    store_name varchar(255),
    store_location varchar(255),
    store_city varchar(255),
    store_state varchar(255),
    store_country varchar(255),
    store_phone varchar(100),
    store_email varchar(255),
    pet_category varchar(100),
    product_weight decimal(12, 2),
    product_color varchar(100),
    product_size varchar(100),
    product_brand varchar(255),
    product_material varchar(255),
    product_description text,
    product_rating decimal(3, 2),
    product_reviews int,
    product_release_date date,
    product_expiry_date date,
    supplier_name varchar(255),
    supplier_contact varchar(255),
    supplier_email varchar(255),
    supplier_phone varchar(100),
    supplier_address varchar(255),
    supplier_city varchar(255),
    supplier_country varchar(255)
);


copy mock_data from '/data/MOCK_DATA (1).csv' with (format csv, header true);
copy mock_data from '/data/MOCK_DATA (2).csv' with (format csv, header true);
copy mock_data from '/data/MOCK_DATA (3).csv' with (format csv, header true);
copy mock_data from '/data/MOCK_DATA (4).csv' with (format csv, header true);
copy mock_data from '/data/MOCK_DATA (5).csv' with (format csv, header true);
copy mock_data from '/data/MOCK_DATA (6).csv' with (format csv, header true);
copy mock_data from '/data/MOCK_DATA (7).csv' with (format csv, header true);
copy mock_data from '/data/MOCK_DATA (8).csv' with (format csv, header true);
copy mock_data from '/data/MOCK_DATA (9).csv' with (format csv, header true);
copy mock_data from '/data/MOCK_DATA.csv' with (format csv, header true);

update mock_data set
    customer_email = trim(customer_email),
    customer_country = trim(customer_country),
    customer_postal_code = trim(customer_postal_code),
    seller_email = trim(seller_email),
    seller_country = trim(seller_country),
    seller_postal_code = trim(seller_postal_code),
    product_name = trim(product_name),
    product_brand = trim(product_brand),
    product_category = trim(product_category),
    pet_category = trim(pet_category),
    store_name = trim(store_name),
    store_city = trim(store_city),
    store_state = trim(store_state),
    store_country = trim(store_country),
    supplier_name = trim(supplier_name),
    supplier_country = trim(supplier_country),
    supplier_city = trim(supplier_city);


drop table if exists fact_sales cascade;
drop table if exists dim_products cascade;
drop table if exists dim_customers cascade;
drop table if exists dim_stores cascade;
drop table if exists dim_sellers cascade;
drop table if exists dim_suppliers cascade;
drop table if exists dim_categories cascade;
drop table if exists dim_geography cascade;