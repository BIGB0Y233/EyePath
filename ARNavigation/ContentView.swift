//
//  ContentView.swift
//  ARNavigation
//
//  Created by ck on 2023/3/8.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Path.timestamp, ascending: true)],
        animation: .default)
    private var myPath: FetchedResults<Path>
    
    //MARK: - 添加路径参数
    @State private var gotoAdd = false
        
    var body: some View {
            NavigationStack
            {
                List {
                    ForEach(myPath) { path in
                        NavigationLink {
                            PathDetailView(name: path.pathname ?? "default")
                        } label: {
                            Text(path.pathname ?? "default")
                        }
                    }
                    .onDelete(perform: deletePath)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        NavigationLink(destination: AddPathNameView()) { Label("Add Item", systemImage: "plus") }
                    }
                } .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("已保存路径")
                .navigationBarBackButtonHidden(true)
            }
    }
    //MARK: - TableViewDelegate Functions
    private func deletePath(offsets: IndexSet) {
        withAnimation {
//            offsets.map { myPath[$0] }.forEach(viewContext.delete)
            offsets.map { myPath[$0] }.forEach{
                selectedPath in
                deleteImage(imageName: selectedPath.pathname!)
                viewContext.delete(selectedPath)
            }
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


