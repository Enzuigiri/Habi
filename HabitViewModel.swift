//
//  HabitViewModel.swift
//  Habi
//
//  Created by Enzu Ao on 16/04/23.
//

import SwiftUI

class HabitViewModel: ObservableObject {
    private var defaults = UserDefaults.standard
    
    private let key = "habitList"
    
    @Published var habits: [HabitModel] = []
    
    init() {
        self.habits = getAll()
    }
    
    private func update(newValue: [HabitModel]) {
        if let data = try? JSONEncoder().encode(newValue) {
            defaults.set(data, forKey: key)
        }
    }
    
    func getAll() -> [HabitModel] {
        if let data = defaults.data(forKey: key),
           let habits = try? JSONDecoder().decode([HabitModel].self, from: data) {
            return habits
        }
        return []
    }
    
    func addHabit(_ habit: HabitModel) {
        habits.append(habit)
        update(newValue: habits)
        print("added", habits)
    }
    
    func removeHabit(id: String) {
        habits.removeAll(where: {$0.id == id})
        self.habits = habits
        update(newValue: habits)
    }
    
    func removeAllHabits() {
        habits.removeAll()
        self.habits = habits
        update(newValue: habits)
    }
    
    func getHabit(id: String) -> HabitModel? {
        return habits.first(where: {$0.id == id})
    }
    
    func updateHabit(updateHabit: HabitModel) {
        removeHabit(id: updateHabit.id)
        let tempHabit = updateHabit
        tempHabit.id = UUID().uuidString
        addHabit(tempHabit)
    }
    
    func hasOverlapRoutineTime(start: Date, end: Date, isUpdate: Bool = false, id: String = "")
    -> (result:Bool, data:HabitModel?) {
        if isUpdate {
            var count = 0
            for habit in habits {
                if(habit.timeStart == start && habit.timeEnd == end) {
                    count += 1
                } else if habit.timeStart < end && start < habit.timeEnd && id != habit.id {
                    return (true, habit)
                } else if habit.timeStart < end && start < habit.timeEnd  {
                    count += 1
                }
                if count > 1 {return (true, habit)}
            }
            return (false, nil)
        }
        for habit in habits {
            if(habit.timeStart == start && habit.timeEnd == end) {
                return (true, habit)
            } else if habit.timeStart < end && start < habit.timeEnd {
                return (true, habit)
            }
        }
        return (false, nil)
    }
    
    func checkRoutineNow(time: Date) -> (result: Bool, data: HabitModel?) {
        for habit in habits {
            if habit.timeStart <= time && time <= habit.timeEnd {
                return (true, habit)
            }
        }
        return (false, nil)
    }
    
    private func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
        
        return components1.year == components2.year &&
        components1.month == components2.month &&
        components1.day == components2.day
    }
    
    private func updateDateToCurrentTime(_ pastDate: Date) -> Date {
        let calendar = Calendar.current
        let currentDateTime = Date()
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDateTime)
        let hour = calendar.component(.hour, from: pastDate)
        let minute = calendar.component(.minute, from: pastDate)
        dateComponents.hour = hour
        dateComponents.minute = minute
        return calendar.date(from: dateComponents) ?? currentDateTime
    }
    
    func checkAndUpdateDate() {
        let current = Date()
        var tempHabit: [HabitModel] = []
        for habit in habits {
            if !isSameDate(habit.timeStart, current) {
                habit.timeStart = updateDateToCurrentTime(habit.timeStart)
                habit.status = ""
                if isSameDate(habit.timeEnd, current) {
                    habit.timeEnd = habit.timeEnd.addingTimeInterval(86400)
                } else if !isSameDate(habit.timeEnd, current) {
                    habit.timeEnd = updateDateToCurrentTime(habit.timeEnd)
                }
            }
            tempHabit.append(habit)
        }
        self.habits = tempHabit
        update(newValue: habits)
    }
    
    func updateStatus(id: String, status: String) {
        let index = habits.firstIndex(where: {$0.id == id})
        if let i = index {
            self.habits[i].status = status
            self.habits[i].id = UUID().uuidString
        }
        update(newValue: habits)
    }
    
    func checkHabitsStatus(id: String = "", lastLogon: Date) -> Bool{
        if habits.contains(where: {$0.status != "missed" || $0.status != "done"}) {
            for habit in habits {
                if habit.id == id && habit.timeEnd <= Date() {
                    habit.id = UUID().uuidString
                    habit.status = "done"
                } else if habit.status != "done" && habit.status != "missed" && habit.timeStart >= lastLogon && habit.timeEnd <= Date() {
                    habit.id = UUID().uuidString
                    habit.status = "missed"
                }
            }
            update(newValue: habits)
            return true
        }
        return false
    }
    //    func updateDateToCurrentDate(){
    //        var tempHabits: [HabitModel] = []
    //        for habit in habits {
    //            if !isSameDate(habit.timeStart, <#T##date2: Date##Date#>)
    //        }
    //    }
}
