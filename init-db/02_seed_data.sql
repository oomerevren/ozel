-- ═══════════════════════════════════════════════════════════
-- OTONOM MEDYA HOLDİNGİ — BAŞLANGIÇ VERİLERİ
-- ═══════════════════════════════════════════════════════════

-- Dikey Marka Ayarları
INSERT INTO vertical_settings (vertical_name, display_name, description, brand_voice, target_audience, content_length_min, content_length_max, seo_focus_keywords, social_media_style) VALUES
('teknoloji', 'Holding Teknoloji', 'Teknoloji dünyasından son gelişmeler', 'Bilgilendirici, yenilikçi, teknik ama anlaşılır', '25-45 yaş, teknoloji meraklısı, profesyonel', 800, 1500, 
 '["yapay zeka", "blockchain", "siber güvenlik", "yazılım", "donanım", "startup"]',
 '{"twitter": "kısa, vurucu, teknik terimler", "instagram": "görsel ağırlıklı, infografik", "linkedin": "profesyonel, analiz odaklı"}'),

('ekonomi', 'Holding Ekonomi', 'Ekonomi ve finans dünyasından haberler', 'Analitik, güvenilir, veri odaklı', '30-60 yaş, yatırımcı, iş insanı, ekonomist', 1000, 1500,
 '["borsa", "döviz", "enflasyon", "faiz", "ekonomi politikası", "şirket haberleri"]',
 '{"twitter": "rakam odaklı, hızlı", "instagram": "grafik/infografik", "linkedin": "detaylı analiz"}'),

('kultur', 'Holding Kültür-Sanat', 'Kültür, sanat ve yaşam haberleri', 'Zarif, entelektüel, erişilebilir', '20-50 yaş, kültür-sanat takipçisi, akademisyen', 600, 1200,
 '["sinema", "müzik", "tiyatro", "sanat", "edebiyat", "kültür etkinlikleri"]',
 '{"twitter": "alıntı, paylaşım odaklı", "instagram": "görsel, estetik", "linkedin": "kültürel analiz"}'),

('magazin', 'Holding Magazin', 'Magazin ve eğlence dünyası', 'Eğlenceli, güncel, dikkat çekici', '18-40 yaş, magazin takipçisi, genç kitle', 400, 800,
 '["ünlü haberleri", "magazin", "eğlence", "moda", "sosyal medya trendleri"]',
 '{"twitter": "hızlı, paylaşım odaklı", "instagram": "görsel ağırlıklı, carousel", "linkedin": "kullanma"}'),

('bilim', 'Holding Bilim', 'Bilim ve araştırma haberleri', 'Akademik ama anlaşılır, merak uyandırıcı', '18-60 yaş, öğrenci, akademisyen, bilim meraklısı', 1000, 2000,
 '["uzay", "fizik", "biyoloji", "tıp", "iklim", "araştırma", "keşif"]',
 '{"twitter": "kısa özet, şaşırtıcı bilgi", "instagram": "infografik, görsel açıklama", "linkedin": "akademik özet"}');

-- Haber Kaynakları
INSERT INTO sources (name, url, type, category, scrape_interval) VALUES
('TechCrunch', 'https://techcrunch.com/feed/', 'rss', 'teknoloji', 300),
('The Verge', 'https://www.theverge.com/rss/index.xml', 'rss', 'teknoloji', 300),
('Ars Technica', 'https://feeds.arstechnica.com/arstechnica/technology-lab', 'rss', 'teknoloji', 300),
('Bloomberg', 'https://feeds.bloomberg.com/markets/news.rss', 'rss', 'ekonomi', 300),
('Reuters Business', 'https://feeds.reuters.com/reuters/businessNews', 'rss', 'ekonomi', 300),
('Financial Times', 'https://www.ft.com/technology?format=rss', 'rss', 'ekonomi', 300),
('BBC Culture', 'https://feeds.bbci.co.uk/news/entertainment_and_arts/rss.xml', 'rss', 'kultur', 300),
('The Guardian Culture', 'https://www.theguardian.com/uk/culture/rss', 'rss', 'kultur', 300),
('Nature News', 'https://www.nature.com/nature.rss', 'rss', 'bilim', 300),
('Science Daily', 'https://www.sciencedaily.com/rss/all.xml', 'rss', 'bilim', 300),
('NASA Breaking News', 'https://www.nasa.gov/rss/dyn/breaking_news.rss', 'rss', 'bilim', 300),
('Page Six', 'https://pagesix.com/feed/', 'rss', 'magazin', 300),
('Anadolu Ajansı', 'https://www.aa.com.tr/tr/rss/default?cat=guncel', 'rss', 'kultur', 300),
('NTV Teknoloji', 'https://www.ntv.com.tr/teknoloji.rss', 'rss', 'teknoloji', 300),
('Ekonomim', 'https://www.ekonomim.com/rss', 'rss', 'ekonomi', 300);

-- Prompt Şablonları
INSERT INTO prompt_templates (template_name, template_type, category, template_text, variables) VALUES

('teknoloji_makale', 'article', 'teknoloji',
 'Sen bir teknoloji editörüsün. Aşağıdaki haber için SEO uyumlu, bilgilendirici ve okuyucuyu sıkmayan bir makale yaz.

Haber Başlığı: {{title}}
Kaynak: {{source}}
Haber Özeti: {{summary}}

İstenen Çıktı:
1. Ana başlık (max 70 karakter, SEO uyumlu)
2. Meta açıklama (max 160 karakter)
3. Giriş paragrafı (haber özeti, 2-3 cümle)
4. Ana içerik (800-1200 kelime, alt başlıklarla)
5. Sonuç paragrafı
6. 5 SEO anahtar kelime
7. Okuma süresi (dakika)

Ton: Bilgilendirici, yenilikçi, teknik ama anlaşılır
Dil: Türkçe
Format: Markdown',
 '{"title": "string", "source": "string", "summary": "string"}'),

