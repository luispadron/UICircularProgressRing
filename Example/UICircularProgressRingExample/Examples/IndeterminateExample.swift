//
//  IndeterminateExample.swift
//  UICircularProgressRingExample
//
//  Created by Luis on 5/30/20.
//  Copyright © 2020 Luis. All rights reserved.
//

import Combine
import UICircularProgressRing
import SwiftUI

struct IndeterminateExample: View {
    @State private var progress: RingProgress = .percent(0)

    private let onDidTapSubject = PassthroughSubject<Void, Never>()
    private var onDidTapPublisher: AnyPublisher<Void, Never> {
        onDidTapSubject.eraseToAnyPublisher()
    }

    private let onDidTapIndeterminateSubject = PassthroughSubject<Void, Never>()
    private var onDidTapIndeterminatePublisher: AnyPublisher<Void, Never> {
        onDidTapIndeterminateSubject.eraseToAnyPublisher()
    }

    private var progressPublisher: AnyPublisher<RingProgress, Never> {
        onDidTapPublisher
            .map {
                self.progress == .percent(1) || self.progress.isIndeterminate ?
                    RingProgress.percent(0) :
                    RingProgress.percent(1)
            }
            .merge(with: onDidTapIndeterminateSubject.map { RingProgress.indeterminate })
            .prepend(progress)
            .eraseToAnyPublisher()
    }

    var body: some View {
        VStack {
            ProgressRing(progress: $progress)
                .animation(.easeInOut(duration: 5))
                .padding(32)

            HStack {
                Button(action: { self.onDidTapSubject.send(()) }) {
                    buttonLabel
                }
                    .padding(16)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .offset(y: -32)

                Button(action: { self.onDidTapIndeterminateSubject.send(()) }) {
                    Text("Make Indeterminate")
                }
                    .padding(16)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(8)
                    .offset(y: -32)
            }
        }
        .navigationBarTitle("Indeterminate")
        .onReceive(progressPublisher) { progress in
            self.progress = progress
        }
    }

    private var buttonLabel: some View {
        if progress == .percent(1) || progress.isIndeterminate {
            return Text("Restart Progress")
        } else {
            return Text("Start Progress")
        }
    }
}

