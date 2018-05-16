-- Table: authors
-- DROP TABLE authors;
CREATE TABLE authors
(
  id bigserial NOT NULL,
  first_name character varying(50),
  last_name character varying(50),
  birthday timestamp without time zone,
  description text,
  CONSTRAINT authors_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

-- Index: authors_birthday_idx
-- DROP INDEX authors_birthday_idx;
CREATE INDEX authors_birthday_idx
  ON authors
  USING btree
  ((birthday::date));

-- Index: authors_last_name_idx
-- DROP INDEX authors_last_name_idx;
CREATE INDEX authors_last_name_idx
  ON authors
  USING btree
  (last_name COLLATE pg_catalog."default");


  
  
  
-- Table: categories
-- DROP TABLE categories;
CREATE TABLE categories
(
  id bigserial NOT NULL,
  parent_caterory_id integer,
  name character varying(255),
  description text,
  CONSTRAINT categories_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);

-- Index: categories_parent_idx

-- DROP INDEX categories_parent_idx;

CREATE INDEX categories_parent_idx
  ON categories
  USING btree
  (parent_caterory_id);


  
  
-- Table: publisher
-- DROP TABLE publisher;
CREATE TABLE publisher
(
  id bigserial NOT NULL,
  name character varying(255),
  description text,
  CONSTRAINT publisher_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
  
  
  
  
  
-- Table: books
-- DROP TABLE books;
CREATE TABLE books
(
  id bigserial NOT NULL,
  category_id integer, -- Категория
  name character varying(255), -- Название книги
  publisher_id integer, -- Издательство
  isbn character varying(17),
  description text, -- Короткое описание книги или демо-часть контента книги
  page_count integer, -- Количество страниц
  publication_date timestamp without time zone, -- Дата публикации книги
  price real, -- Цена
  CONSTRAINT books_pkey PRIMARY KEY (id),
  CONSTRAINT books_category_id_fkey FOREIGN KEY (category_id)
      REFERENCES categories (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT books_publisher_id_fkey FOREIGN KEY (publisher_id)
      REFERENCES publisher (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
COMMENT ON COLUMN books.category_id IS 'Категория';
COMMENT ON COLUMN books.name IS 'Название книги';
COMMENT ON COLUMN books.publisher_id IS 'Издательство';
COMMENT ON COLUMN books.description IS 'Короткое описание книги или демо-часть контента книги';
COMMENT ON COLUMN books.page_count IS 'Количество страниц';
COMMENT ON COLUMN books.publication_date IS 'Дата публикации книги';
COMMENT ON COLUMN books.price IS 'Цена';


-- Index: books_isbn_idx
-- DROP INDEX books_isbn_idx;
CREATE INDEX books_isbn_idx
  ON books
  USING btree
  (isbn COLLATE pg_catalog."default");


  
  
  
-- Table: books_authors
-- DROP TABLE books_authors;
CREATE TABLE books_authors
(
  book_id integer,
  author_id integer,
  CONSTRAINT books_authors_author_id_fkey FOREIGN KEY (author_id)
      REFERENCES authors (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT books_authors_book_id_fkey FOREIGN KEY (book_id)
      REFERENCES books (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT books_authors_book_id_author_id_key UNIQUE (book_id, author_id)
)
WITH (
  OIDS=FALSE
);