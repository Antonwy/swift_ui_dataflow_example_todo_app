//
//  TodoItem.swift
//  swift_data_flow_example (iOS)
//
//  Created by Anton Wyrowski on 20.03.22.
//

import SwiftUI

struct TodoItem: View {
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
                    Text(todo.deadline.toReadableString() ?? "No date secified")
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
