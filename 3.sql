CREATE SCHEMA library;

CREATE TABLE library.readers (
    reader_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    contact VARCHAR(255) NOT NULL,
    passport VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE library.authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    biography TEXT
);

CREATE TABLE library.employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    position VARCHAR(255),
    hire_date DATE NOT NULL CHECK (hire_date <= CURRENT_DATE)
);

CREATE TABLE library.genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE library.publishers (
    publisher_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    contact_info VARCHAR(255)
);

CREATE TABLE library.books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL UNIQUE,
    published_year INT CHECK (published_year > 0),
    description TEXT CHECK (length(description) > 0),
    genre_id INT NOT NULL,
    CONSTRAINT fk_books_genre FOREIGN KEY (genre_id) REFERENCES library.genres (genre_id)
);

CREATE TABLE library.authors_books (
    author_id INT NOT NULL,
    book_id INT NOT NULL,
    PRIMARY KEY (author_id, book_id),
    CONSTRAINT fk_authors_books_author FOREIGN KEY (author_id) REFERENCES library.authors (author_id) ON DELETE CASCADE,
    CONSTRAINT fk_authors_books_book FOREIGN KEY (book_id) REFERENCES library.books (book_id) ON DELETE CASCADE
);

CREATE TABLE library.orders (
    order_id SERIAL PRIMARY KEY,
    employee_id INT,
    reader_id INT,
    taken_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_employee FOREIGN KEY (employee_id) REFERENCES library.employees (employee_id),
    CONSTRAINT fk_orders_reader FOREIGN KEY (reader_id) REFERENCES library.readers (reader_id)
);

CREATE TABLE library.copies (
    copy_id SERIAL PRIMARY KEY,
    publisher_id INT,
    book_id INT,
    is_stored BOOLEAN NOT NULL,
    CONSTRAINT fk_copies_publisher FOREIGN KEY (publisher_id) REFERENCES library.publishers (publisher_id),
    CONSTRAINT fk_copies_book FOREIGN KEY (book_id) REFERENCES library.books (book_id)
);

CREATE TABLE library.orders_history (
    order_id SERIAL PRIMARY KEY,
    employee_id INT,
    reader_id INT,
    taken_at TIMESTAMP NOT NULL,
    returned_at TIMESTAMP,
    CONSTRAINT check_returned_at CHECK (returned_at IS NULL OR returned_at > taken_at),
    CONSTRAINT fk_orders_history_employee FOREIGN KEY (employee_id) REFERENCES library.employees (employee_id),
    CONSTRAINT fk_orders_history_reader FOREIGN KEY (reader_id) REFERENCES library.readers (reader_id)
);

CREATE TABLE library.orders_copies (
    order_id INT NOT NULL,
    copy_id INT NOT NULL,
    PRIMARY KEY (order_id, copy_id),
    CONSTRAINT fk_orders_copies_order FOREIGN KEY (order_id) REFERENCES library.orders (order_id),
    CONSTRAINT fk_orders_copies_copy FOREIGN KEY (copy_id) REFERENCES library.copies (copy_id)
);

CREATE TABLE library.orders_copies_history (
    order_id INT NOT NULL,
    copy_id INT NOT NULL,
    PRIMARY KEY (order_id, copy_id),
    CONSTRAINT fk_orders_copies_history_order FOREIGN KEY (order_id) REFERENCES library.orders_history (order_id),
    CONSTRAINT fk_orders_copies_history_copy FOREIGN KEY (copy_id) REFERENCES library.copies (copy_id)
);

