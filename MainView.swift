//
//  ContentView.swift
//  Habi
//
//  Created by Enzu Ao on 14/04/23.
//

import SwiftUI
import SpriteKit

struct MainView: View {
    @State private var currentTime: Date = Date()
    @State private var isShowALert: Bool = false
    @State private var isShowFinishALert: Bool = false
    @State private var isShowFailALert: Bool = false
    @State private var isStartRoutine: Bool = false
    @State private var tempCurrentRoutine: String = ""
    @State private var tempCurrentRoutineId: String = ""
    var screenWidth = UIScreen.main.bounds.width
    
    @ObservedObject var habitViewModel = HabitViewModel()
    
    @ObservedObject var currentRoutineVM =
    CurrentRoutineViewModel()
    
    @State var activeID =  "Empty"
    
    var gameScene: SKScene {
        let gameScene = GameScene(size: CGSize(width: 600, height: 600))
        gameScene.currentRoutineVM = currentRoutineVM
        gameScene.scaleMode = .resizeFill
        gameScene.backgroundColor = .clear
        gameScene.anchorPoint = CGPoint(x: 0, y: 0)
        
        return gameScene
    }
    
    init() {
        if currentRoutineVM.currentRoutine.id == "" {
            habitViewModel.checkAndUpdateDate()
        }
        if habitViewModel.checkHabitsStatus(id: currentRoutineVM.currentRoutine.id, lastLogon: currentRoutineVM.lastTimeLogon) {
            isShowFailALert =  true
        }
        currentRoutineVM.updateLastLogon()
    }
    
    
    var body: some View {
        VStack {
            SpriteView(scene: gameScene)
            if #available(iOS 16, *) {
                NavigationStack{
                    VStack{
                        
                        if habitViewModel.habits.isEmpty {
                            VStack(spacing: 64) {
                                Text("You don't have any daily habit yet")
                                    .font( screenWidth < 500 ? .title2.bold() : .largeTitle.bold())
                            }
                            
                            
                        } else {
                            List(habitViewModel.habits.sorted { $0.timeStart < $1.timeStart}, id: \.id){ habit in
                                NavigationLink(value: habit.id) {
                                    HabitTaskItem(id: habit.id, title: habit.title, startTime: habit.timeStart, endTime: habit.timeEnd, isStartRoutine: $isStartRoutine, activeID: $activeID, currentStatus: $currentRoutineVM.currentRoutine.status,
                                                  routineStatus: habit.status)
                                }
                                
                            }
                            .accentColor(.red)
                            .listStyle(.sidebar)
                            .navigationDestination(for: String.self) { id in
                                AddingHabitView(habitViewModel: habitViewModel, currentRoutineVM: currentRoutineVM, id: id)
                                
                            }
                            
                        }
                        
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Spacer()
                                Text("My Daily Habit").font( screenWidth < 500 ? .title2.bold() : .largeTitle.bold())
                                    .accessibilityAddTraits(.isHeader)
                                Spacer()
                                NavigationLink(destination: AddingHabitView( habitViewModel: habitViewModel, currentRoutineVM: currentRoutineVM)) {
                                    Image(systemName: "plus")
                                }
                            }
                        }
                    }
                    
                }
                .navigationBarBackButtonHidden(true)
            } else {
                Text("Only Available In iOS 16")
            }
                //                .sheet(isPresented: $isAdding,  content: {
                //                    AddingHabitView(isPresented: $isAdding, habitViewModel: habitViewModel)
                //                        .presentationDetents([.fraction(2.2/3)])
                //
                //                })
                
            }
                .onAppear{
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        
                        currentTime = Date()
                        let Id = isItRoutinetime(time: currentTime, habits: habitViewModel.habits)
                        if activeID != Id {
                            activeID = Id
                        }
                    }
                }
                .alert("Daily habit", isPresented: $isShowALert) {
                    HStack{
                        Button("Later") {
                            
                        }
                        Button("OK") {
                            currentRoutineVM.updateStatus("active")
                            tempCurrentRoutine = currentRoutineVM.currentRoutine.title
                            tempCurrentRoutineId = currentRoutineVM.currentRoutine.id
                            
                        }
                    }
                } message: {
                    Text("Looks like your daily habit: \(currentRoutineVM.currentRoutine.title) is starting, Let's get started and make progress towards your goals. You've got this! 💪")
                }
                .alert("Daily habit", isPresented: $isShowFinishALert) {
                    HStack{
                        Button("Got it!") {
                            print(tempCurrentRoutine)
                            
                        }
                    }
                } message: {
                    Text(" Congratulation 🥳, you just finish your daily habit: \(tempCurrentRoutine) ")
                }
                .alert("Daily habit", isPresented: $isShowFailALert) {
                    HStack{
                        Button("Got it!") {
                            
                        }
                    }
                } message: {
                    Text("Did you forget to do your routine today? It happens to the best of us. Just make sure to prioritize it tomorrow!. PS. you can edit the time if you want to do it today 😉")
                }
        
        //Make a fail alert if the user doesnt do anything
        
        //Check in init app if any routine task that fail to start
        
        //        .alert(,isPresented: $isShowALert) {
        //            Alert(
        //                title: Text("Important message"),
        //                message: Text("Looks like your daily routine: \(currentRoutineVM.currentRoutine.title) is starting"),
        //
        //            )
        //        }
    }
    
    func isItRoutinetime(time: Date, habits: [HabitModel]) -> String {
        let id = currentRoutineVM.currentRoutine.id
        var index = 0
        for habit in habits {
            
            if habit.status != "done" && habit.timeStart <= time && time <= habit.timeEnd {
                //            currentRoutineVM.newCurrent(CurrentRoutineModel(id: habit.id, title: habit.title, timeStart: Date(), timeEnd: habit.timeEnd, durationHours: habit.durationHours, durationMinutes: habit.durationMinutes, status: "Start"))
                
                if id.isEmpty || id != habit.id || isStartRoutine{
                    
                    currentRoutineVM.newCurrent(CurrentRoutineModel(id: habit.id, title: habit.title, timeStart: Date(), timeEnd: habit.timeEnd, durationHours: habit.durationHours, durationMinutes: habit.durationMinutes, status: "pending"))
                    
                    isShowALert = true
                    isStartRoutine.toggle()
                    print(habitViewModel.habits[0].status)
                    
                }
                return habit.id
            }
            
            index+=1
        }
        if currentRoutineVM.currentRoutine.id != "" {
            print(currentRoutineVM.currentRoutine.title)
            if currentRoutineVM.currentRoutine.status != "pending" {
                
                habitViewModel.updateStatus(id: tempCurrentRoutineId, status: "done")
                tempCurrentRoutine = ""
                isShowFinishALert = true
            } else {
                habitViewModel.checkHabitsStatus(lastLogon: currentRoutineVM.lastTimeLogon)
                isShowFailALert = true
            }
            currentRoutineVM.newCurrent(CurrentRoutineModel())
            habitViewModel.checkAndUpdateDate()
        }
        
        return ""
    }
}



