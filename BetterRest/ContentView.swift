//
//  ContentView.swift
//  BetterRest
//
//  Created by Zi on 18/04/2025.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date{
        var components = DateComponents()
        components.hour = 2
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView
        {
            Form
            {
                VStack(alignment: .leading, spacing: 0)
                {
                    Text("When Do You Want to Wake Up?")
                        .font(.headline)
                    DatePicker("Select a Time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                VStack(alignment: .leading, spacing: 0)
                {
                    Text("Desired Amount of Sleep").font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) Hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                VStack(alignment: .leading, spacing: 0)
                {
                    Text("Daily Coffee Intake").font(.headline)
                    Stepper(coffeeAmount==1 ? "1 Cup" : "\(coffeeAmount) Cups", value: $coffeeAmount, in: 1...20)
                }
                
            }
            .navigationTitle("Better Rest")
            .toolbar{
                Button("Calculate", action: calculateBedTime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
        
    }
    func calculateBedTime()
    {
        do
        {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            //more code to come here
        }
        catch
        {
            //more code to come here
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your sleep time. Please try again later."
        }
        showingAlert = true
    }
}

#Preview {
    ContentView()
}
