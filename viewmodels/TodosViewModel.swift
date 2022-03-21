//
//  TodosViewModel.swift
//  swift_data_flow_example (iOS)
//
//  Created by Anton Wyrowski on 20.03.22.
//

import Foundation


class TodosViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    
    @Published var showAddTodoSheet = false
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    func removeTodo(at offset: IndexSet) {
        todos.remove(atOffsets: offset)
    }
}
