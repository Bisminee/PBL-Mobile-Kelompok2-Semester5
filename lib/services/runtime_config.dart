/// Status konfigurasi Firebase untuk seluruh aplikasi.
///
/// Diisi sekali saat `main()` berjalan. Bila `google-services.json` belum ada,
/// `Firebase.initializeApp()` gagal dan nilai ini menjadi false. Halaman login
/// memakainya untuk menampilkan pintu masuk "Mode uji tanpa Firebase", supaya
/// developer tetap bisa mencoba aplikasi tanpa menyiapkan Firebase lebih dulu.
bool firebaseReady = false;
