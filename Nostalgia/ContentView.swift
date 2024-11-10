import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MemoryViewModel()
    @State private var text: String = ""
    @State private var selectedDate = Date()
    @State private var selectedPhoto: UIImage?
    @State private var isShowingImagePicker = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Memory Text", text: $text)
                    
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)
                    
                    Button(action: {
                        isShowingImagePicker = true
                    }) {
                        Text("Select Photo")
                    }
                    
                    if let photo = selectedPhoto {
                        Image(uiImage: photo)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    
                    Button(action: saveMemory) {
                        Text("Save Memory")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                List(viewModel.memories) { memory in
                    VStack(alignment: .leading) {
                        Text(memory.text).font(.headline)
                        Text("\(memory.date, formatter: DateFormatter.shortDate)")
                        if let data = memory.photoData, let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                        }
                    }
                }
            }
            .navigationTitle("Nostalgia")
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $selectedPhoto)
            }
        }
    }
    
    private func saveMemory() {
        viewModel.addMemory(text: text, date: selectedDate, photo: selectedPhoto)
        text = ""
        selectedDate = Date()
        selectedPhoto = nil
    }
}
