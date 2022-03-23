//
//  AddTodoSheet.swift
//  swift_data_flow_example (iOS)
//
//  Created by Anton Wyrowski on 20.03.22.
//

import SwiftUI

struct CreateTodoSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var createTodoViewModel: CreateTodoViewModel
    
    @EnvironmentObject var todosViewModel: TodosViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section("Task") {
                    TextField("Task...", text: $createTodoViewModel.task)
                    DatePicker("Deadline", selection: $createTodoViewModel.deadline, in: Date()...)
                    Picker("Priority", selection: $createTodoViewModel.priority) {
                        ForEach(TaskPriority.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    Button("Save") {
                        todosViewModel.addTodo(createTodoViewModel.asTodo())
                        dismiss()
                    }
                }
            }
            .navigationTitle("Create Todo")
            .navigationBarItems(trailing: Button(action: {
                createTodoViewModel.reset()
                dismiss()
            }) {
                Text("Discard").bold().foregroundColor(.red)
            })
        }
    }
}

struct CreateTodoSheet_Previews: PreviewProvider {
    static var previews: some View {
        Color.clear
            .sheet(isPresented: .constant(true)) {
                CreateTodoSheet(createTodoViewModel: CreateTodoViewModel())
            }
            .environmentObject(TodosViewModel())
    }
}
