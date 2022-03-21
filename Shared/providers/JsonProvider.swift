//
//  JsonProvider.swift
//  swift_data_flow_example (iOS)
//
//  Created by Anton Wyrowski on 20.03.22.
//

import Foundation

class JsonProvider {
    private let jsonFileName = "todos.json"
    let fileUrl: URL?;
    
    init() {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        self.fileUrl = directory?.appendingPathComponent(jsonFileName)
    }
    
    func writeTodos(_ todos: [Todo]) {
        guard let url = fileUrl else {
            print("Bundle url invalid")
            return
        }
        
        do {
            try JSONEncoder().encode(todos).write(to: url)
        } catch {
            print(error)
        }
    }
    
    func readTodos() -> [Todo] {
        guard let json = readJson() else {
            print("Couldn't read todos from json!")
            return []
        }
        
        do {
            return try JSONDecoder().decode([Todo].self,from: json)
        } catch {
            print("Error decoding json to todos!")
            return []
        }
    }
    
    private func readJson() -> Data? {
        guard let url = fileUrl else {
            return nil
        }

        do {
            return try Data(contentsOf: url)
        } catch {
            print(error)
            return nil
        }
    }
}
