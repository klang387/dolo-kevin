//
//  NearbyLocationsVC.swift
//  DoloChallenge
//
//  Created by Kevin Langelier on 2/26/18.
//  Copyright © 2018 Kevin Langelier. All rights reserved.
//

import UIKit
import CoreLocation

class NearbyLocationsVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationsTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var locationManager: CLLocationManager!
    var locations: [Location] = []
    var filteredLocations: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationsTable.delegate = self
        locationsTable.dataSource = self
        searchBar.delegate = self
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).leftView = nil
        UISearchBar.appearance().searchTextPositionAdjustment = UIOffsetMake(10, 0)
        
        if let location = locationManager.location {
            DataService.instance.getNearbyLocations(location: location, completion: { (locations) in
                guard locations != nil else { return }
                self.locations = locations!
                self.filteredLocations = locations!
                self.locationsTable.reloadData()
            })
        }
    }

    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

// UITextField Delegate Functions

extension NearbyLocationsVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredLocations = searchText.isEmpty ? locations : locations.filter({ (location) -> Bool in
            return location.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        locationsTable.reloadData()
        locationsTable.isHidden = filteredLocations.count == 0 ? true : false
    }
    
}

// UITableView Delegate Functions

extension NearbyLocationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as? LocationCell {
            cell.name.text = filteredLocations[indexPath.row].name
            cell.address.text = filteredLocations[indexPath.row].address
            cell.distance.text = "\(filteredLocations[indexPath.row].distance)m"
            let urlString = filteredLocations[indexPath.row].icon
            if urlString != "" {
                ImageCache.instance.getImage(url: urlString, completion: { (image) in
                    cell.icon.image = image
                })
            } else {
                cell.icon.image = UIImage(named: "icnLocationMarker")
            }
            return cell
        }
        return LocationCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let newPostVC = presentingViewController as? NewPostVC else { return }
        newPostVC.locationLbl.text = filteredLocations[indexPath.row].name
        newPostVC.locationOptionalLbl.text = "Change Location"
        ImageCache.instance.getImage(url: filteredLocations[indexPath.row].icon) { (image) in
            newPostVC.locationIcon.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}
