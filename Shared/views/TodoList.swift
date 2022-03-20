//
//  TodoList.swift
//  swift_data_flow_example (iOS)
//
//  Created by Anton Wyrowski on 20.03.22.
//

import SwiftUI

struct TodoList: View {
    @EnvironmentObject var todosController: TodosController;
    
    var body: some View {
        List {
            ForEach($todosController.todos) { $todo in
                TodoItem(todo: $todo)
            }
            .onDelete(perform: todosController.removeTodo)
        }
        .navigationTitle("Todos")
        .toolbar {
            Button {
                todosController.showAddTodoSheet = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
            }
        }
        .sheet(isPresented: $todosController.showAddTodoSheet) {
            CreateTodoSheet()
        }
    }
}

struct TodoList_Previews: PreviewProvider {
    static var previews: some View {
        TodoList()
    }
}
