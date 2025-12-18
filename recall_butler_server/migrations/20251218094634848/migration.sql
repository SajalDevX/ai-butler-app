BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "action" ADD COLUMN "reminderAt" timestamp without time zone;
CREATE INDEX "action_reminder_idx" ON "action" USING btree ("reminderAt");

--
-- MIGRATION VERSION FOR recall_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('recall_butler', '20251218094634848', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251218094634848', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
