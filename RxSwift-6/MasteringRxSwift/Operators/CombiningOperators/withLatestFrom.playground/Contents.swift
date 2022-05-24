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
 # withLatestFrom
 */
/*
 트리거(연산자를 호출하는 옵저버블) 옵저버블이 next 이벤트를 방출하면 데이터 옵저버블이 가장 최근에 방출한 next 이벤트를 구독자에게 전달
 
 */

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let trigger = PublishSubject<Void>()
let data = PublishSubject<String>()

trigger.withLatestFrom(data)
  .subscribe { print($0) }
  .disposed(by: bag)

data.onNext("Hello") //트리거에게 next 이벤트를 전달하지 않아 전달되지 않는다.
trigger.onNext(()) // 구독자에게 전달된다.
trigger.onNext(()) // 반복적으로 전달된다.

//data.onCompleted() // 구독자에게 completed가 전달되지 않는다.
//data.onError(MyError.error) // completed와는 달리 바로 error가 전달된다.
trigger.onNext(())  // completed를 전달하였지만 가장 마지막으로 전달된 next(Hello)가 전달된다.

trigger.onCompleted() // trigger로 completed를 전달하면 구독자에게 바로 전달된다.









