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
        do {
            if let url = fileUrl {
                try JSONEncoder().encode(todos).write(to: url)
            } else {
                print("Bundle url invalid")
            }
        } catch {
            print(error)
        }
    }
    
    func readTodos() -> [Todo] {
        let json = readJson()
        
        if json == nil {
            print("Couldn't read todos from json!")
            return []
        }
        
        do {
            let decodedTodos = try JSONDecoder().decode([Todo].self,
                                                       from: json!)

            return decodedTodos
        } catch {
            print("Error decoding json to todos!")
        }
        
        return []
    }
    
    private func readJson() -> Data? {
        do {
            if let url = fileUrl,
               let jsonData: Data? = try Data(contentsOf: url) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
}
