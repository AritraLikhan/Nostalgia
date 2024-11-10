import UserNotifications
import UIKit
import Combine

class MemoryViewModel: ObservableObject {
    @Published var memories: [Memory] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadMemories()
    }
    
    func addMemory(text: String, date: Date, photo: UIImage?) {
        let newMemory = Memory(text: text, date: date, photoData: photo?.jpegData(compressionQuality: 0.8))
        memories.append(newMemory)
        saveMemories()
        scheduleNotification(for: newMemory)
    }
    
    func saveMemories() {
        if let encoded = try? JSONEncoder().encode(memories) {
            UserDefaults.standard.set(encoded, forKey: "Memories")
        }
    }
    
    func loadMemories() {
        if let data = UserDefaults.standard.data(forKey: "Memories"),
           let decoded = try? JSONDecoder().decode([Memory].self, from: data) {
            memories = decoded
        }
    }
    
    private func scheduleNotification(for memory: Memory) {
        let content = UNMutableNotificationContent()
        content.title = "Remember this day!"
        content.body = memory.text
        content.sound = .default
        
        let triggerDate = Calendar.current.date(byAdding: .year, value: 1, to: memory.date) ?? memory.date
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: memory.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
