//
//  DataService.swift
//  DoloChallenge
//
//  Created by Kevin Langelier on 2/26/18.
//  Copyright © 2018 Kevin Langelier. All rights reserved.
//

import Foundation
import CoreLocation

// Retrieves nearby locations from FourSquare, parses the JSON, and returns array of Location objects via escaping closure.

class DataService {
    
    static let instance = DataService()
    
    func getNearbyLocations(location: CLLocation, completion: @escaping ([Location]?) -> ()) {
        
        let apiPath = "https://api.foursquare.com/v2/venues/search?ll="
        let apiQuery = "&intent=checkin&radius=500&limit=20&oauth_token=OJYYVNIYVTYXOD3MIVZTGECGCIHVERUJU0HQ14WLEO2YZSDN&v=20180226"
        var locations: [Location] = []
        let latitude = location.coordinate.latitude.description
        let longitude = location.coordinate.longitude.description
        
        let urlString = apiPath + latitude + "," + longitude + apiQuery
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return }
                guard let res = json["response"] as? [String:Any] else { return }
                guard let venues = res["venues"] as? [[String:Any]] else { return }
                for venue in venues {
                    var name: String?
                    var address: String?
                    var distance: Int?
                    var iconUrl: String?
                    name = venue["name"] as? String
                    if let location = venue["location"] as? [String:Any] {
                        address = location["address"] as? String
                        distance = location["distance"] as? Int
                    }
                    if let categories = venue["categories"] as? [[String:Any]] {
                        if let icon = categories.first?["icon"] as? [String:Any] {
                            iconUrl = icon["prefix"] as! String + "bg_88.png"
                        }
                    }
                    locations.append(Location(name: name ?? "Unknown", address: address ?? "Unknown", distance: distance ?? -1, icon: iconUrl ?? ""))
                }
                DispatchQueue.main.async {
                    completion(locations)
                }
            } catch let jsonError {
                print(jsonError.localizedDescription)
            }
        }.resume()
        
    }
    
}
