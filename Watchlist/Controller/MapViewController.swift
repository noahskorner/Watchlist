//
//  MapViewController.swift
//  Watchlist
//
//  Created by Noah Korner on 4/8/20.
//  Copyright © 2020 asu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    @IBOutlet weak var movieTheaterMap: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        movieTheaterMap.delegate = self
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        self.initMap()
    }
    
    func initMap(){
        if locationManager.location != nil{
            // Set parent region
            let region: MKCoordinateRegion = MKCoordinateRegion.init(center: locationManager.location!.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
            self.movieTheaterMap.setRegion(region, animated: false)
            // Search for movie theaters
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = "movie theater"
            self.search(using: searchRequest)
        }
    }
    
    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func search(using searchRequest: MKLocalSearch.Request) {
        // Confine the map search area to an area around the user's current location.
        searchRequest.region = movieTheaterMap.region
           
        // Include only point of interest results. This excludes results based on address matches.
        searchRequest.resultTypes = .pointOfInterest
           
        let localSearch = MKLocalSearch(request: searchRequest)
        localSearch.start { [unowned self] (response, error) in
            guard error == nil else {
                print("Error searching for Movie Theaters")
                return
            }
               
            for item in response!.mapItems{
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                annotation.coordinate = item.placemark.coordinate
                self.movieTheaterMap.addAnnotation(annotation)
            }
               
            // Used when setting the map's region in `prepareForSegue`.
            if let updatedRegion = response?.boundingRegion {
                self.movieTheaterMap.setRegion(updatedRegion, animated: true)
            }
        }
    }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let annotations = self.movieTheaterMap.annotations
        self.movieTheaterMap.removeAnnotations(annotations)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }
}