('ekonomi_makale', 'article', 'ekonomi',
 'Sen bir ekonomi editörüsün. Aşağıdaki haber için veri odaklı, analitik bir makale yaz.

Haber Başlığı: {{title}}
Kaynak: {{source}}
Haber Özeti: {{summary}}

İstenen Çıktı:
1. Ana başlık (max 70 karakter)
2. Meta açıklama (max 160 karakter)
3. Giriş (özet, 2-3 cümle)
4. Ana içerik (1000-1500 kelime, verilerle destekli)
5. Sonuç ve değerlendirme
6. 5 SEO anahtar kelime

Ton: Analitik, güvenilir, profesyonel
Dil: Türkçe',
 '{"title": "string", "source": "string", "summary": "string"}'),

('bpt_tarzi_twitter', 'social', 'genel',
 'Aşağıdaki haberi BPT (Breaking/Point/Takeaway) tarzında Twitter/X için optimize et.

Haber: {{title}}
Detay: {{summary}}

İstenen Çıktı:
1. Vurucu başlık cümlesi (max 40 karakter)
2. Ana nokta (1-2 cümle)
3. Alınacak ders/çıkarım (1 cümle)
4. İlgili hashtagler (max 3)

Toplam uzunluk: max 280 karakter
Ton: Net, hızlı, dikkat çekici
Dil: Türkçe',
 '{"title": "string", "summary": "string"}'),

('instagram_carousel', 'social', 'genel',
 'Aşağıdaki haberi Instagram carousel (kaydırmalı gönderi) formatına dönüştür.

Haber: {{title}}
Detay: {{summary}}

İstenen Çıktı (5 slayt):
Slayt 1: Kapak - Dikkat çekici başlık + görsel önerisi
Slayt 2: Ana bilgi - Haberin en önemli kısmı
Slayt 3: Detay - Arka plan/ek bilgi
Slayt 4: Etki - Neden önemli?
Slayt 5: Kapanış - Özet + çağrı (CTA)

Her slayt için metin (max 30 kelime) ve görsel önerisi.
Ton: Görsel, eğlenceli, paylaşılabilir
Dil: Türkçe',
 '{"title": "string", "summary": "string"}'),

('kalite_kontrol_factcheck', 'quality_check', 'genel',
 'Sen bir fact-check uzmanısın. Aşağıdaki haberin doğruluğunu değerlendir.

Haber Başlığı: {{title}}
İçerik: {{content}}
Kaynak: {{source}}

Değerlendirme:
1. Kaynak güvenilir mi? (0-10)
2. İçerikte çelişki var mı?
3. İddialar destekleniyor mu?
4. Manipülatif dil kullanılmış mı? (0-10)
5. Clickbait mi?

JSON çıktısı:
{"source_reliability": 0-10, "has_contradiction": true/false, "manipulation_score": 0-10, "is_clickbait": true/false, "verdict": "güvenilir|şüpheli|güvenilmez", "confidence": 0-1, "notes": "..."}',
 '{"title": "string", "content": "string", "source": "string"}'),

('nihai_hakem', 'quality_check', 'genel',
 'Sen kıdemli bir yayın yönetmenisin. Aşağıdaki denetim sonuçlarını değerlendir ve nihai kararını ver.

İçerik:
- Başlık: {{title}}
- Kategori: {{category}}
- Makale: {{article}}

Denetim Sonuçları:
- Fact-Check: {{fact_check}}
- Hukuk Kontrolü: {{legal_check}}
- İmla & Dil: {{grammar_check}}
- Manipülasyon: {{moderation_check}}

Karar: approve | reject | review
JSON: {"decision": "...", "confidence": 0-1, "reason": "...", "suggestions": ["..."], "requires_human_review": true/false, "publish_immediately": true/false, "risk_level": "low|medium|high"}',
 '{"title": "string", "category": "string", "article": "string", "fact_check": "string", "legal_check": "string", "grammar_check": "string", "moderation_check": "string"}'),

('ogrenme_analizi', 'learning', 'genel',
 'Sen bir eğitim analistisin. Reddedilen içeriği analiz et ve sistem için ders çıkar.

Reddedilen İçerik:
- Başlık: {{title}}
- İçerik: {{content}}
- Kategori: {{category}}

Red Nedenleri: {{rejection_reasons}}

JSON: {"error_type": "...", "lesson_learned": "...", "affected_prompt_type": "...", "prompt_improvement": "...", "severity": 1-10, "preventive_measures": ["..."]}',
 '{"title": "string", "content": "string", "category": "string", "rejection_reasons": "string"}'),

('radyo_metni', 'audio', 'genel',
 'Sen bir radyo haber spikerisin. Aşağıdaki haberi radyo yayın formatına dönüştür.

Haber: {{title}}
İçerik: {{content}}

30-60 saniyelik radyo spotu yaz. Konuşma dili kullan.
Giriş → Gelişme → Kapanış formatında.
150-300 kelime.',
 '{"title": "string", "content": "string"}'),

('düzeltme_önerisi', 'learning', 'genel',
 'Sen bir editörsün. Reddedilen içeriği analiz et ve düzeltilmiş versiyonunu öner.

Reddedilen: {{rejected_content}}
Red Nedeni: {{rejection_reason}}

Düzeltilmiş versiyonu ve değişiklik nedenlerini açıkla.',
 '{"rejected_content": "string", "rejection_reason": "string"}');
