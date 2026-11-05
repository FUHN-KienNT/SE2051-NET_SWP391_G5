-- Migration 07: Thêm bảng password_reset_tokens phục vụ chức năng quên / đặt lại mật khẩu
CREATE TABLE IF NOT EXISTS password_reset_tokens (
    id           bigserial    PRIMARY KEY,
    user_id      bigint       NOT NULL,
    token_hash   varchar(64)  NOT NULL,
    expires_at   timestamptz  NOT NULL,
    used         boolean      NOT NULL DEFAULT false,
    created_at   timestamptz  NOT NULL DEFAULT now(),
    CONSTRAINT fk_prt_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_prt_token_hash ON password_reset_tokens (token_hash);
CREATE INDEX IF NOT EXISTS idx_prt_user_id ON password_reset_tokens (user_id);
