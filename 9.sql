CREATE OR REPLACE FUNCTION move_to_orders_history()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO library.orders_history (order_id, employee_id, reader_id, taken_at, returned_at)
    VALUES (OLD.order_id, OLD.employee_id, OLD.reader_id, OLD.taken_at, NOW());
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_order_delete
BEFORE DELETE ON library.orders
FOR EACH ROW EXECUTE FUNCTION move_to_orders_history();


CREATE OR REPLACE FUNCTION move_to_orders_copies_history()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO library.orders_copies_history (order_id, copy_id)
    VALUES (OLD.order_id, OLD.copy_id);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_orders_copies_delete
BEFORE DELETE ON library.orders_copies
FOR EACH ROW EXECUTE FUNCTION move_to_orders_copies_history();