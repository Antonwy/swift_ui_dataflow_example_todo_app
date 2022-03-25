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
The `CaseIterable` is syntesized by the compiler and gives us an array containing all cases of `TaskPriority`

### 3. `views/TodoItemView.swift`

Let's create a view for displaying Todo items now. This view should show a single item and will later be used in a list.

```swift
import SwiftUI

struct TodoItemView: View {
    @Binding var todo: Todo
    
    var body: some View {
        EmptyView()
    }
}
```

Before we start really adding content to the view, let's create a quick preview:

```swift
struct TodoItemView_Previews: PreviewProvider {
    static var mockTodos = [
        Todo(task: "Shop Groceries", done: false, priority: .low, deadline: Date()),
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
```


```swift
import SwiftUI

struct TodoItemView: View {
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

### 4. `custom_styles/CheckboxToggleStyle.swift`

We create a custom `ToggleStyle` because the default toggle doesn't really look good in our design

```swift
struct CheckboxToggleStyle: ToggleStyle {
  func makeBody(configuration: Configuration) -> some View {
    Button(action: {
      configuration.isOn.toggle()
    }, label: {
      HStack {
        Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
          .imageScale(.large)
        configuration.label
      }
    })
    .buttonStyle(PlainButtonStyle())
  }
}

```

and add `.toggleStyle(CheckboxToggleStyle())` to `views/TodoItem.swift`.

### 5. `viewmodels/CreateTodoViewModel.swift`

This model will be used to produce new Todos.

```swift
class CreateTodoViewModel: ObservableObject {
    private static let initialTask = ""
    
    private static var initialDeadline: Date { Calendar.current.date(byAdding: .day, value: 1, to: Date())! }
    
    private static let initialPriority = TaskPriority.low
    
    @Published var task = CreateTodoViewModel.initialTask
    
    @Published var deadline = CreateTodoViewModel.initialDeadline
    
    @Published var priority = CreateTodoViewModel.initialPriority
    
    func asTodo() -> Todo {
        Todo(task: task, priority: priority, deadline: deadline)
    }
}
```

### 6. `viewmodels/TodosViewModel.swift`

This model manages the entire todo-list. It basically is the main model for the entire app.

```swift
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
```

### 7. `ContentView.swift`

This viewmodel will be owned by our top-most view, the `ContentView`. If we want a view to own a viewmodel, we use `@StateObject`. This works basically exactly like `@State`, but with reference types that conform to `ObservableObject` instead of with value-types. This also means the viewmodel's lifetime is bound to that of `ContentView`.

```swift
struct ContentView: View {
    @StateObject var todosViewModel = TodosViewModel()
    
    var body: some View {
        NavigationView {
            TodoList()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
```

### 8. `views/TodoList.swift`

We use `@ObservedObject` here as this view model is not owned by `TodoList`. Instead, its lifetime is the same as in the view from which the viewmodel gets passed in.

```swift
struct TodoList: View {
    @ObservedObject var todosViewModel: TodosViewModel
    
    var body: some View {
        List {
            ForEach($todosViewModel.todos) { $todo in
                TodoItemView(todo: $todo)
            }
            .onDelete(perform: todosViewModel.removeTodo)
        }
        .navigationTitle("Todos")
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
        TodoList(todosViewModel: Self.model)
    }
}
```

### 9. `ContentView.swift`

Speaking of which, we have to pass the viewmodel down into `TodoList` here.

```swift
struct ContentView: View {
    @StateObject var todosViewModel = TodosViewModel()
    
    var body: some View {
        NavigationView {
            TodoList(todosViewModel: todosViewModel)
        }
    }
}
```

### 10. `views/TodoList.swift`

We can't see the title yet, as this preview does currently not take place in a `NavigationView`:

```swift
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
            TodoList(todosViewModel: Self.model)
        }
    }
}
```

### 11. `views/CreateTodoSheet.swift`

We also want to be able to create new todos:

```swift

struct CreateTodoSheet: View {
    @StateObject var createTodoViewModel = CreateTodoViewModel()
    
    @ObservedObject var todosViewModel: TodosViewModel
    
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
                    }
                }
            }
            .navigationTitle("Create Todo")
        }
    }
}

