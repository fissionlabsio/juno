CREATE TABLE "public"."validatorsets" (
    "height" serial,
    "address" text,
    "pubkey" text,
    "priority" text,
    "voting_power" text,
    PRIMARY KEY ("height")
);
