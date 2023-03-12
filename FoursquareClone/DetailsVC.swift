//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Muhammet Kadir on 11.03.2023.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var placeAtmosphere: UILabel!
    @IBOutlet weak var placeTypeText: UILabel!
    @IBOutlet weak var placeNameText: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
    
    var choosenPlaceId=""
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDataFromParse()
    }
    func getDataFromParse(){
        
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: choosenPlaceId)
        query.findObjectsInBackground{(objects, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }else{
                if objects != nil{
                    if objects!.count > 0{
                        var object = objects![0]
                        
                        if let placeName = object["name"] as? String{
                            self.placeNameText.text = placeName
                        }
                        
                        if let placeType = object["type"] as? String{
                            self.placeTypeText.text = placeType
                        }
                        
                        if let placeAtmosphere = object["atmosphere"] as? String{
                            self.placeAtmosphere.text = placeAtmosphere
                        }
                        
                        if let placeLatitude = object["latitude"] as? String{
                            if let doubleLat = Double(placeLatitude){
                                self.choosenLatitude = doubleLat
                            }
                        }
                        
                        if let placeLongitude = object["longitude"] as? String{
                            if let doubleLog = Double(placeLongitude){
                                self.choosenLongitude = doubleLog
                            }
                        }
                        
                        if let imageData = object.object(forKey: "image") as? PFFileObject{
                            imageData.getDataInBackground{(data , error) in
                                if error == nil {
                                    if data != nil{
                                        self.placeImageView.image = UIImage(data: data!)
                                    }
                                }
                            }
                        }
                        
                        
                        let location = CLLocationCoordinate2D.init(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                        let region = MKCoordinateRegion(center: location, span: span)
                        
                        self.mapView.setRegion(region, animated: true)
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate=location
                        annotation.title = self.placeNameText.text
                        annotation.subtitle = self.placeTypeText.text
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            annotationView!.rightCalloutAccessoryView = button
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.choosenLatitude != 0.0 && self.choosenLongitude != 0.0{
            let requestLocation = CLLocation(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placeMarks,error) in
                if let placeMark = placeMarks{
                    if placeMark.count>0{
                        let newPlaceMark = MKPlacemark(placemark: placeMark[0])
                        let item = MKMapItem(placemark: newPlaceMark)
                        item.name = self.placeNameText.text
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
}
