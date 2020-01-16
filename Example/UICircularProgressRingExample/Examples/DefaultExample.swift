//
//  DefaultExample.swift
//  UICircularProgressRingExample
//
//  Created by Luis on 5/29/20.
//  Copyright © 2020 Luis. All rights reserved.
//

import Combine
import UICircularProgressRing
import SwiftUI

struct DefaultExample: View {
    @State private var progress: RingProgress = .percent(0)

    private let onDidTapSubject = PassthroughSubject<Void, Never>()
    private var onDidTapPublisher: AnyPublisher<Void, Never> {
        onDidTapSubject.eraseToAnyPublisher()
    }

    private var progressPublisher: AnyPublisher<RingProgress, Never> {
        onDidTapPublisher
            .map { self.progress == .percent(1) ? RingProgress.percent(0) : RingProgress.percent(1) }
            .prepend(progress)
            .eraseToAnyPublisher()
    }

    var body: some View {
        VStack {
            ProgressRing(progress: $progress)
                .animation(.easeInOut(duration: 5))
                .padding(32)

            Button(action: { self.onDidTapSubject.send(()) }) {
                buttonLabel
            }
                .padding(16)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .offset(y: -32)
        }
        .navigationBarTitle("Basic")
        .onReceive(progressPublisher) { progress in
            self.progress = progress
        }
    }

    private var buttonLabel: some View {
        if progress == .percent(1) {
            return Text("Restart Progress")
        } else {
            return Text("Start Progress")
        }
    }
}
