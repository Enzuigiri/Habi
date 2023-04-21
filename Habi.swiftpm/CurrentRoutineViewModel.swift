//
//  CurrentRoutineViewModel.swift
//  Habi
//
//  Created by Enzu Ao on 18/04/23.
//

import SwiftUI

class CurrentRoutineViewModel: ObservableObject {
    private var defaults = UserDefaults.standard
    
    private let key = "currentRoutine"
    private let nextRoutineKey = "lastTimeLogon"
    
    @Published var currentRoutine: CurrentRoutineModel = CurrentRoutineModel()
    @Published var lastTimeLogon: Date = Date()
    
    init() {
        self.currentRoutine = getCurrentRoutine()
        self.lastTimeLogon = getLastTimeLogon()
    }
    
    func getCurrentRoutine() -> CurrentRoutineModel {
        if let data = defaults.data(forKey: key),
           let current = try? JSONDecoder().decode(CurrentRoutineModel.self, from: data) {
            return current
        }
        return CurrentRoutineModel()
    }
    
    func getLastTimeLogon() -> Date {
        if let data = defaults.data(forKey: nextRoutineKey),
           let last = try? JSONDecoder().decode(Date.self, from: data) {
            return last
        }
        return Date()
    }
    
    private func update(newValue: CurrentRoutineModel) {
        if let data = try? JSONEncoder().encode(newValue) {
            defaults.set(data, forKey: key)
        }
    }
    
    private func updateLastTimeLogon(newValue: Date) {
        if let data = try? JSONEncoder().encode(newValue) {
            defaults.set(data, forKey: nextRoutineKey)
        }
    }
    
    func newCurrent(_ current: CurrentRoutineModel) {
        self.currentRoutine = current
        update(newValue: currentRoutine)
        print("New", currentRoutine)
    }
    
    func updateLastLogon() {
        lastTimeLogon = Date()
        updateLastTimeLogon(newValue: lastTimeLogon)
    }
    
    func updateStatus(_ status: String) {
        self.currentRoutine.status = status
        update(newValue: currentRoutine)
    }
}
