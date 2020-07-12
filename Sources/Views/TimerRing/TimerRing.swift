//
//  TimerRing.swift
//
//  Created by Luis Padron on 6/5/20.
//

import Combine
import SwiftUI

/// # TimerRing
///
/// A specialized `Ring` for displaying time.
public struct TimerRing<Label: View> {
    private let timeInterval: TimeInterval
    private let tickRate: TimeInterval
    private let axis: RingAxis
    private let clockwise: Bool
    private let outerRingStyle: RingStyle
    private let innerRingStyle: RingStyle
    private let onTick: ((TimeInterval) -> Void)?
    private let label: (TimeInterval) -> Label

    private var tickPublisher: AnyPublisher<Void, Never>
    private var cancellables = Set<AnyCancellable>()

    @State private var ticks: TimeInterval
    @Binding private var isDone: Bool

    /// Creates a `TimerRing` where the `Label` is `EmptyView`.
    ///
    /// - Parameters:
    ///   - time: Determines how long the ring animates for.
    ///   - delay: A delay before the ring begins animating. Default = `nil`.
    ///   - elapsedTime: The amount of time already elapsed. The total running time is determined by `time - elapsedTime`. Default = `nil`.
    ///   - tickRate: The rate at which the ring updates its time value. Default = `TimerRingTimeUnit.milliseconds(100)`.
    ///   - axis: The `RingAxis` at which drawing begins.
    ///   - clockwise: Whether to draw in a clockwise manner.
    ///   - outerRingStyle: The `RingStyle` of the outer ring.
    ///   - innerRingStyle: The `RingStyle` of the outer ring.
    ///   - isPaused: A `Binding` used to determine if the timer is paused. Default = `Binding.constant(false)`.
    ///   - isDone: A `Binding` used to determine if the timer is done.
    ///   - mainScheduler: The scheduler on which the timing operations and animations are run on. Default = `DispatchQueue.main`.
    ///   - onTick: A closure which is called whenever the timer is updated. This is called roughly every `tickRate`.
    ///   - label: A view builder closure which constructs a some `View`. The current time (in seconds) is passed into the closure.
    ///
    /// - Note: Do not perform expensive operations in `onTick`. This closure is called very often.
    public init(
        time: TimerRingTimeUnit,
        delay: TimerRingTimeUnit? = nil,
        elapsedTime: TimerRingTimeUnit? = nil,
        tickRate: TimerRingTimeUnit = .milliseconds(100),
        axis: RingAxis = .top,
        clockwise: Bool = true,
        outerRingStyle: RingStyle = .init(color: .color(.gray), strokeStyle: .init(lineWidth: 32), padding: 0),
        innerRingStyle: RingStyle = .init(color: .color(.blue), strokeStyle: .init(lineWidth: 16), padding: 8),
        isPaused: Binding<Bool> = .constant(false),
        isDone: Binding<Bool>,
        mainScheduler: DispatchQueue = .main,
        onTick: ((TimeInterval) -> Void)? = nil,
        @ViewBuilder _ label: @escaping (TimeInterval) -> Label
    ) {
        _ticks = State(initialValue: elapsedTime?.timeInterval ?? 0)
        self.timeInterval = time.timeInterval
        self.tickRate = tickRate.timeInterval
        self.axis = axis
        self.clockwise = clockwise
        self.outerRingStyle = outerRingStyle
        self.innerRingStyle = innerRingStyle
        _isDone = isDone
        self.onTick = onTick
        self.label = label

        let delayPublisher = Just(())
            .delay(for: .seconds(delay?.timeInterval ?? 0), scheduler: mainScheduler)

        tickPublisher = Timer
            .publish(
                every: tickRate.timeInterval,
                tolerance: 0,
                on: .main,
                in: .common
            )
            .autoconnect()
            .map { _ in }
            .drop(untilOutputFrom: delayPublisher)
            .prefix(while: { !isDone.wrappedValue })
            .drop(while: { isPaused.wrappedValue })
            .receive(on: mainScheduler)
            .eraseToAnyPublisher()
    }
}

