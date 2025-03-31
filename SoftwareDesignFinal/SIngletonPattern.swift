class TrackerSingleton {
    static let shared = TrackerSingleton() // Singleton instance

    private init() {} // Prevents multiple instances

    private var loggedItems: [LoggableItem] = []
    var selectedStatsItem: LoggableItem?

    func addItem(_ item: LoggableItem) {
        loggedItems.insert(item, at: 0)
    }

    func getLoggedItems() -> [LoggableItem] {
        return loggedItems
    }
}
