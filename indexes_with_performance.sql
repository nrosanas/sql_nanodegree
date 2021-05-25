---Exercise Instructions

---For this exercise, you're being asked to modify the table structure provided in order to answer some business requirements. The tables books, authors, and book_authors have had their columns setup, but no constraints nor indexes have been added.

---Given the business requirements below, add the necessary constraints and indexes to support each use-case:

   --- We need to be able to quickly find books and authors by their IDs.
ALTER TABLE authors ADD UNIQUE (id);

--- We need to be able to quickly tell which books an author has written.

CREATE INDEX  on "books" ("author_id");
--- We need to be able to quickly find a book by its ISBN #.

CREATE INDEX ON "books"(REGEXP_REPLACE("isbn",'[^0-9]+','', 'g'));
--- We need to be able to quickly search for books by their titles in a case-insensitive way, even if the title is partial. For example, searching for "the" should return "The Lord of the Rings".
CREATE INDEX ON books (title VARCHAR_PATTERN_OPS);
--- For a given book, we need to be able to quickly find all the topics associated to it.
CREATE INDEX ON book_topics (book_id, topic_id);
--For a given topic, we need to be able to quickly find all the books tagged with it.
CREATE INDEX ON book_topics ( topic_id, book_id);

-- Constraints
ALTER TABLE "authors"
  ADD PRIMARY KEY ("id");

ALTER TABLE "topics"
  ADD PRIMARY KEY("id"),
  ADD UNIQUE ("name"),
  ALTER COLUMN "name" SET NOT NULL;

ALTER TABLE "books"
  ADD PRIMARY KEY ("id"),
  ADD UNIQUE ("isbn"),
  ADD FOREIGN KEY ("author_id") REFERENCES "authors" ("id");

ALTER TABLE "book_topics"
  ADD PRIMARY KEY ("book_id", "topic_id");
-- or ("topic_id", "book_id") instead...?

-- We need to be able to quickly find books and authors by their IDs.
-- Already taken care of by primary keys

-- We need to be able to quickly tell which books an author has written.
CREATE INDEX "find_books_by_author" ON "books" ("author_id");

-- We need to be able to quickly find a book by its ISBN #.
-- The unique constraint on ISBN already takes care of that 
--   by adding a unique index

-- We need to be able to quickly search for books by their titles
--   in a case-insensitive way, even if the title is partial. For example, 
--   searching for "the" should return "The Lord of the rings".
CREATE INDEX "find_books_by_partial_title" ON "books" (
  LOWER("title") VARCHAR_PATTERN_OPS
);

-- For a given book, we need to be able to quickly find all the topics 
--   associated with it.
-- The primary key on the book_topics table already takes care of that 
--   since there's an underlying unique index

-- For a given topic, we need to be able to quickly find all the books 
--   tagged with it.