INSERT INTO library.readers (name, address, contact, passport) VALUES
('Алексей Ковалёв', 'ул. Новая, 10', '+79991234567', '3456789012');

SELECT name, contact FROM library.readers WHERE passport = '1234567890';

UPDATE library.readers
SET contact = '+79990001122'
WHERE passport = '3456789012';

DELETE FROM library.readers WHERE passport = '3456789012';

INSERT INTO library.books (title, published_year, description, genre_id) VALUES
('Новая книга', 2023, 'Описание новой книги', 1);

SELECT COUNT(*) FROM library.books WHERE genre_id = 2;

UPDATE library.books
SET description = 'Обновлённое описание книги', published_year = 2024
WHERE title = 'Новая книга';

DELETE FROM library.books WHERE title = 'Новая книга';
