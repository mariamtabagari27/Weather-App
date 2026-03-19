//
//  ContentView.swift
//  WeatherApp
//
//  Created by Mariam on 07/11/25.
//

import SwiftUI

// MARK: - MAIN VIEW
struct ContentView: View {
    @State private var isNight = false
    @State private var temperature = 22

    var body: some View {
        ZStack {
            AnimatedBackground(isNight: $isNight)
            
            VStack {
                CityTextView(cityName: "Como, IT")

                MainWeatherStatusView(
                    imageName: isNight ? "moon.stars.fill" : "cloud.sun.fill",
                    temperature: temperature
                )

                // WEEKLY SCROLLING FORECAST
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(weekData) { day in
                            WeatherDayView(dayOfWeek: day.name,
                                           imageName: day.icon,
                                           temperature: day.temp)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()

                // WEATHER INFO ROWS
                VStack(spacing: 12) {
                    WeatherInfoRow(icon: "humidity", title: "Humidity", value: "62%")
                    WeatherInfoRow(icon: "wind", title: "Wind", value: "14 km/h")
                    WeatherInfoRow(icon: "sun.max", title: "UV Index", value: "3")
                }
                .padding(.horizontal)
                .padding(.top, 10)

                Spacer()

                // TOGGLE DAY/NIGHT BUTTON
                Button {
                    withAnimation(.easeInOut(duration: 1)) {
                        isNight.toggle()
                        temperature = isNight ? 16 : 22
                    }
                } label: {
                    WeatherButton(title: "Change Day Time",
                                  textColor: .blue,
                                  backgroundColor: .white)
                }

                Spacer()
            }
        }
    }
}

// MARK: - ANIMATED BACKGROUND WITH MOVING STARS
struct AnimatedBackground: View {
    @Binding var isNight: Bool
    @State private var move = false
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: $isNight)

            if isNight {
                Image(systemName: "sparkles")
                    .font(.system(size: 200))
                    .foregroundColor(.white.opacity(0.25))
                    .offset(x: move ? -70 : 70, y: move ? -120 : 120)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 4).repeatForever()) {
                            move.toggle()
                        }
                    }
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - COMPONENTS

struct WeatherDayView: View {
    var dayOfWeek: String
    var imageName: String
    var temperature: Int

    var body: some View {
        VStack {
            Text(dayOfWeek)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 50)
            Text("\(temperature)°")
                .font(.system(size: 29, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

struct BackgroundView: View {
    @Binding var isNight: Bool

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                isNight ? .black : .blue,
                isNight ? .gray : Color("lightBlue")
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct CityTextView: View {
    var cityName: String

    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium))
            .foregroundColor(.white)
            .padding()
    }
}

struct MainWeatherStatusView: View {
    var imageName: String
    var temperature: Int

    var body: some View {
        VStack(spacing: 1) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 170, height: 160)

            Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.bottom, 40)
    }
}

struct WeatherButton: View {
    var title: String
    var textColor: Color
    var backgroundColor: Color

    var body: some View {
        Text(title)
            .frame(width: 290, height: 50)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .font(.system(size: 23, weight: .bold))
            .cornerRadius(50)
    }
}

// MARK: - INFO ROW
struct WeatherInfoRow: View {
    var icon: String
    var title: String
    var value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .foregroundColor(.white)
        }
        .font(.system(size: 20))
        .padding(.horizontal)
    }
}

// MARK: - WEEK DATA MODEL
struct DayWeather: Identifiable {
    var id = UUID()
    var name: String
    var icon: String
    var temp: Int
}

let weekData = [
    DayWeather(name: "MON", icon: "cloud.sun.fill", temp: 21),
    DayWeather(name: "TUE", icon: "sun.max.fill", temp: 25),
    DayWeather(name: "WED", icon: "wind.snow", temp: 19),
    DayWeather(name: "THU", icon: "sunset.fill", temp: 23),
    DayWeather(name: "FRI", icon: "cloud.rain.fill", temp: 18),
    DayWeather(name: "SAT", icon: "cloud.sun.rain.fill", temp: 17),
    DayWeather(name: "SUN", icon: "sun.max.fill", temp: 26)
]

// MARK: - PREVIEW
#Preview {
    ContentView()
}
