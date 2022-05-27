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
 # retry
 */
/*
 error가 발생하면 구독을 해제하고 새로운 구독을 시작, 옵저버블의 모든 작업을 다시 시작한다.
 */

let bag = DisposeBag()

enum MyError: Error {
  case error
}

var attempts = 1

let source = Observable<Int>.create { observer in
  let currentAttempts = attempts
  print("#\(currentAttempts) START")
  
  if attempts < 3 {
    observer.onError(MyError.error)
    attempts += 1
  }
  
  observer.onNext(1)
  observer.onNext(2)
  observer.onCompleted()
  
  return Disposables.create {
    print("#\(currentAttempts) END")
  }
}

source
  .retry(7)
// 재시도 횟수는 6회, 꼭 +1을 해야 원하는 만큼 재시도 한다.
// attempts < 3 조건이 있기 때문에 retry 2번째 부터 구독자에게 전달, completed 한다.
  .subscribe { print($0) }
  .disposed(by: bag)





