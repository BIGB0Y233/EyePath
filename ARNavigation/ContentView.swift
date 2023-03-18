//
//  ContentView.swift
//  ARNavigation
//
//  Created by ck on 2023/3/8.
//

import SwiftUI
import CoreData

struct ContentView: View,TableViewDelegate {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    //MARK: - 列表参数
    @ObservedObject var mutableData = MyData(["default"])
    @State var isScrolling: Bool = false
    @State var detailViewActive = false
    @State var detailViewName = "default"
    @State var isLoading = false
    @State var filename:[String]=[]
    
    //MARK: - 添加路径参数
    @State var shown = false
    @State var text = ""
    @State var isDone = false
    var total = 2
        
    var body: some View {
        ZStack{
            ZStack{
                NavigationView {
                    ZStack {
                        
                        NavigationLink(destination: compassView(pathName: $detailViewName), isActive: $detailViewActive) {
                            EmptyView()
                        }
                        
                        VStack {
                            TextField("Saved", text: Binding(get: {
                                return ""
                            }, set: { (newValue) in
                                // self.inputField = newValue
                                self.mutableData.append(newValue)
                            }))
                            
                            Divider()
                            
                            TableView(dataSource: self.mutableData as TableViewDataSource, delegate: self )
                        }
                        .padding()
                        .edgesIgnoringSafeArea(.bottom)
                        
                    }.navigationBarTitle("Choose a Path")
                        .toolbar {
#if os(iOS)
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                            }
#endif
                            ToolbarItem {
                                Button(action: addPath) {
                                    Label("Add Item", systemImage: "plus")
                                }
                            }
                        }
                }
                
                if self.shown{
                    alertView(text: $text, shown: $shown,isDone: $isDone)
                }
            }.navigate(to: AddPathView(pathName: $text), when: $isDone)
        }
    }
    //MARK: - TableViewDelegate Functions
    private func addPath() {
        self.shown = true
    }
    
    func supplyMoreData() {
        isLoading = true
        var i=0
        
        let manger=FileManager.default
        let urlString=NSHomeDirectory()+"/Documents/"
        do{
            let cintents1 = try manger.contentsOfDirectory(atPath: urlString)
            for word in cintents1
            {
                i+=1
                filename.append(word)
                
            }
        }
        catch{
                    print("Error occurs.")
        }
        mutableData.append(contentsOf: filename)
        isLoading = false
    }
    
    func onScroll(_ tableView: TableView, isScrolling: Bool) {
        withAnimation {
            self.isScrolling = isScrolling
        }
    }
    
    func onAppear(_ tableView: TableView, at index: Int) {
        
        if index+5 > self.mutableData.count() && self.mutableData.count() < self.total && !self.isLoading {
            //print("*** NEED TO SUPPLY MORE DATA ***")

            self.supplyMoreData()
        }
         
    }
    
    func onTapped(_ tableView: TableView, at index: Int) {
        
        //print("Tapped on record \(index)")
        var returnName = "default"
        if index != 0{
            returnName = filename[index-1]
        }
        self.detailViewName = returnName
        self.detailViewActive.toggle()
    }
    
    // this could be a view modifier but I do not think there is a way to read the view modifier
    // from a UIViewRepresentable (yet).
    func heightForRow(_ tableView: TableView, at index: Int) -> CGFloat {
        return 64.0
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

class MyData: TableViewDataSource, ObservableObject {
    @Published var mutableData = [String]()
    
    func count() -> Int {
        return mutableData.count
    }
    func titleForRow(row: Int) -> String {
        return mutableData[row]
    }
    func subtitleForRow(row: Int) -> String? {
        return "导航路线"
    }
    init(_ someData: [String]) {
        mutableData.append(contentsOf: someData)
    }
    func append(contentsOf data: [String]) {
        mutableData.append(contentsOf: data)
    }
    func append(_ single: String) {
        mutableData.append(single)
    }
}
