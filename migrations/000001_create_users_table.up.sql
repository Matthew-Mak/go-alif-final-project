CREATE TABLE users (
                       id SERIAL PRIMARY KEY,
                       username VARCHAR(255) UNIQUE NOT NULL,
                       password TEXT NOT NULL,
                       role TEXT DEFAULT 'user',
                       token_version INTEGER DEFAULT 1,
                       createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updatedat TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);