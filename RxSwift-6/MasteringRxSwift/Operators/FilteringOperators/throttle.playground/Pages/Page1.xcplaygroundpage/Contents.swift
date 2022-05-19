//
//  Mastering RxSwift
//  Copyright (c) KxCoding <help@kxcoding.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import RxSwift

/*:
 # throttle
 */
/*
 .throttle(<#T##dueTime: RxTimeInterval##RxTimeInterval#>, latest: <#T##Bool#>, scheduler: <#T##SchedulerType#>)
 첫번째 파라미터는 반복주기를 전달,
 latest: ture = 주기를 엄격하게 지킨다
 latest: false = 반복주기가 방출된 다음 가장 먼저 방출된 이벤트를 방출
 */

let disposeBag = DisposeBag()

let buttonTap = Observable<String>.create { observer in
  DispatchQueue.global().async {
    for i in 1...10 {
      observer.onNext("Tap \(i)")
      Thread.sleep(forTimeInterval: 0.3)
    }
    
    Thread.sleep(forTimeInterval: 1)
    
    for i in 11...20 {
      observer.onNext("Tap \(i)")
      Thread.sleep(forTimeInterval: 0.5)
    }
    
    observer.onCompleted()
  }
  
  return Disposables.create {
    
  }
}

buttonTap
  .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
// 1초마다 방출
// (forTimeInterval: 0.3) - 첫이벤트는 방출하고 1초에 해당하는 이벤트를 전달, 0.4(1.2초), 0.7(2.1초), 10(3초)

// (forTimeInterval: 0.5) - 첫이벤트는 방출하고 1초에 해당하는 이벤트를 전달, 12(1초), 14(2초), 16(3초), 18(4초), 20(5초)

  .subscribe { print($0) }
  .disposed(by: disposeBag)



//: [Next](@next)
