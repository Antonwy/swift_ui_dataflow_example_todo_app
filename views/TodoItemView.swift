//
//  TodoItemView.swift
//  swift_data_flow_example (iOS)
//
//  Created by Anton Wyrowski on 20.03.22.
//

import SwiftUI

struct TodoItemView: View {
    @Binding var todo: Todo
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Toggle(isOn: $todo.done, label: {})
                .toggleStyle(CheckboxToggleStyle())
            VStack(alignment: .leading) {
                Text(todo.task).bold().font(.headline)
                    .padding(.bottom, 4)
                Group {
                    Text("Deadline: ") +
                    Text(todo.deadline.formatted(date: .abbreviated, time: .omitted))
                        .bold()
                    Text("Priority: ") +
                    Text(todo.priority.rawValue)
                        .bold()
                }
                .font(.system(size: 14))
            }
            .padding(.vertical)
        }
    }
}


struct TodoItemView_Previews: PreviewProvider {
    static var mockTodos = [
        Todo(task: "Shop Groceries", done: true, priority: .low, deadline: Date()),
        Todo(task: "Watch the new Spiderman Movie", done: false, priority: .high, deadline: Date().advanced(by: 24*60*60)),
    ]
    
    static var previews: some View {
        Group {
            List(.constant(Self.mockTodos)) { todo in
                TodoItemView(todo: todo)
            }
        }
    }
}
