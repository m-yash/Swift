//
//  HistoryPage.swift
//  Yash_Mistry_FE_8931383
//
//  Created by user240111 on 12/6/23.
//

import UIKit
import CoreData


class History: UITableViewController {
    
    // Defining data set
    var newsData: [DataForNews]?
    var weatherData: [DataForWeather]?
    var mapsData: [DataForMaps]?
    
    @IBOutlet weak var historyTable: UITableView!
    
    // Reference object to manage content
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        historyTable.delegate = self
        historyTable.dataSource = self
        fetchNews()
        fetchWeather()
        //fetchMaps()
    }
    
    
    func fetchNews(){
        do{
            self.newsData = try content.fetch(DataForNews.fetchRequest())
            DispatchQueue.main.async{
                self.historyTable.reloadData()
            }
        } catch {
            print("no data")
        }
    }
    func fetchWeather(){
        do{
            self.weatherData = try content.fetch(DataForWeather.fetchRequest())
            DispatchQueue.main.async{
                self.historyTable.reloadData()
            }
        } catch {
            print("no data")
        }
    }
    func fetchMaps(){
        do{
            self.mapsData = try content.fetch(DataForMaps.fetchRequest())
            DispatchQueue.main.async{
                self.historyTable.reloadData()
            }
        } catch {
            print("no data")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        switch section {
            case 0:
                return self.newsData?.count ?? 0
            case 1:
                return self.weatherData?.count ?? 0
            case 2:
            print(self.mapsData?.count ?? -1)
                return self.mapsData?.count ?? 0
            default:
                return 0
            }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 3
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! NewsTableViewCell
        
        // Setting border for each cell
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        
        switch indexPath.section {
        case 0:
            // Setting data on UILabel
            let news = self.newsData![indexPath.row]
            cell.titleLabel.text = news.title
            cell.descriptionLabel.text = "Content decscription - \(news.descriptionn ?? "not found")"
            cell.sourceLabel.text = news.source
            cell.authorLabel.text = news.author
            cell.cityNameLabel.text = news.cityName
            cell.sourceOfTransactionLabel.text = news.sourceOfTransaction
            cell.typeofInteractionLabel.text = news.typeOfInteraction
            
            //hiding other cells
            
            cell.tempLabel.isHidden = true
            cell.humidityLabel.isHidden = true
            cell.windLabel.isHidden = true
            cell.dateLabel.isHidden = true
            cell.timeLabel.isHidden = true
            
            cell.startLabel.isHidden = true
            cell.endLabel.isHidden = true
            cell.modeOfTravelLabel.isHidden = true
            cell.distanceTravelledLabel.isHidden = true
        case 1:
            // Setting data on UILabel
            let weather = self.weatherData![indexPath.row]
            cell.cityNameLabel.text = weather.cityName
            cell.tempLabel.text = "Temp: \(String(weather.temperature))°"
            cell.humidityLabel.text = "humidity: \(String(weather.humidity))%"
            cell.windLabel.text = "wind: \(String(weather.wind))km/h"
            cell.sourceLabel.text = weather.sourceOfTransaction
            cell.typeofInteractionLabel.text = weather.typeOfInteraction
            
            // Extracting date
            let dateformat = DateFormatter()
            if let timeStamp = weather.timeStamp {
                // Date
                dateformat.dateFormat = "yyyy-MM-dd"
                cell.dateLabel.text = dateformat.string(from: timeStamp)

                // Time
                dateformat.dateFormat = "HH:mm:ss"
                cell.timeLabel.text = dateformat.string(from: timeStamp)
            }
            
            // hiding other cells
            cell.startLabel.isHidden = true
            cell.endLabel.isHidden = true
            cell.modeOfTravelLabel.isHidden = true
            cell.distanceTravelledLabel.isHidden = true
            
            cell.titleLabel.isHidden = true
            cell.descriptionLabel.isHidden = true
            cell.sourceLabel.isHidden = true
            cell.authorLabel.isHidden = true

        case 2:
            // Setting data on UILabel
            let maps = self.mapsData![indexPath.row]
            
    
            cell.sourceLabel.text = maps.sourceOfTransaction
            cell.cityNameLabel.text = maps.cityName
//            cell.sourceOfTransactionLabel.text = news.sourceOfTransaction
//            cell.typeofInteractionLabel.text = news.typeOfInteraction
            
            //hiding other cells
            
            cell.tempLabel.isHidden = true
            cell.humidityLabel.isHidden = true
            cell.windLabel.isHidden = true
            cell.dateLabel.isHidden = true
            cell.timeLabel.isHidden = true
            
            cell.startLabel.isHidden = true
            cell.endLabel.isHidden = true
            cell.modeOfTravelLabel.isHidden = true
            cell.distanceTravelledLabel.isHidden = true
            
        default:
            break
        }
        
        
        return cell
    }
    
    // implement swipe-to-delete functionality
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch indexPath.section {
                case 0:
                    // deletion for news data
                    if let remove = self.newsData?[indexPath.row] {
                        self.newsData?.remove(at: indexPath.row)
                        self.historyTable.deleteRows(at: [indexPath], with: .fade)
                        self.content.delete(remove)

                        // Save the context
                        do {
                            try self.content.save()
                        } catch {
                            print("Error saving data")
                        }
                    }
                case 1:
                    // deletion for weather data
                    if let remove = self.weatherData?[indexPath.row] {
                        self.weatherData?.remove(at: indexPath.row)
                        self.historyTable.deleteRows(at: [indexPath], with: .fade)
                        self.content.delete(remove)

                        // Save the context
                        do {
                            try self.content.save()
                        } catch {
                            print("Error saving data")
                        }
                    }

                case 2:
                // deletion for weather data
                    if let remove = self.mapsData?[indexPath.row] {
                        self.mapsData?.remove(at: indexPath.row)
                        self.historyTable.deleteRows(at: [indexPath], with: .fade)
                        self.content.delete(remove)

                        // Save the context
                        do {
                            try self.content.save()
                        } catch {
                            print("Error saving data")
                        }
                    }
                    default:
                        break
                    }
        }
    }

}

// UITableViewCell for custom cell
class NewsTableViewCell: UITableViewCell {
    
    // News
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var typeofInteractionLabel: UILabel!
    
    @IBOutlet weak var sourceOfTransactionLabel: UILabel!

   
    // Weather
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    // Maps
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var modeOfTravelLabel: UILabel!
    @IBOutlet weak var distanceTravelledLabel: UILabel!
    
}
