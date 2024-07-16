//
//  Home.swift
//  Pomodoro Timer
//
//  Created by Balaji Venkatesh on 28/06/24.
//

import SwiftUI
import SwiftData

struct Home: View {
    /// Customization Properties
    @State private var background: Color = .red
    /// View Properties
    @State private var flipClockTime: Time = .init()
    @State private var pickerTime: Time = .init()
    @State private var startTimer: Bool = false
    @State private var totalTimeInSeconds: Int = 0
    @State private var timerCount: Int = 0
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Query(sort: [SortDescriptor(\Recent.date, order: .reverse)], animation: .snappy) private var recents: [Recent]
    @Environment(\.modelContext) private var context
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Pomodoro")
                .font(.largeTitle.bold())
                .padding(.top, 15)
            
            /// Flip Clock Text Views for Timer View
            TimerView()
                .padding(.top, 35)
                .offset(y: -15)
            
            /// Custom Time Picker
            TimePicker(
                style: .init(.gray.opacity(0.15)),
                hour: $pickerTime.hour,
                minutes: $pickerTime.minute,
                seconds: $pickerTime.seconds
            )
            .environment(\.colorScheme, .light)
            .padding(15)
            .background(.white, in: .rect(cornerRadius: 10))
            .onChange(of: pickerTime) { oldValue, newValue in
                flipClockTime = newValue
            }
            .disableWithOpacity(startTimer)
            
            TimerButton()
            
            RecentsView()
                .disableWithOpacity(startTimer)
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(background.gradient)
        .onReceive(timer) { _ in
            if startTimer {
                if timerCount > 0 {
                    timerCount -= 1
                    updateFlipClock()
                } else {
                    stopTimer()
                }
            } else {
                timer.upstream.connect().cancel()
            }
        }
    }
    
    /// Updating Flip Clock Values
    func updateFlipClock() {
        let hour = (timerCount / 3600) % 24
        let minute = (timerCount / 60) % 60
        let seconds = (timerCount) % 60
        
        flipClockTime = .init(hour: hour, minute: minute, seconds: seconds)
    }
    
    /// Start/Stop Timer Button With Action
    @ViewBuilder
    func TimerButton() -> some View {
        Button {
            startTimer.toggle()
            
            if startTimer {
                startTimerCount()
            } else {
                stopTimer()
            }
        } label: {
            Text(!startTimer ? "Start Timer" : "Stop Timer")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(.white, in: .rect(cornerRadius: 10))
                .contentShape(.rect(cornerRadius: 10))
        }
        .disableWithOpacity(flipClockTime.isZero && !startTimer)
    }
    
    /// Timer Actions
    func startTimerCount() {
        totalTimeInSeconds = flipClockTime.totalInSeconds
        timerCount = totalTimeInSeconds - 1
        
        /// Checking if the time already exists in the Swift Data model
        if !recents.contains(where: { $0.totalInSeconds == totalTimeInSeconds }) {
            /// Saving it in Recents
            let recent = Recent(hour: flipClockTime.hour, minute: flipClockTime.minute, seconds: flipClockTime.seconds)
            context.insert(recent)
        }
        
        updateFlipClock()
        
        /// Starting Timer
        timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    }
    
    func stopTimer() {
        /// Resetting to it's Initial State
        startTimer = false
        totalTimeInSeconds = 0
        timerCount = 0
        flipClockTime = .init()
        withAnimation(.linear) {
            pickerTime = .init()
        }
        
        timer.upstream.connect().cancel()
    }
    
    /// Recents View
    @ViewBuilder
    func RecentsView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Recents")
                .font(.callout)
                .foregroundStyle(.white.opacity(0.8))
                .opacity(recents.isEmpty ? 0 : 1)
            
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(recents) { value in
                        let isHour = value.hour > 0
                        let isSeconds = value.minute == 0 && value.hour == 0 && value.seconds != 0
                        HStack(spacing: 0) {
                            Text(isHour ? "\(value.hour)" : isSeconds ? "\(value.seconds)" : "\(value.minute)")
                            Text(isHour ? "h" : isSeconds ? "s" : "m")
                        }
                        .font(.callout)
                        .foregroundStyle(.black)
                        .frame(width: 50, height: 50)
                        .background(.white, in: .circle)
                        /// Context Menu Shape
                        .contentShape(.contextMenuPreview, .circle)
                        .contextMenu {
                            Button("Delete", role: .destructive) {
                                /// Deleting this Item from the Swift Data
                                context.delete(value)
                            }
                        }
                        .onTapGesture {
                            /// Loading this as the current timer settings
                            withAnimation(.linear) {
                                pickerTime = .init(hour: value.hour, minute: value.minute, seconds: value.seconds)
                            }
                        }
                    }
                }
                .padding(.vertical, 10)
                .padding(.leading, 10)
            }
            .scrollIndicators(.hidden)
            .padding(.leading, -10)
        }
        .padding(.top, 10)
    }
    
    @ViewBuilder
    func TimerView() -> some View {
        let size: CGSize = .init(width: 100, height: 120)
        HStack(spacing: 0) {
            TimerViewHelper("Hours", value: $flipClockTime.hour, size: size)
            TimerViewHelper("Minutes", value: $flipClockTime.minute, size: size)
            TimerViewHelper("Seconds", value: $flipClockTime.seconds, size: size, isLast: true)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    func TimerViewHelper(_ title: String, value: Binding<Int>, size: CGSize, isLast: Bool = false) -> some View {
        Group {
            VStack(spacing: 10) {
                FlipClockTextEffect(
                    value: value,
                    size: size,
                    fontSize: 60,
                    cornerRadius: 18,
                    foreground: .black,
                    background: .white
                )
                
                Text(title)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.8))
                    .fixedSize()
            }
            
            if !isLast {
                VStack(spacing: 15) {
                    Circle()
                        .fill(.white)
                        .frame(width: 10, height: 10)
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 10, height: 10)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Recent.self)
}

/// Custom View Extensions
extension View {
    /// Disables View With Opacity
    @ViewBuilder
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.5 : 1)
            .animation(.easeInOut(duration: 0.3), value: condition)
    }
}
