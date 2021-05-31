--docker exec -it 3d8 psql -U postgres stripe-example



-- Exercise Instructions

-- In this exercise, you'll get to review many of the new skills you've developed with relational databases! You're being tasked with creating a database of movies with the following specification:

--     A movie has a title and a description, and zero or more categories associated to it.
--     A category is just a name, but that name has to be unique
--     Users can register to the system to rate movies:
--         A user's username has to be unique in a case-insensitive way. For instance, if a user registers with the username "Bob", then nobody can register with "bob" nor "BOB"
--         A user can only rate a movie once, and the rating is an integer between 0 and 100, inclusive
--         In addition to rating movies, users can also "like" categories.
--     The following queries need to execute quickly and efficiently. The database will contain ~6 million movies:
--         Finding a movie by partially searching its name
--         Finding a user by their username
--         For a given user, find all the categories they like and movies they rated
--         For a given movie, find all the users who rated it
--         For a given category, find all the users who like it


CREATE TABLE "movies" (
    "id" SERIAL PRIMARY KEY,
    "title" VARCHAR,
    "description" TEXT
);

CREATE TABLE "categories"(
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR UNIQUE
);

CREATE TABLE "movies_categories" (
    "movie_id" INTEGER REFERENCES "movies" ("id"),
    "category_id" INTEGER REFERENCES "categories"("id"),
    PRIMARY KEY ("movie_id","category_id")
);

CREATE TABLE "users" (
    "id" SERIAL PRIMARY KEY,
    "username" VARCHAR
);
CREATE UNIQUE INDEX ON "users" (LOWER("username"));

CREATE TABLE "user_ratings" (
    "user_id" INTEGER REFERENCES "users" ("id"),
    "movie_id" INTEGER REFERENCES "movies" ("id"),
    "rating" INTEGER CHECK ( "rating">= 0 AND "rating"<= 100),
    PRIMARY KEY("user_id","movie_id")
);

CREATE TABLE "user_categories" (
    "user_id" INTEGER REFERENCES "users" ("id"),
    "cat_id" INTEGER REFERENCES "categories" ("id"),
    PRIMARY KEY("user_id","cat_id")
);

CREATE INDEX ON "user_ratings" ("movie_id");

CREATE INDEX ON "user_categories" ("cat_id");


-- things to improve:
-- limit varchar size
-- adding index for movie_id and cat_id alone so fast queries can be done both ways
