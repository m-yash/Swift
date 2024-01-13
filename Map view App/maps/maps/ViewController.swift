//
//  ViewController.swift
//  maps
//
//  Created by user240111 on 11/9/23.
//

import UIKit

import CoreLocation

import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var CurrentSpeedVar: UILabel!
    @IBOutlet weak var MaxSpeedVar: UILabel!
    @IBOutlet weak var AverageSpeedVar: UILabel!
    @IBOutlet weak var DistanceVar: UILabel!
    @IBOutlet weak var MaxAccelerationVar: UILabel!
    
    @IBOutlet weak var RedAlertVar: UILabel!
    @IBOutlet weak var GreenAlertVar: UILabel!


    var locationManager = CLLocationManager ()
    
    var MaximumSpeed: CLLocationSpeed = 0.0
    
    var LastSpeed: CLLocationSpeed?
    var MaxAcceleration: CLLocationSpeed = 0.0
    
    var AverageSpeedArray: [CLLocationSpeed] = []
    var AverageSpeed: CLLocationSpeed {
        return AverageSpeedArray.reduce(0, +) / Double(AverageSpeedArray.count)
    }
    
    var Distance: CLLocationDistance = 0.0
    var previousLocation: CLLocation?

    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        RedAlertVar.isHidden = true
        map.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func StartTrip(_ sender: UIButton) {

        map.showsUserLocation = true
        locationManager.startUpdatingLocation()
        RedAlertVar.isHidden = true
        GreenAlertVar.backgroundColor = UIColor.green
        }

        @IBAction func StopTrip(_ sender: UIButton) {
            map.showsUserLocation = false

            locationManager.stopUpdatingLocation()
            RedAlertVar.isHidden = true
            GreenAlertVar.backgroundColor = UIColor.lightGray
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print (locations)
            if let location = locations.last {
                
                let CurrentSpeed = location.speed
                let CurrentSpeedInKMH = CurrentSpeed * 3.6
                
                // Current Speed
                CurrentSpeedVar.text = String(format: "%.2f km/h", CurrentSpeedInKMH)
                
                // Maximum Speed
                if CurrentSpeed > MaximumSpeed{
                    MaximumSpeed = CurrentSpeed
                    let MaximumSpeedinKMH = MaximumSpeed * 3.6
                    
                    MaxSpeedVar.text = String(format: "%.2f km/h", MaximumSpeedinKMH)
                }
                
                // Average Speed
                AverageSpeedArray.append(CurrentSpeed)
                let AverageSpeedinKMH = AverageSpeed * 3.6
                AverageSpeedVar.text = String(format: "%.2f km/h", AverageSpeedinKMH)
                
                // Distance
                if let previousLocation = previousLocation {
                    Distance += location.distance(from: previousLocation)
                }
                DistanceVar.text = String(format: "%.2f km", Distance / 1000.0)
                previousLocation = location
                
                // Max Acceleration
                if let LastSpeed = LastSpeed {
                    let speedDifference = abs(CurrentSpeed - LastSpeed)
                    let timeInterval = 1.0
                    let acceleration = speedDifference / timeInterval
                    MaxAcceleration = max(MaxAcceleration, acceleration)
                    MaxAccelerationVar.text = String(format: "%.2f m/s²", MaxAcceleration)
                }
                LastSpeed = CurrentSpeed
                
                // Red Alert
                if CurrentSpeedInKMH > 115{
                    RedAlertVar.isHidden = false
                }
                else{
                    RedAlertVar.isHidden = true
                }
                render(location)
            }
        }
    
    func render (_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude )

        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)

        let region = MKCoordinateRegion(center: coordinate, span: span)
        let pin = MKPointAnnotation ()
        pin.coordinate = coordinate
        map.addAnnotation(pin)
        

        map.setRegion(region, animated: true)

        

    }


}

