CREATE TABLE validatorsets (
    id SERIAL PRIMARY KEY,
    height integer NOT NULL,
    address text NOT NULL,
    pubkey text NOT NULL, 
    priority text NOT NULL,
    voting_power text NOT NULL
);