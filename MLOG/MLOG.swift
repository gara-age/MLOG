//
//  MalendarApp.swift
//  Malendar
//
//  Created by 최민서 on 11/8/23.
//

import SwiftUI

@main
struct MalendarApp: App{

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        //setting up container
        .modelContainer(for: [Expense.self, Category.self])

    }
}


