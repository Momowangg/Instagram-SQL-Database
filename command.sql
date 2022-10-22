# finding 5 oldest users
SELECT *
FROM users
ORDER BY created_at 
LIMIT 5;

# find hottest days  
SELECT DAYNAME(created_at) AS weekday, count(*) AS total
FROM users
GROUP BY DAYNAME(created_at)
ORDER BY count(weekday) DESC; 

# FInd inactive users 
SELECT username
FROM users
WHERE username NOT IN
(SELECT username 
 FROM users, photos
WHERE users.id = photos.user_id);

# find most liked photos
SELECT username, photo_id, image_url
FROM users, likes, photos
WHERE photos.id = likes.photo_id
AND users.id = photos.user_id
GROUP BY photo_id
ORDER BY count(*) DESC
LIMIT 10;

# Find average user posts 
SELECT AVG(a.posts) AS average
FROM
    (SELECT username, count(image_url) as posts
    FROM users LEFT JOIN photos
    ON users.id = photos.user_id
    GROUP BY users.id) a;

# FIND most popular tags
SELECT tag_name, COUNT(*) as total
FROM photo_tags, tags
WHERE photo_tags.tag_id = tags.id
GROUP BY tag_id
ORDER BY total DESC, tag_name
LIMIT 5;

# Find potential bots (users liked every single post)
SELECT users.id
FROM users INNER JOIN likes
ON users.id = likes.user_id
GROUP BY users.id
HAVING count(photo_id) = 
  (SELECT COUNT(DISTINCT photo_id)
  FROM likes)
;


# Possible Function Solution
# CREATE FUNCTION find
# (
#     declare @i INT = 0, @p INT = 0;
#     WHILE @i <= count(user_id)
#     	BEGIN 
#     		WHILE @p <= count(photo_id)
#     			BEGIN
#     				SET @p = @p + 1;
#     				IF @i NOT IN
#                         (SELECT user_id
#                         FROM likes 
#                         left JOIN users
#                         ON users.id = likes.user_id
#                         WHERE photo_id = @p) BREAK;
#     		END;
#     SET @i = @i + 1;
#     END;  		
# );
