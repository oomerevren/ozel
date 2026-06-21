# 🌍 OTONOM MEDYA HOLDİNGİ

> **Tamamen Lokal • 7/24 Otonom • Mistral AI • n8n Orkestrasyon**

---

## 📁 Proje Yapısı

```
otonom-medya-holdingi/
├── README.md                          ← Bu dosya
├── docker-compose.yml                 ← Ana Docker Compose
├── .env.example                       ← Ortam değişkenleri şablonu
├── init-db/
│   ├── 01_schema.sql                  ← Veritabanı şeması
│   └── 02_seed_data.sql               ← Başlangıç verileri
├── workflows/
│   ├── 01_radar_istihbarat.json       ← Haber tarama + kategorizasyon
│   ├── 02_icerik_fabrikasi.json       ← İçerik üretimi (metin + sosyal)
│   ├── 03_kalite_kontrol.json         ← 4'lü paralel denetim + hakem
│   ├── 04_yayin_dagitim.json          ← Platformlara dağıtım
│   ├── 05_kurumsal_hafiza.json        ← Öğrenme sistemi
│   ├── 06_haftalik_iyilestirme.json   ← Prompt optimizasyonu
│   ├── 07_sistem_izleme.json          ← Sağlık kontrolü + uyarılar
│   ├── 08_724_canli_radyo.json        ← 7/24 sesli haber yayını
│   ├── 09_haftalik_dijital_dergi.json ← Haftalık PDF dergi
│   └── error_handler.json             ← Hata yönetimi
├── config/
│   └── ollama_models.txt              ← İndirilecek model listesi
└── scripts/
    └── setup.sh                       ← Kurulum scripti
```

---

## 🚀 Hızlı Başlangıç

### 1. Gereksinimler

```bash
# Sistem
- Docker & Docker Compose
- 8 vCPU, 16 GB RAM (minimum)
- 100 GB SSD
- NVIDIA GPU (opsiyonel, AI hızlandırma için)

# Yazılım
- Docker 24+
- Docker Compose 2.20+
- Git
```

### 2. Kurulum

```bash
# Repo'yu klonla
git clone <repo-url> otonom-medya-holdingi
cd otonom-medya-holdingi

# Environment dosyasını oluştur
cp .env.example .env
# .env dosyasındaki şifreleri güncelle

# Servisleri başlat
docker-compose up -d

# Ollama modellerini indir (ilk kurulum ~15-30 dk)
docker exec medya-ollama ollama pull mistral-small-latest
docker exec medya-ollama ollama pull mistral-medium-latest
docker exec medya-ollama ollama pull mistral-large-latest

# Veritabanı şemasını uygula
docker exec -i medya-postgres psql -U medya_user -d medya_db < init-db/01_schema.sql
docker exec -i medya-postgres psql -U medya_user -d medya_db < init-db/02_seed_data.sql

# n8n'e giriş yap
open http://localhost:5678
```

### 3. Workflow'ları İçe Aktar

1. n8n editörünü aç: `http://localhost:5678`
2. İlk kullanıcı hesabını oluştur
3. Settings > Credentials'den PostgreSQL ve Ollama bağlantılarını ekle
4. Her JSON dosyasını import et:
   - `workflows/01_radar_istihbarat.json`
   - `workflows/02_icerik_fabrikasi.json`
   - `workflows/03_kalite_kontrol.json`
   - `workflows/04_yayin_dagitim.json`
   - `workflows/05_kurumsal_hafiza.json`
   - `workflows/06_haftalik_iyilestirme.json`
   - `workflows/07_sistem_izleme.json`
   - `workflows/08_724_canli_radyo.json`
   - `workflows/09_haftalik_dijital_dergi.json`
   - `workflows/error_handler.json`
5. Her workflow'u "Active" yap

---

## 🏗️ Sistem Mimarisi

