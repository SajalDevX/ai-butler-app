BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "calendar_event_cache" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "googleEventId" text NOT NULL,
    "calendarId" text NOT NULL,
    "title" text NOT NULL,
    "description" text,
    "location" text,
    "startTime" timestamp without time zone NOT NULL,
    "endTime" timestamp without time zone NOT NULL,
    "isAllDay" boolean NOT NULL,
    "isRecurring" boolean NOT NULL,
    "recurringEventId" text,
    "recurrenceRule" text,
    "organizerEmail" text,
    "attendeesJson" text,
    "attendeeCount" bigint NOT NULL,
    "meetingLink" text,
    "conferenceType" text,
    "aiSummary" text,
    "suggestedPrep" text,
    "relatedEmailIds" text,
    "relatedCaptureIds" text,
    "contextBrief" text,
    "eventStatus" text NOT NULL,
    "responseStatus" text,
    "reminderMinutes" bigint,
    "hasCustomReminder" boolean NOT NULL,
    "etag" text,
    "lastSyncedAt" timestamp without time zone NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "calendar_user_idx" ON "calendar_event_cache" USING btree ("userId");
CREATE UNIQUE INDEX "calendar_google_event_idx" ON "calendar_event_cache" USING btree ("googleEventId");
CREATE INDEX "calendar_start_time_idx" ON "calendar_event_cache" USING btree ("startTime");
CREATE INDEX "calendar_calendar_id_idx" ON "calendar_event_cache" USING btree ("calendarId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "email_summaries" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "gmailId" text NOT NULL,
    "threadId" text NOT NULL,
    "subject" text NOT NULL,
    "fromEmail" text NOT NULL,
    "fromName" text,
    "toEmails" text NOT NULL,
    "ccEmails" text,
    "receivedAt" timestamp without time zone NOT NULL,
    "snippet" text,
    "bodyText" text,
    "hasAttachments" boolean NOT NULL,
    "attachmentNames" text,
    "aiSummary" text,
    "importanceScore" bigint NOT NULL,
    "importanceReason" text,
    "category" text NOT NULL,
    "sentiment" text,
    "requiresAction" boolean NOT NULL,
    "suggestedActions" text,
    "deadlineDetected" timestamp without time zone,
    "draftReply" text,
    "draftTone" text,
    "isRead" boolean NOT NULL,
    "isArchived" boolean NOT NULL,
    "isProcessed" boolean NOT NULL,
    "processingError" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "email_user_idx" ON "email_summaries" USING btree ("userId");
CREATE UNIQUE INDEX "email_gmail_id_idx" ON "email_summaries" USING btree ("gmailId");
CREATE INDEX "email_thread_idx" ON "email_summaries" USING btree ("threadId");
CREATE INDEX "email_importance_idx" ON "email_summaries" USING btree ("importanceScore");
CREATE INDEX "email_received_idx" ON "email_summaries" USING btree ("receivedAt");
CREATE INDEX "email_requires_action_idx" ON "email_summaries" USING btree ("requiresAction");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "google_tokens" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "accessToken" text NOT NULL,
    "refreshToken" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "scope" text NOT NULL,
    "gmailEnabled" boolean NOT NULL,
    "calendarEnabled" boolean NOT NULL,
    "lastGmailSync" timestamp without time zone,
    "lastCalendarSync" timestamp without time zone,
    "gmailHistoryId" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "google_token_user_idx" ON "google_tokens" USING btree ("userId");
CREATE INDEX "google_token_expires_idx" ON "google_tokens" USING btree ("expiresAt");


--
-- MIGRATION VERSION FOR recall_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('recall_butler', '20251218103355016', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251218103355016', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
