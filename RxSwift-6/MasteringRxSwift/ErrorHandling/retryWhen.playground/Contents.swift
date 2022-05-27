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
 # retry(when:)
 */
/*
 
 */

let bag = DisposeBag()

enum MyError: Error {
  case error
}

var attempts = 1

let source = Observable<Int>.create { observer in
  let currentAttempts = attempts
  print("START #\(currentAttempts)")
  
  if attempts < 3 {
    observer.onError(MyError.error)
    attempts += 1
  }
  
  observer.onNext(1)
  observer.onNext(2)
  observer.onCompleted()
  
  return Disposables.create {
    print("END #\(currentAttempts)")
  }
}

let trigger = PublishSubject<Void>()

source
  .retry { _ in trigger }
// trigger를 방출하지 않으면 첫 시도만 하고 종료
// trigger로 onNext 전달하면 그 횟수만큼 시도
  .subscribe { print($0) }
  .disposed(by: bag)

trigger.onNext(())
trigger.onNext(())
trigger.onNext(())
//+1 되어 4번 시도 후 종료

