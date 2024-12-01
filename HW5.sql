-- 1. Напишіть SQL запит, який буде відображати таблицю order_details та поле customer_id з таблиці orders 
-- відповідно для кожного поля запису з таблиці order_details.
-- Це має бути зроблено за допомогою вкладеного запиту в операторі SELECT.
USE mydb;
SELECT order_details.*,(SELECT customer_id FROM orders WHERE orders.id = order_details.order_id) AS customer_id
FROM order_details;
-- 2. Напишіть SQL запит, який буде відображати таблицю order_details. 
-- Відфільтруйте результати так, щоб відповідний запис із таблиці orders виконував умову shipper_id=3.
-- Це має бути зроблено за допомогою вкладеного запиту в операторі WHERE.
USE mydb;
SELECT order_details.*
FROM order_details
WHERE order_id IN (SELECT id FROM orders WHERE shipper_id=3);
-- 3. Напишіть SQL запит, вкладений в операторі FROM, який буде обирати рядки 
-- з умовою quantity>10 з таблиці order_details. 
-- Для отриманих даних знайдіть середнє значення поля quantity — групувати слід за order_id.
USE mydb;
SELECT
	order_id,
    AVG(quantity) AS avg_quantity
FROM
	(SELECT * FROM order_details WHERE quantity >10) AS filtered_details
GROUP BY
    order_id;
-- 4. Розв’яжіть завдання 3, використовуючи оператор WITH для створення тимчасової таблиці temp. 
-- Якщо ваша версія MySQL більш рання, ніж 8.0, створіть цей запит за аналогією до того, як це зроблено в конспекті.
USE mydb;
WITH temp AS (
    SELECT order_id, quantity
    FROM order_details
    WHERE quantity >10
)
SELECT order_id, AVG(quantity) AS avg_quantity
FROM temp
GROUP BY order_id;
-- 5. Створіть функцію з двома параметрами, яка буде ділити перший параметр на другий. 
-- Обидва параметри та значення, що повертається, повинні мати тип FLOAT.
DELIMITER //

CREATE FUNCTION CalculateDivision(
	first_number FLOAT,
    second_number FLOAT
)
RETURNS FLOAT
DETERMINISTIC 
NO SQL
BEGIN
    DECLARE result FLOAT;
    SET result = first_number / second_number;
    RETURN result;
END //

DELIMITER ;

SELECT CalculateDivision(12.34, 2) AS result;
-- Використайте конструкцію DROP FUNCTION IF EXISTS. 
-- Застосуйте функцію до атрибута quantity таблиці order_details . 
-- Другим параметром може бути довільне число на ваш розсуд.
DROP FUNCTION IF EXISTS CalculateDivision;
SELECT
    order_id,
    quantity,
    CalculateDivision(quantity, 2) AS divided_quantity
FROM
    order_details;

