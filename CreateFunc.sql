-- Create the procedure proc_insert_round
CREATE OR REPLACE PROCEDURE proc_insert_round(
    parm_p1 CHAR(255),
    parm_tok1 CHAR(1),
    parm_p2 CHAR(255),
    parm_tok2 CHAR(1)
) AS
    -- Declare local variables for game ID and tokens
    local_game_id INT;
    local_token1 CHAR(1);
    local_token2 CHAR(1);
BEGIN
    -- Call a function to resolve the game ID based on player IDs and tokens
    local_game_id := resolve_game(parm_p1, parm_tok1, parm_p2, parm_tok2);

    -- Check if the game ID is NULL (invalid game)
    IF local_game_id IS NULL THEN
        -- Invalid game, return error code 1
        INSERT INTO tbl_errata (fld_e_doc, fld_e_SQLERRM, fld_e_SQLSTATE)
        VALUES (CURRENT_TIMESTAMP, 'Invalid game', 'ERR006');
        RETURN;
    END IF;

    -- Check if the game ID is negative (players reversed, swap tokens)
    IF local_game_id < 0 THEN
        -- Swap tokens
        local_token1 := parm_tok2;
        local_token2 := parm_tok1;
    ELSE
        local_token1 := parm_tok1;
        local_token2 := parm_tok2;
    END IF;

    -- Check for valid tokens
    IF local_token1 NOT IN ('R', 'P', 'S') OR local_token2 NOT IN ('R', 'P', 'S') THEN
        -- Invalid game token, return error code 2
        INSERT INTO tbl_errata (fld_e_doc, fld_e_SQLERRM, fld_e_SQLSTATE)
        VALUES (CURRENT_TIMESTAMP, 'Invalid game token', 'ERR007');
        RETURN;
    END IF;

    -- Insert the new round into tbl_rounds
    INSERT INTO tbl_rounds (game_id, player1_token, player2_token, extra_value)
    VALUES (local_game_id, local_token1, local_token2, NULL); -- Adjust extra_value as needed
END;