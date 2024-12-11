-- Запрос 1
-- Описание: Получить список жанров книг, которые имеют более 10 книг, и вывести количество книг для каждого жанра.
SELECT g.genre_name, COUNT(b.book_id) AS number_of_books
FROM library.books b
INNER JOIN library.genres g ON b.genre_id = g.genre_id
GROUP BY g.genre_name
HAVING COUNT(b.book_id) > 10;
-- Ожидания: 
-- В результате выполнения запроса будут получены названия жанров, в которых число книг превышает 10, 
-- вместе с количеством таких книг.

-- Запрос 2
-- Описание: Получить список книг, изданных после 2000 года. Книги должны быть отсортированы по году издания 
-- (по возрастанию), а затем по длине названия (по убыванию). Для каждой книги определить её положение по длине 
-- названия среди книг, изданных в том же году.
SELECT b.title, b.published_year, LENGTH(b.title) AS title_length,
       RANK() OVER (PARTITION BY b.published_year ORDER BY LENGTH(b.title) DESC) AS year_rank
FROM library.books b
WHERE b.published_year > 2000
ORDER BY b.published_year, title_length DESC;
-- Ожидания: 
-- В результате выполнения запроса будет получен список книг, выпущенных после 2000 года, отсортированный 
-- сначала по возрастанию года издания, а затем по убыванию длины названия книги. Рядом с каждой книгой будет 
-- указан её ранг в рамках года по длине названия.

-- Запрос 3
-- Описание: На основе истории заказов определить 5 самых активных читателей, которые взяли наибольшее количество 
-- книг, и вывести их имена, контактные данные и общее количество взятых книг.
SELECT r.name, r.contact, COUNT(o.order_id) AS total_books_borrowed
FROM library.readers r
INNER JOIN library.orders o ON r.reader_id = o.reader_id
GROUP BY r.name, r.contact
ORDER BY total_books_borrowed DESC
LIMIT 5;
-- Ожидания: 
-- Результат запроса покажет имена и контактные данные пяти читателей, которые взяли наибольшее количество книг, 
-- в порядке убывания общего количества взятых книг.

-- Запрос 4
-- Описание: Для каждой книги определить, сколько раз она была взята в каждом году, отсортировав результаты по 
-- количеству взятий в порядке убывания с использованием оконной функции.
SELECT b.title, YEAR(o.order_date) AS year, COUNT(o.order_id) AS times_borrowed,
       RANK() OVER (PARTITION BY YEAR(o.order_date) ORDER BY COUNT(o.order_id) DESC) AS rank
FROM library.books b
INNER JOIN library.orders o ON b.book_id = o.book_id
GROUP BY b.title, YEAR(o.order_date)
ORDER BY year, rank;
-- Ожидания: 
-- Для каждой книги будет показано, сколько раз она была взята в каждый год, с указанием ее ранга, сортированного 
-- по количеству взятий в порядке убывания в пределах каждого года.

-- Запрос 5
-- Описание: Узнать среднее количество книг, взятых каждым читателем, и вывести тех, кто взял книг больше среднего 
-- по библиотеке.
WITH average_books AS (
    SELECT AVG(book_count) AS avg_books
    FROM (
        SELECT COUNT(o.book_id) AS book_count
        FROM library.orders o
        GROUP BY o.reader_id
    ) reader_books
)
SELECT r.name, r.contact, COUNT(o.book_id) AS book_count
FROM library.readers r
INNER JOIN library.orders o ON r.reader_id = o.reader_id
GROUP BY r.reader_id, r.name, r.contact
HAVING COUNT(o.book_id) > (SELECT avg_books FROM average_books);
-- Ожидания: 
-- Запрос вернет имена и контактные данные читателей, которые брали книг больше среднего значения по всем читателям.
