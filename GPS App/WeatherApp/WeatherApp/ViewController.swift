//
//  ViewController.swift
//  WeatherApp
//
//  Created by user240111 on 11/15/23.
//

import UIKit
import CoreLocation

struct WeatherData: Codable {
    let main: Main
    let wind: Wind
    let name: String
    let weather: [Weather]
    
}

struct Main: Codable {
    let temp: Double
    let humidity: Int

}

struct Wind: Codable {
    let speed: Double
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()

        DisplayWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }

    func DisplayWeatherData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let apiUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=4451717c65ae546256e4b5cc2060b8d5")!
       
        let task = URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }

            guard let data = data else {
                print("No data")
                return
            }

            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.updateUI(with: weatherData)
                }
            } catch {
                print(error)
            }
        }

        task.resume()
    }

    func updateUI(with weatherData: WeatherData) {
        // JSON data
        let temperature = weatherData.main.temp
        let temperatureInCelsius = kelvinToCelsius(temperature)
        let windSpeed = weatherData.wind.speed
        let windSpeedInKMH = MeterPerSecToKmPerHour(windSpeed)
        let cityName = weatherData.name
        let humidity = weatherData.main.humidity
        let weatherDescription = weatherData.weather.first?.main ?? "N/A"
        
        
        // Icon
        let weatherIcon = weatherData.weather.first?.icon ?? "01d"
        
        cityNameLabel.text = cityName
        descriptionLabel.text = weatherDescription
        temperatureLabel.text = "\(Int(temperatureInCelsius))°"
        humidityLabel.text = "Humidity: \(humidity)%"
        windLabel.text = "Wind: \(windSpeedInKMH) km/h"
        print("Temperature: \(Int(temperatureInCelsius))°")
        print("Wind Speed: \(Int(windSpeedInKMH)) km/h")
        print("Humidity: \(humidity) %")
        print("City Name: \(cityName)")
        print("Weather Description: \(weatherDescription)")
    

        // Load weather icon from URL
        if let iconUrl = URL(string: "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: iconUrl) {
                    DispatchQueue.main.async {
                        self.iconImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    func kelvinToCelsius(_ kelvin: Double) -> Double {
        return kelvin - 273.15
    }
    
    func MeterPerSecToKmPerHour(_ metersPerSecond: Double) -> Double {
        return metersPerSecond * 3.6
    }
}
