
-- 1. Статистика выданных книг по жанрам
-- Это представление получает информацию о количестве выданных книг каждого жанра. 
-- Оно связывает таблицы orders, orders_copies, copies, books, и genres. 

CREATE VIEW library.genre_issue_statistics AS
SELECT 
    genres.genre_name AS genre_name,
    COUNT(orders.order_id) AS total_issues
FROM 
    library.orders AS orders
INNER JOIN 
    library.orders_copies AS orders_copies ON orders.order_id = orders_copies.order_id
INNER JOIN 
    library.copies AS copies ON orders_copies.copy_id = copies.copy_id
INNER JOIN 
    library.books AS books ON copies.book_id = books.book_id
INNER JOIN 
    library.genres AS genres ON books.genre_id = genres.genre_id
GROUP BY 
    genres.genre_name;

-- 2. Среднее время возврата книг
-- Это представление вычисляет среднее время возврата книг. 
-- Оно связывает таблицы orders, orders_history, и orders_copies_history.

CREATE VIEW library.average_return_time AS
SELECT 
    orders.order_id AS order_id,
    AVG(DATE_PART('day', orders_copies_history.returned_at - orders_history.taken_at)) AS avg_return_time_days
FROM 
    library.orders AS orders
INNER JOIN 
    library.orders_history AS orders_history ON orders.order_id = orders_history.order_id
INNER JOIN 
    library.orders_copies_history AS orders_copies_history ON orders.order_id = orders_copies_history.order_id
WHERE 
    orders_copies_history.returned_at IS NOT NULL
GROUP BY 
    orders.order_id;

-- 3. Количество книг в библиотеке по издательствам
-- Представление дает информацию о количестве книг от каждого издательства, находящихся в библиотеке.

CREATE VIEW library.publisher_book_count AS
SELECT 
    publishers.name AS publisher_name,
    COUNT(copies.copy_id) AS total_stored_books
FROM 
    library.copies AS copies
INNER JOIN 
    library.books AS books ON copies.book_id = books.book_id
INNER JOIN 
    library.publishers AS publishers ON copies.publisher_id = publishers.publisher_id
WHERE 
    copies.is_stored = TRUE
GROUP BY 
    publishers.name;
