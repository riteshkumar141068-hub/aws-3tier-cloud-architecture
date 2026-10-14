CREATE TABLE IF NOT EXISTS Employee (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150),
    username VARCHAR(100) UNIQUE,
    password VARCHAR(255) NOT NULL,
    regdate DATE
);
