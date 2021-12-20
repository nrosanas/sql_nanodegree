INSERT INTO topics(name) SELECT DISTINCT topic FROM bad_posts;

INSERT INTO users(username) 
    SELECT DISTINCT username FROM (
        SELECT username FROM bad_posts 
        UNION SELECT REGEXP_SPLIT_TO_TABLE(upvotes, ',') FROM bad_posts 
        UNION SELECT REGEXP_SPLIT_TO_TABLE(downvotes, ',') FROM bad_posts
        UNION SELECT username FROM bad_comments
    ) T;

INSERT INTO posts(id, title, user_id, URL, text, topic_id)
    SELECT b.id, LEFT(b.title,100) , u.id, b.URL, b.TEXT_content, t.id 
    FROM users u
    JOIN bad_posts b
    ON u.username = b.username 
    JOIN topics t 
    ON t.name = b.topic; 

INSERT INTO comments(user_id, post_id, text)
    SELECT u.id, p.id, c.TEXT_content
    FROM users u
    JOIN bad_comments c
    ON u.username = c.username 
    JOIN posts p 
    ON p.id = c.post_id; 

INSERT INTO votes (user_id, post_id, value)
    SELECT u.id,p.id , 1 
    FROM(
        SELECT id, REGEXP_SPLIT_TO_TABLE(upvotes, ',') username
        FROM bad_posts
    ) AS p
    JOIN users u 
    ON p.username = u.username;


INSERT INTO votes (user_id, post_id, value)
    SELECT u.id,p.id , -1 
    FROM(
        SELECT id, REGEXP_SPLIT_TO_TABLE(downvotes, ',') username
        FROM bad_posts
    ) AS p
    JOIN users u 
    ON p.username = u.username;
    
DROP TABLE bad_comments;
DROP TABLE bad_posts;