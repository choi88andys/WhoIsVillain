


import SwiftUI

struct TableView: View {
    var item: PersonalData
    var isTurtle: Bool = false
    
    
    var body: some View {
        return HStack(spacing: 0) {
            HStack {
                if isTurtle {
                    Image(systemName: "tortoise.fill")
                        .font(.system(size: SettingConstants.fontSize*0.8))
                }
                else {
                    if item.isTurnOn {
                        Image(systemName: "hand.point.right")
                            .font(.system(size: SettingConstants.fontSize))
                    }
                }
            }
            .frame(minWidth: UIScreen.main.bounds.size.width*0.1 )
            
            Text(item.personName)
                .truncationMode(.middle)
                .lineLimit(1)
                .font(.custom("courier", size: SettingConstants.fontSize))
                .frame(width: UIScreen.main.bounds.size.width*0.3)
                
            Spacer()
            Text(item.showRemainedTime)
                .fixedSize()
                .font(.custom("copperplate", size: SettingConstants.fontSize*1.9))
                .frame(minWidth: UIScreen.main.bounds.size.width*0.3)
            Spacer()
            
            HStack(spacing: 1) {
                if item.timeoutCounter > 0 {
                    Image(systemName: "clock.badge.exclamationmark")
                    Image(systemName: "multiply")
                        .font(.system(size: SettingConstants.fontSize*0.5))
                    Text("\(item.timeoutCounter)")
                }
            }
            .font(.system(size: SettingConstants.fontSize))
            .frame(minWidth: UIScreen.main.bounds.size.width*0.15)            
        }
    }
}



struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TableView(item: PersonalData(personName: "AAAAABBBBBBCCCCCCCC", timeCount: 3355, timeoutCounter: 88))
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            .previewDisplayName("8")
        
        TableView(item: PersonalData(personName: "AAAAABBBBBBCCCCCCCC", timeCount: 3355, timeoutCounter: 88))
            .previewDevice(PreviewDevice(rawValue: "iPad (9th generation)"))
            .previewDisplayName("pad 9 gen")
    }
}

