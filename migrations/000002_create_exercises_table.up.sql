CREATE TABLE exercises (
                           id BIGSERIAL PRIMARY KEY,
                           name TEXT NOT NULL,
                           description TEXT,
                           createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           updatedat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                            deletedat TIMESTAMP
);