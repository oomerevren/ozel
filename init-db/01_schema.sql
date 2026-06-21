-- ═══════════════════════════════════════════════════════════
-- OTONOM MEDYA HOLDİNGİ — POSTGRESQL ŞEMASI
-- ═══════════════════════════════════════════════════════════

-- 1. Kaynaklar Tablosu
CREATE TABLE IF NOT EXISTS sources (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    url VARCHAR(1000) NOT NULL UNIQUE,
    type VARCHAR(50) DEFAULT 'rss',
    category VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    scrape_interval INTEGER DEFAULT 300,
    last_scraped TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 2. Ham Haber Tablosu
CREATE TABLE IF NOT EXISTS raw_news (
    id SERIAL PRIMARY KEY,
    source_id INTEGER REFERENCES sources(id),
    title VARCHAR(500) NOT NULL,
    url VARCHAR(1000) UNIQUE,
    summary TEXT,
    full_content TEXT,
    category VARCHAR(50),
    importance_score INTEGER DEFAULT 5,
    reliability_score FLOAT DEFAULT 0.5,
    language VARCHAR(10) DEFAULT 'tr',
    published_at TIMESTAMP,
    scraped_at TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20) DEFAULT 'pending',
    raw_data JSONB,
    title_hash VARCHAR(64),
    content_hash VARCHAR(64)
);

-- 3. Üretilen İçerik Tablosu
CREATE TABLE IF NOT EXISTS generated_content (
    id SERIAL PRIMARY KEY,
    news_id INTEGER REFERENCES raw_news(id),
    title VARCHAR(500),
    slug VARCHAR(500),
    article TEXT,
    meta_description VARCHAR(200),
    seo_keywords JSONB,
    twitter_post TEXT,
    instagram_carousel JSONB,
    linkedin_post TEXT,
    facebook_post TEXT,
    tags JSONB,
    category VARCHAR(50),
    language VARCHAR(10) DEFAULT 'tr',
    word_count INTEGER,
    reading_time INTEGER,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20) DEFAULT 'draft',
    version INTEGER DEFAULT 1
);

-- 4. Kalite Kontrol Tablosu
CREATE TABLE IF NOT EXISTS quality_checks (
    id SERIAL PRIMARY KEY,
    content_id INTEGER REFERENCES generated_content(id),
    check_type VARCHAR(50),
    agent_name VARCHAR(100),
    model_used VARCHAR(50),
    result JSONB,
    score FLOAT,
    decision VARCHAR(20),
    reason TEXT,
    suggestions JSONB,
    checked_at TIMESTAMP DEFAULT NOW(),
    final_decision VARCHAR(20)
);

-- 5. Kurumsal Hafıza Tablosu
CREATE TABLE IF NOT EXISTS corporate_memory (
    id SERIAL PRIMARY KEY,
    error_type VARCHAR(100),
    category VARCHAR(50),
    description TEXT,
    lesson_learned TEXT,
    affected_prompt TEXT,
    new_prompt TEXT,
    severity INTEGER DEFAULT 5,
    frequency INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    applied BOOLEAN DEFAULT FALSE,
    applied_at TIMESTAMP
);

-- 6. Yayın Kayıtları Tablosu
CREATE TABLE IF NOT EXISTS publications (
    id SERIAL PRIMARY KEY,
    content_id INTEGER REFERENCES generated_content(id),
    platform VARCHAR(50),
    platform_post_id VARCHAR(200),
    platform_url VARCHAR(1000),
    published_at TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20),
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    engagement_data JSONB
);

-- 7. 7/24 Radyo Akışı Tablosu
CREATE TABLE IF NOT EXISTS radio_stream (
    id SERIAL PRIMARY KEY,
    news_id INTEGER REFERENCES raw_news(id),
    content_id INTEGER REFERENCES generated_content(id),
    audio_url VARCHAR(500),
    transcript TEXT,
    broadcast_at TIMESTAMP DEFAULT NOW(),
    duration_seconds INTEGER,
    status VARCHAR(20),
    error_message TEXT
);

-- 8. Sistem Logları Tablosu
CREATE TABLE IF NOT EXISTS system_logs (
    id SERIAL PRIMARY KEY,
    workflow_name VARCHAR(200),
    execution_id VARCHAR(100),
    node_name VARCHAR(200),
    log_level VARCHAR(20),
    message TEXT,
    details JSONB,
    created_at TIMESTAMP DEFAULT NOW()
);

