-- BASIC
#1. Display all records from the table.
SELECT * FROM zepto;

#2. Show only the name and mrp of all products. 
SELECT name,mrp FROM zepto;

#3. List all products where Category = 'Fruits & Vegetables'. 
SELECT name AS product FROM zepto WHERE category= 'Fruits & Vegetables';

#4. Find products where mrp is greater than 3000. 
SELECT name AS product,mrp FROM zepto WHERE mrp>3000;

#5. Show products where discountPercent is 15. 
SELECT name AS product FROM zepto WHERE discountPercent=15;

#6. Display products where outOfStock is FALSE. 
SELECT name AS product,outOfStock FROM zepto WHERE outOfStock='FALSE';

#7. List the names of products with weightInGms greater than 500. 
SELECT name AS product,weightInGms FROM zepto WHERE weightInGms>500;

#8. Find products where availableQuantity is less than 5. 
SELECT name AS product,availableQuantity FROM zepto WHERE availableQuantity<=5;

#9. Show distinct categories available in the table. 
SELECT DISTINCT category FROM zepto;

#10. Count the total number of products. 
SELECT COUNT(name) FROM zepto; 

#11. Display products sorted by mrp in ascending order. 
SELECT name AS product,mrp FROM zepto ORDER BY mrp ASC;

#12. Display products sorted by discountPercent in descending order. 
SELECT name AS product,discountPercent FROM zepto ORDER BY discountPercent DESC;

#13. Show top 10 most expensive products based on mrp. 
SELECT name AS product,mrp FROM zepto ORDER BY mrp DESC LIMIT 10;

#14. Find products where name starts with letter ‘T’. 
SELECT name AS product FROM zepto WHERE name LIKE 'T%';

#15. Count how many products are out of stock. 
SELECT COUNT(outOfStock) FROM zepto WHERE outOfStock='FALSE';

#16. Show products where quantity is greater than 50. 
SELECT name AS product,quantity FROM zepto WHERE quantity>50;

#17. Find products where mrp is between 2000 and 4000.
SELECT name AS product,mrp FROM zepto WHERE mrp>2000 AND mrp<4000;

#18. Display products where discountedSellingPrice is less than 1500. 
SELECT name AS product,discountedSellingPrice FROM zepto WHERE discountedSellingPrice<1500;

#19. List products where weightInGms equals 1000. 
SELECT name AS product,weightInGms FROM zepto WHERE weightInGms=1000;

#20. Show all products whose category contains the word ‘Vegetables’. 
SELECT * FROM zepto WHERE category LIKE '% Vegetables';

-- INTERMEDIATE

#21. Find the maximum mrp in each category. 
SELECT category,MAX(mrp) AS MAX_VALUE FROM zepto GROUP BY category;

#22. Find the minimum discountedSellingPrice in each category. 
SELECT category,MIN(discountedSellingPrice) AS MIN_discountedsellingprice FROM zepto GROUP BY category;

#23. Count the number of products in each category. 
SELECT category,COUNT(name) AS numberofproducts FROM zepto GROUP BY category;

#24. Calculate the average mrp of all products. 
SELECT AVG(mrp) FROM zepto;
SELECT name AS product,AVG(mrp) FROM zepto GROUP BY name;

#25. Show total available quantity of products category-wise. 
SELECT category,SUM(availableQuantity) FROM zepto GROUP BY category;

#26. Find products where the difference between mrp and discountedSellingPrice is greater than 1000. 
SELECT name AS product FROM zepto WHERE `mrp`-`discountedSellingPrice`>1000;

#27. Display products with discount greater than the average discount. 
SELECT name AS product,mrp-discountedSellingPrice AS discount FROM zepto 
 WHERE mrp-discountedSellingPrice>(SELECT AVG(mrp-discountedSellingPrice) FROM zepto);
 
 #28. Show categories having more than 50 products. 
SELECT category,COUNT(*) AS productcount FROM zepto  GROUP BY category  HAVING COUNT(*)>50;

#29. Find top 5 products with highest discount percent. 
SELECT name AS products,discountPercent FROM zepto ORDER BY discountPercent DESC LIMIT 5;

#30. Display total inventory weight (weightInGms * availableQuantity) for each product.
SELECT name AS products,weightInGms*availableQuantity AS invintory_weight FROM zepto;

#31. Find products where discountedSellingPrice is less than 50% of mrp.
SELECT name AS products,((mrp - discountedSellingPrice)/mrp)*100 AS discount_percent FROM zepto WHERE discountedSellingPrice<mrp*0.5;

#32. Show products whose names contain the word ‘Coconut’. 
SELECT name AS products FROM zepto WHERE name LIKE '%Coconut%';

