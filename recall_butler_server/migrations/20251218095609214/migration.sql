BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "token_usage_history" (
    "id" bigserial PRIMARY KEY,
    "contentType" text NOT NULL,
    "complexityBucket" text NOT NULL,
    "complexityScore" double precision,
    "tokensAllocated" bigint NOT NULL,
    "tokensUsed" bigint NOT NULL,
    "wasComplete" boolean NOT NULL,
    "isQuickAnalysis" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "token_history_type_idx" ON "token_usage_history" USING btree ("contentType", "complexityBucket");
CREATE INDEX "token_history_created_idx" ON "token_usage_history" USING btree ("createdAt");
CREATE INDEX "token_history_quick_idx" ON "token_usage_history" USING btree ("isQuickAnalysis");


--
-- MIGRATION VERSION FOR recall_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('recall_butler', '20251218095609214', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251218095609214', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
