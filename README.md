
![Cloudie Cover](https://github.com/user-attachments/assets/9d74ddb3-fc4c-453a-b8c5-796a4774bacd)

# ☁️ Cloudie - Weather App

A full-featured weather forecast application built using Flutter and Dart, powered by the OpenWeatherMap API. This app provides real-time weather data including temperature, humidity, wind speed, and pressure with a modern, responsive UI. Designed using the MVVM architecture and Provider for state management to ensure clean and scalable code.

## 🔧 Features

- Live Weather Updates
- Displays real-time temperature, weather conditions, wind speed, humidity, and pressure.

- City Search with Auto-Suggestions
- Search for any city using dynamic suggestions and instant weather results.

- Current Location Detection
- Automatically fetches weather data based on the user's current geolocation.

- Responsive UI
- Modern, adaptive interface that fits perfectly across different screen sizes and orientations.

- Robust Error Handling
- Gracefully handles empty search inputs, network issues, or failed API responses.

## 🚀 Tech Stack

- **Flutter** - UI framework
- **Dart** - Programming language
- **OpenWeatherMap API** (or similar) for weather data
- **HTTP package** for API calls
- **Providert**  State managemen
- **MVVM Architecture** Clean code structure

##  Screenshort

|  ![Picsart_25-05-29_17-21-30-982](https://github.com/user-attachments/assets/4aee7881-8b02-44f8-ab93-c82b567d98bf) |

## 🛠️ How It Works

1. The user enters a city name.
2. The app fetches weather data from the API using the API key.
3. The weather conditions and temperature are displayed on the screen.


## 📦 Folder Structure

- lib/
- ├── binding/
- ├── common/
- │ ├── style/
- │ └── widgets/
- ├── data/
- │ ├── repositories/
- │ └── services/
- ├── features/
- │ ├── auth/
- | |   ├── controllers/
- │ |   ├── models/
- │ |   └── screens/
- │ ├── personalization/
- | |   ├── controllers/
- │ |   ├── models/
- │ |   └── screens/
- │ └── App/
- | |   ├── controllers/
- │ |   ├── models/
- │ |   └── screens/
- ├── localization/
- ├── utils/
- │ ├── constant/
- │ ├── devices/
- │ ├── formatters/
- │ ├── helpers/
- │ ├── http/
- │ ├── local-storage/
- │ ├── logging/
- │ ├── theme/
- │ └── validators/
- └── main.dart
