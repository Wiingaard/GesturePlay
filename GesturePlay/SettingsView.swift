//
//  SettingsView.swift
//  GesturePlay
//
//  Created by Martin Wiingaard on 02/11/2020.
//

import SwiftUI

struct SettingsView<Content: View>: View {
    
    var content: () -> Content
    
    @State private var showSettings = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                VStack {
                    if showSettings {
                        content()
                        .padding(.horizontal, 24)
                        .transition(.move(edge: .top))
                        .transition(.opacity)
                        
                    }
                    
                    ZStack {
                        HStack {
                            Text("Settings")
                                .padding(.trailing, 4)
                            Image(systemName: "arrowtriangle.down.fill")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .rotationEffect(showSettings ? .degrees(-180) : .zero)
                        }.frame(maxWidth: .infinity)
                        HStack {
                            Button.init(action: { presentationMode.wrappedValue.dismiss() }, label: {
                                Image(systemName: "arrowtriangle.left.fill")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.primary)
                                    .frame(width: 10, height: 10)
                            })
                            .padding()
                            Spacer()
                        }
                    }
                }
                .padding(.top, geometry.safeAreaInsets.top)
                .transition(.slide)
                .padding(.bottom, 12)
                .background(
                    RoundedCorner(radius: 16, corners: [.bottomLeft, .bottomRight])
                        .fill(Color.init(.secondarySystemBackground).opacity(showSettings ? 1 : 0))
                        
                )
                .onTapGesture {
                    withAnimation {
                        showSettings.toggle()
                    }
                }
                .ignoresSafeArea(edges: .top)
                
                Spacer()
            }
        }
    }
}
struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        SettingsView {
            VStack {
                HStack {
                    Text("Rotation")
                    Slider.init(value: .constant(0.5), in: 0...360)
                }
                HStack {
                    Text("Duration")
                    Slider.init(value: .constant(0.5), in: 0.1...3)
                }
            }
        }
    }
}