// MARK: - Default Init

extension TimerRing where Label == EmptyView {

    /// Creates a `TimerRing` where the `Label` is `EmptyView`.
    ///
    /// - Parameters:
    ///   - time: Determines how long the ring animates for.
    ///   - delay: A delay before the ring begins animating. Default = `nil`.
    ///   - elapsedTime: The amount of time already elapsed. The total running time is determined by `time - elapsedTime`. Default = `nil`.
    ///   - tickRate: The rate at which the ring updates its time value. Default = `TimerRingTimeUnit.milliseconds(100)`.
    ///   - axis: The `RingAxis` at which drawing begins.
    ///   - clockwise: Whether to draw in a clockwise manner.
    ///   - outerRingStyle: The `RingStyle` of the outer ring.
    ///   - innerRingStyle: The `RingStyle` of the outer ring.
    ///   - isPaused: A `Binding` used to determine if the timer is paused. Default = `Binding.constant(false)`.
    ///   - isDone: A `Binding` used to determine if the timer is done.
    ///   - mainScheduler: The scheduler on which the timing operations and animations are run on. Default = `DispatchQueue.main`.
    ///   - onTick: A closure which is called whenever the timer is updated. This is called roughly every `tickRate`.
    ///
    /// - Note: Do not perform expensive operations in `onTick`. This closure is called very often.
    public init(
        time: TimerRingTimeUnit,
        delay: TimerRingTimeUnit? = nil,
        elapsedTime: TimerRingTimeUnit? = nil,
        tickRate: TimerRingTimeUnit = .milliseconds(100),
        axis: RingAxis = .top,
        clockwise: Bool = true,
        outerRingStyle: RingStyle = .init(color: .color(.gray), strokeStyle: .init(lineWidth: 32), padding: 0),
        innerRingStyle: RingStyle = .init(color: .color(.blue), strokeStyle: .init(lineWidth: 16), padding: 8),
        isPaused: Binding<Bool> = .constant(false),
        isDone: Binding<Bool>,
        mainScheduler: DispatchQueue = .main,
        onTick: ((TimeInterval) -> Void)? = nil
    ) {
        self.init(
            time: time,
            delay: delay,
            elapsedTime: elapsedTime,
            tickRate: tickRate,
            axis: axis,
            clockwise: clockwise,
            outerRingStyle: outerRingStyle,
            innerRingStyle: innerRingStyle,
            isPaused: isPaused,
            isDone: isDone,
            mainScheduler: mainScheduler,
            onTick: onTick
        ) { _ in
            EmptyView()
        }
    }
}

// MARK: - Body

extension TimerRing: View {

    public var body: some View {
        ZStack {
            ZStack(alignment: .center) {
                Ring(
                    percent: 1,
                    axis: axis,
                    clockwise: clockwise,
                    color: outerRingStyle.color,
                    strokeStyle: outerRingStyle.strokeStyle
                )
                .padding(CGFloat(outerRingStyle.padding))

                Ring(
                    percent: ticks / timeInterval,
                    axis: axis,
                    clockwise: clockwise,
                    color: innerRingStyle.color,
                    strokeStyle: innerRingStyle.strokeStyle
                )
                .padding(CGFloat(innerRingStyle.padding))
                .modifier(AnimatableTimeTextModifier(timeInterval: ticks, label: label))
            }
        }
        .onReceive(tickPublisher) {
            guard self.ticks < self.timeInterval else {
                self.isDone = true
                return
            }

            withAnimation {
                self.ticks = min(self.ticks + self.tickRate, self.timeInterval)
                self.onTick?(self.ticks)
            }
        }
    }
}

// MAARK: - Previews

struct TimerRing_Previews: PreviewProvider {
    static var previews: some View {
        TimerRing(time: .seconds(30), tickRate: .milliseconds(100), isDone: .constant(false))
    }
}
