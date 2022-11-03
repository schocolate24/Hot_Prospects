//
//  ProspectsView.swift
//  HotProspects
//
//  Created by 中木翔子 on 2022/10/25.
//

import CodeScanner
import SwiftUI

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @EnvironmentObject var prospects: Prospects
    
    @State private var isShowingScanner = false
    @State private var showingConfirmation = false
    @State private var ButtonToggled = false
    
    let filter: FilterType
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        if prospect.isContacted {
                            Image(systemName: "person.crop.circle.fill.badge.checkmark")
                                .font(.system(size: 25))
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "person.crop.circle.badge.xmark")
                                .font(.system(size: 25))
                                .foregroundColor(.blue)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            
                        } label: {
                            Label("Trash", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                Button {
                    isShowingScanner = true
                } label: {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Schocolate\n@hackingwithswift.com", completion: handleScan)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingConfirmation = true

                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .confirmationDialog("Sort your lists", isPresented: $showingConfirmation) {
                        Button("Alphabetic") { ButtonToggled = true }
                        Button("Most recent") {}
                    }
                }
            }
        }
    }
    
    // this "title" is for the navigation title
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    // this is to filter people if they're contected or not
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted}
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted}
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.add(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func sortByName() -> Any {
        if ButtonToggled == true {
            return filteredProspects.sorted()
        }
        return false
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}



