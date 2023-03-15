//
//  DataManager.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import Foundation

class DataManager {
    
    private static let path = "https://www.swissquote.ch/mobile/iphone/Quote.action?formattedList&formatNumbers=true&listType=SMI&addServices=true&updateCounter=true&&s=smi&s=$smi&lastTime=0&&api=2&framework=6.1.1&format=json&locale=en&mobile=iphone&language=en&version=80200.0&formatNumbers=true&mid=5862297638228606086&wl=sq"
    
    func fetchQuotes(completionHandler: @escaping (([Quote]?) -> Void)) {
        guard let url = URL(string: Self.path) else {
            completionHandler(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil)
                return
            }
            if let quotes = try? JSONDecoder().decode([Quote].self, from: data) {
                completionHandler(quotes)
            } else {
                completionHandler(nil)
            }
        }.resume()
    }
    
}
