//
//  Weather.swift
//  Yash_Mistry_FE_8931383
//
//  Created by user240111 on 12/6/23.
//

import UIKit

import CoreLocation

struct WeatherData: Codable {
    let main: Mainn
    let wind: Wind
    let name: String
    let weather: [jsonWeather]
    
}

struct Mainn: Codable {
    let temp: Double
    let humidity: Int

}

struct Wind: Codable {
    let speed: Double
}

struct jsonWeather: Codable {
    let main: String
    let description: String
    let icon: String
}

class Weather: UIViewController, CLLocationManagerDelegate {
    
    // Segue data variable
    var cityName: String?
    var source : String?
    
    // CoreData Initialization for Weather
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    // Save data in CoreData
    func saveDataWeatherCD(_ cityName:String,_ humidity:Int,_ temperature:Int, _ wind:Int, _ sourceOfTranscation:String) {

        let weatherr = DataForWeather(context: self.content)
        
        weatherr.cityName = cityName
        weatherr.humidity = Int32(humidity)
        weatherr.temperature = Int32(temperature)
        weatherr.wind = Double(wind)
        weatherr.typeOfInteraction = "Weather"
        weatherr.sourceOfTransaction = sourceOfTranscation
        weatherr.timeStamp = Date()

        do {
            try self.content.save()
            print("data saved in Weather.")
            print(weatherr.humidity )
        } catch {
            print("error: \(error)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()

        DisplayWeatherData(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    // function to fetch data from URL
    func DisplayWeatherData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    
        let apiUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName ?? "california")&appid=4451717c65ae546256e4b5cc2060b8d5")!
       
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
        windLabel.text = "Wind: \(Int(windSpeedInKMH)) km/h"
        
        if cityName.lowercased() != "california"{
            
            // saving data in core data
            saveDataWeatherCD(cityName, humidity,Int(temperatureInCelsius) ,Int(windSpeedInKMH), source ?? "From Weather")
            // Setting icon from url
            if let iconUrl = URL(string: "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png") {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: iconUrl) {
                        DispatchQueue.main.async {
                            self.iconImageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }}
    func kelvinToCelsius(_ kelvin: Double) -> Double {
        return kelvin - 273.15
    }
    
    func MeterPerSecToKmPerHour(_ metersPerSecond: Double) -> Double {
        return metersPerSecond * 3.6
    }
    
    // Alert box for city name input
    @IBAction
    func getWeatherAlertBox(_ sender: UIButton) {
        let myAlertControl = UIAlertController(title: "Where would you like to go", message: "Enter here new destination here", preferredStyle: .alert)
        
        myAlertControl.addTextField { textField in
            textField.placeholder = ""
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            if let textField = myAlertControl.textFields?.first {
                if let text = textField.text {
                    self.cityName = text
                    self.DisplayWeatherData(latitude: 0, longitude: 0)
                }
            }
        }
     
        myAlertControl.addAction(cancelButton)
        myAlertControl.addAction(okButton)
        
  
        present(myAlertControl, animated: true, completion: nil)
    }
}


    
