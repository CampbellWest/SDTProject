import Foundation

// Common Protocol for Workouts and Meals
protocol LoggableItem {
    var name: String { get }
}

// Workout Classes
class StrengthWorkout: LoggableItem {
    let name: String
    let sets: Int
    let reps: Int
    
    init(name: String, sets: Int, reps: Int) {
        self.name = name
        self.sets = sets
        self.reps = reps
    }
}

class CardioWorkout: LoggableItem {
    let name: String
    let duration: Int // in minutes
    
    init(name: String, duration: Int) {
        self.name = name
        self.duration = duration
    }
}

// Meal Classes
class Meal: LoggableItem {
    let name: String
    let calories: Int
    let protein: Double
    let carbs: Double
    let fats: Double
    
    init(name: String, calories: Int, protein: Double, carbs: Double, fats: Double) {
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
    }
}

// Factory Class
class LoggableItemFactory {
    static func createItem(type: String, name: String, sets: Int = 0, reps: Int = 0, duration: Int = 0,
                           calories: Int = 0, protein: Double = 0.0, carbs: Double = 0.0, fats: Double = 0.0) -> LoggableItem {
        switch type {
        case "Strength":
            return StrengthWorkout(name: name, sets: sets, reps: reps)
        case "Cardio":
            return CardioWorkout(name: name, duration: duration)
        case "Meal":
            return Meal(name: name, calories: calories, protein: protein, carbs: carbs, fats: fats)
        default:
            fatalError("Invalid type")
        }
    }
}
