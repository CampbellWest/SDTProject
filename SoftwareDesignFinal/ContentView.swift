import SwiftUI
import CoreData

struct ContentView: View {
    @State private var meals: [LoggableItem] = []
    @State private var workouts: [LoggableItem] = []
    
    @State private var showWorkoutForm = false
    @State private var showMealForm = false
    @State private var showStatsView = false
    @State private var selectedTab = 0
    @State private var showStopWatch = false
    
    // Color scheme
    let accentColor = Color("AccentColor", defaultValue: Color.green)
    let secondaryColor = Color("SecondaryColor", defaultValue: Color.blue.opacity(0.7))
    let backgroundColor = Color("BackgroundColor", defaultValue: Color.white)
    let cardBackgroundColor = Color("CardBackgroundColor", defaultValue: Color.gray.opacity(0.1))
    
    // Window size
    let windowWidth: CGFloat = 1080
    let windowHeight: CGFloat = 820
    
    var body: some View {
        HStack(spacing: 0) {
            // Enhanced side panel
            SidePanelView()
                .frame(width: 220)
            
            // Main content area
            VStack(spacing: 0) {
                // Header with tabs
                HStack {
                    TabButton(title: "Dashboard", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    
                    TabButton(title: "Progress", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                    
                    TabButton(title: "Nutrition", isSelected: selectedTab == 2) {
                        selectedTab = 2
                    }
                    
                    TabButton(title: "Workouts", isSelected: selectedTab == 3) {
                        selectedTab = 3
                    }
                    
                    Spacer()
                    Button {
                        showStopWatch = true
                    } label: {
                        AchievementBadge(icon: "stopwatch", title: "", color: .blue)

                    }
                    .padding(.top, 14)
                    .padding(.horizontal, -5)
                    .buttonStyle(PlainButtonStyle())

                }
                .padding(.horizontal)
                .padding(.top, -5)
                .padding(.bottom, -5)
                .background(backgroundColor)
                
                // Main content based on selected tab
                if selectedTab == 0 {
                    dashboardView
                } else if selectedTab == 1 {
                    Text("Progress tracking will be shown here")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(backgroundColor)
                } else if selectedTab == 2 {
                    Text("Nutrition details will be shown here")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(backgroundColor)
                } else {
                    Text("Workout plans will be shown here")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(backgroundColor)
                }
            }
            .background(backgroundColor)
            .sheet(isPresented: $showMealForm, onDismiss: { updateLoggedItems() }) {
                MealForm(meals: $meals)
            }
            .sheet(isPresented: $showWorkoutForm, onDismiss: { updateLoggedItems() }) {
                WorkoutForm(workouts: $workouts)
            }
            .sheet(isPresented: $showStatsView) {
                if let selectedItem = TrackerSingleton.shared.selectedStatsItem {
                    LoggableItemView(item: selectedItem)
                } else {
                    Text("No item selected")
                }
            }
            .sheet(isPresented: $showStopWatch) {
                StopwatchView() 
            }
        }
        .frame(width: windowWidth, height: windowHeight)
        .onAppear {
            LoggableItemStorage.shared.loadItems()
            updateLoggedItems() // Load existing data on app start
        }
    }
    
    
    // Dashboard view
    var dashboardView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                // Summary cards
                HStack(spacing: 16) {
                    SummaryCard(
                        title: "Today's Calories",
                        value: "1,850",
                        subtitle: "of 2,800 goal",
                        icon: "flame.fill",
                        color: .orange
                    )
                    
                    SummaryCard(
                        title: "Water Intake",
                        value: "1.2L",
                        subtitle: "of 2.5L goal",
                        icon: "drop.fill",
                        color: .blue
                    )
                    
                    SummaryCard(
                        title: "Active Minutes",
                        value: "35",
                        subtitle: "of 60 goal",
                        icon: "bolt.fill",
                        color: .yellow
                    )
                    
                    SummaryCard(
                        title: "Protein",
                        value: "120g",
                        subtitle: "of 160g goal",
                        icon: "chart.bar.fill",
                        color: .purple
                    )
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Meals Section
                SectionHeader(title: "Recent Meals", icon: "fork.knife") {
                    showMealForm.toggle()
                }
                
                // Improved meals list
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        if meals.isEmpty {
                            EmptyStateCard(
                                message: "No meals logged yet",
                                icon: "plus.circle",
                                buttonText: "Add Meal"
                            ) {
                                showMealForm.toggle()
                            }
                            .frame(width: 160, height: 180)
                        } else {
                            ForEach(meals, id: \.name) { meal in
                                MealCard(meal: meal) {
                                    TrackerSingleton.shared.selectedStatsItem = meal
                                    showStatsView = true
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 200)
                
                // Workouts Section
                SectionHeader(title: "Recent Workouts", icon: "figure.highintensity.intervaltraining") {
                    showWorkoutForm.toggle()
                }
                
                // Improved workouts list
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        if workouts.isEmpty {
                            EmptyStateCard(
                                message: "No workouts logged yet",
                                icon: "plus.circle",
                                buttonText: "Add Workout"
                            ) {
                                showWorkoutForm.toggle()
                            }
                            .frame(width: 160, height: 180)
                        } else {
                            ForEach(workouts, id: \.name) { workout in
                                WorkoutCard(workout: workout) {
                                    TrackerSingleton.shared.selectedStatsItem = workout
                                    showStatsView = true
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 200)
                
                // Upcoming section
                SectionHeader(title: "Upcoming", icon: "calendar") {
                    // Calendar action
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    UpcomingItem(
                        time: "Today, 7:00 PM",
                        title: "Evening Run",
                        subtitle: "30 min, 5km",
                        color: .green
                    )
                    
                    UpcomingItem(
                        time: "Tomorrow, 8:00 AM",
                        title: "Chest & Arms",
                        subtitle: "Strength training, 45 min",
                        color: .blue
                    )
                    
                    UpcomingItem(
                        time: "Wed, 6:30 PM",
                        title: "Yoga Class",
                        subtitle: "Flexibility, 60 min",
                        color: .purple
                    )
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .background(backgroundColor)
    }
    
    // Function to update UI from Singleton
    private func updateLoggedItems() {
        let allItems = TrackerSingleton.shared.getLoggedItems()
        
        // Filter items into meals and workouts
        meals = allItems.compactMap { $0 as? Meal }
        workouts = allItems.filter { $0 is StrengthWorkout || $0 is CardioWorkout }
    }
}

// MARK: - Components

// Tab Button
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .primary : .secondary)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
        }
        .background(
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.primary.opacity(0.1))
                }
            }
        )
    }
}

