-- Create the procedure proc_insert_player
CREATE OR REPLACE PROCEDURE proc_insert_player(
    parm_id CHAR(255),
    parm_errlvl OUT INT
) AS
BEGIN
    -- Check if the player ID parameter is 'error'
    IF parm_id = 'error' THEN
        -- Raise an exception and log it to tbl_errata
        INSERT INTO tbl_errata (fld_e_doc, fld_e_SQLERRM, fld_e_SQLSTATE)
        VALUES (CURRENT_TIMESTAMP, 'Invalid player ID parameter', 'ERR001');
        parm_errlvl := -13; -- Error level for 'error' parameter
        RETURN;
    END IF;

    -- Check for unique player ID
    IF EXISTS (SELECT * FROM tbl_players WHERE player_id = parm_id) THEN
        -- Raise an exception and log it to tbl_errata
        INSERT INTO tbl_errata (fld_e_doc, fld_e_SQLERRM, fld_e_SQLSTATE)
        VALUES (CURRENT_TIMESTAMP, 'Player ID already exists', 'ERR002');
        parm_errlvl := -13; -- Error level for duplicate player ID
        RETURN;
    END IF;

    -- Insert the new player
    INSERT INTO tbl_players (player_id) VALUES (parm_id);
    parm_errlvl := 0; -- Success
END;
/
-- Create the procedure proc_insert_game
CREATE OR REPLACE PROCEDURE proc_insert_game(
    parm_p1 CHAR(255),
    parm_p2 CHAR(255),
    parm_errlvl OUT INT
) AS
    -- Declare local variables for player IDs
    local_p1 CHAR(255);
    local_p2 CHAR(255);
BEGIN
    -- Check if either player ID parameter is 'error'
    IF parm_p1 = 'error' OR parm_p2 = 'error' THEN
        -- Raise an exception and log it to tbl_errata
        INSERT INTO tbl_errata (fld_e_doc, fld_e_SQLERRM, fld_e_SQLSTATE)
        VALUES (CURRENT_TIMESTAMP, 'Invalid player ID parameter', 'ERR001');
        parm_errlvl := -13; -- Error level for 'error' parameter
        RETURN;
    END IF;

    -- Copy parameters into local variables and swap if reversed
    local_p1 := parm_p1;
    local_p2 := parm_p2;
    
    -- Check for NULLs
    IF local_p1 IS NULL OR local_p2 IS NULL THEN
        -- Raise an exception and log it to tbl_errata
        INSERT INTO tbl_errata (fld_e_doc, fld_e_SQLERRM, fld_e_SQLSTATE)
        VALUES (CURRENT_TIMESTAMP, 'Player ID cannot be NULL', 'ERR003');
        parm_errlvl := -13; -- Error level for NULL parameter
        RETURN;
    END IF;

    -- Ensure the pair does not already exist in tbl_games
    IF EXISTS (SELECT * FROM tbl_games
               WHERE (player1_id = local_p1 AND player2_id = local_p2)
                  OR (player1_id = local_p2 AND player2_id = local_p1)) THEN
        -- Raise an exception and log it to tbl_errata
        INSERT INTO tbl_errata (fld_e_doc, fld_e_SQLERRM, fld_e_SQLSTATE)
        VALUES (CURRENT_TIMESTAMP, 'Game pair already exists', 'ERR004');
        parm_errlvl := -13; -- Error level for duplicate game pair
        RETURN;
    END IF;

    -- Check that both player IDs exist in tbl_players
    IF NOT EXISTS (SELECT * FROM tbl_players WHERE player_id = local_p1)
       OR NOT EXISTS (SELECT * FROM tbl_players WHERE player_id = local_p2) THEN
        -- Raise an exception and log it to tbl_errata
        INSERT INTO tbl_errata (fld_e_doc, fld_e_SQLERRM, fld_e_SQLSTATE)
        VALUES (CURRENT_TIMESTAMP, 'Player ID not found in tbl_players', 'ERR005');
        parm_errlvl := -13; -- Error level for player not found
        RETURN;
    END IF;

    -- Insert the new game
    INSERT INTO tbl_games (player1_id, player2_id, created_at)
    VALUES (local_p1, local_p2, NOW()); -- Adjust timestamp function as needed
    parm_errlvl := 0; -- Success
END;
/
