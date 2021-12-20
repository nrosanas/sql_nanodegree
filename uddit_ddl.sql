CREATE TABLE "users" (
    "id" BIGSERIAL PRIMARY KEY,
    "username" VARCHAR(25) UNIQUE NOT NULL,
    "last_login" TIMESTAMP
);

CREATE TABLE "topics" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(30) UNIQUE NOT NULL,
    "description" VARCHAR(500)
);

CREATE TABLE "posts" (
   "id" BIGSERIAL PRIMARY KEY,  
   "title" VARCHAR(100) NOT NULL,
   "user_id" INTEGER REFERENCES "users" ("id") ON DELETE SET NULL,
   "url" VARCHAR(250),
   "text" TEXT,
   "topic_id" INTEGER REFERENCES "topics" ("id") ON DELETE CASCADE NOT NULL,
   "date_time" TIMESTAMP,
   CONSTRAINT "text_or_url" CHECK ((("url" IS NULL) AND ("text" IS NOT NULL AND "text" <> '')) OR (("url" IS NOT NULL) AND ("text" IS NULL)))
);


CREATE TABLE "comments"(
   "id" BIGSERIAL PRIMARY KEY,
   "user_id" INTEGER REFERENCES "users" ("id") ON DELETE SET NULL,
   "post_id" INTEGER REFERENCES "posts" ("id") ON DELETE CASCADE NOT NULL ,
   "text" TEXT NOT NULL,
   "comment_id" INTEGER REFERENCES "comments" ("id") ON DELETE CASCADE,
   "date_time" TIMESTAMP 
);


CREATE TABLE "votes"(
   "vote_id" BIGSERIAL PRIMARY KEY,
   "post_id" INTEGER REFERENCES "posts" ("id") ON DELETE CASCADE,
   "user_id" INTEGER REFERENCES "users" ("id") ON DELETE SET NULL,
   "value" SMALLINT,
   CONSTRAINT "one_vote_per_post" UNIQUE ("post_id", "user_id")
);

CREATE INDEX "search_url" ON "posts"("url");
CREATE INDEX "post_score" ON "votes"("post_id", "value");
CREATE INDEX "top_comment" ON "comments"("comment_id");


