//
//  HomeVC.swift
//  DoloChallenge
//
//  Created by Kevin Langelier on 2/26/18.
//  Copyright © 2018 Kevin Langelier. All rights reserved.
//

import UIKit
import CoreLocation

class HomeVC: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    
    @IBOutlet weak var icon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

    }

    @IBAction func newPostPressed(_ sender: Any) {
        performSegue(withIdentifier: "toNewPostVC", sender: nil)
    }
}

