-- Create the 'rps' database
CREATE DATABASE rps;

-- Grant CONNECT to public_users
GRANT CONNECT TO public_users;

-- Connect to the 'rps' database
\c rps;

-- Create the 'tbl_players' table
CREATE TABLE tbl_players (
    player_id CHAR(255) PRIMARY KEY,
    date_of_creation TIMESTAMP DEFAULT NOW() NOT NULL
);

-- Create the 'tbl_games' table
CREATE TABLE tbl_games (
    game_id SERIAL PRIMARY KEY,
    player1_id CHAR(255) REFERENCES tbl_players(player_id),
    player2_id CHAR(255) REFERENCES tbl_players(player_id),
    created_at TIMESTAMP DEFAULT NOW() NOT NULL,
    CONSTRAINT unique_players_pair UNIQUE (player1_id, player2_id)
);

-- Create the 'tbl_rounds' table
CREATE TABLE tbl_rounds (
    round_id SERIAL PRIMARY KEY,
    game_id INT REFERENCES tbl_games(game_id),
    player1_token CHAR(1) CHECK (player1_token IN ('R', 'P', 'S')),
    player2_token CHAR(1) CHECK (player2_token IN ('R', 'P', 'S')),
    extra_value VARCHAR(255), -- You can specify the data type you need for the extra value
    CONSTRAINT valid_tokens CHECK (player1_token <> player2_token)
);

-- Create the 'tbl_errata' table
CREATE TABLE tbl_errata (
    errata_id SERIAL PRIMARY KEY,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW() NOT NULL
);

-- Create the sequence
DROP SEQUENCE IF EXISTS seq_rps_seq;
CREATE SEQUENCE seq_rps_seq;

-- Create the 'tbl_valid_tokens' table
CREATE TABLE tbl_valid_tokens (
    fld_vt_token CHAR(1) PRIMARY KEY
);

-- Insert valid tokens
INSERT INTO tbl_valid_tokens (fld_vt_token) VALUES ('R'), ('P'), ('S'), ('#'); -- '#' will be our error test char for later

-- Test inserts into tbl_players
INSERT INTO tbl_players (player_id) VALUES ('Al'), ('Betty'), ('Chas'), ('Donna');

-- Test inserts into tbl_games
-- Good, accept
INSERT INTO tbl_games (game_id, player1_id, player2_id) VALUES (NEXTVAL('seq_rps_seq'), 'Al', 'Chas');
-- Good, accept
INSERT INTO tbl_games (game_id, player1_id, player2_id) VALUES (NEXTVAL('seq_rps_seq'), 'Betty', 'Chas');
-- Good, accept
INSERT INTO tbl_games (game_id, player1_id, player2_id) VALUES (NEXTVAL('seq_rps_seq'), 'Chas', 'Donna');
-- Good, accept
INSERT INTO tbl_games (game_id, player1_id, player2_id) VALUES (NEXTVAL('seq_rps_seq'), 'Al', 'Donna');

-- Demonstrate rejection of duplicate pairs
-- This insert should fail due to the unique constraint on (player1_id, player2_id)
INSERT INTO tbl_games (game_id, player1_id, player2_id) VALUES (NEXTVAL('seq_rps_seq'), 'Al', 'Chas');

-- Demonstrate rejection on foreign key violation (no 'Joe' in players)
-- This insert should fail due to the foreign key constraint on player2_id
INSERT INTO tbl_games (game_id, player1_id, player2_id) VALUES (NEXTVAL('seq_rps_seq'), 'Betty', 'Joe');

-- Test inserts into tbl_rounds
-- You'll need to use the game IDs obtained from the tbl_games table for these inserts
-- Replace 'game_id_here' with the actual game ID
INSERT INTO tbl_rounds (game_id, player1_token, player2_token, extra_value) VALUES (game_id_here, 'R', 'S', 'extra_value_1');
INSERT INTO tbl_rounds (game_id, player1_token, player2_token, extra_value) VALUES (game_id_here, 'P', 'R', 'extra_value_2');
INSERT INTO tbl_rounds (game_id, player1_token, player2_token, extra_value) VALUES (game_id_here, 'S', 'P', 'extra_value_3');
