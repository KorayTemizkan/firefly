<img width="512" height="512" alt="FireFly_by_KorayTemizkan" src="https://github.com/user-attachments/assets/53d14c45-4feb-4bc8-b845-2b00d88edb08" />

# FireFly

Bu proje, modern ve ölçeklenebilir bir **Firebase tabanlı anlık mesajlaşma uygulamasıdır**. Flutter mimarisinde Clean Architecture prensipleri gözetilerek geliştirilmiş olup; gerçek zamanlı veritabanı yönetimi, kimlik doğrulama, yapay zeka entegrasyonu ve dinamik yapılandırma özellikleri sunar.

---

## 📋 Temel Özellikler

* **Gerçek Zamanlı Sohbet:** Firestore entegrasyonu ile anlık mesajlaşma, dosya ve görsel paylaşımı.
* **Bağlantı Yönetimi:** Kullanıcı arama, bağlantı istekleri gönderme, onaylama ve reddetme süreçleri.
* **Yapay Zeka Destekli Deneyim:** `FirebaseAiService` ile zenginleştirilmiş sohbet özellikleri.
* **Akıllı Bildirimler:** Firebase Cloud Messaging (FCM) ile bildirim yönetimi ve uygulama içi şık Snackbar bildirimleri.
* **Uzaktan Yapılandırma:** Firebase Remote Config ile uygulama ayarlarını (mesajlar, görseller, görünümler) kod değişikliği gerektirmeden dinamik olarak güncelleme.
* **Güvenli Kimlik Doğrulama:** `firebase_ui_auth` ile email tabanlı giriş/kayıt sistemi ve profil yönetimi.
* **Hata Yönetimi:** Firebase Crashlytics entegrasyonu ile gerçek zamanlı hata raporlama.

---

## 🛠 Teknik Yığın (Tech Stack)

* **State Management:** `flutter_bloc` (Cubit yaklaşımı)
* **Dependency Injection:** `get_it` (Singleton ve Factory desenleri)
* **Navigation:** `auto_route` (Tip güvenli ve modüler yönlendirme)
* **UI/UX:**
* `flutter_chat_ui` (Sohbet arayüzü)
* `cached_network_image` (Önbellekli resim yönetimi)
* `photo_view` (Tam ekran ve zoom edilebilir görseller)


* **Backend:** Firebase (Firestore, Auth, Messaging, Remote Config, Crashlytics)

---

## 📂 Proje Yapısı

Proje, kodun okunabilirliğini ve modülerliğini artırmak için **Feature-First** yaklaşımıyla yapılandırılmıştır:

```text
lib/
├── config/             # Rota ve uygulama konfigürasyonları
├── core/               # Servisler, ağ katmanı, widgetlar ve yardımcılar (utils)
├── features/           # Özellik bazlı modüller:
│   ├── auth/           # Giriş ve kayıt işlemleri
│   ├── chat/           # Mesajlaşma ve medya gönderimi
│   ├── home/           # Sohbetler, istekler ve kullanıcı listesi
│   ├── notification/   # Bildirim yönetimi
│   └── remote_config/  # Uzaktan yapılandırma süreçleri
└── injection_container.dart # Bağımlılık enjeksiyon merkezi (sl)

```

---

## ⚙️ Kurulum

1. **Repo'yu Klonlayın:**
```bash
git clone <proje-url>

```


2. **Bağımlılıkları Yükleyin:**
```bash
flutter pub get

```


3. **Firebase Entegrasyonu:**
* Projenizi Firebase Console üzerinden oluşturun.
* `google-services.json` (Android) ve `GoogleService-Info.plist` (iOS) dosyalarını ilgili dizinlere yerleştirin.


4. **Uygulamayı Çalıştırın:**

```bash
    flutter run
    ```

---

*Bu proje, geliştirilmeye devam eden bir çalışma olup, Flutter ve Firebase ekosisteminin en iyi uygulamalarını (best practices) temel almaktadır.*

```
