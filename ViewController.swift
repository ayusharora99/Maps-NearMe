//
//  ViewController.swift
//  Maps + Near Me
//
//  Created by Ayush Arora on 6/30/16.
//  Copyright © 2016 Ayush Arora. All rights reserved.
//



import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

class ViewController : UIViewController, SideBarDelegate {
   
   
    
    var sideBar:SideBar = SideBar()
    
    var selectedPin:MKPlacemark? = nil
    
    var resultSearchController:UISearchController? = nil
    
    var matchingPoints: [MKMapItem] = []
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var standardOrHybrid: UISegmentedControl!
        var isHybrid = false;
    @IBOutlet weak var currentLocation: UIButton!
    @IBOutlet weak var clearPins: UIButton!


    
    override func viewDidLoad() {
        sideBar = SideBar(sourceView: self.view, menuItems: ["Banks",
                                                             "Beaches",
                                                             "Coffee",
                                                             "Convenience Stores",
                                                             "Costco",
                                                             "Fast Food",
                                                             "Gas",
                                                             "Groceries",
                                                             "Hospitals",
                                                             "Hotels",
                                                             "Libraries",
                                                             "Malls",
                                                             "Movies",
                                                             "Parks",
                                                             "Pools",
                                                             "Post Offices",
                                                             "Restaurants",
                                                             "Restrooms",
                                                             "Schools"])
        sideBar.delegate = self
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for a place or address"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        currentLocation.setBackgroundImage(UIImage(named: "images.png"), for: UIControlState())
        let onLongPress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.onLongPress))
        onLongPress.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(onLongPress)
        let alert = UIAlertController(title: "Alert", message: "Using the search bar to search for a location first allows you to use the sidebar!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    func onLongPress(gesture: UILongPressGestureRecognizer){
        if gesture.state == .ended {
            let point = gesture.location(in: self.mapView)
            let coordinate = self.mapView.convert(point, toCoordinateFrom: self.mapView)
            print(coordinate)
            
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler:{ (placemarks, error) in
                if error != nil{
                    print(error)
                    return
                }
            else if (placemarks?.count)! > 0{
                let pm = placemarks![0]
                let address = pm.addressDictionary!
                print("\n\(address)")
                    if (pm.areasOfInterest?.count)! > 0
                    {
                        let areaOfInterest = pm.areasOfInterest?[0]
                        print (areaOfInterest)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        //Set title and subtitle if you want
                        annotation.title = areaOfInterest
                        self.mapView.addAnnotation(annotation)

                    }
                    else
                    {
                        print("Cant find an area of interest on this pin!")
                    }
    

                }
            //Now use this coordinate to add annotation on map.
            
            }
        )}
    }



    func sideBarDidSelectButtonAtIndex(index:Int) {
        
        if index == 0{
            
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Bank"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
            
                for item in response.mapItems {
                    
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                    
                    
                    
                }
            }
        }
        if index == 1{
            
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Beach"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 2{
            
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Coffee"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 3{
            
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Convenience Store"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 4{
            
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Costco"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 5{
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Fast Food"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 6{
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Gas"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 7{
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Grocery"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 8{
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Hospital"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 9{
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Hotel"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 10{
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Library"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 11{
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Mall"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 12{
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Theater"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 13{
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Park"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 14{
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Pool"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 15{
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Post Office"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 16{
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Restaurant"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 17{
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "Restroom"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
        if index == 18{
            mapView.removeAnnotations(mapView.annotations)
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = "School"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
                guard error == nil else { return }
                guard let response = response else { return }
                self.matchingPoints = response.mapItems
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    let annotationView = MKPinAnnotationView()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.placemark.name
                    annotationView.pinTintColor = UIColor.blue
                    if let city = item.placemark.locality,
                        let state = item.placemark.administrativeArea {
                        annotation.subtitle = "\(city) \(state)"
                    }
                    
                    self.mapView.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
    }
    

    func getDirections(){
        let refreshAlert = UIAlertController(title: "Directions", message: "Which app would you like to open directions in?", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { (action: UIAlertAction!) in
            if let selectedPin = self.selectedPin {
                let mapItem = MKMapItem(placemark: selectedPin)
                let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                mapItem.openInMaps(launchOptions: launchOptions)
            }
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { (action: UIAlertAction!) in
            if let selectedPin = self.selectedPin {
                if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
                    UIApplication.shared.openURL(NSURL(string:
                        "comgooglemaps://?saddr=&daddr=\(selectedPin.coordinate.latitude),\(selectedPin.coordinate.longitude)&directionsmode=driving")! as URL)
                }
            }
        }))
        refreshAlert.addAction(UIAlertAction(title: "Waze", style: .default, handler: { (action: UIAlertAction!) in
            UIApplication.shared.openURL(NSURL(string: "waze://?ll=\(self.selectedPin!.coordinate.latitude),\(self.selectedPin!.coordinate.longitude)&navigate=yes" )! as URL)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
            self.dismiss(animated: true, completion: nil)
        }))
        present(refreshAlert, animated: true, completion: nil)
    }

    func doCall(_ mapView : MKMapView! , didUpdateUserLocation userLocation : MKUserLocation, placemark:MKPlacemark )
    {
        let request = MKLocalSearchRequest()
        let searchBar = resultSearchController!.searchBar
        request.naturalLanguageQuery = searchBar.text
        let span =  MKCoordinateSpan(latitudeDelta: 0.00000000001, longitudeDelta: 0.0000000001)
        let search = MKLocalSearch(request: request)
        search.start {MKLocalSearchResponse, error in
            for item in (MKLocalSearchResponse?.mapItems)! as [MKMapItem]
            {
                let optionalString = item.phoneNumber
                if let unwrapped = optionalString
                {
                    let cleanUrl = unwrapped.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
                    if cleanUrl != nil {
                        let url: URL = URL(string: "tel://" + (cleanUrl))!
                        UIApplication.shared.openURL(url)
                        break
                        print(cleanUrl)
                    }
                }

                
        }
        }
    }

  
    @IBAction func toClearPins(_ sender: UIButton) {
        mapView.removeAnnotations(mapView.annotations)
    }
}



extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.02, 0.02)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    @IBAction func changeToHybridOrStandard(_ sender: AnyObject) {
        
        if isHybrid == false
        {
            mapView.mapType = MKMapType.hybrid;
            isHybrid = true;
        }
        else
        {
            mapView.mapType = MKMapType.standard;
            isHybrid = false;
        }
    }
        
    @IBAction func backToCurrentLocation(_ sender: UIButton) {
       
        locationManager.requestLocation();
        
    }
    }


extension ViewController: HandleMapSearch {
    func dropPinZoomIn(_ placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        
        // clear existing pins
        // mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        let annotationView = MKPinAnnotationView()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        annotationView.pinTintColor = UIColor.blue
        if let city = placemark.locality,
           let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.02, 0.02)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

extension ViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 45, height: 45)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        let callButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "k14707749"), for: UIControlState())
        callButton.setBackgroundImage(UIImage(named: "callforwarding"), for: UIControlState())
      button.addTarget(self, action: #selector(ViewController.getDirections), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(ViewController.doCall), for: .touchUpInside)
        pinView!.leftCalloutAccessoryView = button
        pinView!.rightCalloutAccessoryView = callButton
        //pinView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure) as UIButton
        return pinView
    }
}




