# WeatherTest (Flutter)

Aplikasi cuaca dengan tampilan glassmorphism + gradient, aksen **floating glows**, dan **dua kartu cuaca sekaligus**: **lokasi saat ini** (GPS) serta **hasil pencarian kota**. State dikelola dengan **Riverpod**.

---

## ✨ Fitur

- 📍 Otomatis memuat **cuaca lokasi saat ini** saat aplikasi dibuka
- 🔎 **Pencarian kota** dan menampilkan hasilnya bersamaan dengan lokasi saat ini
- 🎛️ UI modern: glass card, gradient background, floating glows


---

## 🛠️ Teknologi

- Flutter 3.x
- Riverpod (state management)
- intl (format tanggal/waktu)
- OpenWeather API (Current Weather Data)
- Geolocator (lokasi perangkat)

## 📦 Struktur Project (ringkas)
ib/
├─ core/
│ ├─ models/ # Weather
│ ├─ repository/ # WeatherRepository (OpenWeather)
│ └─ services/ # LocationService (geolocator)
├─ features/
│ └─ home/
│ ├─ controller/ # HomeController
│ ├─ widgets/ # background_gradient, floating_glows, hero card, dll
│ ├─ weather_controller.dart
│ └─ home_page.dart
└─ utils/ # error helper, time provider

---

## 🎬 Demo

<p align="center">
  <img src="D:\flutter\technicaltest\weather\assets\screenshot\weather.gif" alt="WeatherTest Demo" width="360"/>
</p>

## 🖼️ Screenshots

<p align="center">
  <img src="D:\flutter\technicaltest\weather\assets\screenshot\homepage.jpeg" alt="Home" width="280"/>
  <img src="D:\flutter\technicaltest\weather\assets\screenshot\loginpage.jpeg" alt="Search Result" width="280"/>
</p>