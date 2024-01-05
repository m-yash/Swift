//
//  Direction.swift
//  Yash_Mistry_FE_8931383
//
//  Created by user240111 on 12/6/23.
//

import UIKit
import MapKit
import CoreLocation

class Map : UIViewController,CLLocationManagerDelegate, MKMapViewDelegate{
    
    // Segue data variable
    var cityName : String?
    var source : String?
    
    // CoreData Initialization for News
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var sourceCoordinate: CLLocationCoordinate2D?
    // Outlets
    @IBOutlet weak var map: MKMapView!

    // Map
    var locationManager = CLLocationManager ()
    
    var currentModeOfTransport: MKDirectionsTransportType = .automobile
    
    // Slider initialization
    @IBOutlet weak var zoomSlider: UISlider! {
            didSet {
                zoomSlider.minimumValue = 0
                zoomSlider.maximumValue = 5
                
                zoomSlider.addTarget(self, action: #selector(SliderValueChanged(_:)), for: .valueChanged)
            }
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.delegate = self
        convertAddress(self.cityName ?? "toronto")
        
    }

    override func viewDidAppear(_ animated: Bool) {
        // Recalling to reload map with new city request
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.delegate = self
        self.convertAddress(self.cityName ?? "toronto")
    }


// Alertbox for city name input
    @IBAction func getDirectionAlertBox(_ sender: Any) {
        let myAlertControl = UIAlertController(title: "Where would you like to go", message: "Enter here new destination here", preferredStyle: .alert)
        
        myAlertControl.addTextField { textField in
            textField.placeholder = ""
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            if let textField = myAlertControl.textFields?.first {
                if let text = textField.text {
                    self.cityName = text
                    self.convertAddress(self.cityName ?? "toronto")
                    
                }
            }
        }
     
        myAlertControl.addAction(cancelButton)
        myAlertControl.addAction(okButton)
    
        present(myAlertControl, animated: true, completion: nil)

    }

    // converting city name into lat and long
    func convertAddress(_ cityName : String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(cityName) {
            (placemarks, error) in
           guard let placemarks = placemarks,
                 let location = placemarks.first?.location
            else {
                    print ("no location found")
                    return
                }
            print(location)
            self.mapThis(desitiationCor: location.coordinate)
            }
    }
    // setting location and updating render

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print (locations)
        if let location = locations.first {
            manager.startUpdatingLocation()
             render (location)
        }
    }
    // function to set region and pin
    func render (_ location: CLLocation) {
        let coordinate = CLLocationCoordinate2D (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude )

        let span = MKCoordinateSpan(latitudeDelta: 4.9, longitudeDelta: 4.9)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        let pin = MKPointAnnotation ()

        pin.coordinate = coordinate
        map.addAnnotation(pin)
        map.setRegion(region, animated: true)
    }

    func mapThis(desitiationCor : CLLocationCoordinate2D) {
        if let location = locationManager.location {
            sourceCoordinate = location.coordinate
        } else {
            sourceCoordinate = CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832)
        }
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate!)
        let destinationPlacemark = MKPlacemark(coordinate: desitiationCor)
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        let destinationRequest = MKDirections.Request()

        //start and end
        destinationRequest.source = sourceItem
        destinationRequest.destination = destinationItem

        // defining mode of travel
        destinationRequest.transportType = currentModeOfTransport
        
        destinationRequest.requestsAlternateRoutes = true

        // calculating direction
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in

            guard let response = response else {
                if let error = error  {
                    print("something went wrong")
                }
                return
            }
            self.map.removeOverlays(self.map.overlays)
            let route = response.routes[0]

            // adding overlay to routes
            self.map.addOverlay(route.polyline)
            self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)

            // setting endpoint pin
            let pin = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D (latitude: desitiationCor.latitude, longitude: desitiationCor.longitude )

            pin.coordinate = coordinate
            
            // setting pin as CITY NAME
            pin.title = self.cityName
            self.map.addAnnotation(pin)
            
            self.saveDataMapsCD(self.cityName ?? "not found", self.source ?? "not found")
    }
}

    // setting path line
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let routeline = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        routeline.strokeColor = .green
        
        
           return routeline
    }
    
    // Car Mode button
    @IBAction func carButton(_ sender: UIButton) {
        currentModeOfTransport = .automobile
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.delegate = self
        self.convertAddress(self.cityName ?? "toronto")
    }
    
    // Bicycle Mode button
    @IBAction func bicycleButton(_ sender: UIButton) {
        currentModeOfTransport = .walking
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.delegate = self
        self.convertAddress(self.cityName ?? "toronto")
    }

    // Walking mode button
    @IBAction func walkButton(_ sender: UIButton) {
        currentModeOfTransport = .walking
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.delegate = self
        self.convertAddress(self.cityName ?? "toronto")
    }
    
    // Save data in CoreData
    func saveDataMapsCD(_ cityName:String,_ source:String) {

        let maps = DataForMaps(context: self.content)
        
        maps.cityName = cityName
        maps.typeOfInteraction = "Directions"
        maps.sourceOfTransaction = source
//        maps.startPoint = startpoint
//        maps.endPoint = endpoint
        
        do {
            try self.content.save()
            print("data saved in maps.")
            print(maps.cityName ?? "not found")
        } catch {
            print("error: \(error)")
        }
    }
    
    // Sliding Function
    @objc func SliderValueChanged(_ sender: UISlider) {

        let currentRegion = map.region

            // setting zoomlevel
            let zoomLevel = Double(sender.value).rounded()
            print(zoomLevel)
            // setting zoom out
            let invertedZoomLevel = 1.0 / zoomLevel

            let newSpan = MKCoordinateSpan(
                latitudeDelta: currentRegion.span.latitudeDelta * invertedZoomLevel,
                longitudeDelta: currentRegion.span.longitudeDelta * invertedZoomLevel
            )

            // Handling Exception (when values cross limit)
            let validLatitudeDelta = min(180.0, max(0.0001, newSpan.latitudeDelta))
            let validLongitudeDelta = min(360.0, max(0.0001, newSpan.longitudeDelta))

            let newRegion = MKCoordinateRegion(
                center: currentRegion.center,
                span: MKCoordinateSpan(latitudeDelta: validLatitudeDelta, longitudeDelta: validLongitudeDelta)
            )

            map.setRegion(newRegion, animated: true)

        }
}
