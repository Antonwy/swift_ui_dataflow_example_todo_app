//
//  TodosController.swift
//  swift_data_flow_example (iOS)
//
//  Created by Anton Wyrowski on 20.03.22.
//

import Foundation


class TodosController: ObservableObject {
    @Published var todos: [Todo] = [] {
        didSet {
            jsonProvider.writeTodos(todos)
        }
    }
    @Published var showAddTodoSheet = false
    private let jsonProvider = JsonProvider()
    
    func loadTodos() {
        todos = jsonProvider.readTodos()
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    func removeTodo(at offset: IndexSet) {
        todos.remove(atOffsets: offset)
    }
}
