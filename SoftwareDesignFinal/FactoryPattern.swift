import Foundation

// Common Protocol for Workouts and Meals
protocol LoggableItem {
    var name: String { get }
}

// Workout Class
class StrengthWorkout: LoggableItem {
    let name: String
    let sets: String
    let reps: String
    
    init(name: String, sets: String, reps: String) {
        self.name = name
        self.sets = sets
        self.reps = reps
    }
}

// Cardio Class
class CardioWorkout: LoggableItem {
    let name: String
    let duration: String // in minutes
    
    init(name: String, duration: String) {
        self.name = name
        self.duration = duration
    }
}

// Meal Class
class Meal: LoggableItem {
    let name: String
    let calories: String
    let protein: String
    let carbs: String
    let fats: String
    
    init(name: String, calories: String,
         protein: String, carbs: String, fats: String) {
        
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
    }
}

// Factory Class
class LoggableItemFactory {
    static func createItem(type: String, name: String, sets: String = "", reps: String = "", duration: String = "",
                           calories: String = "", protein: String = "", carbs: String = "", fats: String = "") -> LoggableItem {
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