// Section Header
struct SectionHeader: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .font(.headline)
            
            Spacer()
            
            Button(action: action) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 20))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

// Summary Card
struct SummaryCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Image(systemName: icon)
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// Meal Card
struct MealCard: View {
    let meal: LoggableItem
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .bottomTrailing) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green.opacity(0.2))
                        .frame(height: 100)
                    
                    Image(systemName: "fork.knife")
                        .font(.system(size: 40))
                        .foregroundColor(.green.opacity(0.4))
                        .padding(8)
                }
                
                Text(meal.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 8)
                
                if let meal = meal as? Meal {
                    Text("\(meal.calories) calories")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                }
                
                Spacer()
            }
            .frame(width: 160, height: 180)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Workout Card
struct WorkoutCard: View {
    let workout: LoggableItem
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .bottomTrailing) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue.opacity(0.2))
                        .frame(height: 100)
                    
                    Image(systemName: getWorkoutIcon())
                        .font(.system(size: 40))
                        .foregroundColor(.blue.opacity(0.4))
                        .padding(8)
                }
                
                Text(workout.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 8)
                
                getWorkoutDetails()
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .frame(width: 160, height: 180)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getWorkoutIcon() -> String {
        if workout is CardioWorkout {
            return "figure.run"
        } else {
            return "dumbbell.fill"
        }
    }
    
    private func getWorkoutDetails() -> some View {
        if let cardio = workout as? CardioWorkout {
            return Text("\(cardio.duration) min")
                .padding(.horizontal, 8)
        } else if let strength = workout as? StrengthWorkout {
            return Text("\(strength.sets) sets • \(strength.reps) reps")
                .padding(.horizontal, 8)
        } else {
            return Text("Workout")
                .padding(.horizontal, 8)
        }
    }
}

