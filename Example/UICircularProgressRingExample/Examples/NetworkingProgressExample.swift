//
//  NetworkingProgressExample.swift
//  UICircularProgressRingExample
//
//  Created by Luis Padron on 6/4/20.
//  Copyright © 2020 Luis. All rights reserved.
//

import Combine
import SwiftUI
import UICircularProgressRing

struct NetworkingProgressExample: View {
    private static let animationDuration = 0.1
    @ObservedObject private var viewModel = NetworkingProgressExampleViewModel(
        debounceRate: .seconds(NetworkingProgressExample.animationDuration),
        mainScheduler: DispatchQueue.main
    )

    var body: some View {
        VStack(spacing: 32) {
            ProgressRing(progress: $viewModel.progress)
                .animation(.easeOut(duration: Self.animationDuration))
                .frame(width: 200, height: 200)

            Button(action: { self.viewModel.onDidTapStartNetworkTaskSubject.send(()) }) {
                Text("Start download task")
            }
                .padding(16)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
        }
    }
}

private final class NetworkingProgressExampleViewModel: ObservableObject {
    @Published var progress: RingProgress = .percent(0)

    let onDidTapStartNetworkTaskSubject = PassthroughSubject<Void, Never>()
    private var startNetworkTaskTrigger: AnyPublisher<Void, Never> {
        onDidTapStartNetworkTaskSubject.eraseToAnyPublisher()
    }

    private var downloadTaskSubject = PassthroughSubject<URLSessionDataTask, Never>()
    private lazy var progressPublisher: AnyPublisher<RingProgress, Never> = {
        downloadTaskSubject
            .flatMap { $0.progress.publisher(for: \.fractionCompleted) }
            .map  { RingProgress.percent($0) }
            .eraseToAnyPublisher()
    }()

    private var cancellables = Set<AnyCancellable>()
    private var downloadTask: URLSessionDataTask?

    init(
        debounceRate: DispatchQueue.SchedulerTimeType.Stride,
        mainScheduler: DispatchQueue
    ) {
        // hopefully this URL doesn't break 🙏
        let testUrl = URL(string: "http://ipv4.download.thinkbroadband.com/200MB.zip")!

        startNetworkTaskTrigger
            .sink { [weak self] _ in
                self?.downloadTask?.cancel()
                let task = URLSession.shared.dataTask(with: testUrl)
                task.resume()
                self?.downloadTaskSubject.send(task)
                self?.downloadTask = task
            }
            .store(in: &cancellables)

        progressPublisher
            .receive(on: mainScheduler)
            .sink { [weak self] progress in
                self?.progress = progress
            }
            .store(in: &cancellables)
    }

    deinit {
        downloadTask?.cancel()
    }
}
