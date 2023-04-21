//
//  HabitModel.swift
//  Habi
//
//  Created by Enzu Ao on 16/04/23.
//

import SwiftUI

class HabitModel: Encodable, Decodable, Identifiable, ObservableObject {
    static func == (lhs: HabitModel, rhs: HabitModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    @Published var id: String
    @Published var title: String
    @Published var timeStart: Date
    @Published var timeEnd: Date
    @Published var durationHours: Int
    @Published var durationMinutes: Int
    @Published var durationTotal: Double
    @Published var status: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case timeStart
        case timeEnd
        case durationHours
        case durationMinutes
        case durationTotal
        case status
    }
    
    init() {
        self.id = ""
        self.title = ""
        self.timeStart = Date()
        self.timeEnd = Date()
        self.durationHours = 0
        self.durationMinutes = 0
        self.durationTotal = 0
        self.status = ""
    }
    
    init(id: String = UUID().uuidString, title: String, timeStart: Date, timeEnd: Date,
         durationHours: Int, durationMinutes: Int, durationTotal: Double, status: String = "created"){
        self.id  = id
        self.title = title
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.durationHours = durationHours
        self.durationMinutes = durationMinutes
        self.durationTotal = durationTotal
        self.status = status == "missed" ? "" : status
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        timeStart = try container.decode(Date.self, forKey: .timeStart)
        timeEnd = try container.decode(Date.self, forKey: .timeEnd)
        durationHours = try container.decode(Int.self, forKey: .durationHours)
        durationMinutes = try container.decode(Int.self, forKey: .durationMinutes)
        durationTotal = try container.decode(Double.self, forKey: .durationTotal)
        status = try container.decode(String.self, forKey: .status)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(timeStart, forKey: .timeStart)
        try container.encode(timeEnd, forKey: .timeEnd)
        try container.encode(durationHours, forKey: .durationHours)
        try container.encode(durationMinutes, forKey: .durationMinutes)
        try container.encode(durationTotal, forKey: .durationTotal)
        try container.encode(status, forKey: .status)
    }
}
