//
//  Todo.swift
//  swift_data_flow_example (iOS)
//
//  Created by Anton Wyrowski on 20.03.22.
//

import Foundation

struct Todo: Identifiable {
    let id: UUID = UUID()
    let task: String
    var done: Bool = false
    let priority: TaskPriority
    let deadline: Date
}

enum TaskPriority: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}
