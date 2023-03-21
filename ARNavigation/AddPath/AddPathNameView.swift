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
    @State private var readytoAdd = false
    
    var body: some View {
        VStack {
            
            NavigationLink(destination: AddPathView(pathName: $pathName), isActive: $readytoAdd) {
                EmptyView()
            }
            
            Text("🚶添加新路径").font(.largeTitle)
            
            TextField("路径名称", text: $pathName)
                .padding()
                .background(Color.white)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            TextField("描述(可选)", text: $pathDescription)
                .padding()
                .background(Color.white)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            Button(action: {
                // TODO: 开始添加路径
                if checkConflict() || pathName==""
                {
                    showAlert = true
                }
                else{
                    generateNewData()
                }
                         }) {
                Text("开始记录路径")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.blue)
                    .cornerRadius(15.0)
            }
        }
        .alert(isPresented: $showAlert) {
        Alert(title: Text("⚠️打咩"), message: Text("名称为空或已存在"), dismissButton: .default(Text("Got it!")))
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
        newPath.anglediff = [0.0]
        newPath.direction = ["straight"]
        do {
            try viewContext.save()
            readytoAdd = true
        } catch {
            readytoAdd = false
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct AddPathNameView_Previews: PreviewProvider {
    static var previews: some View {
        AddPathNameView()
    }
}
