//
//  Todo.swift
//  swift_data_flow_example (iOS)
//
//  Created by Anton Wyrowski on 20.03.22.
//

import Foundation

struct Todo: Codable, Identifiable {
    let id: String
    let task: String
    var done: Bool
    let priority: TaskPriority
    let deadline: Date
    
    init(task: String, done: Bool = false, priority: TaskPriority, deadline: Date) {
        self.task = task
        self.done = done
        self.priority = priority
        self.deadline = deadline
        self.id = UUID().uuidString
    }
    
    
}

enum TaskPriority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}
