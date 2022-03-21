//
//  ContentView.swift
//  Shared
//
//  Created by Anton Wyrowski on 20.03.22.
//

import SwiftUI

struct ContentView: View {
        
    @StateObject var todosViewModel = TodosViewModel()
    
    var body: some View {
        NavigationView {
            TodoList()
        }
        .onAppear {
            todosViewModel.loadTodos()
        }
        .environmentObject(todosViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
