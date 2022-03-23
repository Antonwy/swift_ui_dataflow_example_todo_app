//
//  TodoList.swift
//  swift_data_flow_example (iOS)
//
//  Created by Anton Wyrowski on 20.03.22.
//

import SwiftUI

struct TodoList: View {
    @EnvironmentObject var todosViewModel: TodosViewModel
    
    var body: some View {
        List {
            ForEach($todosViewModel.todos) { $todo in
                TodoItemView(todo: $todo)
            }
            .onDelete(perform: todosViewModel.removeTodo)
        }
        .navigationTitle("Todos")
        .toolbar {
            Button {
                todosViewModel.showAddTodoSheet = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
            }
        }
        .sheet(isPresented: $todosViewModel.showAddTodoSheet) {
            CreateTodoSheet(createTodoViewModel: todosViewModel.addTodoViewModel)
        }
    }
}

struct TodoList_Previews: PreviewProvider {
    static var model: TodosViewModel {
        let viewmodel = TodosViewModel()
        for todo in TodoItemView_Previews.mockTodos {
            viewmodel.addTodo(todo)
        }
        return viewmodel
    }
    
    
    static var previews: some View {
        NavigationView {
            TodoList()
        }
        .environmentObject(Self.model)
    }
}
