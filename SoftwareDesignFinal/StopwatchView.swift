//
//  StopwatchView.swift
//  SoftwareDesignFinal
//
//  Created by Campbell West on 2025-03-31.
//

import SwiftUI

struct StopwatchView: View {
    @Environment(\.dismiss) var dismiss
    @State private var time = 0.0
    @State private var isRunning = false
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            Text(String(format: "%.2f", time))
                .font(.system(size: 64))
                .monospacedDigit()
                .padding(20)
                .background(Color.black.opacity(0.5))
                .border(Color.black, width: 2)
            
            HStack {
                Button {
                    if isRunning {
                        stopTimer()
                    } else {
                        startTimer()
                    }
                } label: {
                    Image(systemName: isRunning ? "pause" : "play")
                        .fontWeight(.bold)
                        
                }
                .background(isRunning ? .red : .green)
                .cornerRadius(4)
                
                
                Button {
                    resetTimer()
                } label: {
                    Image(systemName: "restart")
                        .fontWeight(.bold)
                }
                .cornerRadius(4)
            }
            .padding(5)
            
            Button {
                dismiss()
            } label: {
                Text("Close")
            }

        }
        .padding()
        .background(Color.gray.opacity(0.2))
    }
    
    private func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            time += 0.01
        }
    }
    
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
    }
    
    func resetTimer() {
        stopTimer()
        time = 0.0
    }
}

#Preview {
    StopwatchView()
}
