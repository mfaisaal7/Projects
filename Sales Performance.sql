# Dari data clean_data sales performance, kita ingin mengetahui:

# 1. A. Overall performance dari tahun 2009–2012 untuk jumlah order dan total sales order finished
# 1. B. Overall performance by subcategory product yang akan dibandingkan antara tahun 2011 dan tahun 2012
# 2. A. Efektifitas dan efisiensi promosi yang dilakukan selama ini, dengan menghitung burn rate dari promosi yang dilakukan overall berdasarkan tahun
# 2. B. Efektifitas dan efisiensi promosi yang dilakukan selama ini, dengan menghitung burn rate dari promosi yang dilakukan overall berdasarkan sub-category
# 3. Analisa terhadap customer setiap tahunnya dan Analisa terhadap jumlah customer baru setiap tahunnya
# Formula untuk burn rate : (total discount / total sales) * 100

# Membuat database bernama Sales Performance 
create database sales_performance;

# Menggunakan database Sales Performance
use sales_performance;

# Kali ini kita akan menggunakan table bernama clean_data. Dataset yang digunakan berisi transaksi dari tahun 2009-2012 dengan jumlah raw data sebanyak 5500 dan berjumlah 10 kolom
SELECT * 
FROM clean_data;

# 1. A. Overall Performance by Year
SELECT
	LEFT (order_date,4) as years,
	SUM(sales) as sales,
	COUNT(order_status) as number_of_order
FROM
	clean_data
WHERE
	order_status = 'Order Finished' # Filter order_status dengan ‘Order Finished’ karena hanya ingin menghitung transaksi yang sudah selesai
GROUP BY
	years
order by
	years;
    
# 1. B. Overall Performance by Product Sub Category
SELECT
	year (order_date) as years, # Untuk order_date menggunakan Year untuk menampilkan tahun saja. untuk penjumlahan menggunakan SUM
	product_sub_category,
	sum(sales) as sales
FROM
	clean_data
WHERE
	year (order_date) between 2011 and 2012 and
	order_status = 'Order Finished' # Filter order_date berdasarkan tahun antara 2011–2012 saja dengan order_status ‘Order Finished’. Dan diurutkan berdasarkan sales tertinggi
GROUP BY
	year (order_date),
	product_sub_category
ORDER BY
	years,sales desc;
    
# 2. A. Promotion Effectiveness and Effeciency by Years
Select 
	year(order_date) as years, # Untuk order_date menggunakan Year untuk menampilkan tahun saja.
	sum(sales) as sales,
	sum(discount_value) as promotion_value, # untuk penjumlahan menggunakan SUM pada Kolom sales dan discount_value,
	round(sum(discount_value)/sum(sales)*100,2) as burn_rate_percentage # round untuk membulatkan angka dengan 2 angka dibelakang koma pada tabel burn_rate_percentage
from 
	clean_data
where
	order_status = 'Order Finished' # Filter order_status dengan ‘Order Finished’ karena hanya ingin menghitung transaksi yang sudah selesai
group by
	year(order_date)
order by
	year(order_date) asc;
    
# 2.B. Promotion Effectiveness and Effeciency by Product Sub Category
select
	year(order_date) as years,
	product_sub_category,
	product_category,
	sum(sales) as sales,
	sum(discount_value) as promotion_value,
	round(sum(discount_value)/sum(sales)*100,2) as burn_rate_percentage
from 
	clean_data
where
	year(order_date) = 2012 and order_status = 'Order Finished' # Filter order_status dengan ‘Order Finished’ karena hanya ingin menghitung transaksi yang sudah selesai dan order_date hanya pada tahun 2012 saja

group by       
	year(order_date),product_sub_category,product_category
order by
	sales desc;
    
# 3. Customers Transaction per Year
select
	year(order_date) as years,
	count(distinct customer) as number_of_customer # Untuk order_date menggunakan Year untuk menampilkan tahun saja. Serta mengitung jumlah customer yang bertransaksi selama setahun dan tidak ada duplikasi dengan menggunakan DISTINCT
from 
	clean_data
where
	year(order_date) between 2009 and 2012 and order_status = 'Order Finished'
group by
	year(order_date)
order by
	year(order_date)