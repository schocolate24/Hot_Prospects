//
//  ContentView.swift
//  HotProspects
//
//  Created by 中木翔子 on 2022/10/18.
//


//2. Use JSON and the documents directory for saving and loading our user data.
//3. Use a confirmation dialog to customize the way users are sorted in each tab – by name or by most recent. (less than a half way there)


import SamplePackage
import SwiftUI

struct ContentView: View {
    @StateObject var prospects = Prospects()
    
    var body: some View {
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                } 
            ProspectsView(filter: .contacted)
                .tabItem {
                    Label("Everyone", systemImage: "checkmark.circle")
                }
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
        .environmentObject(prospects)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
