//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Landon Cayia on 7/1/22.
//

import Foundation
import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    
    var color: Color {
        switch amount {
        case ..<10:
            return .green
        case 10..<100:
            return .orange
        default:
            return .red
        }
    }
}
