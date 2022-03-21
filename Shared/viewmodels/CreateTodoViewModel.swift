//
//  CreateTodoViewModel.swift
//  swift_data_flow_example (iOS)
//
//  Created by Anton Wyrowski on 20.03.22.
//

import Foundation

class CreateTodoViewModel: ObservableObject {
    @Published var task: String = ""
    private let today: Date = Date()
    @Published var deadline: Date
    @Published var priority: TaskPriority = .low
    
    init() {
        self.deadline = Calendar.current.date(byAdding: .day, value: 1, to: today)!
    }
    
    func asTodo() -> Todo {
        return Todo(task: task, priority: priority, deadline: deadline)
    }
 
}
