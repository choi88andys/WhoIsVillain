

import Foundation

class SharedTimer: ObservableObject{
  @Published var timer: Timer?
  @Published var users: [PersonalData] = []
  @Published var turn: Int = 0
  @Published var isPaused: Bool = true
  @Published var isClockwise: Bool = true
  @Published var urgentCountdownToggle: Bool = false
  var countdownSec: Double = 30
  
  init(){
    timer = Timer.scheduledTimer(timeInterval: Values.timerInterval,
                                 target: self,
                                 selector: #selector(timeDidFire),
                                 userInfo: nil,
                                 repeats: true)
    timer?.tolerance = Values.timerInterval * 0.1
  }
  convenience init(users: [PersonalData]){
    self.init()
    self.users = users
  }
  
  @objc func timeDidFire(){
    if !isPaused && users[turn].timeCount > 0 {
      users[turn].timeCount -= Values.timerInterval
      
      if users[turn].timeCount <= 5 {
        urgentCountdownToggle.toggle()
      }
      if users[turn].timeCount <= 0 {
        users[turn].timeoutCounter += 1
      }
    }
  }
  
  func reset(){
    users.removeAll()
    turn = 0
    isPaused = true
    isClockwise = true
  }
}
