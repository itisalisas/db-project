-- 1. Статистика выданных книг по жанрам
-- Это представление получает информацию о количестве выданных книг каждого жанра. 
-- Оно связывает таблицы orders, orders_copies, copies, books, и genres. 

CREATE VIEW views.genre_issue_statistics AS
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
    genres.genre_name
ORDER BY total_issues;

-- 2. Среднее время возврата книг
-- Это представление вычисляет среднее время возврата книг. 
-- Оно связывает таблицы orders, orders_history, и orders_copies_history.

CREATE VIEW views.average_return_time AS
SELECT books.title, 
       AVG(EXTRACT(EPOCH FROM (orders_history.returned_at - orders_history.taken_at))) / 86400 AS average_return_days
FROM 
    library.books
INNER JOIN 
    library.copies ON books.book_id = copies.book_id
INNER JOIN 
    library.orders_copies_history ON copies.copy_id = orders_copies_history.copy_id
INNER JOIN 
    library.orders_history ON orders_copies_history.order_id = orders_history.order_id
WHERE 
    orders_history.returned_at IS NOT NULL
GROUP BY 
    books.title
ORDER BY 
    books.title;

-- 3. Количество книг в библиотеке по издательствам
-- Представление дает информацию о количестве книг от каждого издательства, находящихся в библиотеке.

CREATE VIEW views.publisher_book_count AS
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
    publishers.name
ORDER BY 
    COUNT(copies.copy_id);
