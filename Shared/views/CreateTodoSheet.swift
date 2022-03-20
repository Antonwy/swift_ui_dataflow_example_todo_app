//
//  AddTodoSheet.swift
//  swift_data_flow_example (iOS)
//
//  Created by Anton Wyrowski on 20.03.22.
//

import SwiftUI

struct CreateTodoSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var createTodoController = CreateTodoController()
    
    @EnvironmentObject var todosController: TodosController
    
    var body: some View {
        NavigationView {
            List {
                Section("Task") {
                    TextField("Task...", text: $createTodoController.task)
                    DatePicker("Deadline", selection: $createTodoController.deadline, in: Date()...)
                    Picker("Priority", selection: $createTodoController.priority) {
                        ForEach(TaskPriority.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    Button("Save") {
                        todosController.addTodo(createTodoController.asTodo())
                        dismiss()
                    }
                }
            }
            .navigationTitle("Create todo")
            .navigationBarItems(trailing: Button(action: {
                dismiss()
            }) {
                Text("Cancel").bold().foregroundColor(.red)
            })
        }
    }
}

struct CreateTodoSheet_Previews: PreviewProvider {
    static var previews: some View {
        CreateTodoSheet()
    }
}
