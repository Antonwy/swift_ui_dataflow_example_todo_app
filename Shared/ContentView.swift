//
//  ContentView.swift
//  Shared
//
//  Created by Anton Wyrowski on 20.03.22.
//

import SwiftUI

struct ContentView: View {
        
    @StateObject var todosController = TodosController()
    
    var body: some View {
        NavigationView {
            TodoList()
        }
        .onAppear {
            todosController.loadTodos()
        }
        .environmentObject(todosController)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
