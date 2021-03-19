CREATE TABLE "clients" (
    "id" SERIAL,
    "name" VARCHAR,
    "last_name" VARCHAR,
    "phone" INTEGER
);

CREATE TABLE "emails" (
    "email" VARCHAR,
    "client_id" INTEGER
);

CREATE TABLE "rooms" (
    "id" SERIAL,
    "floor" SMALLINT,
    "room_number" SMALLINT,
    "sq_ft" SMALLINT
);

CREATE TABLE "reservations" (
    "id" SERIAL,
    "client_id" SERIAL,
    "entry" TIMESTAMP,
    "exit" TIMESTAMP
);


ALTER TABLE "students" ALTER COLUMN "email_adress" SET DATA TYPE VARCHAR;
ALTER TABLE "courses" ALTER COLUMN "rating" SET DATA TYPE REAL;
ALTER TABLE "registrations" ALTER COLUMN "student_id" SET DATA TYPE INTEGER;
ALTER TABLE "students" ALTER COLUMN "id" SET DATA TYPE INTEGER;