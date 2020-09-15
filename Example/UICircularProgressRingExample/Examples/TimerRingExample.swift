//
//  TimerRingExample.swift
//  UICircularProgressRingExample
//
//  Created by Luis Padron on 6/5/20.
//  Copyright © 2020 Luis. All rights reserved.
//

import SwiftUI
import UICircularProgressRing

struct TimerRingExample: View {
    @State private var isTimerPaused: Bool = false
    @State private var isTimerDone: Bool = false
    @State private var isInverseCountdown: Bool = false
    
    private static let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(".inverseCountdow")
                    .font(.system(.headline))
                    .bold()
                Text("Change the timer mode to countdown or regular")
                    .font(.system(.subheadline))
                    .foregroundColor(.gray)
                
                Toggle(isOn: $isInverseCountdown) {
                    Text("inverseCountdown")
                }
            }
            .padding(.horizontal, 16)
            
            VStack {
                TimerRing(
                    time: .minutes(1),
                    delay: .seconds(0.5),
                    inverseCountdown: isInverseCountdown,
                    innerRingStyle: .init(
                        color: .color(.green),
                        strokeStyle: .init(lineWidth: 16, lineCap: .round, lineJoin: .round),
                        padding: 8
                    ),
                    isPaused: $isTimerPaused,
                    isDone: $isTimerDone
                ) { currentTime in
                    Text("\(Self.timeFormatter.string(from: currentTime) ?? "NaN")")
                        .font(.title)
                        .bold()
                }
                    .padding(.horizontal, 32)

                HStack {
                    Button(action: { self.isTimerPaused.toggle() }) {
                        Text(isTimerPaused ? "Continue" : "Pause")
                    }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 32)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)

                    Text("Completed: \(isTimerDone ? "✅" : "❌")")
                        .font(.headline)
                }
            }
        }
        .navigationBarTitle("Timer Ring")
    }
}
