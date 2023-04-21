//
//  AddingHabitView.swift
//  Habi
//
//  Created by Enzu Ao on 14/04/23.
//

import SwiftUI

struct AddingHabitView: View {
    @State private var title: String = ""
    @State private var timeStart: Date = Date()
    @State private var timeEnd: Date = Date()
    @Environment(\.presentationMode) var presentationMode
    @State private var id: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 1
    @State private var duration: Double = 1
    @State private var status: String = ""
    @State private var showingAlert = false
    @State private var errorTitleIsEmpty: Bool = false
    @State private var errorRoutineOverlap: Bool = false
    @State private var routineOverlap: HabitModel = HabitModel()
    
    
    @ObservedObject var habitViewModel: HabitViewModel
    @ObservedObject var currentRoutineVM: CurrentRoutineViewModel
    
    init(habitViewModel: HabitViewModel, currentRoutineVM: CurrentRoutineViewModel, id: String = "") {
        self.habitViewModel = habitViewModel
        self.currentRoutineVM = currentRoutineVM
        isOverlap(start: timeStart, end: timeEnd)
        self._id = State(initialValue: id)
        print(id)
        if !id.isEmpty {
            let habit = habitViewModel.getHabit(id: id)
            self._title = State(initialValue:  habit!.title)
            self._timeStart = State(initialValue: habit!.timeStart)
            self._hours = State(initialValue: habit!.durationHours)
            self._minutes = State(initialValue: habit!.durationMinutes)
            self._timeEnd = State(initialValue: habit!.timeEnd)
            self._status = State(initialValue: habit!.status)
        }
    }
    
    var body: some View {
        VStack{
            
            Form {
                Section(header: Text("DAILY HABIT")) {
                    HStack{
                        Text("Title").font(.headline)
                        if errorTitleIsEmpty {
                            Text(": is required")
                                .font(.headline)
                                .foregroundColor(.red)
                        }
                    }
                    TextField(title, text: $title, prompt: Text("Habit title"))
                        .onChange(of: title) { newValue in
                            errorTitleIsEmpty = false
                            if newValue.count >= 40 {
                                let index = newValue.index(newValue.startIndex, offsetBy: 40)
                                title = String(newValue[..<index])
                            }
                        }
                        .keyboardType(.asciiCapable)
                        .autocorrectionDisabled(true)
                }
                
                Section(header: Text("Routine Time")) {
                    if errorRoutineOverlap {
                        Text("Your habit overlap with habit \(routineOverlap.title ) at time \(routineOverlap.timeStart, formatter: dateFormatter) - \(routineOverlap.timeEnd, formatter: dateFormatter)")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    DatePicker("Time start", selection: $timeStart, displayedComponents: .hourAndMinute)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .onChange(of: timeStart) {
                            newValue in
                            duration = Double(hours*3600+minutes*60)
                            timeEnd = timeStart.addingTimeInterval(duration)
                            isOverlap(start: timeStart, end: timeEnd)
                        }
                    Text("Routine duration: \(String(format: "%02d:%02d", hours, minutes))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TimePicker(hours: $hours, minutes: $minutes, endTime: $timeEnd, selectedTime: $timeStart,  errorRoutineOverlap: $errorRoutineOverlap,
                               routineOverlap: $routineOverlap)
                    Text("End time: \(timeEnd, formatter: dateFormatter)")
                }
                
                if !id.isEmpty {
                    HStack{
                        Button(action:  {
                            showingAlert =  true
                        }) {
                            Text("Delete")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Divider()
                        Button(action: {
                            onUpdate()
                        }) {
                            Text("Update")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                } else {
                    Button {
                        onSubmit()
                    } label: {
                        Text("Add")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .onAppear{
                timeEnd = timeStart.addingTimeInterval(Double(hours*3600+minutes*60))
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Are you sure want to delete this daily habit ?"), primaryButton: .cancel(Text("Cancel")), secondaryButton:
                        .destructive(Text("Delete")) {
                            onDelete()
                        })
            }
            
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    func isOverlap(start: Date, end: Date) {
        if errorRoutineOverlap && routineOverlap.timeStart <= end && start <= routineOverlap.timeEnd {
            return
        }
        errorRoutineOverlap = false
    }
    
    func onSubmit() {
        let overlap = habitViewModel.hasOverlapRoutineTime(start: timeStart, end: timeEnd)
        if title.isEmpty {
            errorTitleIsEmpty = true
        } else if overlap.result {
            errorRoutineOverlap = true
            routineOverlap = overlap.data!
        } else {
            habitViewModel.addHabit(HabitModel(title: title, timeStart: timeStart, timeEnd: timeEnd, durationHours: hours, durationMinutes: minutes, durationTotal: duration))
            HabiNotification().scheduleDailyNotification(notificationTime: timeEnd, id: habitViewModel.habits.last!.id, habit: title)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func onUpdate() {
        let overlap = habitViewModel.hasOverlapRoutineTime(start: timeStart, end: timeEnd, isUpdate: true, id: id)
        
        if title.isEmpty {
            errorTitleIsEmpty = true
        } else if overlap.result {
            errorRoutineOverlap = true
            routineOverlap = overlap.data!
        } else {
            habitViewModel.updateHabit(updateHabit: HabitModel(id: id, title: title, timeStart: timeStart, timeEnd: timeEnd, durationHours: hours, durationMinutes: minutes, durationTotal: duration, status: status))
            HabiNotification().removeScheduledNotification(id: id)
            HabiNotification().scheduleDailyNotification(notificationTime: timeEnd, id: habitViewModel.habits.last!.id, habit: title)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func onDelete() {
        if currentRoutineVM.currentRoutine.id == "" {
            currentRoutineVM.newCurrent(CurrentRoutineModel())
        }
        habitViewModel.removeHabit(id: id)
        HabiNotification().removeScheduledNotification(id: id)
        self.presentationMode.wrappedValue.dismiss()
    }
    
    
}

struct TimePicker: View {
    @Binding var hours: Int
    @Binding var minutes: Int
    @Binding var endTime: Date
    @Binding var selectedTime: Date
    @Binding var errorRoutineOverlap: Bool
    @Binding var routineOverlap: HabitModel
    var body: some View {
        VStack {
            Stepper("Hours: \(hours)", value: $hours, in: 0...23)
                .onChange(of: hours) { newValue in
                    if hours <= 0 && minutes <= 0{
                        minutes = 1
                    } else if minutes == 1 {
                        minutes = 0
                    }
                    endTime = selectedTime.addingTimeInterval(Double(hours*3600+minutes*60))
                    isOverlap(start: selectedTime, end: endTime)
                }
            Stepper("Minutes: \(Int(minutes))", value: $minutes, in: 0...59)
                .onChange(of: minutes) { newValue in
                    if hours <= 0 && minutes < 1 {
                        minutes = 1
                    }
                    endTime = selectedTime.addingTimeInterval(Double(hours*3600+minutes*60))
                    isOverlap(start: selectedTime, end: endTime)
                }
        }
    }
    
    func isOverlap(start: Date, end: Date) {
        if errorRoutineOverlap && routineOverlap.timeStart <= end && start <= routineOverlap.timeEnd {
            return
        }
        errorRoutineOverlap = false
    }
}

struct AddingHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddingHabitView(habitViewModel: HabitViewModel(), currentRoutineVM: CurrentRoutineViewModel())
    }
}
