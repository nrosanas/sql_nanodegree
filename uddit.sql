CREATE TABLE "users" (
    "id" SERIAL PRIMARY KEY,
    "username" VARCHAR(25) UNIQUE NOT NULL,
    "last_login" TIMESTAMP
);

CREATE TABLE "topics" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(30) UNIQUE NOT NULL,
    "description" VARCHAR(500)
);

CREATE TABLE "posts" (
   "id" SERIAL PRIMARY KEY,  
   "title" VARCHAR(100) NOT NULL,
   "user_id" INTEGER REFERENCES "users" ("id") ON DELETE SET NULL,
   "URL" VARCHAR(250),
   "text" TEXT,
   "topic_id" INTEGER REFERENCES "topics" ("id") ON DELETE CASCADE,
   "date_time" TIMESTAMP NOT NULL,
   CONSTRAINT "text_or_url" CHECK (("URL" IS NULL) OR ("text" IS NULL))
);


CREATE TABLE "comments"(
   "id" SERIAL PRIMARY KEY,
   "user_id" INTEGER REFERENCES "users" ("id") ON DELETE SET NULL,
   "post_id" INTEGER REFERENCES "posts" ("id") ON DELETE CASCADE,
   "text" TEXT NOT NULL,
   "comment_id" INTEGER REFERENCES "comments" ("id") ON DELETE SET NULL,
   "date_time" TIMESTAMP NOT NULL
);


CREATE TABLE "votes"(
   "post_id" INTEGER REFERENCES "posts" ("id") ON DELETE CASCADE,
   "user_id" INTEGER REFERENCES "users" ("id") ON DELETE SET NULL,
   "value" SMALLINT,
   PRIMARY KEY ("post_id", "user_id")
);

