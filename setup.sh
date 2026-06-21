#!/bin/bash
set -e

echo "🌍 Otonom Medya Holdingi Kurulum Başlatılıyor..."

# Docker kontrolü
if ! command -v docker &> /dev/null; then
    echo "❌ Docker bulunamadı."
    exit 1
fi

if ! docker compose version &> /dev/null 2>&1; then
    echo "❌ Docker Compose bulunamadı."
    exit 1
fi

# .env dosyası kontrolü
if [ ! -f .env ]; then
    echo "📝 .env dosyası oluşturuluyor..."
    cp .env.example .env
    # Güvenli şifreler üret
    sed -i "s/POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=$(openssl rand -base64 32)/" .env
    sed -i "s/ENCRYPTION_KEY=.*/ENCRYPTION_KEY=$(openssl rand -base64 32)/" .env
    sed -i "s/REDIS_PASSWORD=.*/REDIS_PASSWORD=$(openssl rand -base64 32)/" .env
    echo "✅ .env dosyası oluşturuldu. Şifreleri kontrol edin!"
fi

# Servisleri başlat
echo "🚀 Servisler başlatılıyor..."
docker compose up -d

# Ollama'nın başlamasını bekle
echo "⏳ Ollama başlıyor..."
sleep 15

# Modelleri indir
echo "🤖 Mistral modelleri indiriliyor..."
docker exec medya-ollama ollama pull mistral-small-latest
docker exec medya-ollama ollama pull mistral-medium-latest
docker exec medya-ollama ollama pull mistral-large-latest

# PostgreSQL'in başlamasını bekle
echo "⏳ PostgreSQL başlıyor..."
sleep 5

# Veritabanı şemasını uygula
echo "🗄️ Veritabanı şeması uygulanıyor..."
docker exec -i medya-postgres psql -U medya_user -d medya_db < init-db/01_schema.sql
docker exec -i medya-postgres psql -U medya_user -d medya_db < init-db/02_seed_data.sql

echo ""
echo "✅ Kurulum tamamlandı!"
echo "🌐 n8n Editor: http://localhost:5678"
echo "🗄️ PostgreSQL: localhost:5432"
echo "🤖 Ollama API: http://localhost:11434"
echo ""
echo "📋 Sonraki Adımlar:"
echo "1. n8n editörünü aç: http://localhost:5678"
echo "2. Kullanıcı hesabı oluştur"
echo "3. Credentials'ları yapılandır (PostgreSQL, Ollama)"
echo "4. Workflow JSON'larını import et"
echo "5. Workflow'ları aktif et"
echo ""
echo "🔑 .env dosyasındaki şifreleri güvenli yerde saklayın!"
