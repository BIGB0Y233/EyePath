//
//  OnboardingView.swift
//  EyePath
//
//  Created by ck on 2023/4/23.
//

import SwiftUI


struct OnboardingView: View {
    @Binding var isOnboarding: Bool
    
    var body: some View {
                TabView{
                        OnboardingStepView(imageName: "ill1", title: "Step 1：路线制作", description: "制作路线时，\n手持设备从起点走到终点。")
                    
                    OnboardingStepView(imageName: "ill2", title: "Step 2:导航", description: "回到起点，开始导航！")
                    PermissionsListView(isOnboarding: $isOnboarding)
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .background(Color(uiColor: .systemGray5))
    }
}

struct OnboardingStepView: View {
    var imageName: String
    var title: String
    var description: String
    
    var body: some View {
        VStack {
            
            Text("使用流程")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
                .padding(20)
            
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Text(description)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.top, 10)
            Spacer()
        }
    }
}

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView()
//    }
//}
