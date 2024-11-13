//
//  Memory.swift
//  Nostalgia
//
//  Created by Tanmoy Biswas on 13/11/24.
//

import Foundation
import SwiftUI

struct Memory: Identifiable, Codable {
    var id = UUID()
    var text: String
    var date: Date
    var photoData: Data?
}
