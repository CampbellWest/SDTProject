import SwiftUI

struct LoggableItemView: View {
    @Environment(\.dismiss) var dismiss
    let item: LoggableItem

    var body: some View {
        VStack {
            Text(item.name)
                .font(.headline)
                .padding(5)
            Divider()
                .padding(5)
                .frame(maxWidth: 150)
            // Determine and display the correct stats
            if let meal = item as? Meal {
                VStack {
                    Text("Calories: \(meal.calories) kcal")
                    Text("Protein: \(meal.protein)g | Carbs: \(meal.carbs)g | Fats: \(meal.fats)g")
                }
                .padding(5)
            } else if let strength = item as? StrengthWorkout {
                Text("Sets: \(strength.sets) | Reps: \(strength.reps)")
                    .padding(5)
            } else if let cardio = item as? CardioWorkout {
                Text("Duration: \(cardio.duration) minutes")
                    .padding(5)
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
    LoggableItemView(item: StrengthWorkout(name: "Test", sets: "3", reps: "10"))
}
