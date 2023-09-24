//
//  CitiesService.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 21/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import Foundation

protocol CitiesProtocol {
    func loadConnections() async -> Connections?
}

struct CitiesService: CitiesProtocol {
    
    let url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    func loadConnections() async -> Connections? {
        guard let url = url else {
            return nil
        }
        
        do {
            let session = URLSession.shared
            let (data, _) = try await session.data(from: url)
            let connections = try JSONDecoder().decode(Connections.self, from: data)
            
            return connections
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