// Empty State Card
struct EmptyStateCard: View {
    let message: String
    let icon: String
    let buttonText: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundColor(.secondary.opacity(0.5))
            
            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: action) {
                Text(buttonText)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.accentColor)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// Upcoming Item
struct UpcomingItem: View {
    let time: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .trailing) {
                Text(time.components(separatedBy: ", ")[0])
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(time.components(separatedBy: ", ")[1])
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .frame(width: 80)
            
            Rectangle()
                .fill(color)
                .frame(width: 4, height: 50)
                .cornerRadius(2)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

// Enhanced Side Panel
struct SidePanelView: View {
    // Mock user data
    let user = (
        name: "Bob Taylor",
        weight: "160 lbs",
        goalWeight: "200 lbs",
        height: "5' 10\"",
        age: 25,
        calorieGoal: 2800
    )
    
    var body: some View {
        VStack(spacing: 0) {
            // User profile section
            VStack(spacing: 20) {
                // Profile image with edit button
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                        .padding(.top, 30)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: 26, height: 26)
                        .overlay(
                            Image(systemName: "pencil")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        )
                        .offset(x: 5, y: 5)
                }
                
                Text(user.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                // User stats
                VStack(spacing: 10) {
                    UserStatRow(
                        icon: "scalemass.fill",
                        label: "Current Weight:",
                        value: user.weight
                    )
                    
                    UserStatRow(
                        icon: "arrow.up.forward",
                        label: "Goal Weight:",
                        value: user.goalWeight
                    )
                    
                    UserStatRow(
                        icon: "ruler",
                        label: "Height:",
                        value: user.height
                    )
                    
                    UserStatRow(
                        icon: "calendar",
                        label: "Age:",
                        value: "\(user.age)"
                    )
                    
                    UserStatRow(
                        icon: "flame.fill",
                        label: "Calorie Goal:",
                        value: "\(user.calorieGoal.formatted())"
                    )
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 20)
            
            // Badges section with improved design
            VStack(spacing: 12) {
                Text("Achievements")
                    .font(.headline)
                    .padding(.top, 16)
                
                HStack(spacing: 12) {
                    AchievementBadge(icon: "figure.walk", title: "10K Steps", color: .orange)
                    AchievementBadge(icon: "trophy.fill", title: "Streak", color: .yellow)
                    AchievementBadge(icon: "bolt.fill", title: "Power", color: .green)
                }
                .padding(.bottom, 16)
            }
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.1))
            
            Spacer()
            
            // Navigation menu
            VStack(spacing: 0) {
                NavigationLink(icon: "house.fill", title: "Dashboard")
                NavigationLink(icon: "chart.bar.fill", title: "Progress")
                NavigationLink(icon: "fork.knife", title: "Nutrition")
                NavigationLink(icon: "figure.walk", title: "Workouts")
                NavigationLink(icon: "bell.fill", title: "Reminders")
                NavigationLink(icon: "gearshape.fill", title: "Settings")
            }
            .padding(.vertical)
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {}) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Sign out")
                        .font(.subheadline)
                }
                .foregroundColor(.secondary)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.bottom, 20)
            }
        }
        .background(Color.gray.opacity(0.1))
    }
}

// User Stat Row
struct UserStatRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundColor(.blue)
            
            Text(label)
                .font(.callout)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.callout)
                .fontWeight(.medium)
        }
    }
}

// Achievement Badge
struct AchievementBadge: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// Navigation Link
struct NavigationLink: View {
    let icon: String
    let title: String
    
    var body: some View {
        Button(action: {}) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                
                Text(title)
                    .font(.callout)
                
                Spacer()
            }
            .foregroundColor(.primary)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 4) // Added spacing between navigation items
    }
}

// Extension for Color with default value
extension Color {
    init(_ name: String, defaultValue: Color) {
        self.init(name)
    }
}

#Preview {
    ContentView()
}
