-- Вывод читателей, которые просрочили срок сдачи книг (14 дней)
CREATE OR REPLACE PROCEDURE library.find_overdue_orders()
AS $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        WITH overdue_orders AS (
            SELECT
                r.reader_id,
                r.name,
                o.order_id,
                o.taken_at,
                o.taken_at::DATE + INTERVAL '14 days' AS due_date
            FROM
                library.orders o
            INNER JOIN
                library.readers r ON o.reader_id = r.reader_id
            WHERE
                CURRENT_DATE > (o.taken_at::DATE + INTERVAL '14 days')
        )
        SELECT
            *
        FROM
            overdue_orders
        ORDER BY
            due_date
    LOOP
        RAISE NOTICE 'Reader ID: %, Name: %, Order ID: %, Taken At: %, Due Date: %',
            rec.reader_id, rec.name, rec.order_id, rec.taken_at, rec.due_date;
    END LOOP;
END $$
LANGUAGE plpgsql;

CALL library.find_overdue_orders();

-- Вывод книг, у которых сейчас нет копий, находящихся в библиотеке
CREATE OR REPLACE PROCEDURE library.find_books_with_no_available_copies()
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT b.book_id, b.title
        FROM library.books b
        LEFT JOIN (
            SELECT book_id, COUNT(copy_id) AS available_copies
            FROM library.copies
            WHERE is_stored = TRUE
            GROUP BY book_id
        ) c ON b.book_id = c.book_id
        WHERE COALESCE(c.available_copies, 0) = 0
    LOOP
        RAISE NOTICE 'Book ID: %, Title: % has no available copies.', rec.book_id, rec.title;
    END LOOP;
END $$;

CALL library.find_books_with_no_available_copies();