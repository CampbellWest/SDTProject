import SwiftUI
import CoreData

struct ContentView: View {
    @State private var meals: [Meal] = []
    @State private var workouts: [LoggableItem] = []
    
    @State private var showWorkoutForm = false
    @State private var showMealForm = false
    
    var body: some View {
        HStack {
            SidePanelView()
            
            VStack {
                VStack{
                    // Meals Section
                    HStack {
                        Text("Recent Meals")
                            .font(.system(size: 16, weight: .bold))
                            .padding()
                        Spacer()
                        Button(action: {
                            showMealForm.toggle()
                        }) {
                            Image(systemName: "plus.app")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding()

                    }
                    Spacer()
                    // Meals List
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(meals, id: \.name) { meal in
                                VStack {
                                    Text(meal.name)
                                        .font(.title)
                                        .padding()
                                        .frame(width: 125, height: 125)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                        .fixedSize()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    Spacer()
                }
                .sheet(isPresented: $showMealForm, onDismiss: { updateLoggedItems() }) {
                    MealForm(meals: $meals)
                }

                
                
                Divider()
                
                VStack {
                    // Workouts Section
                    HStack {
                        Text("Recent Workouts")
                            .font(.system(size: 16, weight: .bold))
                            .padding()
                        Spacer()
                        Button(action: {
                            showWorkoutForm.toggle()
                        }) {
                            Image(systemName: "plus.app")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding()
                    }
                    
                    // Workouts List (Horizontally Scrollable)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(workouts, id: \.name) { workout in
                                VStack {
                                    Text(workout.name)
                                        .font(.title)
                                        .padding()
                                        .frame(width: 125, height: 125)
                                        .background(Color.green)
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                    
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .sheet(isPresented: $showWorkoutForm, onDismiss: { updateLoggedItems() }) {
                    WorkoutForm(workouts: $workouts)
                }
                
                
            }
            .frame(width: 600, height: 450)
            .onAppear {
                updateLoggedItems() // Load existing data on app start
            }
        }
        
    }
        
    
    // Function to update UI from Singleton
    private func updateLoggedItems() {
        let allItems = TrackerSingleton.shared.getLoggedItems()
        
        // Filter items into meals and workouts
        meals = allItems.compactMap { $0 as? Meal }
        workouts = allItems.filter { $0 is StrengthWorkout || $0 is CardioWorkout }
    }
}

#Preview {
    ContentView()
}

struct SidePanelView: View {
    var body: some View {
        VStack {
            VStack{
                Text("Bob")
                    .font(.title)
                    .padding(.top, 50)
                
                Image(systemName: "person.circle")
                    .font(.system(size: 50))
                    .padding(10)
                
                Text("Current Weight: 160lbs")
                    .padding(3)
                Text("Goal Weight: 200lbs")
                    .padding(3)
                Text("Height: 5' 10\"")
                    .padding(3)
                Text("Age: 25")
                    .padding(3)
                Text("Calorie Goal: 2,800")
                    .padding(3)
            }
            
            VStack {
                Text("Badges")
                    .font(.title)
                    .padding(.top, 3)
                    
                HStack{
                    Spacer()
                    Image(systemName: "bolt.shield.fill")
                        .font(.system(size: 30))
                        .padding(.top, -5)
                    Spacer()
                    Image(systemName: "bolt.shield.fill")
                        .font(.system(size: 30))
                        .padding(.top, -5)
                    Spacer()
                    Image(systemName: "bolt.shield.fill")
                        .font(.system(size: 30))
                        .padding(.top, -5)
                    Spacer()
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 90)
            .background(Color.blue.opacity(0.5))
            
            
                
            Spacer()
            HStack{
                Spacer()
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 25))
                Spacer()
                Image(systemName: "gearshape")
                    .font(.system(size: 25))
                Spacer()
                
            }
            
            Spacer()
            
        }
        .frame(width: 175) // Fixed width
        .background(Color.gray.opacity(0.2))
        .edgesIgnoringSafeArea(.vertical)
        Spacer()
    }
}

