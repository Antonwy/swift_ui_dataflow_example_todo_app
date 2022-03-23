//
//  CreateTodoViewModel.swift
//  swift_data_flow_example (iOS)
//
//  Created by Anton Wyrowski on 20.03.22.
//

import Foundation

class CreateTodoViewModel: ObservableObject {
    private static let initialTask = ""
    
    private static var initialDeadline: Date { Calendar.current.date(byAdding: .day, value: 1, to: Date())! }
    
    private static let initialPriority = TaskPriority.low
    
    @Published var task = CreateTodoViewModel.initialTask
    
    @Published var deadline = CreateTodoViewModel.initialDeadline
    
    @Published var priority = CreateTodoViewModel.initialPriority
    
    func reset() {
        self.task = Self.initialTask
        self.deadline = Self.initialDeadline
        self.priority = Self.initialPriority
    }
    
    func asTodo() -> Todo {
        Todo(task: task, priority: priority, deadline: deadline)
    }
}