struct HabitTaskItem: View {
    @State var id: String
    @State var title: String
    @State var startTime: Date
    @State var endTime: Date
    @Binding var isStartRoutine: Bool
    @Binding var activeID: String
    @Binding var currentStatus: String
    @State var routineStatus: String
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(title)
                    .font( screenWidth < 500 ? .title3.weight(.semibold) : .title.bold())
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                
                Text("\(startTime, formatter: dateFormatter) - \(endTime, formatter: dateFormatter)")
                    .font(.system(size: screenWidth < 500 ? 15 : 25))
                
            }
            
            Spacer()
            if routineStatus == "done" {
                Button {
                } label: {
                    Text("You have completed this daily habit")
                        .font(.system(size: screenWidth < 500 ? 15 : 25))
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.green)
                
                
            } else if Date() > endTime && routineStatus != "missed"{
                Button {
                    print(id, routineStatus)
                } label: {
                    Text("Scheduled for tomorrow")
                        .font(.system(size: screenWidth < 500 ? 15 : 25))
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.gray)
                
            } else if Date() > endTime && routineStatus == "missed" {
                Button {
                    print(id, routineStatus)
                } label: {
                    Text("You missed this daily habit")
                        .font(.system(size: screenWidth < 500 ? 15 : 25))
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.red)
            }else if Date() < startTime{
                Button {
                    print(id, routineStatus)
                } label: {
                    Text("Will begin at \(startTime, formatter: dateFormatter), Good Luck")
                        .font(.system(size: screenWidth < 500 ? 15 : 25))
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.gray)
            }
            if id == activeID {
                if currentStatus == "pending" {
                    Button {
                        print(id, routineStatus)
                        isStartRoutine.toggle()
                    } label: {
                        Text("Start Habit")
                            .font(.system(size: screenWidth < 500 ? 15 : 25))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.blue)
                } else if currentStatus == "active" {
                    Button {
                        print(id, routineStatus)
                    } label: {
                        Text("Habit is starting")
                            .font(.system(size: screenWidth < 500 ? 15 : 25))
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.green)
                }
                
            }
            
        }
        
        //        VStack(alignment: .leading) {
        //            Text(title)
        //                .font( screenWidth < 500 ? .title3.bold() : .title.bold())
        //            HStack{
        //                Text("\(startTime, formatter: dateFormatter) - \(endTime, formatter: dateFormatter)")
        //                    .font(.system(size: screenWidth < 500 ? 15 : 25))
        //                Spacer()
        //
        //            }
        //            .font(.body)
        //        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

