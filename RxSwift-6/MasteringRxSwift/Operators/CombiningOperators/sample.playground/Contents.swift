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
 # sample
 */
/*
 트리거 옵저버블이 next 이벤트를 전달할 떄마다 데이터 옵저버블이 next 이벤트를 방출하지만, 동일한 next 이벤트를 반복해서 방출하지 않는 연산자
 */

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let trigger = PublishSubject<Void>()
let data = PublishSubject<String>()

data.sample(trigger)
  .subscribe { print($0) }
  .disposed(by: bag)

//trigger.onNext(())
data.onNext("Hello")

trigger.onNext(())
trigger.onNext(()) // 방출X, 동일한 이벤트를 방출하지 않는다.

//data.onCompleted()
//trigger.onNext(())

data.onError(MyError.error) // trigger가 next를 방출하지 않아도 error를 전달한다.




