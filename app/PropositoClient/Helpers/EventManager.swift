//
//  EventManager.swift
//  PropositoClient
//
//  Created by Matheus Silva on 01/02/20.
//  Copyright © 2020 Matheus Gois. All rights reserved.
//

import Foundation

class EventManager {
    private init () { }
    static let shared = EventManager()
    // using NSMutableArray as Swift arrays can't change size inside dictionaries (yet, probably)
    var listeners = Dictionary<String, NSMutableArray>()
    // Create a new event listener, not expecting information from the trigger
    // + eventName: Matching trigger eventNames will cause this listener to fire
    // + action: The block of code you want executed when the event triggers
    func listenTo(eventName: String, action: @escaping (() -> Void)) {
        let newListener = EventListenerAction(callback: action)
        addListener(eventName: eventName.uppercased(), newEventListener: newListener)
    }
    // Create a new event listener, expecting information from the trigger
    // + eventName: Matching trigger eventNames will cause this listener to fire
    // + action: The block of code you want executed when the event triggers
    func listenTo(eventName: String, action: @escaping ((Any?) -> Void)) {
        let newListener = EventListenerAction(callback: action)
        addListener(eventName: eventName.uppercased(), newEventListener: newListener)
    }
    internal func addListener(eventName: String, newEventListener: EventListenerAction) {
        if let listenerArray = self.listeners[eventName] {
            // action array exists for this event, add new action to it
            listenerArray.add(newEventListener)
        } else {
            // no listeners created for this event yet, create a new array
            self.listeners[eventName] = [newEventListener] as NSMutableArray
        }
    }
    // Removes all listeners by default, or specific listeners through paramters
    // + eventName: If an event name is passed, only listeners for that event will be removed
    func removeListeners(_ eventNameToRemoveOrNil: String?) {
        if let eventNameToRemove = eventNameToRemoveOrNil {
            // remove listeners for a specific event
            if let actionArray = self.listeners[eventNameToRemove] {
                // actions for this event exist
                actionArray.removeAllObjects()
            }
        } else {
            // no specific parameters - remove all listeners on this object
            self.listeners.removeAll(keepingCapacity: false)
        }
    }
    // Triggers an event
    // + eventName: Matching listener eventNames will fire when this is called
    // + information: pass values to your listeners
    func trigger(eventName: String, information: Any? = nil) {
        if let actionObjects = self.listeners[eventName.uppercased()] {
            for actionObject in actionObjects {
                if let actionToPerform = actionObject as? EventListenerAction {
                    if let methodToCall = actionToPerform.actionExpectsInfo {
                        methodToCall(information)
                    } else if let methodToCall = actionToPerform.action {
                        methodToCall()
                    }
                }
            }
        }
    }
    func printAllLiesteners() {
        print("--- Listeners ---")
        for line in listeners {
            print(line.key)
        }
        print("-----------------")
    }
}

// Class to hold actions to live in NSMutableArray
class EventListenerAction {
    let action: (() -> Void)?
    let actionExpectsInfo: ((Any?) -> Void)?
    init(callback: @escaping (() -> Void) ) {
        self.action = callback
        self.actionExpectsInfo = nil
    }
    init(callback: @escaping ((Any?) -> Void)) {
        self.actionExpectsInfo = callback
        self.action = nil
    }
}