struct CreateTodoSheet_Previews: PreviewProvider {
    static var previews: some View {
        Color.clear
            .sheet(isPresented: .constant(true)) {
                CreateTodoSheet(todosViewModel: TodosViewModel())
            }
    }
}
```

### 12. `views/TodoList.swift`

We now add the plus button the the `TodoList` and a `sheet` that pops up when this button is pressed showing the `CreateTodoSheet`.

```swift
struct TodoList: View {
    @ObservedObject var todosViewModel: TodosViewModel
    
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
            CreateTodoSheet(todosViewModel: todosViewModel)
        }
    }
}
```

### 13. `views/TodoList.swift`

I dislike how I have to explicitly pass the `TodosViewModel` around everywhere, as it is basically used in every bigger view of my app. Let's fix that.

SwiftUI provides a special feature for that: the environment

`views/CreateTodoSheet.swift` -> change to `@EnvironmentObject`

It works exactly like `@ObservedObject`, except we don't have to provide its value.

`views/TodoList.swift` -> change to `@EnvironmentObject`, remove initializer argument

Where are the `@EnvironmentObject`'s getting the viewmodel from? -> we have to pass it into the view stack somewhere using the `View.environmentObject(_:)` function:

`ContentView.swift` -> add `.environmentObject(todosViewModel)`, remove initializer argument

--> we also have to pass the viewmodel into the environment for previews!

```swift
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
```

```swift
struct CreateTodoSheet_Previews: PreviewProvider {
    static var previews: some View {
        Color.clear
            .sheet(isPresented: .constant(true)) {
                CreateTodoSheet()
            }
            .environmentObject(TodosViewModel())
    }
}

```

### 14. `views/CreateTodoSheet.swift`

I want the sheet to close automatically when I press "Save".

We can use `@Environment(\.dismiss)` for that. Now, `@Environment` is to `@State`, what `@EnvironmentObject` is to `@StateObject`. However it does not use the type to identify the right object in the environment, but KeyPaths on a type called `EnvironmentValues`.

The respective elements in the environment are usually provided by SwiftUI itself or other SwiftUI frameworks, but you can also define your own.

Now, `@Environment(\.dismiss)` gives us a type that can be called as a function. This function dismisses the top-most view on the stack that defines a dismiss action. In our case the `sheet`.

We can now also create an extra button that discards our input and closes the sheet (just as the swipe-down gesture does).

```swift
struct CreateTodoSheet: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var createTodoViewModel = CreateTodoViewModel()
    
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
                dismiss()
            }) {
                Text("Discard").bold().foregroundColor(.red)
            })
        }
    }
}
```

### 15. `views/CreateTodoSheet.swift`

We're almost done now. However, we wanted to not reset the input if we just dismiss the sheet without tapping "Discard" or "Save".

To achieve this, we have to increase the lifetime of the `CreateTodoViewModel`. Currently it dies when the sheet is dismissed and is recreated when its opened.

We make it an `@ObservedObject` and pass it in from the `TodoList` (which lives as long as the app does). 

```swift
struct CreateTodoSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var createTodoViewModel: CreateTodoViewModel


struct CreateTodoSheet_Previews: PreviewProvider {
    static var previews: some View {
        Color.clear
            .sheet(isPresented: .constant(true)) {
                CreateTodoSheet(createTodoViewModel: CreateTodoViewModel())
```

### 16. `views/TodoList.swift`

We could store the `CreateTodoViewModel` on this view using `@StateObject`. However, we are going to store it inside the `TodosViewModel`, as that allows us to have the two models interact with each other, without the `View` code getting involved.

`viewmodels/TodosViewModel.swift`
```swift
class TodosViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    
    @Published var showAddTodoSheet = false
    
    let addTodoViewModel = CreateTodoViewModel()
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    func removeTodo(at offset: IndexSet) {
        todos.remove(atOffsets: offset)
    }
}
```

`views/TodoList.swift`
```swift
        .sheet(isPresented: $todosViewModel.showAddTodoSheet) {
            CreateTodoSheet(createTodoViewModel: todosViewModel.addTodoViewModel)
        }

```

### 17. `viewmodels/CreateTodoViewModel.swift`

We now have to manually reset the view model.

```swift
class CreateTodoViewModel: ObservableObject {
    private static let initialTask = ""
    
    private static var initialDeadline: Date { Calendar.current.date(byAdding: .day, value: 1, to: Date())! }
    
    private static let initialPriority = TaskPriority.low
    
    @Published var task = CreateTodoViewModel.initialTask
    
    @Published var deadline = CreateTodoViewModel.initialDeadline
    
    @Published var priority = CreateTodoViewModel.initialPriority
    
    func reset() {
        self.task = Self.initialTask
        self.deadline = Self.initialDeadline
        self.priority = Self.initialPriority
    }
```

This can be done by the `TodosViewModel` on save!

`viewmodels/TodosViewModel.swift`
```swift
class TodosViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    
    @Published var showAddTodoSheet = false
    
    let addTodoViewModel = CreateTodoViewModel()
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
        addTodoViewModel.reset()
    }
```

And we can still to it manually inside the view code for the discard button:

`views/CreateTodoSheet.swift`
```swift
            .navigationBarItems(trailing: Button(action: {
                createTodoViewModel.reset()
                dismiss()
            }) {
                Text("Discard").bold().foregroundColor(.red)
            })
```
