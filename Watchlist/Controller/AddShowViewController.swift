//
//  AddShowViewController.swift
//  Watchlist
//
//  Created by Noah Korner on 4/7/20.
//  Copyright © 2020 asu. All rights reserved.
//

import UIKit

protocol AddShowDelegate: class {
    func addShow(newShow:Show)
}

class AddShowViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // MARK: JSON Structs
    struct results: Decodable {
        let results: [result]
    }
             
    struct result: Decodable {
        let locations:[location]
    }
       
    struct location: Decodable{
        let display_name:String
        let icon:String
        let id:String
        let name:String
        let url:String
    }
    
    //MARK: Outlets
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var prioritySlider: UISlider!
    @IBOutlet weak var typeSegControl: UISegmentedControl!
    @IBOutlet weak var hasSeenView: UIView!
    @IBOutlet weak var plLow: UILabel!
    @IBOutlet weak var plHigh: UILabel!
    
    //MARK: Variables
    weak var delegate: AddShowDelegate? = nil
    var image:UIImage = UIImage(named: "default")!
    
    //MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        plLow.layer.cornerRadius = 10
        plHigh.layer.cornerRadius = 10
        titleTextField.addTarget(self, action: #selector(AddShowViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        hasSeenView.layer.cornerRadius = 25
        img.layer.cornerRadius = 10
        img.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        img.layer.borderWidth = 2
        doneButton.isEnabled = false;
    }
    
    //MARK: Actions
    @IBAction func cancelAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButton(_ sender: Any) {
        if titleTextField.text! == "" {
            dismiss(animated: true, completion: nil)
        }
        else{
            // Temporarily store newShow attributes
            let name = titleTextField.text!
            let priorityLevel = Int(prioritySlider.value)
            let type = typeSegControl.selectedSegmentIndex //0 = TV Show, 1 = Movie
                //PLACEHOLDER CODE -> Need to figure out what to do if user has already seen the show
                let rating = -1
                let review = ""
                let hasSeen = false
            var subscriptions = [String]()
                   
            // Remove whitespaces from searchShow
            let searchShow = name.replacingOccurrences(of: " ", with: "-")
            // Web API Request
            let headers = [
                "x-rapidapi-host": "utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com",
                "x-rapidapi-key": "d07e4387f6msh3ee8d8ef29ff735p1ef405jsn3749d176571f"
            ]

            let request = NSMutableURLRequest(url: NSURL(string: "https://utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com/lookup?term=\(searchShow)&country=us")! as URL, cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    return
                } else {
                    let decoder = JSONDecoder()
                    let json = try! decoder.decode(results.self, from: data!)
                    for item in json.results{
                        for each in item.locations{
                            subscriptions.append(each.display_name)
                        }
                    }
                    //Remove duplicates from array
                    let uniqueUnordered = Array(Set(subscriptions))
                    let uniqueOrdered = Array(NSOrderedSet(array: uniqueUnordered))
                    subscriptions = uniqueOrdered as! [String]
                    //Create new show object
                    let newShow = Show(n: name, pl: priorityLevel, ra: rating, re: review, t: type, seen: hasSeen, img: self.image, subs:subscriptions)
                    // Add to watchlist
                    self.delegate?.addShow(newShow: newShow)
                }
            })
            dataTask.resume()
            
            // Dismiss to WatchlistViewController
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func addPhotoAction(_ sender: Any) {
        // Initialize Photo Alert & Actions
        let photoAlert = UIAlertController(title: "Add Photo", message: "", preferredStyle: .alert)
                      
        let libraryAction = UIAlertAction(title: "Library", style: .default) { (aciton) in
            let photoPicker = UIImagePickerController ()
            photoPicker.delegate = self
            photoPicker.sourceType = .photoLibrary
                          
            // Present Libary
            self.present(photoPicker, animated: true, completion: nil)
        }
                      
        let cameraAction = UIAlertAction(title: "Camera", style: .default){ (action) in
            let photoPicker = UIImagePickerController ()
            photoPicker.delegate = self
            photoPicker.sourceType = .camera
            // Present Camera
            self.present(photoPicker, animated: true, completion: nil)
        }
        photoAlert.addAction(libraryAction)
        photoAlert.addAction(cameraAction)
        
        self.present(photoAlert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker .dismiss(animated: true, completion: nil)
        image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        img.image = image
    }
    
    @objc func textFieldDidChange(_ textField:UITextField){
        //un-grey out done button
        if(textField.text! == ""){
            doneButton.isEnabled = false
        }
        else{
            doneButton.isEnabled = true
        }
    }
}
