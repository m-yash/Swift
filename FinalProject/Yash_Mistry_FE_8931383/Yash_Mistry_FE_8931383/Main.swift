//
//  ViewController.swift
//  Yash_Mistry_FE_8931383
//
//  Created by user240111 on 12/4/23.
//

import UIKit
import CoreLocation

class Main: UIViewController, UITabBarDelegate {
    @IBOutlet var pressButton : UIButton!

    // Navigation Buttons Outlet
    @IBOutlet var newsButton : UIButton!
    @IBOutlet var directionButton : UIButton!
    @IBOutlet var weatherButton : UIButton!
    
    // tabBar funcionality
    @IBOutlet var tabBar : UITabBar!
    
    var newsTab : UIViewController?
    var directionTab : UIViewController?
    var weatherTab : UIViewController?
    
    var locationManager = CLLocationManager ()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Tab Bar
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        print(item.tag)
        
        self.view.subviews.forEach { $0.removeFromSuperview() }
        
        
        switch(item.tag) {
        case 1:
            if newsTab == nil {
                newsTab = storyboard.instantiateViewController(withIdentifier: "newsTab") as! News
                self.view.insertSubview(newsTab!.view!, belowSubview: self.tabBar)
            }
        case 2:
            if directionTab == nil {
                directionTab = storyboard.instantiateViewController(withIdentifier: "directionTab") as! Map
                self.view.insertSubview(directionTab!.view!, belowSubview: self.tabBar)
            }
        case 3:
            if weatherTab == nil {
                weatherTab = storyboard.instantiateViewController(withIdentifier: "weatherTab") as! Weather
                self.view.insertSubview(weatherTab!.view!, belowSubview: self.tabBar)
            }
        default:
            break;
        }
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Requesting location access
        locationManager.delegate 
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // AlertBox for city name input
    @IBAction
    func EntryAlertBoxMethod(_ sender: UIButton) {
        let alertBox = UIAlertController(title: "Where would you like to go", message: "Enter you destination", preferredStyle: .alert)
        
        alertBox.addTextField { textField in
            textField.placeholder = ""
        }
        
        let newsButton = UIAlertAction(title: "News", style: .default) { _ in
            self.performSegue(withIdentifier: "cityNameForNews", sender: (alertBox.textFields?.first?.text, "From Home"))
            
        }
        let directionsButton = UIAlertAction(title: "Directions", style: .default){ _ in
            self.performSegue(withIdentifier: "cityNameForDirections", sender: (alertBox.textFields?.first?.text, "From Home"))
            
        }
        let weatherButton = UIAlertAction(title: "Weather", style: .default){ _ in
            self.performSegue(withIdentifier: "cityNameForWeather", sender: (alertBox.textFields?.first?.text, "From Home"))
            
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
     
        alertBox.addAction(newsButton)
        alertBox.addAction(directionsButton)
        alertBox.addAction(weatherButton)
        alertBox.addAction(cancelButton)
        
  
        present(alertBox, animated: true, completion: nil)
    }
    
    // Segue implementation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cityNameForNews" {
            if let newsViewController = segue.destination as? News, let data = sender as? (String, String) {
                newsViewController.cityName = data.0
                newsViewController.source = data.1
            }
        } else if segue.identifier == "cityNameForDirections" {
            if let directionViewController = segue.destination as? Map, let data = sender as? (String, String) {
                directionViewController.cityName = data.0
                directionViewController.source = data.1
            }
        } else if segue.identifier == "cityNameForWeather" {
            if let weatherViewController = segue.destination as? Weather, let data = sender as? (String, String) {
                weatherViewController.cityName = data.0
                weatherViewController.source = data.1
            }
        }
        
    }
}

