//
//  DetailViewController.swift
//  Watchlist
//
//  Created by Noah Korner on 4/8/20.
//  Copyright © 2020 asu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var priorityLevelLabel: UILabel!
    @IBOutlet weak var typeSegControl: UISegmentedControl!
    @IBOutlet weak var subsTableView: UITableView!
    
    
    
    //MARK: Variables
    var currentShow:Show?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imgView.image = currentShow!.image
        imgView.layer.cornerRadius = 5
        imgView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        imgView.layer.borderWidth = 2
        self.navBar.topItem?.title = currentShow?.name
        priorityLevelLabel.layer.cornerRadius = 10
        priorityLevelLabel.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        priorityLevelLabel.layer.borderWidth = 1
        switch currentShow!.priorityLevel {
            case 0...4:
                priorityLevelLabel.text! = "Low"
                priorityLevelLabel.layer.backgroundColor = .init(srgbRed: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
            case 4...7:
                priorityLevelLabel.text! = "Medium"
                priorityLevelLabel.layer.backgroundColor = .init(srgbRed: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
            case 7...10:
                priorityLevelLabel.text! = "High"
                priorityLevelLabel.layer.backgroundColor = .init(srgbRed: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            default:
                priorityLevelLabel.text! = "Medium"
        }
        typeSegControl.selectedSegmentIndex = currentShow!.type
        typeSegControl.isEnabled = false
    }
    
    @IBAction func doneAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentShow!.subscriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCell", for: indexPath)
        cell.textLabel!.text = currentShow?.subscriptions[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Subscriptions"
    }
    
}
