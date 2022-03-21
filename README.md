# swift_ui_dataflow_example_todo_app

### 0. Present Complete Prototype

### 1. `ContentView.swift`

```swift
struct ContentView: View {    
    var body: some View {
        Text("Hello World")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

```

### 2. `models/Todo.swift`

Define what a Todo item actually is:

```swift
struct Todo: Identifiable {
    let id: UUID = UUID()
    let task: String
    var done: Bool = false
    let priority: TaskPriority
    let deadline: Date
}

enum TaskPriority: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}
```

### 3. `views/TodoItem.swift

Let's create a view for displaying Todo items now. This view should show a single item and will later be used in a list.

```swift
import SwiftUI

struct TodoItem: View {
    @Binding var todo: Todo
    
    var body: some View {
        EmptyView()
    }
}
```

Before we start really adding content to the view, let's create a quick preview:

```swift
struct TodoItem_Previews: PreviewProvider {
    static var mockTodos = [
        Todo(task: "Shop Groceries", done: false, priority: .low, deadline: Date()),
        Todo(task: "Watch the new Spiderman Movie", done: false, priority: .high, deadline: Date().advanced(by: 24*60*60)),
    ]
    
    static var previews: some View {
        Group {
            List(.constant(Self.mockTodos)) { todo in
                TodoItem(todo: todo)
            }
        }
    }
}
```


```swift
import SwiftUI

struct TodoItem: View {
    @Binding var todo: Todo
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Toggle(isOn: $todo.done, label: {})
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
```

### very end. `custom_styles/CheckboxToggleStyle.swift`



and add `.toggleStyle(CheckboxToggleStyle())` to `views/TodoItem.swift`.
