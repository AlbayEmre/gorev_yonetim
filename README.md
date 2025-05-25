# ✅ Görev Yönetim Uygulaması

**Görev Yönetim**, Flutter ile geliştirilmiş, **Firebase tabanlı**, modern, çok özellikli ve çok dilli bir görev (task) takip uygulamasıdır. Kullanıcılar görev oluşturabilir, ses kaydı ekleyebilir, fotoğraf yükleyebilir ve Firebase üzerinden gerçek zamanlı olarak veriyle etkileşim kurabilir. Proje; **BLoC yapısı**, **clean code prensipleri**, **modüler yapı**, **çoklu platform desteği** ve **modern UI/UX bileşenleriyle** donatılmıştır.

---

## 🧠 Temel Teknolojiler

- 📱 **Flutter 3.4.4+**
- 🔥 **Firebase Core, Auth, Firestore, Storage, Remote Config**
- ⚙️ **flutter_bloc + Equatable** ile state management
- 🎙️ **Ses kaydı ve oynatma** (flutter_sound, audioplayers, record)
- 🌐 **Google ile Giriş** (google_sign_in)
- 🧳 **Yerel veri saklama** (Hive, path_provider, shared_preferences)
- 🌍 **Çoklu dil desteği** (easy_localization + auto_localized)
- 🖼️ **Fotoğraf yükleme** (image_picker + firebase_storage)
- 📶 **İnternet kontrolü** (connectivity_plus)
- 🪄 Animasyonlar, özel butonlar, lottie entegrasyonu

---

## 🚀 Özellikler

- ✅ Görev oluşturma, silme ve güncelleme
- 🔐 E-posta ve Google hesabıyla giriş
- 🔊 Göreve ses kaydı ekleme ve dinleme
- 📸 Göreve fotoğraf ekleme
- 📊 Gerçek zamanlı veri senkronizasyonu (Firestore)
- 🌍 Türkçe ve İngilizce dil desteği
- 🆕 Firebase Remote Config ile güncelleme kontrolü
- 🎨 Modern UI, responsive yapı
- 🔗 Local ve remote veri yönetimi

---

## 📦 Kurulum

```bash
# 1. Projeyi klonla
git clone https://github.com/AlbayEmre/gorev_yonetim.git
cd gorev_yonetim

# 2. Bağımlılıkları yükle
flutter pub get

# 3. Uygulamayı başlat
flutter run


lib/
├── main.dart                    # Giriş noktası
├── core/                        # Temalar, sabitler, helper'lar
├── features/
│   ├── auth/                    # Giriş / kayıt / kullanıcı yönetimi
│   ├── home/                    # Ana ekran, görev listesi
│   ├── task/                    # Görev verileri, servisleri, detayları
│   ├── voice/                   # Ses kaydı modülleri
├── blocs/                       # BLoC yapılandırmaları
├── widgets/                     # Ortak widgetlar
├── models/                      # Veri modelleri
├── localization/                # Çeviri dosyaları ve servisleri
├── services/                    # Firebase servisleri, API katmanı
└── routes/                      # Sayfa yönlendirmeleri

```
 Firebase Özellikleri
🔐 firebase_auth – e-posta ve Google ile giriş

🔥 cloud_firestore – görev verileri

🗂️ firebase_storage – fotoğraf ve ses dosyaları

⚙️ firebase_remote_config – sürüm/güncelleme kontrolü

 Ses Özellikleri
Kayıt: flutter_sound, record

Oynatma: audioplayers

İzinler: permission_handler

Dosya yolu: path_provider

 Network & Durum
connectivity_plus: Ağ bağlantı kontrolü

fluttertoast: Geri bildirim mesajları
