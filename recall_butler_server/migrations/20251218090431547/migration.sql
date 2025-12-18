BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "capture" ADD COLUMN "quickDescription" text;
ALTER TABLE "capture" ADD COLUMN "quickType" text;
ALTER TABLE "capture" ADD COLUMN "processingProgress" bigint;
ALTER TABLE "capture" ADD COLUMN "processedAt" timestamp without time zone;
ALTER TABLE "capture" ADD COLUMN "errorMessage" text;
CREATE INDEX "capture_status_idx" ON "capture" USING btree ("processingStatus");

--
-- MIGRATION VERSION FOR recall_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('recall_butler', '20251218090431547', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251218090431547', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
