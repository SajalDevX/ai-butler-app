BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "device_tokens" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "fcmToken" text NOT NULL,
    "deviceType" text NOT NULL,
    "deviceName" text,
    "isActive" boolean NOT NULL,
    "lastUsedAt" timestamp without time zone,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "device_token_user_idx" ON "device_tokens" USING btree ("userId");
CREATE UNIQUE INDEX "device_token_fcm_idx" ON "device_tokens" USING btree ("fcmToken");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "notification_logs" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "sourceType" text NOT NULL,
    "sourceId" text NOT NULL,
    "title" text NOT NULL,
    "body" text NOT NULL,
    "priority" bigint NOT NULL,
    "sentAt" timestamp without time zone NOT NULL,
    "deliveredAt" timestamp without time zone,
    "readAt" timestamp without time zone,
    "fcmMessageId" text,
    "error" text
);

-- Indexes
CREATE INDEX "notification_user_idx" ON "notification_logs" USING btree ("userId");
CREATE UNIQUE INDEX "notification_source_idx" ON "notification_logs" USING btree ("sourceType", "sourceId");
CREATE INDEX "notification_sent_idx" ON "notification_logs" USING btree ("sentAt");


--
-- MIGRATION VERSION FOR recall_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('recall_butler', '20251219101026788', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251219101026788', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
