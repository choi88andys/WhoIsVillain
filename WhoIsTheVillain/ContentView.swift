//
//  ContentView.swift
//  WhoIsTheVillain
//
//  Created by MacAndys on 2021/12/05.
//


import SwiftUI

struct ContentView: View {
    private let startImageHeight: CGFloat = SettingConstants.isPhone ? 70 : 105
    private let startImageWidth: CGFloat = SettingConstants.isPhone ? 220 : 330
    
    @State var isClockwise: Bool = true
    @State var timeMin: Int = 0
    @State var timeSec: Int = 0
    @State var numUsers: Int = 2
    @State var nameArray: [String] = []
    @StateObject var sharedTimer: SharedTimer = SharedTimer()
    
    @State var isActivePlayingView: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        return NavigationView {
            ZStack {
                VStack {
                    AppLabel()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                HStack {
                                    Image(systemName: "doc")
                                        .onTapGesture {
                                            isClockwise = true
                                            timeSec = 0
                                            timeMin = 0
                                            numUsers = 2
                                            for i in 0..<nameArray.count {
                                                nameArray[i] = "\(Strings.player) \(i+1)"
                                            }
                                        }
                                }
                            }
                            
                            ToolbarItem(placement: .navigationBarTrailing) {
                                HStack {
                                    NavigationLink(destination: ScoreboardView(isActivePlayingView: $isActivePlayingView)) {
                                        Image(systemName: "chart.bar.xaxis")
                                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    }
                                    NavigationLink(destination: HelpView()) {
                                        Image(systemName: "questionmark")
                                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    }
                                }
                            }
                        }
                        .font(.system(size: SettingConstants.fontSize))
                    Spacer()
                                                            
                        
                    ScrollView {
                        VStack(spacing: SettingConstants.fontSize*0.4) {
                            HStack(spacing: 0) {
                                Spacer()
                                Text(Strings.personalTimeLimit)
                                    .lineLimit(1)
                                    .padding(.trailing, SettingConstants.fontSize*0.6)
                                
                                Menu {
                                    Picker("", selection: $timeMin) {
                                        ForEach(0..<60) { i in
                                            Text("\(i) \(Strings.minuteShort)")
                                        }
                                    }
                                    .labelsHidden()
                                    .pickerStyle(.inline)
                                } label: {
                                    Text("\(timeMin)\(Strings.minuteShort)")
                                        .fixedSize()
                                        .padding(.trailing, SettingConstants.fontSize*0.3)
                                }
                                
                                Menu {
                                    Picker("", selection: $timeSec) {
                                        ForEach(0..<60) { j in
                                            Text("\(j) \(Strings.secondShort)")
                                        }
                                    }
                                    .labelsHidden()
                                    .pickerStyle(.inline)
                                } label: {
                                    Text("\(timeSec)\(Strings.secondShort)")
                                        .fixedSize()
                                }
                                
                                Spacer()
                            }
                            .font(.system(size: SettingConstants.fontSize))
                            
                            
                            
                            HStack(spacing: 0) {
                                Spacer()
                                
                                Text(Strings.userCount)
                                    .lineLimit(1)
                                    .padding(.trailing, SettingConstants.fontSize*0.6)
                                
                                Menu {
                                    Picker("", selection: $numUsers) {
                                        ForEach(SettingConstants.minUsers..<SettingConstants.maxUsers+1,
                                                id: \.self) { i in
                                            Text("\(i) \(Strings.users)")
                                        }
                                    }
                                    .labelsHidden()
                                    .pickerStyle(InlinePickerStyle())
                                } label: {
                                    Text("\(numUsers) \(Strings.users)")
                                        .fixedSize()
                                }
                                
                                Spacer()
                            }
                            .font(.system(size: SettingConstants.fontSize))
                            
                            HStack(spacing: 0) {
                                Spacer()
                                
                                HStack {
                                    if isClockwise {
                                        Text(Strings.clockwise)
                                            .truncationMode(.head)
                                    } else {
                                        Text(Strings.counterClockwise)
                                            .truncationMode(.head)
                                    }
                                }
                                
                                Toggle("", isOn: $isClockwise)
                                    .frame(width: UIScreen.main.bounds.size.width*0.001)
                                    .padding(.trailing, UIScreen.main.bounds.size.width*0.27)
                                    .padding(.leading, UIScreen.main.bounds.size.width*0.08)
                            }
                            .font(.system(size: SettingConstants.fontSize))
                            
                        }
                        
                        
                        
                        InputNameView(numUsers: $numUsers, nameArray: $nameArray)
                            
                    }
                    
                    
                    Spacer()
                    Divider()
                    NavigationLink(destination: PlayingView(
                        isActivePlayingView: $isActivePlayingView).onAppear(){
                            sharedTimer.reset()
                            
                            
                            sharedTimer.isClockwise = isClockwise
                            let time = Double(timeMin*60 + timeSec) > SettingConstants.countdownSec ?
                            Double(timeMin*60 + timeSec) : SettingConstants.countdownSec
                            
                            for i in 0..<numUsers {
                                let name = nameArray[i]
                                sharedTimer.users.append(PersonalData(
                                    timeCount: time,
                                    personName: name)
                                )
                            }
                            
                            sharedTimer.users[0].isTurnOn = true
                            
                            UIApplication.shared.isIdleTimerDisabled = true
                        }.onDisappear() {
                            UIApplication.shared.isIdleTimerDisabled = false
                        }, isActive: $isActivePlayingView)
                    {
                        Ellipse()
                            .fill(Color.green)
                            .overlay(Text(Strings.start)
                                        .font(.system(size: SettingConstants.overlayTextSize, weight: Font.Weight.heavy, design: Font.Design.rounded))
                                        .foregroundColor(Color.black)
                                        .multilineTextAlignment(.center)
                            )
                            .frame(width:startImageWidth, height: startImageHeight)
                    }
                    .isDetailLink(false)
                    .padding()
                }
                .onAppear() {
                    if nameArray.count == 0 {
                        for i in 0..<SettingConstants.maxUsers {
                            nameArray.append("\(Strings.player) \(i+1)")
                        }
                    }
                } // end V
                
            } // end Z
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
            
        } // end Navi
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .environmentObject(sharedTimer)
    }
}




struct InputNameView: View {
    @Binding var numUsers: Int
    @Binding var nameArray: [String]
    
    var body: some View {
        VStack {
            if nameArray.count > 0 {
                ForEach(0..<numUsers, id: \.self) { index in
                    HStack(spacing: 5){
                        Image(systemName: "person.crop.square")
                            .font(.system(size: SettingConstants.fontSize*1.5))
                            .padding(.horizontal, SettingConstants.fontSize*0.7 )
                        
                        TextField("", text: $nameArray[index])
                            .font(.system(size: SettingConstants.fontSize*1.3))
                            .multilineTextAlignment(.leading)
                            .disableAutocorrection(true)
                    }
                    .padding(SettingConstants.fontSize*0.5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, lineWidth: 1.5))
                    .padding(.horizontal, SettingConstants.fontSize*0.3)

                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static let deviceNumber = 1
    
    static var previews: some View {
        switch deviceNumber {
        case 1:
            ContentView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
                .previewDisplayName("8 Plus")
            
        case 2:
            ContentView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
                .previewDisplayName("8 Plus")
            
            ContentView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("11 Pro Max")
            
        case 3:
            ContentView()
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (5th generation)"))
                .previewDisplayName("12.9-inch")
            
        default:
            ContentView()
        }
    }
}