#33. Calculate total stock value (discountedSellingPrice * availableQuantity) for each product. 
SELECT name AS products,discountedSellingPrice * availableQuantity AS total_value_inRS FROM zepto;

#34. Display the category with the highest average discount. 
SELECT category,AVG(mrp-discountedSellingPrice) AS avg_discount FROM zepto GROUP BY category ORDER BY avg_discount DESC LIMIT 1;

#35. Show products where availableQuantity is zero but outOfStock is FALSE (data inconsistency check). 
SELECT name AS products,availableQuantity,outOfStock FROM zepto WHERE availableQuantity=0 AND outOfStock='FALSE';

-- ADVANCED

#36. Rank products within each category based on mrp.
SELECT category, name, mrp,
       RANK() OVER (PARTITION BY category ORDER BY mrp DESC) AS mrp_rank
FROM zepto;

#37. Second highest MRP product in each category
SELECT *
FROM (
    SELECT category, name, mrp,
           DENSE_RANK() OVER (PARTITION BY category ORDER BY mrp DESC) AS rnk
    FROM zepto
) t
WHERE rnk = 2;

#38Display Cumulative sum of availableQuantity category-wise
SELECT category, name, availableQuantity,
       SUM(availableQuantity) OVER (
           PARTITION BY category
           ORDER BY name
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS cumulative_quantity
FROM zepto;

#39. Find products whose mrp is higher than the average mrp of their category. 
SELECT *
FROM zepto z
WHERE mrp > (
    SELECT AVG(mrp)
    FROM zepto
    WHERE category = z.category
);

#40. Products where discount % is above category average discount %
SELECT *
FROM zepto z
WHERE ((mrp - discountedSellingPrice)/mrp)*100 > (
    SELECT AVG((mrp - discountedSellingPrice)/mrp)*100
    FROM zepto
    WHERE category = z.category
);

#41. Create a view showing only in-stock products with discount greater than 20%
CREATE VIEW in_stock_high_discount AS
SELECT
    name AS product,
    category,
    mrp,
    discountedSellingPrice,
    discountPercent,
    availableQuantity
FROM zepto
WHERE outOfStock = 'FALSE'
  AND discountPercent > 20;
  
  SELECT * FROM in_stock_high_discount;
  
#42.write a query to Update outOfStock = TRUE where availableQuantity = 0
UPDATE zepto
SET outOfStock = 'TRUE'
WHERE availableQuantity = 0;

#43. Create a stored procedure to fetch products by category name. 
DELIMITER $$

CREATE PROCEDURE GetProducts_ByCategory(IN cat_name VARCHAR(255))
BEGIN
    SELECT *
    FROM zepto
    WHERE category = cat_name;
END $$

DELIMITER ;

CALL GetProducts_ByCategory('Fruits & Vegetables');

#44. Create a function to calculate discount amount (mrp - discountedSellingPrice). 
DELIMITER $$

CREATE FUNCTION GetDiscountAmount(mrp DECIMAL(10,2),
                                   discountedSellingPrice DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN mrp - discountedSellingPrice;
END $$
DELIMITER ;

SELECT name, GetDiscountAmount(mrp, discountedSellingPrice) AS discount_amount
FROM zepto;

#45. Find duplicate product names
SELECT name, COUNT(*) AS cnt
FROM zepto
GROUP BY name
HAVING COUNT(*) > 1;

#46. Top 3 cheapest products in each category
SELECT *
FROM (
    SELECT category, name, mrp,
           DENSE_RANK() OVER (PARTITION BY category ORDER BY mrp ASC) AS price_rank
    FROM zepto
) t
WHERE price_rank <= 3;

#47.Find Categories where total stock value > 1,00,000
SELECT category,
       SUM(discountedSellingPrice * availableQuantity) AS total_stock_value
FROM zepto
GROUP BY category
HAVING total_stock_value > 100000;

#48. Trigger: set outOfStock = TRUE when availableQuantity becomes 0
DELIMITER $$

CREATE TRIGGER trg_set_outofstock
BEFORE UPDATE ON zepto
FOR EACH ROW
BEGIN
    IF NEW.availableQuantity = 0 THEN
        SET NEW.OutOfStock = TRUE;
    END IF;
END $$

DELIMITER ;

#49. Management Report

#(Category, Total Products, Avg MRP, Avg Discount)

SELECT category,
       COUNT(*) AS total_products,
       AVG(mrp) AS avg_mrp,
       AVG(mrp - discountedSellingPrice) AS avg_discount
FROM zepto
GROUP BY category;

#50. Products with MRP greater than overall average MRP (Subquery)
SELECT *
FROM zepto
WHERE mrp > (SELECT AVG(mrp) FROM zepto);





















