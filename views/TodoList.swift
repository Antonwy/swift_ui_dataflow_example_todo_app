//
//  TodoList.swift
//  swift_data_flow_example (iOS)
//
//  Created by Anton Wyrowski on 20.03.22.
//

import SwiftUI

struct TodoList: View {
    @EnvironmentObject var todosViewModel: TodosViewModel;
    
    var body: some View {
        List {
            ForEach($todosViewModel.todos) { $todo in
                TodoItem(todo: $todo)
            }
            .onDelete(perform: todosViewModel.removeTodo)
        }
        .navigationTitle("Todos")
        .toolbar {
            Button {
                todosViewModel.showAddTodoSheet = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
            }
        }
        .sheet(isPresented: $todosViewModel.showAddTodoSheet) {
            CreateTodoSheet()
        }
    }
}

struct TodoList_Previews: PreviewProvider {
    static var previews: some View {
        TodoList()
    }
}
