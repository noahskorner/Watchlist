//
//  WatchlistViewController.swift
//  Watchlist
//
//  Created by Noah Korner on 4/7/20.
//  Copyright © 2020 asu. All rights reserved.
//

import UIKit
import CoreData

class WatchlistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, AddShowDelegate{
    // MARK: Outlets
    @IBOutlet weak var showTableView: UITableView!
    
    // MARK: Variables
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //handler to managed object
    var fetchResults = [ShowEntity]() //array that stores CoreData ShowEntities
    var watchlist = Shows() //Shows object with member variable shows:[Show]
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.showTableView.rowHeight = 150
        // Fetch CoreData
        fetchRecords()
    }
    
    func fetchRecords(){
        // Create a new fetch request using the ShowEntity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ShowEntity")
        // Execute the fetch request, and cast the results to an array of ShowEntity objects
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [ShowEntity])!
        let count = fetchResults.count
        print("Number of fetched objects: \(count)")
        fetchResults = fetchResults.sorted(by: { $0.priorityLevel > $1.priorityLevel })
        
        // For each City entity, create a cityObject and add it to myCities array
        for item in self.fetchResults {
            watchlist.shows.append(item.convertToShow())
        }
    }
    
    func addShow(newShow:Show){
        // Add Show object to watchlist array
        watchlist.addShowObject(newShow:newShow)
        // Add Show object to CoreData
        self.addEntity(show: newShow)
        print("Added : \(newShow.name)")
        print("Subs : \(newShow.subscriptions)")
        watchlist.shows = watchlist.shows.sorted(by: { $0.priorityLevel > $1.priorityLevel })
        fetchResults = fetchResults.sorted(by: { $0.priorityLevel > $1.priorityLevel })
        // Reload tableView
        DispatchQueue.main.async {
            self.showTableView.reloadData()
        }

    }
    
    // Helper function to convert Show -> ShowEntity and add to managedObjectContext
    func addEntity(show:Show){
        // Create a new entity object
        let ent = NSEntityDescription.entity(forEntityName: "ShowEntity", in: self.managedObjectContext)
        let newShowEntity = ShowEntity(entity: ent!, insertInto: self.managedObjectContext)
        newShowEntity.name = show.name
        newShowEntity.priorityLevel = Int16(show.priorityLevel)
        newShowEntity.rating = Int16(show.rating)
        newShowEntity.review = show.review
        newShowEntity.type = Int16(show.type)
        newShowEntity.hasSeen = show.hasSeen
        newShowEntity.image = show.image.pngData()! as Data
        newShowEntity.subscriptions = convertArrayToString(subs: show.subscriptions)
        fetchResults.append(newShowEntity)
        
        // Save Core Data
        do {
            try managedObjectContext.save()
        } catch {
            print("Error while saving the new show")
        }
    }
    
    func convertArrayToString(subs:[String]) -> String{
        var subscriptions:String = ""
        for string in subs{
            subscriptions += string
            subscriptions += "+"
        }
        return subscriptions
    }
 
    @IBAction func moreInfo(_ sender: Any) {
        let alert = UIAlertController(title: "More Info", message: "Watchlist stores the TV Shows and Movies you haven't seen yet. Shows are displayed by priority level. Press + to add your first show!", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchlist.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showCell", for: indexPath) as! ShowTableViewCell
        let currentShow:Show = watchlist.shows[indexPath.row]
        cell.nameLabel.text! = currentShow.name
        cell.imgView.image = currentShow.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            do {
                // Remove from CoreData
                managedObjectContext.delete(fetchResults.remove(at:indexPath.row))
                try managedObjectContext.save()
            } catch {
                print("Error while saving core data")
            }
            // Remove from watchlist array
            watchlist.shows.remove(at: indexPath.row)
            // Reload tableView
            showTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addShowView"){
            if let viewController: AddShowViewController = segue.destination as? AddShowViewController {
                viewController.delegate = self
            }
        }
        if(segue.identifier == "detailView"){
            if let viewController: DetailViewController = segue.destination as? DetailViewController {
                viewController.currentShow = watchlist.shows[showTableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
}
