CREATE SCHEMA views;

CREATE VIEW views.v_readers AS
SELECT
    name,
    CONCAT(SUBSTR(address, 1, 5), REPEAT('*', LENGTH(address) - 5)) as masked_address,
    CONCAT(SUBSTR(contact, 1, 5), REPEAT('*', LENGTH(contact) - 8), SUBSTR(contact, LENGTH(contact) - 3)) AS masked_contact,
    CONCAT(SUBSTR(passport, 1, 2), REPEAT('*', LENGTH(passport) - 4), SUBSTR(passport, LENGTH(passport) - 2)) AS masked_passport
FROM library.readers;

CREATE VIEW views.v_authors AS
SELECT
    name,
    biography
FROM library.authors;

CREATE VIEW views.v_employees AS
SELECT
    name,
    position,
    hire_date
FROM library.employees;

CREATE VIEW views.v_genres AS
SELECT
    genre_name,
    description
FROM library.genres;

CREATE VIEW views.v_publishers AS
SELECT
    name,
    CONCAT(SUBSTR(address, 1, 5), REPEAT('*', LENGTH(address) - 5)) as masked_address,
    CONCAT(SUBSTR(contact_info, 1, 5), REPEAT('*', LENGTH(contact_info) - 9), SUBSTR(contact_info, LENGTH(contact_info) - 3)) AS masked_contact_info
FROM library.publishers;

CREATE VIEW views.v_books AS
SELECT
    title,
    published_year,
    b.description,
    genre_name
FROM library.books b
INNER JOIN library.genres g ON b.genre_id = g.genre_id;

CREATE VIEW views.v_authors_books AS
SELECT
    a.name as author_name,
    b.title as book_title
FROM library.authors_books a_b
INNER JOIN library.authors a ON a_b.author_id = a.author_id
INNER JOIN library.books b ON a_b.book_id = b.book_id;

CREATE VIEW views.v_orders AS
SELECT
    e.name as employee_name,
    r.name as reader_name,
    taken_at
FROM library.orders o
INNER JOIN library.employees e ON e.employee_id = o.employee_id
INNER JOIN library.readers r ON r.reader_id = o.reader_id;

CREATE VIEW views.v_copies AS
SELECT
    p.name as publisher_name,
    b.title as book_title,
    is_stored
FROM library.copies c
INNER JOIN library.publishers p ON c.publisher_id = p.publisher_id
INNER JOIN library.books b ON b.book_id = c.book_id;

CREATE VIEW views.v_orders_history AS
SELECT
    e.name as employee_name,
    r.name as reader_name,
    taken_at,
    returned_at
FROM library.orders_history oh
INNER JOIN library.employees e ON e.employee_id = oh.employee_id
INNER JOIN library.readers r ON r.reader_id = oh.reader_id;

CREATE VIEW views.v_orders_copies AS
SELECT
    order_id,
    copy_id
FROM library.orders_copies;

CREATE VIEW views.v_orders_copies_history AS
SELECT
    order_id,
    copy_id
FROM library.orders_copies_history;
