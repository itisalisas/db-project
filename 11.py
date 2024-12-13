from peewee import *
import datetime

database = PostgresqlDatabase('postgres', user='postgres', password='postgres', host='localhost', port=5432)


class BaseModel(Model):
    class Meta:
        database = database


class Readers(BaseModel):
    reader_id = AutoField(primary_key=True, column_name='reader_id')
    name = CharField()
    address = CharField(null=True)
    contact = CharField()
    passport = CharField(unique=True)

    class Meta:
        table_name = 'readers'
        schema = 'library'


class Authors(BaseModel):
    author_id = AutoField(primary_key=True, column_name='author_id')
    name = CharField()
    biography = TextField(null=True)

    class Meta:
        table_name = 'authors'
        schema = 'library'


class Employees(BaseModel):
    employee_id = AutoField(primary_key=True, column_name='employee_id')
    name = CharField()
    position = CharField(null=True)
    hire_date = DateField()

    class Meta:
        table_name = 'employees'
        schema = 'library'


class Genres(BaseModel):
    genre_id = AutoField(primary_key=True, column_name='genre_id')
    genre_name = CharField(unique=True)
    description = TextField(null=True)

    class Meta:
        table_name = 'genres'
        schema = 'library'


class Publishers(BaseModel):
    publisher_id = AutoField(primary_key=True, column_name='publisher_id')
    name = CharField()
    address = CharField(null=True)
    contact_info = CharField(null=True)

    class Meta:
        table_name = 'publishers'
        schema = 'library'


class Books(BaseModel):
    book_id = AutoField(primary_key=True, column_name='book_id')
    title = CharField(unique=True)
    published_year = IntegerField()
    description = TextField()
    genre_id = ForeignKeyField(column_name='genre_id', field='genre_id', model=Genres)

    class Meta:
        table_name = 'books'
        schema = 'library'


class AuthorsBooks(BaseModel):
    author_id = ForeignKeyField(column_name='author_id', field='author_id', model=Authors)
    book_id = ForeignKeyField(column_name='book_id', field='book_id', model=Books)

    class Meta:
        table_name = 'authors_books'
        schema = 'library'
        primary_key = CompositeKey('author_id', 'book_id')


class Orders(BaseModel):
    order_id = AutoField(primary_key=True, column_name='order_id')
    employee_id = ForeignKeyField(column_name='employee_id', field='employee_id', model=Employees)
    reader_id = ForeignKeyField(column_name='reader_id', field='reader_id', model=Readers)
    taken_at = DateTimeField(default=datetime.datetime.now)

    class Meta:
        table_name = 'orders'
        schema = 'library'


class Copies(BaseModel):
    copy_id = AutoField(primary_key=True, column_name='copy_id')
    publisher_id = ForeignKeyField(column_name='publisher_id', field='publisher_id', model=Publishers)
    book_id = ForeignKeyField(column_name='book_id', field='book_id', model=Books)
    is_stored = BooleanField()

    class Meta:
        table_name = 'copies'
        schema = 'library'


class OrdersHistory(BaseModel):
    order_id = AutoField(primary_key=True, column_name='order_id')
    employee_id = ForeignKeyField(column_name='employee_id', field='employee_id', model=Employees)
    reader_id = ForeignKeyField(column_name='reader_id', field='reader_id', model=Readers)
    taken_at = DateTimeField()
    returned_at = DateTimeField()

    class Meta:
        table_name = 'orders_history'
        schema = 'library'    


class OrdersCopies(BaseModel):
    order_id = ForeignKeyField(column_name='order_id', field='order_id', model=Orders)
    copy_id = ForeignKeyField(column_name='copy_id', field='copy_id', model=Copies)

    class Meta:
        table_name = 'orders_copies'
        schema = 'library' 
        primary_key = CompositeKey('order_id', 'copy_id')


class OrdersCopiesHistory(BaseModel):
    order_id = ForeignKeyField(column_name='order_id', field='order_id', model=OrdersHistory)
    copy_id = ForeignKeyField(column_name='copy_id', field='copy_id', model=Copies)

    class Meta:
        table_name = 'orders_copies_history'
        schema = 'library' 
        primary_key = CompositeKey('order_id', 'copy_id')


Publishers.insert(name = 'Popcorn Books', address='ул. Молодёжная, 12').execute()

for publisher in Publishers.select():
    print(publisher.name, publisher.address, publisher.contact_info)

Publishers.update(address='ул. Молодёжная, 12a').where(Publishers.name=='Popcorn Books').execute()

Publishers.delete().where(Publishers.name=='Popcorn Books').execute()

# Список издательств, чьи книги брали в 2023 хотя бы 3 раза
publishers_with_popular_books = (
    Publishers
    .select(Publishers.name, fn.COUNT(OrdersCopiesHistory.order_id).alias('order_count'))
    .join(Copies)
    .join(OrdersCopiesHistory)
    .join(OrdersHistory)
    .where(OrdersHistory.taken_at.between(datetime.datetime(2023, 1, 1), datetime.datetime(2023, 12, 31)))
    .group_by(Publishers.name)
    .having(fn.COUNT(OrdersCopiesHistory.order_id) >= 3)
)

for publisher in publishers_with_popular_books:
    print(f"{publisher.name} — {publisher.order_count} книги")

# Список работников и числа завершенных ими заказов за 2023 год
employees_with_completed_orders = (
    Employees
    .select(Employees.name, fn.COUNT(OrdersHistory.order_id).alias('completed_orders'))
    .join(OrdersHistory)
    .where(OrdersHistory.returned_at.between(datetime.datetime(2023, 1, 1), datetime.datetime(2023, 12, 31)))
    .group_by(Employees.name)
    .order_by(fn.COUNT(OrdersHistory.order_id).desc())
)

for employee in employees_with_completed_orders:
    print(f"{employee.name} — {employee.completed_orders} завершенных заказа")