```
┌─────────────────────────────────────────────────────────────────┐
│                    OTONOM MEDYA HOLDİNGİ                         │
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐   │
│  │ 01_Radar     │→│ 02_İçerik    │→│ 03_Kalite Kontrol    │   │
│  │ (5dk)        │  │ (10dk)       │  │ (Paralel 4 Agent)    │   │
│  └──────────────┘  └──────────────┘  └──────────┬───────────┘   │
│                                                  │               │
│                                    ┌─────────────┼─────────────┐ │
│                                    ▼             ▼             ▼ │
│                              ┌──────────┐ ┌──────────┐ ┌──────┐ │
│                              │ 04_Yayın │ │ 08_7/24  │ │05_06 │ │
│                              │ Dağıtım  │ │ Radyo    │ │Hafıza│ │
│                              └──────────┘ └──────────┘ └──────┘ │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ 07_Sistem İzleme (15dk) + Error Handler                 │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                  │
│  ┌─────────────────┐  ┌─────────────────┐  ┌────────────────┐  │
│  │  n8n (Orkestr.) │  │  Ollama (AI)    │  │ PostgreSQL     │  │
│  │  localhost:5678 │  │  localhost:11434│  │  localhost:5432│  │
│  └─────────────────┘  └─────────────────┘  └────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🤖 Mistral AI Modelleri

| Model | Kullanım | Context | Not |
|-------|----------|---------|-----|
| **Mistral Small** | Hızlı sınıflandırma, özet | 128K | En ucuz, en hızlı |
| **Mistral Medium** | İçerik üretimi, analiz | 256K | Dengeli kalite/hız |
| **Mistral Large** | Fact-check, hukuk, hakem | 128K | En yüksek kalite |

**Lokal Kurulum:** Ollama ile çalışır. Harici API'ye ihtiyaç yoktur.

---

## 📊 Veritabanı Tabloları

| Tablo | Açıklama |
|-------|----------|
| `sources` | Haber kaynakları (RSS, API, scraper) |
| `raw_news` | Ham haber verisi |
| `generated_content` | Üretilen içerikler (makale, sosyal medya) |
| `quality_checks` | Kalite kontrol sonuçları |
| `corporate_memory` | Öğrenme deposu |
| `publications` | Yayın kayıtları |
| `radio_stream` | Radyo yayın akışı |
| `system_logs` | Sistem logları |
| `vertical_settings` | Dikey marka ayarları |
| `prompt_templates` | Prompt şablonları |

---

## ⚙️ Ortam Değişkenleri

```bash
# .env dosyası
POSTGRES_PASSWORD=GucluSifre123!
ENCRYPTION_KEY=openssl-rand-base64-32
REDIS_PASSWORD=RedisSifre456!

CMS_API_URL=http://localhost:8080
CMS_API_KEY=your-cms-key
TTS_ENDPOINT=http://localhost:5002
ALERT_WEBHOOK_URL=https://hooks.slack.com/your-webhook
```

---

## 🔄 Workflow Akışı

```
1. RADAR (5dk) → RSS/API tarama → Parse → Deduplicate → Kategorize → Kaydet
2. İÇERİK (10dk) → Bekleyen haberleri al → AI ile içerik üret → Kaydet
3. KALİTE (10dk) → 4 paralel denetim → Nihai hakem → ONAY/RED/İNCELEME
4. YAYIN (5dk) → Onaylananları platformlara dağıt → Kaydet
5. HAFIZA (6saat) → Reddedilenleri analiz et → Öğrenme → Kaydet
6. İYİLEŞTİRME (7gün) → Öğrenmeleri değerlendir → Prompt'ları optimize et
7. İZLEME (15dk) → Metrikleri topla → Sağlığı kontrol et → Uyarı gönder
8. RADYO (1dk) → Onaylanan haberi seslendir → Yayınla → Kaydet
9. DERGİ (7gün) → Haftanın en iyilerini seç → Dergi oluştur → Yayınla
```

---

## 🛡️ Güvenlik

- ✅ Tamamen lokal (harici bağımlılık yok)
- ✅ AES-256 credential şifreleme
- ✅ $env erişimi kapalı
- ✅ Webhook auth + HMAC doğrulama
- ✅ RBAC ile erişim sınırlı
- ✅ Execution data pruning
- ✅ Düzenli otomatik yedek

---

## 📈 Performans Hedefleri

| Metrik | Hedef |
|--------|-------|
| Haber yakalama süresi | < 5 dakika |
| İçerik üretim süresi | < 10 dakika |
| Kalite kontrol süresi | < 5 dakika |
| Toplam süre (yakalama → yayın) | < 30 dakika |
| Sistem uptime | %99.9 |
| Doğruluk oranı | > %95 |

---

## 🐛 Sorun Giderme

```bash
# n8n logları
docker logs medya-n8n

# PostgreSQL logları
docker logs medya-postgres

# Ollama logları
docker logs medya-ollama

# Veritabanı bağlantısı testi
docker exec -it medya-postgres psql -U medya_user -d medya_db -c "SELECT 1;"

# Ollama modeli testi
docker exec medya-ollama ollama run mistral-small-latest "Merhaba"

# n8n healthcheck
curl http://localhost:5678/healthz
```

---

## 📝 Lisans

Bu proje eğitim ve araştırma amaçlıdır. Ticari kullanım için gerekli lisansları alın.

---

**🌍 Otonom Medya Holdingi — Dünyanın en hızlı refleks veren medya ekosistemi**
"# ozel" 
