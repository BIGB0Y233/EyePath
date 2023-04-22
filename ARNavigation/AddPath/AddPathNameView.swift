//
//  AddPathNameView.swift
//  ARNavigation
//
//  Created by ck on 2023/3/20.
//

import SwiftUI
import CoreData

struct AddPathNameView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var pathName: String = ""
    @State private var pathDescription: String = ""
    @State private var showAlert = false
    @State private var readytoAutoAdd = false
    @State private var readytoAdd = false
    @AppStorage("addMode") var selectedMode = 0
    @Binding var shouldPresent:Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("🚶添加新路径").font(.largeTitle).padding(50)
                TextField("路径名称", text: $pathName)
                    .padding()
                    .background(Color(uiColor: .systemGray6))
                    .cornerRadius(5.0)
                    .padding(20)
                
                TextField("描述(可选)", text: $pathDescription)
                    .padding()
                    .background(Color(uiColor: .systemGray6))
                    .cornerRadius(5.0)
                    .padding(20)
                NavigationLink(destination: AutoAddPathView(pathName: pathName,shouldPresent: $shouldPresent), isActive: $readytoAutoAdd) { EmptyView() }.isDetailLink(false)
                NavigationLink(destination: AddPathView(pathName: pathName,shouldPresent: $shouldPresent), isActive: $readytoAdd) { EmptyView() }.isDetailLink(false)
                Button(action: {
                    // TODO: 开始添加路径
                    if checkConflict() || pathName==""
                    {
                        showAlert = true
                    }
                    else{
                        DispatchQueue.main.async {
                            generateNewData()
                        }
                    }
                }) {
                    Text("开始记录路径")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                        .padding(50)
                }.alert(isPresented: $showAlert) {
                    Alert(title: Text("⚠️NO"), message: Text("名称为空或已存在!"), dismissButton: .default(Text("Ok")) {
                    })
                }
                .navigationBarItems(leading: Button(action: {
                    shouldPresent = false
                }) {
                    Text("取消")
                })
                
                //                    NavigationLink(destination: AutoAddPathView(pathName: "可以了", shouldPresent: $shouldPresent))
                //                    {
                //                        Text("后门")
                //                    }.isDetailLink(false)
                //                   Spacer()
                //                }
                
                //                NavigationLink(destination: selectedMode==0 ? AutoAddPathView(pathName: pathName) : AddPathView(pathName: pathName), isActive: $readytoAdd) { EmptyView() }
                
                Spacer()
                
            }
        }
    }
    
    private func checkConflict() -> Bool{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Path")
        fetchRequest.predicate = NSPredicate(format: "pathname == %@", pathName)
        do {
            let results = try viewContext.fetch(fetchRequest)
            for result in results {
                if result.value(forKey: "pathname") is String {
                    print("conflict happened")
                    return true
                }
            }
        } catch let error as NSError {
            print("check failed!")
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        return false
    }
    
    private func generateNewData(){
        let newPath = Path(context: viewContext)
        newPath.pathname = pathName
        newPath.pathdescription = pathDescription
        //Transformable数据需要赋初值
        newPath.position = [[0.0,0.0,0.0]]
        newPath.truenorth = [0.0]
        newPath.direction = ["startingpoint"]
        newPath.timestamp = Date()
        do {
            try viewContext.save()
            if selectedMode == 0{
                readytoAutoAdd = true
            }
            else{
                readytoAdd = true
            }
        } catch {
            readytoAutoAdd = false
            readytoAdd = false
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

//struct AddPathNameView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPathNameView()
//    }
//}
