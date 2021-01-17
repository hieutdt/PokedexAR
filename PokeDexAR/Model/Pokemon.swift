//
//  Pokemon.swift
//  PokeDexAR
//
//  Created by Trần Đình Tôn Hiếu on 1/16/21.
//

import Foundation
import UIKit

public enum PokemonType: String {
    case normal = "normal"
    case fire = "fire"
    case water = "water"
    case grass = "grass"
    case electric = "electric"
    case ice = "ice"
    case dark = "dark"
    case ghost = "ghost"
    case fairy = "fairy"
    case dragon = "dragon"
}

public struct Pokemon: Identifiable, Hashable {
    
    public var id = UUID().uuidString
    
    var name: String = ""
    var type: PokemonType = .normal
    var thumbUrl: String = ""
    var arImageName: String = ""
    var arModelName: String = ""
    var desc: String = ""
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(dictionary: [String: Any]) {
        if dictionary.isNotEmpty() {
            self.name = dictionary.stringValueForKey("name")
            self.type = PokemonType(rawValue: dictionary.stringValueForKey("type")) ?? .normal
            self.thumbUrl = dictionary.stringValueForKey("thumbImageUrl")
            self.arImageName = dictionary.stringValueForKey("3DModelFileName")
            self.arModelName = dictionary.stringValueForKey("3DModelName")
            self.desc = dictionary.stringValueForKey("description")
        }
    }
    
    public static func colorByType(_ type: PokemonType) -> UIColor {
        switch type {
        case .fire:
            return .systemRed
            
        case .normal:
            return .systemGray
            
        case .water:
            return .systemBlue
        
        case .electric:
            return .systemYellow
            
        case .ice:
            return .systemTeal
            
        case .grass:
            return .systemGreen
        
        default:
            return .white
        }
    }
}
