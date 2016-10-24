//
//  RoutesViewController.swift
//  City Tour
//
//  Created by JUAN ANDRÉS CÁRDENAS DIAZ on 11/10/16.
//  Copyright © 2016 JUAN ANDRÉS CÁRDENAS DIAZ. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class RoutesViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ARDataSource{

    
    @IBOutlet weak var routesMap: MKMapView!
    
    
    @IBOutlet weak var btnMarker: UIButton!
    @IBOutlet weak var btnNewRoute: UIButton!
    @IBOutlet weak var btnScanQR: UIButton!
    @IBOutlet weak var btnShowAR: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnSaveRoute: UIButton!
    
    @IBOutlet weak var lblRoutesInfo: UILabel!
    
    @IBOutlet weak var tableRoutes: UITableView!
    
    
    let locManager = CLLocationManager()
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    private let mPicker = UIImagePickerController()
    
    var currentLocation : CLLocation? = nil
    var lastLocation : CLLocation? = nil
    
    var routeName : String? = nil
    var markerName : String? = nil
    var markerImage : UIImage? = nil
    
    var tblRoutesItems : [Route]? = nil
    var selectedRouteIndex : Int = 0
    var textToShare :String = ""
    
    var originMapItem: MKMapItem!
    var destinyMapItem: MKMapItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("Camera Available: \(UIImagePickerController.isSourceTypeAvailable(.Camera))")
        
        self.btnMarker.hidden = true
        self.btnScanQR.hidden = true
        self.btnShowAR.hidden = true
        self.btnShare.hidden = true
        self.btnSaveRoute.hidden = true
        
        routesMap.delegate = self
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.distanceFilter = 10
        locManager.requestWhenInUseAuthorization()
        
        self.setZoomMap(15)
        
        mPicker.delegate = self
        
        tblRoutesItems = getSavedRoutes()
        
        if  tblRoutesItems!.count > 0 {
        
            lblRoutesInfo.text = " \(tblRoutesItems!.count) Ruta(s) Disponible(s)"
            
        }else {
        
            lblRoutesInfo.text = "No hay rutas almacenadas"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func createRoute(sender: AnyObject) {
        
        let alertCreateRoute = UIAlertController(title: "Nueva Ruta",
                                      message: "Completa los datos de tu nueva ruta.",
                                      preferredStyle: .Alert)
        
        let createAction = UIAlertAction(title: "Crear",
                                       style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
        let txtName = alertCreateRoute.textFields![0] as UITextField
        let txtDescription = alertCreateRoute.textFields![1] as UITextField
                                        
        self.routeName = txtName.text
        
        self.createNewRoute(self.routeName!, routeDescription: txtDescription.text!)
                                        
        self.routesMap.removeAnnotations(self.routesMap.annotations)
        self.routesMap.removeOverlays(self.routesMap.overlays)
            
        self.btnMarker.hidden = false
        self.btnSaveRoute.hidden = false
        self.btnScanQR.hidden = true
        self.btnShowAR.hidden = true
        self.btnShare.hidden = true
                                        
        
        })
        
        createAction.enabled = false
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .Destructive) { (action: UIAlertAction) -> Void in
        
        }
        
        alertCreateRoute.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
            
            textField.placeholder = "Nombre"
            
        }
        
        alertCreateRoute.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
            
            textField.placeholder = "Descripción"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                createAction.enabled = textField.text != ""
            }
            
        }
        
        alertCreateRoute.addAction(createAction)
        alertCreateRoute.addAction(cancelAction)
        
        presentViewController(alertCreateRoute,
                              animated: true,
                              completion: nil)
        
    }
    
    
    @IBAction func addMarker(sender: AnyObject) {
        
        lastLocation = currentLocation
        
        
        let alertAddMarker = UIAlertController(title: "Punto de Interés",
                                                 message: "Ingresa el nombre del punto de interés que vas a agregar a tu ruta y si lo deseas, tambien puedes agregar una fotografia.",
                                                 preferredStyle: .Alert)
        
        let photoAction = UIAlertAction(title: "Agregar Fotografía",
                                         style: .Default,
                                         handler: { (action:UIAlertAction) -> Void in
                                            
          let txtMarker = (alertAddMarker.textFields?.first)! as UITextField
          self.markerName = txtMarker.text
          let lastLatitude = Double((self.lastLocation?.coordinate.latitude)!)
          let lastLongitude = Double((self.lastLocation?.coordinate.longitude)!)
                                            
          self.createNewPoint(self.routeName!, pointName: self.markerName!, latitude: lastLatitude, longitude: lastLongitude)
                                            
          self.addNewMarker(self.markerName!, markerLat: lastLatitude, markerLong: lastLongitude)
                                            
                                            
          if UIImagePickerController.isSourceTypeAvailable(.Camera){
            
            self.mPicker.sourceType = UIImagePickerControllerSourceType.Camera
            
          } else {
            
            self.mPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
          }
                                            
          self.presentViewController(self.mPicker, animated: true, completion: nil)
                                            
        })
        
        photoAction.enabled = false
        
        let saveAction = UIAlertAction(title: "Guardar Punto",
                                         style: .Default) { (action: UIAlertAction) -> Void in
                                            
        let txtMarker = (alertAddMarker.textFields?.first)! as UITextField
        self.markerName = txtMarker.text
        let lastLatitude = Double((self.lastLocation?.coordinate.latitude)!)
        let lastLongitude = Double((self.lastLocation?.coordinate.longitude)!)
                                            
        self.createNewPoint(self.routeName!, pointName: self.markerName!, latitude: lastLatitude, longitude: lastLongitude)
                                            
        self.addNewMarker(self.markerName!, markerLat: lastLatitude, markerLong: lastLongitude)
                                            
        }
        
        saveAction.enabled = false

        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .Destructive) { (action: UIAlertAction) -> Void in
                                            
        }
        
        alertAddMarker.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
            
            textField.placeholder = "Nombre"
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                
                photoAction.enabled = textField.text != ""
                saveAction.enabled = textField.text != ""
            }
            
        }
       
        
        alertAddMarker.addAction(photoAction)
        alertAddMarker.addAction(saveAction)
        alertAddMarker.addAction(cancelAction)
        
        presentViewController(alertAddMarker,
                              animated: true,
                              completion: nil)
        
        
    }
    
    
    
    
    @IBAction func scanQRCode(sender: AnyObject) {
        
        let scanViewController = storyboard?.instantiateViewControllerWithIdentifier("scan-vc")
        self.navigationController?.pushViewController(scanViewController!, animated: true)
    }
    
    
    @IBAction func showAR(sender: AnyObject) {
        
        let savedPoints = self.getRoutePoints(tblRoutesItems![self.selectedRouteIndex].name!)
        
        let pointsToShow = self.getARAnnotations(savedPoints)
        
        var arViewController = ARViewController()
        arViewController.debugEnabled = true
        arViewController.dataSource = self
        arViewController.maxDistance = 0
        arViewController.maxVisibleAnnotations = 100
        arViewController.maxVerticalLevel = 5
        arViewController.headingSmoothingFactor = 0.05
        arViewController.trackingManager.userDistanceFilter = 25
        arViewController.trackingManager.reloadDistanceFilter = 75
        
        arViewController.setAnnotations(pointsToShow)
        self.presentViewController(arViewController, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func shareRoutes(sender: AnyObject) {
        
        textToShare = ""
        
        textToShare += "La siguiente ruta podría ser de tú interés... \n\n Nombre: \(tblRoutesItems![selectedRouteIndex].name!):\n\n "
        
        textToShare += "Descripción: \(tblRoutesItems![selectedRouteIndex].detail!). Esta conformada por los siguientes puntos: \n\n"
        
        let pointsToShare = getRoutePoints(tblRoutesItems![selectedRouteIndex].name!)
        
        for point in pointsToShare {
        
        textToShare += "\t-> \(point.name!) \n"
        
        }
        
        //print(">>> Text To Share: \n \(textToShare)")
        
        let objectsToShare = [textToShare]
            
        let socialActivity = UIActivityViewController (activityItems: objectsToShare, applicationActivities: nil)
            
        self.presentViewController(socialActivity, animated: true, completion: nil)

        
    }
    
    @IBAction func closeRoute(sender: AnyObject) {
        
        
        let alertController = UIAlertController(title: "Confirmación", message: "¿Esta seguro que no desea incluir más puntos en la ruta \(self.routeName!)?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "No", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Si", style: .Default) { (action) in
            
            self.btnMarker.hidden = true
            self.btnSaveRoute.hidden = true
            self.btnScanQR.hidden = true
            self.btnShowAR.hidden = true
            self.btnShare.hidden = true
            
            self.tblRoutesItems = self.getSavedRoutes()
            self.tableRoutes.reloadData()
            self.lblRoutesInfo.text = " \(self.tblRoutesItems!.count) Ruta(s) Disponible(s)"
            
            self.routesMap.removeAnnotations(self.routesMap.annotations)
            self.routesMap.removeOverlays(self.routesMap.overlays)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
        
    }
    
    /******* FUNCIONALIDADES TABLE VIEW *********/
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tblRoutesItems!.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("routes-cell", forIndexPath: indexPath) as! RoutesTableViewCell
        
        if tblRoutesItems != nil {
        
            cell.routeTitleLbl?.text = tblRoutesItems![indexPath.row].name
            cell.routeDescriptionLbl?.text = tblRoutesItems![indexPath.row].detail
            let points = getRoutePoints(tblRoutesItems![indexPath.row].name!)
            cell.routePointsLbl?.text = String(points.count)
        }
        
        else{
            
            cell.routeTitleLbl?.text = ""
            cell.routeDescriptionLbl?.text = ""
            cell.routePointsLbl?.text = ""
        }

        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedRouteIndex = indexPath.row
        
        routesMap.removeAnnotations(routesMap.annotations)
        routesMap.removeOverlays(routesMap.overlays)
        
        btnMarker.hidden = true
        btnSaveRoute.hidden = true
        btnScanQR.hidden = false
        btnShowAR.hidden = false
        btnShare.hidden = false
        
        
        let points = getRoutePoints(tblRoutesItems![indexPath.row].name!)
        
        drawRouteFromCurrentLocation(points)
        
    }
    
    /******* FUNCIONALIDADES MAPA *********/
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            
            locManager.startUpdatingLocation()
            routesMap.showsUserLocation = true
            
        }else{
            
            locManager.stopUpdatingLocation()
            routesMap.showsUserLocation = false
            
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        routesMap.centerCoordinate = manager.location!.coordinate
        currentLocation = manager.location!
        
        /*
        let currentLocation : CLLocation = manager.location!
        
        var mapPoint = CLLocationCoordinate2D()
        mapPoint.latitude = currentLocation.coordinate.latitude
        mapPoint.longitude = currentLocation.coordinate.longitude
        
        if lastCoordinate != nil{
            
            let pin = MKPointAnnotation()
            pin.title = "Coordinates: \(mapPoint.latitude), \(mapPoint.longitude)"
            
            //let distance = lastCoordinate!.distanceFromLocation(currentLocation)
            //distanceTraveled += round(Double(distance.description)!)
            //pin.subtitle = "Distance Traveled: \(distanceTraveled)m"
            pin.coordinate = mapPoint
            
            routesMap.addAnnotation(pin)
            
        }else{
            
            let pin = MKPointAnnotation()
            //pin.title = "Latitude: \(mapPoint.latitude), Longitude: \(mapPoint.longitude)"
            //pin.subtitle = "Start Point"
            //pin.coordinate = mapPoint
            
            routesMap.addAnnotation(pin)
            
            
        }
        
        */
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Error: Code \(error.code) - \(error.description)")
        
        /*let errorAlert = UIAlertController(title: "Upsss!", message: "Error: \(error.code)", preferredStyle: .Alert)
         let okAction = UIAlertAction(title: "OK", style: .Default, handler: {accion in
         
         print("Ok button pressed!")
         })
         
         errorAlert.addAction(okAction)
         self.presentViewController(errorAlert, animated: true, completion: nil)*/
        
    }
    
    func setZoomMap(zoomLevel : Int){
        
        for i in 0 ..< zoomLevel {
            
            autoreleasepool{
                
                let span = MKCoordinateSpan(latitudeDelta: routesMap.region.span.latitudeDelta/2, longitudeDelta: routesMap.region.span.longitudeDelta/2)
                let region = MKCoordinateRegion(center: routesMap.region.center, span: span)
                
                routesMap.setRegion(region, animated: true)
                
            }
            
        }
        
    }
    
    func addNewMarker(markerTitle: String, markerLat: CLLocationDegrees, markerLong: CLLocationDegrees){
    
        let pin = MKPointAnnotation()
        let mapPoint = CLLocationCoordinate2D(latitude: markerLat, longitude: markerLong)
        pin.title = markerTitle
        pin.coordinate = mapPoint
        
        routesMap.addAnnotation(pin)
    }
    
    func drawRouteFromCurrentLocation(routePoints: [Point]) {
        
        //3000 hace referencia a 3 KM a la redonda a partir del punto central
        let region = MKCoordinateRegionMakeWithDistance((self.currentLocation?.coordinate)!, 3000, 3000)
        routesMap.setRegion(region, animated: true)
    
        var referenceCoordinate = currentLocation?.coordinate
        var referencePoint = MKPlacemark(coordinate: referenceCoordinate!, addressDictionary: nil)
        
        originMapItem = MKMapItem(placemark: referencePoint)
        originMapItem.name = "Inicio de Ruta"
        
        self.showPoint(originMapItem!)
        
        for point in routePoints {
            
            referenceCoordinate = CLLocationCoordinate2D (latitude:  CLLocationDegrees(point.latitude!), longitude: CLLocationDegrees(point.longitude!))
            referencePoint = MKPlacemark(coordinate: referenceCoordinate!, addressDictionary: nil)
            
            destinyMapItem = MKMapItem(placemark: referencePoint)
            destinyMapItem.name = point.name
            
            self.showPoint(destinyMapItem!)
            
            self.getRoute(self.originMapItem, routeDestiny: self.destinyMapItem)
            
            originMapItem = destinyMapItem
        
        }
    
    }
    
    func showPoint(point: MKMapItem){
        
        let pointToShow = MKPointAnnotation()
        
        pointToShow.coordinate = point.placemark.coordinate
        pointToShow.title = point.name
        routesMap.addAnnotation(pointToShow)
        
        
    }
    
    func getRoute(routeOrigin: MKMapItem, routeDestiny: MKMapItem){
        
        let routeRequest = MKDirectionsRequest()
        routeRequest.source = routeOrigin
        routeRequest.destination = routeDestiny
        routeRequest.transportType = .Walking
        
        let indications = MKDirections(request: routeRequest)
        indications.calculateDirectionsWithCompletionHandler({
            (routeResponse: MKDirectionsResponse?, error: NSError?) in
            
            if error != nil {
                
                print ("Error al obtener la ruta")
                
            } else {
                
                self.showRoute(routeResponse!)
                
            }
            
        })
        
    }
    
    func showRoute(route: MKDirectionsResponse){
        
        for route in route.routes{
            
            routesMap.addOverlay(route.polyline, level:MKOverlayLevel.AboveRoads)
            
            /*
            for step in route.steps{
                print(step.instructions)
            }
            */
        }
        
    }

    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay:overlay)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3.0
        
        return renderer
        
    }

    
    /******* FUNCIONALIDADES CAMARA *********/
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        // Se guarda marker en coreData
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

     /******* FUNCIONALIDADES CORE DATA *********/
    
    func createNewRoute(routeName: String, routeDescription: String){
    
        let routeEntity = NSEntityDescription.entityForName("Route", inManagedObjectContext: moc)
        let route = Route(entity: routeEntity!, insertIntoManagedObjectContext: moc)
        
        route.name = routeName
        route.detail = routeDescription
        
        do{
            
            try self.moc.save()
            
        } catch let error as NSError {
            print("createNewRoute Failed: \(error.localizedDescription)")
            
        }
    
    }
    
    func createNewPoint(routeName: String, pointName: String, latitude: Double, longitude: Double){
        
        let pointEntity = NSEntityDescription.entityForName("Point", inManagedObjectContext: moc)
        let point = Point(entity: pointEntity!, insertIntoManagedObjectContext: moc)
        
        point.routeName = routeName
        point.name = pointName
        point.latitude = latitude
        point.longitude = longitude
        
        do{
            
            try self.moc.save()
            
        } catch let error as NSError {
            print("createNewPoint Failed: \(error.localizedDescription)")
            
        }
        
    }
    
    
    func getSavedRoutes() -> [Route]{
        
        let routeEntity = NSEntityDescription.entityForName("Route", inManagedObjectContext: moc)
        let routesRequest = NSFetchRequest()
        routesRequest.entity = routeEntity
        
        //let whereCondition = NSPredicate(format: "routeName = %@", "")
        //routesRequest.predicate = whereCondition
        
        do{
            
            let result = try moc.executeFetchRequest(routesRequest)
            if result.count > 0
            {
                return result as! [Route]
            
            } else {
                return []
            }
        
        } catch let error as NSError {
            print("getSavedRoutes Failed: \(error.localizedDescription)")
            return []
        }
        
    }
    
    func getRoutePoints(routeName: String) -> [Point]{
        
        let routeEntity = NSEntityDescription.entityForName("Point", inManagedObjectContext: moc)
        let routesRequest = NSFetchRequest()
        routesRequest.entity = routeEntity
        
        let whereCondition = NSPredicate(format: "routeName = %@", routeName)
        routesRequest.predicate = whereCondition
        
        do{
            
            let result = try moc.executeFetchRequest(routesRequest)
            if result.count > 0
            {
                return result as! [Point]
                
            } else {
                return []
            }
            
        } catch let error as NSError {
            print("getRoutePoints Failed: \(error.localizedDescription)")
            return []
        }
        
    }
    
    /******* FUNCIONALIDADES REALIDAD AUMENTADA *********/
    
    func ar(arAnnotationView: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView{
        
        let viewAR = TestAnnotationView()
        viewAR.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        viewAR.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
        
        return viewAR
        
    }
    
    private func getARAnnotations(points:[Point]) -> Array<ARAnnotation>
    {
        
        var annotations: [ARAnnotation] = []
        
        for point in points
        {
            let annotation = ARAnnotation()
            annotation.location = CLLocation(latitude: Double(point.latitude!), longitude: Double(point.longitude!))
            annotation.title = point.name
            annotations.append(annotation)
        }
        
        return annotations
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
