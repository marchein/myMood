//
//  Statistics.swift
//  myMood
//
//  Created by Marc Hein on 02.07.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import SwiftUI
import UIKit

struct Statistics: View {
    
    @State private var selectedDuration = 3
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("Zeitraum")
                        Spacer()
                        
                        Picker(selection: $selectedDuration.onChange(durationChange), label: Text("")) {
                            Text("Woche").tag(0)
                            Text("Monat").tag(1)
                            Text("Jahr").tag(2)
                            Text("Gesamt").tag(3)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                    }
                }
                Section {
                    HStack {
                        Text("Einträge")
                        Spacer()
                        Text("\(Model.statsContainer.data.count)")
                    }
                    HStack {
                        Text("Ältester Eintrag")
                        Spacer()
                        Text(Model.statsContainer.lastDay?.isoDate ?? "Kein Eintrag vorhanden")
                    }
                    HStack {
                        Text("Einträge pro Woche")
                        Spacer()
                        Text(Model.statsContainer.getEntrysPerWeek())
                    }
                }
            }.listStyle(GroupedListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .navigationBarTitle("Statistiken")
        }.onAppear {
            self.durationChange(self.selectedDuration)
            Model.statsContainer.didChange.send(Model.statsContainer)
        }
        
    }
    
    func durationChange(_ tag: Int) {
        let durationVal = duration(from: tag)
        print("tag: \(tag), duration: \(durationVal)")
        Model.statsContainer.selectedTime = durationVal
        print(Model.statsContainer.selectedTime)
        print(Model.statsContainer.data.count)

    }
    
    func duration(from tag: Int) -> Duration {
        switch tag {
        case 0:
            return .week
        case 1:
            return .month
        case 2:
            return .year
        default:
            return .allTime
        }
    }
}

struct Statistics_Previews: PreviewProvider {
    static var previews: some View {
        Statistics()
    }
}

class StatisticsHostingController: UIHostingController<Statistics> {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: Statistics());
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
