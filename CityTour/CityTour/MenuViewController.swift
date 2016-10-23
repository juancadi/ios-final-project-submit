//
//  ViewController.swift
//  CityTour
//
//  Created by JUAN ANDRÉS CÁRDENAS DIAZ on 10/10/16.
//  Copyright © 2016 JUAN ANDRÉS CÁRDENAS DIAZ. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuTableView: UITableView!
    

    var menuLabels:[String] = [
        "Mis Rutas", "Escaner", "Eventos", "Acerca de..."]
    var menuImages = [
        UIImage(named:"ic_menu_routes"), UIImage(named:"ic_menu_qr"), UIImage(named:"ic_menu_events"), UIImage(named:"ic_menu_about")]
    var menuIds:[String] = [
        "routes-vc", "scan-vc", "events-vc", "about-vc"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuLabels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
         let cell = tableView.dequeueReusableCellWithIdentifier("menu-cell", forIndexPath: indexPath) as! MenuTableViewCell
        
        cell.menuLbl?.text = menuLabels[indexPath.row]
        cell.menuImg?.image = menuImages[indexPath.row]
        
        return cell
        
 
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vcName = menuIds[indexPath.row]
        let viewController = storyboard?.instantiateViewControllerWithIdentifier(vcName)
        self.navigationController?.pushViewController(viewController!, animated: true)
 
    }


}

