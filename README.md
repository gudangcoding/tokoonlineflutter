# Tokoonline — Alur Pembelajaran

Dokumen ini menjelaskan alur pembelajaran proyek Tokoonline dari awal: persiapan folder, persiapan logika (repository, Bloc, DI), hingga mempresentasikan data ke UI. Cocok sebagai panduan belajar arsitektur Flutter yang rapi dan scalable.

## 1) Persiapan Lingkungan & Folder

- Instal Flutter SDK dan pastikan `flutter doctor` hijau.
- Clone atau buka folder proyek ini.
- Jalankan pemasangan dependency: `flutter pub get`.
- Menjalankan aplikasi:
  - Mobile/Chrome: `flutter run -d chrome`
  - Web server lokal: `flutter run -d web-server --web-hostname=localhost --web-port=9002`

Struktur folder utama yang digunakan:

- `lib/core/`
  - `config/`: konfigurasi aplikasi.
  - `di/`: dependency injection (GetIt). Lihat `core/di/injection.dart`.
  - `network/`: klien HTTP (`ApiClient`) berbasis `Dio`.
  - `theme/`: tema aplikasi.
- `lib/data/`
  - `auth/`, `products/`: implementasi data source (remote) dan repository konkret.
- `lib/domain/`
  - `auth/`, `products/`: kontrak repository dan entity domain.
- `lib/presentation/`
  - `auth/`, `cart/`, `products/`, `profile/`, `navigation/`, `component/`, `dashboard/`, `splash/`.
  - Layer UI + state management (Bloc/Event/State) per fitur.

## 2) Arsitektur & Persiapan Logika

Pendekatan yang dipakai: layering Data–Domain–Presentation dengan Repository Pattern, DI (GetIt), dan state management Bloc.

- Dependency Injection (DI)
  - `configureDependencies()` di `core/di/injection.dart` mendaftarkan `ApiClient`, repository, dan Bloc.
  - Di `main.dart`, `MultiBlocProvider` membuat Bloc tersedia global.

- Jaringan & Repository
  - `ApiClient` (Dio) mengatur base URL, header, dan menyimpan token (SharedPreferences).
  - Produk:
    - `data/products/product_remote_data_source.dart`: metode `fetchProducts({query, page, limit})` dan `fetchProductDetail(id)` memanggil endpoint `/products` dan `/products/:id`.
    - `data/products/product_repository_impl.dart`: memetakan respons ke `domain/products/product_entity.dart`.
    - `domain/products/product_repository.dart`: kontrak `getProducts({query, page, limit})` dan `getProductDetail(id)`.
  - Auth:
    - `data/auth/auth_remote_data_source.dart`: login ke `/customers/login`, mengambil `token` dan (opsional) `customerId`.

- State Management (Bloc)
  - Produk (`presentation/products/bloc/*`):
    - Event: `LoadProducts`, `LoadProductDetail`, `LoadMoreProducts`, `RefreshProducts`.
    - State: `ProductState` menyimpan `products`, `detail`, `status`, `page`, `hasMore`, `isLoadingMore`, `isRefreshing`, `query`.
    - Bloc: memuat halaman pertama, memuat berikutnya (infinite scroll), dan refresh (pull-to-refresh).
  - Keranjang (`presentation/cart/bloc/*`):
    - Event: `AddToCart`, `RemoveFromCart`, `ClearCart`, `CheckoutRequested`.
    - Bloc: hitung total, kirim payload checkout ke `/checkout`, serta notifikasi sukses/gagal.
  - Auth (`presentation/auth/bloc/*`):
    - `AuthStatus { unknown, authenticated, unauthenticated, loading, error }` untuk kontrol redirect.

## 3) Menyajikan Data ke UI

- Navigasi
  - `presentation/navigation/app_router.dart` memakai GoRouter dengan redirect berdasarkan `AuthStatus`.
  - Rute penting: `/login`, `/register`, `/` (dashboard), `/product/:id`, `/checkout`, `/profile`.

- Halaman Produk (Beranda)
  - `presentation/products/pages/products_page.dart`:
    - Pencarian & kategori horizontal.
    - Grid produk dengan `BlocBuilder<ProductBloc, ProductState>`.
    - Infinite scroll: saat mendekati bawah, kirim `LoadMoreProducts`.
    - Pull-to-refresh: `RefreshIndicator` memicu `RefreshProducts`.
    - Item loader di akhir grid saat `hasMore == true`.

- Detail Produk
  - `presentation/products/pages/product_detail_page.dart`: menampilkan gambar, nama, harga, deskripsi, dan tombol “Tambah ke Keranjang”.

- Keranjang & Checkout
  - `presentation/cart/pages/cart_page.dart`: daftar item, subtotal, aksi hapus.
  - `presentation/cart/pages/checkout_page.dart`: validasi alamat, metode pembayaran, dan panggil `CheckoutRequested`.

- Login (Sesuai Desain)
  - `presentation/auth/pages/login_page.dart`: header bergelombang (`AppWaveHeader`), logo, form dalam kartu, input berikon, tombol biru bundar, tautan lupa password/daftar.
  - `presentation/component/app_text_input.dart`: mendukung `prefixIcon` untuk email/password.

- Profil & Upload Foto
  - `presentation/profile/pages/profile_page.dart`: pratinjau foto, pilih dari galeri/kamera, dan unggah.

## 4) API yang Digunakan (Contoh)

- `GET /products?q=<query>&page=<page>&limit=<limit>` — daftar produk.
- `GET /products/:id` — detail produk.
- `POST /customers/login` — login, mengembalikan token.
- `POST /checkout` — kirim item keranjang, total, alamat, dan metode pembayaran.

Catatan: Sesuaikan nama parameter (`page`, `limit`, `q`) dengan backend Anda bila berbeda (misal `per_page`).

## 5) Langkah Uji Cepat

- Jalankan aplikasi (`flutter run -d chrome`), pastikan diarahkan ke `/login` saat belum login.
- Login, masuk ke dashboard `/`. Coba scroll Beranda hingga bawah untuk melihat infinite load.
- Tarik dari atas untuk refresh list produk.
- Buka detail produk, tekan “Tambah ke Keranjang”, lalu cek keranjang.
- Lengkapi checkout (alamat + metode), tekan “Bayar Sekarang”.
- Buka Profil, coba unggah foto profil.

## 6) Tips & Praktik Baik

- Pastikan error dari network (`DioException`) ditangani dan ditampilkan dengan snackbar.
- Gunakan `LayoutBuilder`/`ListView` pada halaman detail agar responsif di layar kecil.
- Jaga konsistensi limit (`8`) agar sesuai dengan grid dan pengalaman scroll.
- Simpan `query` di state agar hasil pencarian konsisten saat `LoadMore` dan `Refresh`.

## 7) Referensi

- Flutter docs: https://docs.flutter.dev/
- Bloc: https://bloclibrary.dev/
- Dio: https://pub.dev/packages/dio
- GoRouter: https://pub.dev/packages/go_router
