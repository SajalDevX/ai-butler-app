BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "action" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "captureId" bigint,
    "type" text NOT NULL,
    "title" text NOT NULL,
    "notes" text,
    "dueAt" timestamp without time zone,
    "isCompleted" boolean NOT NULL,
    "priority" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "completedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "action_user_idx" ON "action" USING btree ("userId");
CREATE INDEX "action_capture_idx" ON "action" USING btree ("captureId");
CREATE INDEX "action_due_idx" ON "action" USING btree ("dueAt");
CREATE INDEX "action_completed_idx" ON "action" USING btree ("isCompleted");


--
-- MIGRATION VERSION FOR recall_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('recall_butler', '20251217085742584', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251217085742584', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
