class TrackerSingleton {
    static let shared = TrackerSingleton() // Singleton instance

    private init() {} // Prevents multiple instances

    private var loggedItems: [LoggableItem] = []

    func addItem(_ item: LoggableItem) {
        loggedItems.append(item)
    }

    func getLoggedItems() -> [LoggableItem] {
        return loggedItems
    }
}
