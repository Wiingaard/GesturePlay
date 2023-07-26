//
//  MainNavigationView.swift
//  GesturePlay
//
//  Created by Martin Wiingaard on 31/10/2020.
//

import SwiftUI

struct MainNavigationView: View {
    
    var body: some View {
        NavigationView(content: {
            List.init((0..<3)) { row in
                if row == 0 {
                    NavigationLink(destination: CircleContentView()
                                    .navigationBarHidden(true)
                    ) {
                        Text("Circle dragging")
                    }
                } else if row == 1 {
                    NavigationLink(destination: CardPlayContentView()
                                    .navigationBarHidden(true)
                    ) {
                        Text("Card play")
                    }
                } else if row == 2 {
                    NavigationLink(destination: TimerContentView()
                                    .navigationBarHidden(true)
                    ) {
                        Text("Timer play")
                    }
                } else if row == 3 {
                    NavigationLink(destination: DispatchContentView()
                                    .navigationBarHidden(true)
                    ) {
                        Text("Dispatch play")
                    }
                }
                
                    
            }.navigationTitle("Gestures")
            .listStyle(InsetGroupedListStyle())
        })
    }
}


struct MainNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MainNavigationView()
    }
}
