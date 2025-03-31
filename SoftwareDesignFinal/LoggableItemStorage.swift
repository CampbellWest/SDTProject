import Foundation

class LoggableItemStorage {
    static let shared = LoggableItemStorage()
    private init() {}

    private let fileManager = FileManager.default

    private func getFileURL() -> URL {
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = directory.appendingPathComponent("loggable_items.txt")

        if !fileManager.fileExists(atPath: fileURL.path) {
            fileManager.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
            guard let fileHandle = try? FileHandle(forWritingTo: getFileURL()) else {
                print("Error opening file for appending.")
                return (nil as URL?)!
            }
            fileHandle.write("Type,Name,Sets,Reps,Duration,Calories,Protein,Carbs,Fats\n".data(using: .utf8)!)
            fileHandle.closeFile()
        }

        return fileURL
    }

    func appendToCSV(_ item: LoggableItem) {
        var csvText = ""
        
        if let strength = item as? StrengthWorkout {
            csvText = "Strength,\(strength.name),\(strength.sets),\(strength.reps),0,0,0,0,0\n"
        } else if let cardio = item as? CardioWorkout {
            csvText = "Cardio,\(cardio.name),0,0,\(cardio.duration),0,0,0,0\n"
        } else if let meal = item as? Meal {
            csvText = "Meal,\(meal.name),0,0,0,\(meal.calories),\(meal.protein),\(meal.carbs),\(meal.fats)\n"
        }
        
        guard let fileHandle = try? FileHandle(forWritingTo: getFileURL()) else {
            print("Error opening file for appending.")
            return
        }

        fileHandle.seekToEndOfFile()
        fileHandle.write(csvText.data(using: .utf8)!)
        fileHandle.closeFile()
    }

    
    func loadItems() {
        
        var data = ""
        
        let fileURL = getFileURL()
        print(fileURL)
        do{
            data = try String(contentsOf: fileURL, encoding: .utf8)
        } catch{
            print("ERROR: \(error)")
            return
        }
        
        var rows = data.components(separatedBy: .newlines)
        let columnCount = rows.first?.components(separatedBy: ",").count
        
        rows.removeFirst()
        
        for row in rows {
            let columns = row.components(separatedBy: ",")
            if columns.count == columnCount {
                let thisItem = LoggableItemFactory.createItem(type: columns[0],
                                                              name: columns[1],
                                                              sets: columns[2],
                                                              reps: columns[3],
                                                              duration: columns[4],
                                                              calories: columns[5],
                                                              protein: columns[6],
                                                              carbs: columns[7],
                                                              fats: columns[8])
                
                TrackerSingleton.shared.addItem(thisItem)
            }
        }
    }
}
