import SwiftUI

struct MealForm: View {
    @Binding var meals: [LoggableItem] // Reference to meal list
    @Environment(\.presentationMode) var presentationMode // Dismiss sheet

    @State private var type = "Meal"
    @State private var name = ""
    @State private var calories = ""
    @State private var protein = ""
    @State private var carbs = ""
    @State private var fats = ""

    var body: some View {
        
            Form {
                
                TextField("Meal Name", text: $name)

                TextField("Calories", text: $calories)
                TextField("Protein", text: $protein)
                TextField("Carbs", text: $carbs)
                TextField("fats", text: $fats)
                
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addMeal()
                        presentationMode.wrappedValue.dismiss() // Close form
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        
    }

    func addMeal() {
        let calsInt = Int(calories), proteinDouble = Double(protein), carbsDouble = Double(carbs), fatsDouble = Double(fats)
    
        let newMeal = LoggableItemFactory.createItem(type: type, name: name, calories: calsInt ?? 0, protein: proteinDouble ?? 0.0, carbs: carbsDouble ?? 0.0, fats: fatsDouble ?? 0.0)
        
        TrackerSingleton.shared.addItem(newMeal)
    }
}

struct WorkoutForm: View {
    @Binding var workouts: [LoggableItem] // Reference to workout list
    @Environment(\.presentationMode) var presentationMode // Dismiss sheet

    @State private var workoutType = "Strength"
    @State private var name = ""
    @State private var sets = ""
    @State private var reps = ""
    @State private var duration = ""

    let workoutTypes = ["Strength", "Cardio"]

    var body: some View {
        
            Form {
                Picker("Workout Type", selection: $workoutType) {
                    ForEach(workoutTypes, id: \.self) { type in
                        Text(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                TextField("Workout Name", text: $name)

                if workoutType == "Strength" {
                    TextField("Sets", text: $sets)
                        
                    TextField("Reps", text: $reps)
                        
                } else {
                    TextField("Duration (minutes)", text: $duration)
                        
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addWorkout()
                        presentationMode.wrappedValue.dismiss() // Close form
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        
    }

    func addWorkout() {
        if workoutType == "Strength", let setsInt = Int(sets), let repsInt = Int(reps) {
            
            let newWorkout = LoggableItemFactory.createItem(type: workoutType, name: name, sets: setsInt, reps: repsInt)
            TrackerSingleton.shared.addItem(newWorkout)
            
        } else if workoutType == "Cardio", let durationInt = Int(duration) {
            
            let newWorkout = LoggableItemFactory.createItem(type: workoutType, name: name, duration: durationInt)
            TrackerSingleton.shared.addItem(newWorkout)
        }
    }
}


#Preview {
    @State var sampleWorkouts: [LoggableItem] = []
    WorkoutForm(workouts: $sampleWorkouts)
}
