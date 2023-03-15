//
//  Market.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 30.04.21.
//

import Foundation


class Market: Decodable {
    var marketName:String = "SMI"
    var quotes:[Quote]? = []
}
