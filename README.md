# test2018_DB9413AA4FC1F30AB9F1BB66CA379244

###Пример базы данных - Библиотека

Схему можно посмотреть онлайн тут: http://sqlfiddle.com/#!15/9cf41/2/0

Локально (в своей базе): можно выполнить последовательно запросы из файлов:
- 00_create_tables.sql - создаст необходимые таблицы
- 01_categories.sql - добавление данных по Категориям
- 02_publisher.sql - добавление данных по Издательствам
- 03_authors.sql - добавление данных по Авторам
- 04_books.sql - добавление данных по Книгам
- 05_books_authors.sql - добавление данных по связке MANY-TO-MANY для Книг и Авторов




###Написать SQL который вернет список книг, написанный 3-мя соавторами. Результат: книга - количество соавторов.


```sql
EXPLAIN ANALYSE
SELECT
	b.*
FROM books AS b
INNER JOIN (
	SELECT
		ba.book_id,
		COUNT (ba.author_id)
	FROM books_authors AS ba
	GROUP BY ba.book_id
	HAVING COUNT (ba.author_id) >= 3
) AS bt ON bt.book_id = b. ID

Hash Join  (cost=48.47..53.73 rows=1 width=632) (actual time=0.069..0.071 rows=1 loops=1)
  Hash Cond: (ba.book_id = b.id)
  ->  HashAggregate  (cost=47.45..49.95 rows=200 width=8) (actual time=0.023..0.024 rows=1 loops=1)
        Filter: (count(ba.author_id) >= 3)
        Rows Removed by Filter: 1
        ->  Seq Scan on books_authors ba  (cost=0.00..31.40 rows=2140 width=8) (actual time=0.004..0.004 rows=4 loops=1)
  ->  Hash  (cost=1.01..1.01 rows=1 width=632) (actual time=0.028..0.028 rows=3 loops=1)
        Buckets: 1024  Batches: 1  Memory Usage: 1kB
        ->  Seq Scan on books b  (cost=0.00..1.01 rows=1 width=632) (actual time=0.017..0.020 rows=3 loops=1)
Total runtime: 0.170 ms




EXPLAIN ANALYSE
SELECT
	b.*
FROM
	books AS b
INNER JOIN (
	SELECT *
	FROM
		(
			SELECT
				ba.book_id,
				COUNT (ba.author_id) AS cnt
			FROM books_authors AS ba
			GROUP BY ba.book_id
		) AS t
	WHERE
		t.cnt >= 3
) AS bt ON bt.book_id = b. ID

Hash Join  (cost=48.47..53.73 rows=1 width=632) (actual time=0.069..0.070 rows=1 loops=1)
  Hash Cond: (ba.book_id = b.id)
  ->  HashAggregate  (cost=47.45..49.95 rows=200 width=8) (actual time=0.022..0.023 rows=1 loops=1)
        Filter: (count(ba.author_id) >= 3)
        Rows Removed by Filter: 1
        ->  Seq Scan on books_authors ba  (cost=0.00..31.40 rows=2140 width=8) (actual time=0.004..0.005 rows=4 loops=1)
  ->  Hash  (cost=1.01..1.01 rows=1 width=632) (actual time=0.029..0.029 rows=3 loops=1)
        Buckets: 1024  Batches: 1  Memory Usage: 1kB
        ->  Seq Scan on books b  (cost=0.00..1.01 rows=1 width=632) (actual time=0.017..0.019 rows=3 loops=1)
Total runtime: 0.170 ms

```