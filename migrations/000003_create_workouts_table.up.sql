CREATE TABLE workouts (
                          id SERIAL PRIMARY KEY,
                          user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                          name text unique,
                          title text,
                          category TEXT NOT NULL,
                          photo_path text,
                          createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          updatedat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          deletedat TIMESTAMP
);