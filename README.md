# MyWeatherApp 2.0

# Overview

MyWeatherApp has been developed as a fulfilment of a Mobile assessment showcasing knowledge in IOS Development.

The App provides the Weather of a user's current location alongside a 5 day forecast of the same location. It also has two themes Forest and Sea with weather changes of a location being visually represented via the images and icons provided.

## Run the App

Pull or download the project to your machine and run 'MyWeatherApp.xcodeproj' using XCode. Build and run the app on the preferred simulator or device (NOTE: You'll have to register the AppID with your Developer ID to run it on your Device).

## App Use

MyWeatherApp will ask for location permissions on launch. After the permissions are provided, two calls are made to [OpenWeather](https://openweathermap.org), one for current user's location weather and another for a 5 day 3 hourly forecast of the same location. These details are then presented to the user. Depending on the weather, the images, icons and color change to reflect the same.

On the Settings page, one can change between Forest and Sea themes. Additionally one can change the Units between Metric and Imperial. These settings are persisted using UserDefaults.

One can also interact with the Favorites page where one can add and persist a Favorite City using [Open Street Maps (Nominatim)](https://nominatim.openstreetmap.org) along with its current Weather.

## Endpoints

- [OpenWeather](https://openweathermap.org)
- [Open Street Maps (Nominatim)](https://nominatim.openstreetmap.org)

## Persistence

- UserDefaults have been used to save the Theme and Units Settings as long as Current City Weather and Favorite Cities.

## Tech and Structures
- [x] URLSession
- [X] RESTful APIs
- [x] SwiftUI
- [x] Combine
- [x] MVVM Architecture
- [x] UserDefaults

## Screenshots

![Simulator Screenshot - iPhone 16 Pro - 2025-01-13 at 12 47 56](https://github.com/user-attachments/assets/b0061903-5aa5-43ae-bf9a-d56098632db8)
![Simulator Screenshot - iPhone 16 Pro - 2025-01-13 at 12 48 00](https://github.com/user-attachments/assets/65300b11-1aff-4cfb-95ab-c92bb0a20db5)
![Simulator Screenshot - iPhone 16 Pro - 2025-01-13 at 12 48 29](https://github.com/user-attachments/assets/efaae247-c965-47a2-a0fe-ede496991788)
![Simulator Screenshot - iPhone 16 Pro - 2025-01-13 at 12 48 04](https://github.com/user-attachments/assets/7bf832b8-508f-4304-9fe2-7a5cc11df5b8)
