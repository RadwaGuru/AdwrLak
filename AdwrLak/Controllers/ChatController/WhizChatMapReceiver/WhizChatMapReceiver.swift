//
//  WhizChatMapReceiver.swift
//  AdForest
//
//  Created by Apple on 12/03/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import MapKit
class WhizChatMapReceiver: UITableViewCell,MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var lblChatTime: UILabel!
    @IBOutlet weak var mkMapViewReceiver: MKMapView!
    @IBOutlet weak var mainContainer: UIView!{
        didSet{
            mainContainer.roundCorners()
        }
    }
    
    
    var locationManager = CLLocationManager()
    let newPin = MKPointAnnotation()
    let regionRadius: CLLocationDistance = 1000
    var initialLocation = CLLocation(latitude: 31.466693, longitude: 74.3167868)
    var latitude = ""
    var longitude = ""
    var mapTitle = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if latitude != "" && longitude != "" {
            initialLocation = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
        }
        self.centerMapOnLocation(location: initialLocation)
        self.addAnnotations(coords: [initialLocation])

        setupView()

    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func actionDirectionBtn(_ sender: Any) {
        let latie: CLLocationDegrees = Double(latitude)!
        let longi: CLLocationDegrees = Double(longitude)!
        
        let regionDistance:CLLocationDistance = 100
        let coordinates = CLLocationCoordinate2DMake(latie, longi)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = mapTitle
        mapItem.openInMaps(launchOptions: options)
        
        
    }
    

    
    //MARK:- Map View Delegate Methods
    
    func setupView (){
        mkMapViewReceiver.delegate = self
        mkMapViewReceiver.showsUserLocation = true
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }

    }
    
    // MARK: - Map
    func centerMapOnLocation (location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mkMapViewReceiver.setRegion(coordinateRegion, animated: true)
        
    }
    func addAnnotations(coords: [CLLocation]){
        
        for coord in coords{
            let CLLCoordType = CLLocationCoordinate2D(latitude: coord.coordinate.latitude,
                                                      longitude: coord.coordinate.longitude);
            let anno = MKPointAnnotation();
            anno.coordinate = CLLCoordType;
            mkMapViewReceiver.addAnnotation(anno);
        }
    }
    
    private func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil;
        }else {
            let pinIdent = "Pin"
            var pinView: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation;
                pinView = dequeuedView;
            }else{
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdent);
            }
            return pinView;
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.latitude = String(location.coordinate.latitude)
        self.longitude = String(location.coordinate.longitude)
        debugPrint("\(self.latitude):\(self.longitude)")
        self.mkMapViewReceiver.setRegion(region, animated: true)
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let bounds = mapView.region
        initialLocation = CLLocation(latitude: Double(bounds.center.latitude), longitude: Double(bounds.center.longitude))
        let latClicked = bounds.center.latitude
        let longCliked = bounds.center.longitude
        getAddressFromLatLon(pdblLatitude: String(latClicked), withLongitude: String(longCliked))

    }
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    debugPrint("-------===============>Map Receiver>>>>> \(addressString)")
                    print(addressString)
                    self.mapTitle  = addressString
                }
        })
        
    }

    
    
    
}

