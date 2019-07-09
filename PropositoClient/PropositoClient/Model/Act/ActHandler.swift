//
//  ActHandler.swift
//  PropositoClient
//
//  Created by Matheus Gois on 08/07/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import Foundation

enum ActLoadResponse: Error {
    case success(acts: [Act])
    case error(description: String)
}

enum ActUpdateResponse: Error {
    case success(acts: Act)
    case error(description: String)
}

class ActHandler {
    static func create(act:Act, withCompletion completion:(ActUpdateResponse) -> Void) {
        do {
            try ActDAO.shared.create(newEntity: act)
            completion(ActUpdateResponse.success(acts: act))
        } catch {
            completion(ActUpdateResponse.error(description: "OPS!! we have a problem to create your act"))
        }
    }
    
    static func loadPrayWith(completion: @escaping (ActLoadResponse) -> Void) {
        do {
            let acts = try ActDAO.shared.read()
            completion(ActLoadResponse.success(acts: acts))
        } catch {
            completion(ActLoadResponse.error(description: "OPS!! we have a problem to read your acts"))
        }
    }
    
    static func update(act: Act, withCompletion completion:(ActUpdateResponse) -> Void) {
        do {
            try ActDAO.shared.update(entity: act)
            completion(ActUpdateResponse.success(acts: act))
        }catch{
            completion(ActUpdateResponse.error(description: "OPS!! We have a problem to update your Act"))
        }
    }
    
    static func delete(acts: Act, withCompletion completion:(ActUpdateResponse) -> Void) {
        do {
            try ActDAO.shared.delete(entity: acts)
            completion(ActUpdateResponse.success(acts: acts))
        }catch{
            completion(ActUpdateResponse.error(description: "OPS!! We have a problem to delete your Task"))
        }
    }
    static private func saveLocally(_ acts: [Act]) {
        for act in acts {
            do {
                try ActDAO.shared.create(newEntity: act)
            }catch{
                print("Error to save task \"\(act.title)\" locally");
            }
        }
    }
}