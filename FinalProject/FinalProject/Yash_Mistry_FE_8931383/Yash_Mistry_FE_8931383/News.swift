//
//  News.swift
//  Yash_Mistry_FE_8931383
//
//  Created by user240111 on 12/6/23.
//


import UIKit
import CoreData

// JSON with codable protocol
struct NewsResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
}

struct Source: Codable {
    let name: String
}

class News : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // CoreData Initialization for News
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    // Segue data variable
    var cityName : String?
    var source : String?
    
    @IBOutlet weak var tableView: UITableView!

    var articles: [Article] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Showing default data when user access News from tab bar
        getNewsData(self.cityName ?? "canada", self.source ?? "From Home")
                
    }
    
    // Save data in CoreData
    func saveDataNewsCD(_ cityName:String,_ title:String, _ description:String, _ source:String, _ author:String, _ sourceOfTranscation:String) {

        let news = DataForNews(context: self.content)
        
        news.cityName = cityName
        news.title = title
        news.descriptionn = description
        news.source = source
        news.author = author
        news.sourceOfTransaction = sourceOfTranscation
        news.typeOfInteraction = "News"
        news.timeStamp = Date()

        do {
            try self.content.save()
            print("data saved in News.")
            print(news.title ?? "not found")
        } catch {
            print("error: \(error)")
        }
    }
    
    // Setting up API and and fetching JSON data
    func getNewsData(_ cityName : String, _ source : String){
        let urlString = "https://newsapi.org/v2/everything?q=\(cityName)&apiKey=67ed11f142d14ee590519978d402d124"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                guard let data = data else {
                    print("No data received")
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(NewsResponse.self, from: data)

                    self.articles = result.articles

                    // Reloading table view
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if cityName.lowercased() != "canada"{
                            self.saveFirstArticle(self.cityName ?? "not found")
                        }
                        
                    }

                } catch {
                    print("Error: \(error)")
                }
            }.resume()
        }

        // setting dataSource and Delegate for table view
        tableView.dataSource = self
        tableView.delegate = self
        
    }

    // Setting up table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(articles.count)
        return articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! ArticleTableViewCell

        let article = articles[indexPath.row]
        
        // Setting border for each cell
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.black.cgColor

        cell.titleLabel.text = article.title
        cell.descriptionLabel.text = "Content decscription - \(article.description ?? "not found")"
        cell.sourceLabel.text = article.source.name
        cell.authorLabel.text = article.author
        
        

        return cell
    }
    // function to fetch first article from array
    func saveFirstArticle(_ cityName: String){
        let firstt = articles.first
        print(firstt?.title ?? "not found")
        print(firstt?.description ?? "not found")
        print(firstt?.source.name ?? "not found")
        print(firstt?.author ?? "not found")
        
        saveDataNewsCD(cityName,firstt?.title ?? "not found", firstt?.description ?? "not found", firstt?.source.name ?? "not found", firstt?.author ?? "not found", source ?? "not found")
    }
    
    // AlertBox for data from News
    @IBAction
    func getNewsAlertBox(_ sender: UIBarButtonItem) {
        let myAlertControl = UIAlertController(title: "Where would you like to go", message: "Enter here new destination here", preferredStyle: .alert)
        
        myAlertControl.addTextField { textField in
            textField.placeholder = ""
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            if let textField = myAlertControl.textFields?.first {
                if let text = textField.text {
                    self.cityName = text
                    self.source = "From News"
                    self.getNewsData(self.cityName ?? "canada", self.source ?? "From News")
                }
            }
        }
     
        myAlertControl.addAction(cancelButton)
        myAlertControl.addAction(okButton)
        
  
        present(myAlertControl, animated: true, completion: nil)
    }
}



// UITableViewCell for custom cell
class ArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
}