-- 9. Dikey Marka Ayarları Tablosu
CREATE TABLE IF NOT EXISTS vertical_settings (
    id SERIAL PRIMARY KEY,
    vertical_name VARCHAR(100) UNIQUE,
    display_name VARCHAR(200),
    description TEXT,
    brand_voice TEXT,
    target_audience TEXT,
    content_length_min INTEGER DEFAULT 800,
    content_length_max INTEGER DEFAULT 1200,
    seo_focus_keywords JSONB,
    social_media_style JSONB,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 10. Prompt Şablonları Tablosu
CREATE TABLE IF NOT EXISTS prompt_templates (
    id SERIAL PRIMARY KEY,
    template_name VARCHAR(200) UNIQUE,
    template_type VARCHAR(100),
    category VARCHAR(50),
    template_text TEXT,
    variables JSONB,
    version INTEGER DEFAULT 1,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- 11. Aboneler Tablosu (Dergi için)
CREATE TABLE IF NOT EXISTS subscribers (
    id SERIAL PRIMARY KEY,
    email VARCHAR(300) NOT NULL,
    name VARCHAR(200),
    preferences JSONB,
    is_active BOOLEAN DEFAULT TRUE,
    subscribed_at TIMESTAMP DEFAULT NOW(),
    last_sent_at TIMESTAMP
);

-- İndeksler
CREATE INDEX IF NOT EXISTS idx_raw_news_status ON raw_news(status);
CREATE INDEX IF NOT EXISTS idx_raw_news_category ON raw_news(category);
CREATE INDEX IF NOT EXISTS idx_raw_news_published ON raw_news(published_at DESC);
CREATE INDEX IF NOT EXISTS idx_raw_news_source ON raw_news(source_id);
CREATE INDEX IF NOT EXISTS idx_raw_news_title_hash ON raw_news(title_hash);
CREATE INDEX IF NOT EXISTS idx_raw_news_content_hash ON raw_news(content_hash);

CREATE INDEX IF NOT EXISTS idx_content_status ON generated_content(status);
CREATE INDEX IF NOT EXISTS idx_content_news ON generated_content(news_id);
CREATE INDEX IF NOT EXISTS idx_content_category ON generated_content(category);
CREATE INDEX IF NOT EXISTS idx_content_created ON generated_content(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_quality_content ON quality_checks(content_id);
CREATE INDEX IF NOT EXISTS idx_quality_decision ON quality_checks(final_decision);
CREATE INDEX IF NOT EXISTS idx_quality_type ON quality_checks(check_type);

CREATE INDEX IF NOT EXISTS idx_memory_error_type ON corporate_memory(error_type);
CREATE INDEX IF NOT EXISTS idx_memory_category ON corporate_memory(category);
CREATE INDEX IF NOT EXISTS idx_memory_applied ON corporate_memory(applied);

CREATE INDEX IF NOT EXISTS idx_publications_content ON publications(content_id);
CREATE INDEX IF NOT EXISTS idx_publications_platform ON publications(platform);
CREATE INDEX IF NOT EXISTS idx_publications_status ON publications(status);

CREATE INDEX IF NOT EXISTS idx_radio_status ON radio_stream(status);
CREATE INDEX IF NOT EXISTS idx_radio_broadcast ON radio_stream(broadcast_at DESC);

CREATE INDEX IF NOT EXISTS idx_logs_level ON system_logs(log_level);
CREATE INDEX IF NOT EXISTS idx_logs_created ON system_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_logs_workflow ON system_logs(workflow_name);

-- Fonksiyonlar

-- Hash fonksiyonu (deduplication için)
CREATE OR REPLACE FUNCTION generate_hash(input_text TEXT)
RETURNS VARCHAR(64) AS $$
BEGIN
    RETURN encode(sha256(input_text::bytea), 'hex');
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Trigger: raw_news insert/update'te hash oluştur
CREATE OR REPLACE FUNCTION update_news_hashes()
RETURNS TRIGGER AS $$
BEGIN
    NEW.title_hash := generate_hash(NEW.title);
    NEW.content_hash := generate_hash(COALESCE(NEW.full_content, NEW.summary));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_news_hashes ON raw_news;
CREATE TRIGGER trg_update_news_hashes
    BEFORE INSERT OR UPDATE ON raw_news
    FOR EACH ROW
    EXECUTE FUNCTION update_news_hashes();

-- Trigger: updated_at otomatik güncelleme
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_content_updated_at ON generated_content;
CREATE TRIGGER trg_update_content_updated_at
    BEFORE UPDATE ON generated_content
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS trg_update_vertical_updated_at ON vertical_settings;
CREATE TRIGGER trg_update_vertical_updated_at
    BEFORE UPDATE ON vertical_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS trg_update_memory_updated_at ON corporate_memory;
CREATE TRIGGER trg_update_memory_updated_at
    BEFORE UPDATE ON corporate_memory
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS trg_update_prompt_updated_at ON prompt_templates;
CREATE TRIGGER trg_update_prompt_updated_at
    BEFORE UPDATE ON prompt_templates
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
