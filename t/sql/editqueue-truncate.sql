BEGIN;
SET client_min_messages TO 'WARNING';

TRUNCATE editor CASCADE;
TRUNCATE artist CASCADE;
TRUNCATE artist_name CASCADE;

COMMIT;
