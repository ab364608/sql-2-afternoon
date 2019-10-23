-- JOINS

-- 1
SELECT * FROM invoice AS i
JOIN invoice_line AS il ON il.invoice_id = i.invoice_id
WHERE il.unit_price > .99;

-- 2
SELECT i.invoice_date, c.first_name, c.last_name, i.total FROM invoice AS i
JOIN customer AS c ON c.customer_id = i.customer_id;

-- 3
SELECT c.first_name, c.last_name, e.first_name, e.last_name FROM customer AS c
JOIN employee AS e ON c.support_rep_id = e.employee_id;

-- 4
SELECT al.title, ar.name FROM album AS al
JOIN artist AS ar ON al.artist_id = ar.artist_id;

-- 5
SELECT pt.playlist_track_id FROM playlist_track AS pt
JOIN playlist AS p ON pt.playlist_id = p.playlist_id
WHERE p.name = 'Music';

-- 6
SELECT t.name FROM playlist_track AS pt
JOIN track AS t ON pt.track_id = t.track_id
WHERE pt.playlist_id = 5;

-- 7
SELECT t.name, p.name FROM playlist_track AS pt
JOIN track AS t ON pt.track_id = t.track_id
JOIN playlist AS p ON pt.playlist_id = p.playlist_id;

-- 8
SELECT al.title, t.name FROM track AS t
JOIN album AS al ON t.album_id = al.album_id
JOIN genre AS g ON t.genre_id = g.genre_id
WHERE g.name = 'Alternative & Punk';


-- NESTED QUERIES

-- 1
SELECT * FROM invoice
WHERE invoice_id IN (SELECT invoice_id FROM invoice_line WHERE unit_price > .99);

-- 2
SELECT * FROM playlist_track
WHERE playlist_id IN (SELECT playlist_id FROM playlist WHERE name = 'Music');

-- 3
SELECT name FROM track
WHERE track_id IN (SELECT track_id FROM playlist_track WHERE playlist_id = 5);

-- 4
SELECT * FROM track
WHERE genre_id IN (SELECT genre_id FROM genre WHERE name = 'Comedy');

-- 5
SELECT * FROM track
WHERE album_id IN (SELECT album_id FROM album WHERE title = 'Fireball');

-- 6
SELECT * FROM track
WHERE album_id IN (SELECT album_id FROM album 
    WHERE artist_id IN (SELECT artist_id FROM artist
        WHERE name = 'Queen'));


-- UPDATING ROWS

-- 1
UPDATE customer
SET fax = null
WHERE fax IS NOT null;

-- 2
UPDATE customer
SET company = 'Self'
WHERE company IS null;

-- 3
UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett';

-- 4
UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';

-- 5
UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id = (SELECT genre_id FROM genre WHERE name = 'Metal')
AND composer IS NULL;


-- GROUP BY

-- 1
SELECT COUNT(*), g.name FROM track AS t
JOIN genre AS g ON g.genre_id = t.genre_id
GROUP BY g.name;

-- 2
SELECT COUNT(*), g.name FROM track AS t
JOIN genre AS g ON g.genre_id = t.genre_id
WHERE g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name;

-- 3
SELECT ar.name, COUNT(*) FROM album AS al
JOIN artist AS ar ON al.artist_id = ar.artist_id
GROUP BY ar.name;


-- USE DISTINCT

-- 1
SELECT DISTINCT composer FROM track;

-- 2
SELECT DISTINCT billing_postal_code FROM invoice;

-- 3
SELECT DISTINCT company FROM customer;


-- DELETE ROWS

-- 1
DELETE FROM practice_delete
WHERE type = 'bronze';

-- 2
DELETE FROM practice_delete
WHERE type = 'silver';

-- 3
DELETE FROM practice_delete
WHERE value = 150;


-- eCommerce Simulation

-- STEP 1
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  name VARCHAR(80) NOT null,
  email TEXT NOT null
)

CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  name VARCHAR(150) NOT null,
  price INT NOT null
)

CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  product_id INT,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
)

-- STEP 2
INSERT INTO users (name, email)
VALUES
('Bobby', 'bobbysemail@gmail.ls'),
('Robby', 'robbysemail@gmail.ls'),
('Billy', 'billysemail@gmail.ls')

INSERT INTO products (name, price)
VALUES
('Chicken Tenders', 13),
('Steak', 24),
('Rack of Ribs', 28)

INSERT INTO orders (product_id)
VALUES
(1),
(2),
(3)

-- STEP 3
SELECT * FROM products AS p
JOIN orders AS o ON p.product_id = o.product_id
WHERE o.product_id = 1;

SELECT * FROM orders AS o
JOIN products AS p ON p.product_id = o.product_id;

SELECT SUM(p.price) FROM orders AS o
JOIN products AS p ON p.product_id = o.product_id
WHERE o.order_id = 2;

-- STEP 4
ALTER TABLE users
ADD order_id INT;

ALTER TABLE users
ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- STEP 5   Forgot to make my foreign primary keys increment (serial)
UPDATE users 
SET order_id = 1
WHERE name ='Bobby';

UPDATE users 
SET order_id = 2
WHERE name ='Robby';

UPDATE users 
SET order_id = 3
WHERE name ='Billy';

-- STEP 6
SELECT * FROM orders AS o
JOIN users AS u ON o.order_id = u.order_id
WHERE u.user_id = 1;

SELECT SUM(o.order_id) FROM orders AS o
JOIN users AS u ON o.order_id = u.order_id;