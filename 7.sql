CREATE VIEW views.v_readers AS
SELECT
    name,
    address,
    CONCAT(SUBSTR(contact, 1, 5), REPEAT('*', LENGTH(contact) - 8), SUBSTR(contact, LENGTH(contact) - 3)) AS masked_contact,
    CONCAT(SUBSTR(passport, 1, 2), REPEAT('*', LENGTH(passport) - 4), SUBSTR(passport, LENGTH(passport) - 2)) AS masked_passport
FROM library.readers;

CREATE VIEW views.v_authors AS
SELECT
    author_id,
    name,
    biography
FROM library.authors;

CREATE VIEW views.v_employees AS
SELECT
    employee_id,
    name,
    position,
    hire_date
FROM library.employees;

CREATE VIEW views.v_genres AS
SELECT
    genre_id,
    genre_name,
    description
FROM library.genres;

CREATE VIEW views.v_publishers AS
SELECT
    publisher_id,
    name,
    address,
    CONCAT(SUBSTR(contact_info, 1, 5), REPEAT('*', LENGTH(contact_info) - 9), SUBSTR(contact_info, LENGTH(contact_info) - 3)) AS masked_contact_info
FROM library.publishers;

CREATE VIEW views.v_books AS
SELECT
    book_id,
    title,
    published_year,
    description,
    genre_id
FROM library.books;

CREATE VIEW views.v_authors_books AS
SELECT
    author_id,
    book_id
FROM library.authors_books;

CREATE VIEW views.v_orders AS
SELECT
    order_id,
    employee_id,
    reader_id,
    taken_at
FROM library.orders;

CREATE VIEW views.v_copies AS
SELECT
    copy_id,
    publisher_id,
    book_id,
    is_stored
FROM library.copies;

CREATE VIEW views.v_orders_history AS
SELECT
    order_id,
    employee_id,
    reader_id,
    taken_at,
    returned_at
FROM library.orders_history;

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
