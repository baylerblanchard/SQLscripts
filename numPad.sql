DO $$
DECLARE
    input_letter CHAR(1) := 'A'; -- Replace with the letter you want to map
    digit CHAR(1);
BEGIN
    IF input_letter = '1' THEN
        digit := '1';
    ELSIF input_letter = 'A' OR input_letter = 'B' OR input_letter = 'C' THEN
        digit := '2';
    ELSIF input_letter = 'D' OR input_letter = 'E' OR input_letter = 'F' THEN
        digit := '3';
    ELSIF input_letter = 'G' OR input_letter = 'H' OR input_letter = 'I' THEN
        digit := '4';
    ELSIF input_letter = 'J' OR input_letter = 'K' OR input_letter = 'L' THEN
        digit := '5';
    ELSIF input_letter = 'M' OR input_letter = 'N' OR input_letter = 'O' THEN
        digit := '6';
    ELSIF input_letter = 'P' OR input_letter = 'R' OR input_letter = 'S' THEN
        digit := '7';
    ELSIF input_letter = 'T' OR input_letter = 'U' OR input_letter = 'V' THEN
        digit := '8';
    ELSIF input_letter = 'W' OR input_letter = 'X' OR input_letter = 'Y' THEN
        digit := '9';
    ELSE
        digit := '$';
    END IF;

    -- Output the result
    RAISE NOTICE 'Letter: %, Digit: %', input_letter, digit;
END $$;
