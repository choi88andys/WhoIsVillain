

import SwiftUI


struct ScoreboardView: View {
  let dismiss: () -> ()
  let homeButtonTapped: () -> ()
  let isActivePlayingView: Bool
  
  let df = DateFormatter()
  let defaults = UserDefaults.standard
  
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    df.dateFormat = "yyyy.MM.dd.   -   HH:mm:ss"
    defaults.synchronize()
    // Must use it to handle sync issue.
    
    let dateArray = defaults
      .object(forKey: "dateArray") as? [Date] ?? [Date]()
    let namesArray = defaults
      .object(forKey: "namesArray") as? [[String]] ?? [[String]]()
    let timesArray = defaults
      .object(forKey: "timesArray") as? [[Double]] ?? [[Double]]()
    let countersArray = defaults
      .object(forKey: "countersArray") as? [[Int]] ?? [[Int]]()
    
    
    return VStack {
      BannerView()
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            HStack {
              if isActivePlayingView {
                Image(systemName: "house.fill")
                  .onTapGesture {
                    homeButtonTapped()
                  }
              }
              else {
                Image(systemName: "arrowshape.turn.up.backward.fill")
                  .onTapGesture {
                    dismiss()
                  }
              }
            }
          }
        }
        .font(.system(size: Values.fontSize))
      
      
      ScrollView(showsIndicators: false) {
        if dateArray.count == 0 {
          VStack {
            Image(systemName: "nosign")
              .font(.system(size: Values.fontSize*4))
              .padding(30)
            Text(Strings.noData)
              .font(.system(size: Values.fontSize))
          }
          
          
        } else {
          LazyVStack {
            ForEach((0..<dateArray.count).reversed(), id: \.self) { i in
              let maxCounter: Int = countersArray[i].max() ?? 0
              
              DisclosureGroup {
                Divider()
                ForEach(0..<namesArray[i].count, id: \.self) { j in
                  TableView(item: PersonalData(personName: namesArray[i][j],
                                               timeCount: timesArray[i][j],
                                               timeoutCounter: countersArray[i][j]),
                            isTurtle: (maxCounter==0) ? false : (countersArray[i][j]==maxCounter) )
                  .id(UUID())
                }
              } label: {
                HStack {
                  Spacer()
                  Text(df.string(from: dateArray[i]))
                  // .fixedSize()
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                  Spacer()
                }
                .font(.system(size: Values.fontSize))
              }
              .frame(width: UIScreen.main.bounds.size.width - Values.fontSize*0.5)
              .padding(.trailing, Values.fontSize*0.2)
              .overlay(
                RoundedRectangle(cornerRadius: 15)
                  .stroke(Color.gray, lineWidth: 1.5))
            }
          }
          
        }
      } // scroll end
      .navigationBarBackButtonHidden(true)
      
    }
  } // body end
}


