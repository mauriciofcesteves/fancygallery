//
//  Network.swift
//  FancyGallery
//
//  Created by Mauricio Esteves on 2020-01-06.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

/* Manage the network callbacks. */
public class NetworkManager {
    
    /* MARK: STATIC ENDPOINTS */
    static let ENDPOINT = "https://www.mocky.io/v2/5e13522a3100007952d47753"
    static let DELAY_ENDPOINT = "https://www.mocky.io/v2/5e13522a3100007952d47753?mocky-delay=100ms"
    
    /* MARK: STATIC SINGLETON */
    static let shared = NetworkManager()
    
    public var pets: [PhotoModel]?
    
    private init() {}
    
    /* Fetch a list of Photos from an endpoint. */
    func requestPhotoData(completion: @escaping (Bool, [PhotoModel]?) -> ()) {
        let urlString = NetworkManager.ENDPOINT
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let `self` = self else {
                completion(false, nil)
                return
            }
            
            if error != nil {
                print(error!.localizedDescription)
                completion(false, nil)
                return
            }
            
            guard let data = data else {
                completion(false, nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if let jsonResponse = json["pets"] as? NSArray {
                        self.pets = []
                        for pet in jsonResponse {
                            if let currentPet = pet as? [String: Any] {
                                let newPet = PhotoModel(json: currentPet)
                                
                                if newPet.id.isEmpty {
                                    completion(false, nil)
                                    return
                                }
                                
                                self.pets?.append(newPet)
                            }
                        }
                        
                        completion(true, self.pets)
                    }
                }
            } catch {
                print("error casting json")
                completion(false, nil)
                return
            }
            
            }.resume()
        //End of URLSession implementation
    }
}
