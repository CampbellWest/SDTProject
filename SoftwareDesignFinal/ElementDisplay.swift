import SwiftUI

struct LoggableItemView: View {
    @Environment(\.dismiss) var dismiss
    let item: LoggableItem

    var body: some View {
        VStack {
            Text(item.name)
                .font(.headline)
            
            // Determine and display the correct stats
            if let meal = item as? Meal {
                Text("Calories: \(meal.calories) kcal")
                Text("Protein: \(meal.protein)g | Carbs: \(meal.carbs)g | Fats: \(meal.fats)g")
            } else if let strength = item as? StrengthWorkout {
                Text("Sets: \(strength.sets) | Reps: \(strength.reps)")
            } else if let cardio = item as? CardioWorkout {
                Text("Duration: \(cardio.duration) minutes")
            } else {
                Text("Unknown item type")
            }

            Button("Close") {
                dismiss()
            }
        }
        .padding()
    }
}

#Preview {
    LoggableItemView(item: StrengthWorkout(name: "Test", sets: 3, reps: 10))
}
