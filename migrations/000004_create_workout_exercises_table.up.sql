CREATE TABLE workout_exercises (
                                   workout_id INTEGER NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
                                   exercise_id INTEGER NOT NULL REFERENCES exercises(id) ON DELETE CASCADE,
                                   reps INTEGER NOT NULL,
                                   sets INTEGER NOT NULL,
                                   PRIMARY KEY (workout_id, exercise_id)
);