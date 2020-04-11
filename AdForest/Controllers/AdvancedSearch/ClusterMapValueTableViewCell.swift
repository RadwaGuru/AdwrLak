//
//  ClusterMapValueTableViewCell.swift
//  AdForest
//
//  Created by Glixen on 31/03/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
protocol mKMapDelegate {
    func mkMapValues(latitude: String, longitude: String)
}




var delegate: mKMapDelegate?

let map = GMSMapView()
let locationManager = CLLocationManager()
let newPin = MKPointAnnotation()
let regionRadius: CLLocationDistance = 1000
var initialLocation = CLLocation(latitude: 25.276987, longitude: 55.296249)

var latitude = ""
var longitude = ""


@available(iOS 11.0, *)
@available(iOS 11.0, *)
@available(iOS 11.0, *)

class ClusterMapValueTableViewCell: UITableViewCell,MKMapViewDelegate ,GMSMapViewDelegate{

    
    @IBOutlet weak var mkMap: MKMapView!
    private var userTrackingButton: MKUserTrackingButton!
    private var scaleView: MKScaleView!
    // Create a location manager to trigger user tracking
       private let locationManager = CLLocationManager()
       
       private func setupCompassButton() {
            let compass = MKCompassButton(mapView: mkMap)
            compass.compassVisibility = .visible
//            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: compass)
            mkMap.showsCompass = true
           
       }
    
    
    private func setupUserTrackingButtonAndScaleView() {
        mkMap.showsUserLocation = true
        
        userTrackingButton = MKUserTrackingButton(mapView: mkMap)
        userTrackingButton.isHidden = true // Unhides when location authorization is given.
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userTrackingButton)
        
        // By default, `MKScaleView` uses adaptive visibility, so it only displays when zooming the map.
        // This is behavior is confirgurable with the `scaleVisibility` property.
        scaleView = MKScaleView(mapView: mkMap)
        scaleView.legendAlignment = .trailing
//        view.addSubview(scaleView)
        
        let stackView = UIStackView(arrangedSubviews: [scaleView, userTrackingButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
//        view.addSubview(stackView)
        
//        NSLayoutConstraint.activate([stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
//                                     stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)])
    }
    
    //MARK:- Map View Delegate Methods
    func latLong(lat: String, long: String,place:String) {
      

        
//        self.txtLatitude.text = lat
//        self.txtLatitude.text = long
        
        latitude = lat
        longitude = long
        initialLocation = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
        self.centerMapOnLocation(location: initialLocation)
        self.addAnnotations(coords: [initialLocation])
        
       }

    func setupView (){
        mkMap.delegate = self
        mkMap.showsUserLocation = true
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
        mkMap.setRegion(coordinateRegion, animated: true)
    }
    func addAnnotations(coords: [CLLocation]){
        
        for coord in coords{
            let CLLCoordType = CLLocationCoordinate2D(latitude: coord.coordinate.latitude,
                                                      longitude: coord.coordinate.longitude);
            let anno = MKPointAnnotation();
            anno.coordinate = CLLCoordType;
            mkMap.addAnnotation(anno);
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
        latitude = String(location.coordinate.latitude)
        longitude = String(location.coordinate.longitude)
        print(latitude)
        print(longitude)
//        (self.delegate? as AnyObject).mkMapValues(latitude: latitude, longitude: longitude)
        delegate?.mkMapValues(latitude: latitude, longitude: longitude)
        //        self.txtLatitude.text = self.latitude
//        self.txtLongitude.text = self.longitude
        self.mkMap.setRegion(region, animated: true)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupCompassButton()
        setupUserTrackingButtonAndScaleView()
        
        setupView()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }

    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
@available(iOS 11.0, *)
extension ClusterMapValueTableViewCell: CLLocationManagerDelegate {
 
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let locationAuthorized = status == .authorizedWhenInUse
//        userTrackingButton.isHidden = !locationAuthorized
    }
}
