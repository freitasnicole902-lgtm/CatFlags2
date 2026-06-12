//
//  Situation.swift
//  CatFlags
//
//  Created by academy on 10/06/26.
//

import Foundation

struct Situation: Codable, Identifiable {
    let id: Int
    let theme: Theme
    let text: String
}
