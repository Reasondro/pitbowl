# Pitbowl

**Pitbowl** adalah aplikasi berbasis Flutter yang bertujuan untuk menghubungkan **investor** dengan **UMKM di Indonesia**. Aplikasi ini memungkinkan UMKM untuk mempresentasikan ide bisnis mereka ("Pitch") kepada calon investor yang tertarik.

## 📌 Fitur Utama

1. **Pitch & Investasi**
   - UMKM dapat membuat **pitch** baru melalui fitur **New Pitch**.
   - Investor dapat melihat daftar pitch yang tersedia dan memilih untuk berinvestasi.

2. **Feed & Market**
   - Terdapat **feed** yang menampilkan pitch terbaru dari UMKM.
   - Investor dapat melihat informasi bisnis UMKM secara lebih mendalam di halaman **Market**.

3. **Profil Pengguna & Portofolio**
   - Setiap pengguna memiliki **profil** yang dapat diedit.
   - Investor dapat melihat **portofolio investasi** mereka dalam aplikasi.

4. **Video Pitch & Detail Post**
   - UMKM dapat mengunggah video pitch sebagai presentasi bisnis mereka.
   - Investor dapat melihat **detail pitch** sebelum berinvestasi.

5. **Autentikasi & Splash Screen**
   - Aplikasi menggunakan **Firebase Authentication** untuk login.
   - Terdapat **Splash Screen** untuk pengalaman pengguna yang lebih baik.

---

## 📂 Struktur Direktori

```bash
lib/
├── data/
│   └── dummy_data.dart               # Data dummy untuk testing
│
├── model/
│   └── pitch.dart                    # Model untuk Pitch UMKM
│
├── providers/
│   └── user_pitch.dart               # Provider untuk state management pitch
│
├── screens/
│   ├── auth_screen.dart              # Layar autentikasi (login/register)
│   ├── new_pitch_screen.dart         # Layar untuk membuat pitch baru
│   ├── pitbowl_screen.dart           # Layar utama aplikasi
│   ├── post_detail_screen.dart       # Layar untuk melihat detail pitch
│   ├── splash_screen.dart            # Layar splash saat aplikasi pertama dibuka
│
├── widgets/
│   ├── feed_item.dart                # Widget untuk setiap item di feed
│   ├── feed_list.dart                # Widget daftar feed pitch
│   ├── invest_sheet.dart             # Widget untuk modal investasi
│   ├── market.dart                   # Widget tampilan market UMKM
│   ├── pitch_placeholder.dart        # Widget placeholder untuk pitch kosong
│   ├── user_portfolio.dart           # Widget portofolio investasi user
│   ├── user_profile.dart             # Widget untuk menampilkan profil user
│   ├── user_video_input.dart         # Widget input video untuk pitch
│   ├── video_player.dart             # Widget untuk memutar video pitch
│
├── firebase_options.dart             # Konfigurasi Firebase
├── main.dart                         # Entry point aplikasi
```

---

## 🚀 Cara Menjalankan Aplikasi

1. **Clone** repositori ini:
   ```bash
   git clone https://github.com/your-repository/pitbowl.git
   cd pitbowl
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Jalankan aplikasi**:
   ```bash
   flutter run
   ```

> **Catatan**: Pastikan Anda sudah mengkonfigurasi **Firebase** di `firebase_options.dart` sebelum menjalankan aplikasi.

---

## 🛠 Teknologi yang Digunakan

- **Flutter** (Dart)
- **Firebase Authentication** (untuk login pengguna)
- **Firebase Firestore** (untuk menyimpan data pitch dan investasi)
- **Provider** (State Management)
- **Video Player Package** (untuk menampilkan video pitch)

---

## 📌 Kontribusi

Jika Anda ingin berkontribusi pada proyek ini:

1. **Fork** repositori ini.
2. **Buat branch** baru untuk fitur atau perbaikan Anda.
3. **Commit** perubahan Anda dan buat **pull request**.

Kami menghargai setiap kontribusi! 🚀

---

## 📜 Lisensi

Proyek ini dilisensikan di bawah [MIT License](LICENSE). Anda dapat menggunakan dan memodifikasi kode ini sesuai kebutuhan.

---

💡 **Pitbowl - Membantu UMKM Bertumbuh & Menghubungkan Investor dengan Kesempatan Baru!**

