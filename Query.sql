use blinkit_sales;
select * from data;
select count(*) from data;
SET SQL_SAFE_UPDATES = 0;

#Data Cleaning

#change column name ï»¿Item Fat Content to Item Fat Content
ALTER TABLE data
RENAME COLUMN `ï»¿Item Fat Content` TO `Item Fat Content`;

#irregularity in Item Fat Content
UPDATE data
SET `Item Fat Content`=
case when `Item Fat Content` in ('LF','low fat') then 'Low Fat'
	 when `Item Fat Content`= 'reg' then 'Regular'
     else `Item Fat Content`
end;
select distinct(`Item Fat Content`) from data;

#Changing data type of outlet establishment year from int to date
ALTER TABLE data
MODIFY COLUMN `Outlet Establishment Year` YEAR;

#Analysis

#KPIs
#Total Sales
select concat(cast(sum(`Total Sales`)/1000000 as decimal(10,2)),'M') as total_sales_millions from data; 
#gives output in millions
#Average Sales
select cast(avg(`Total Sales`) as decimal(10,0)) as avg_sales from data;
#Number of items
select count(*) as no_of_items from data;
#Average Rating
select cast(avg(Rating) as decimal(10,2)) as avg_rating from data;

# (A) Variations in Metrics with Fat content
#1.Total Sales
select `Item Fat Content`,
       concat(cast(sum(`Total Sales`)/1000 as decimal(10,2)),'K') as total_sales from data
group by `Item Fat Content`;
#2.Average Sales
select `Item Fat Content`,cast(avg(`Total Sales`) as decimal(10,0)) as avg_sales from data
group by `Item Fat Content`; 
#3.Number of items
select `Item Fat Content`,count(*) as no_of_items from data
group by `Item Fat Content`;
#4.Average Rating
select `Item Fat Content`,cast(avg(Rating) as decimal(10,2)) as avg_rating from data
group by `Item Fat Content`;

# (B) Metrics by Item Type
select `Item Type`,concat(cast(sum(`Total Sales`)/1000 as decimal(10,2)),'K') as total_sales,
		cast(avg(`Total Sales`) as decimal(10,0)) as avg_sales,
        count(*) as no_of_items,
        cast(avg(Rating) as decimal(10,2)) as avg_rating
from data
group by `Item Type`
order by sum(`Total Sales`) desc;

# (C) Metrics:Fat Content by Outlet
#Fat Content by Outlet for Total Sales:
SELECT 
    `Outlet Location Type`,
    CAST(SUM(CASE WHEN `Item Fat Content` = 'Low Fat' THEN `Total Sales` ELSE 0 END) / 1000 AS DECIMAL(10,2)) AS Low_Fat,
    CAST(SUM(CASE WHEN `Item Fat Content` = 'Regular' THEN `Total Sales` ELSE 0 END) / 1000 AS DECIMAL(10,2)) AS Regular
FROM data
GROUP BY `Outlet Location Type`
ORDER BY `Outlet Location Type`;
#Fat Content by Outlet for Average Sales:
SELECT 
    `Outlet Location Type`,
    CAST(AVG(CASE WHEN `Item Fat Content` = 'Low Fat' THEN `Total Sales` ELSE 0 END) AS DECIMAL(10,2)) AS Low_Fat,
    CAST(AVG(CASE WHEN `Item Fat Content` = 'Regular' THEN `Total Sales` ELSE 0 END) AS DECIMAL(10,2)) AS Regular
FROM data
GROUP BY `Outlet Location Type`
ORDER BY `Outlet Location Type`;
#Fat Content by Outlet for Number of Items:
SELECT 
    `Outlet Location Type`,
    count(CASE WHEN `Item Fat Content` = 'Low Fat' THEN `Total Sales` END) AS Low_Fat,
    count(CASE WHEN `Item Fat Content` = 'Regular' THEN `Total Sales` END) AS Regular
FROM data
GROUP BY `Outlet Location Type`
ORDER BY `Outlet Location Type`;
#Fat Content by Outlet for Average Rating:
SELECT 
    `Outlet Location Type`,
    CAST(AVG(CASE WHEN `Item Fat Content` = 'Low Fat' THEN `Rating` ELSE 0 END) AS DECIMAL(10,2)) AS Low_Fat,
    CAST(AVG(CASE WHEN `Item Fat Content` = 'Regular' THEN `Rating` ELSE 0 END) AS DECIMAL(10,2)) AS Regular
FROM data
GROUP BY `Outlet Location Type`
ORDER BY `Outlet Location Type`;

# (D) Metrics by Outlet Establishment
select `Outlet Establishment Year`,concat(cast(sum(`Total Sales`)/1000 as decimal(10,2)),'K') as total_sales,
		cast(avg(`Total Sales`) as decimal(10,0)) as avg_sales,
        count(*) as no_of_items,
        cast(avg(Rating) as decimal(10,2)) as avg_rating
from data
group by `Outlet Establishment Year`
order by sum(`Total Sales`) desc;

# (E) Percentage of Sales by Outlet Size:
select `Outlet Size`,cast(sum(`Total Sales`)as decimal(10,2)) as total_sales,
cast((sum(`Total Sales`)*100/sum(sum(`Total Sales`)) over()) as decimal(10,2)) as sales_percentage
from data
group by `Outlet Size`
order by total_sales desc;

# (F) Sales by Outlet Location:
select `Outlet Location Type`,concat(cast(sum(`Total Sales`)/1000 as decimal(10,2)),'K') as total_sales,
		cast(avg(`Total Sales`) as decimal(10,0)) as avg_sales,
        count(*) as no_of_items,
        cast(avg(Rating) as decimal(10,2)) as avg_rating
from data
group by `Outlet Location Type`
order by total_sales desc;

# (G) All Metrics by Outlet Type:
select `Outlet Type`,concat(cast(sum(`Total Sales`)/1000 as decimal(10,2)),'K') as total_sales,
		cast(avg(`Total Sales`) as decimal(10,0)) as avg_sales,
        count(*) as no_of_items,
        cast(avg(Rating) as decimal(10,2)) as avg_rating
from data
group by `Outlet Type`
order by total_sales desc;