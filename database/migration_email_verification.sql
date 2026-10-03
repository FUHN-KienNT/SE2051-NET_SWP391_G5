-- =====================================================================
-- Migration: Tạo bảng email_verification_tokens phục vụ xác thực email
-- =====================================================================

CREATE TABLE IF NOT EXISTS email_verification_tokens (
    id           BIGSERIAL    PRIMARY KEY,
    user_id      BIGINT       NOT NULL,
    token_hash   VARCHAR(64)  NOT NULL,
    expires_at   TIMESTAMPTZ  NOT NULL,
    used         BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_evt_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_evt_token_hash
    ON email_verification_tokens(token_hash);

CREATE INDEX IF NOT EXISTS idx_evt_user_id
    ON email_verification_tokens(user_id);
