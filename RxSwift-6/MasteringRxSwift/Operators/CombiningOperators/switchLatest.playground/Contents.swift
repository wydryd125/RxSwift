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
 # switchLatest
 */
/*
 가장 최근에 방출된 옵저버블을 구독하고, 이 옵저버블이 전달하는 이벤트를 구독자에게 전달
 */

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let a = PublishSubject<String>()
let b = PublishSubject<String>()

let source = PublishSubject<Observable<String>>()

source
  .switchLatest()
  .subscribe { print($0) }
  .disposed(by: bag)

a.onNext("1")
b.onNext("b")
// a,b와 source사이 연결된 것이 없기 때문에 방출이 되지 않는다.

source.onNext(a)
a.onNext("2")
b.onNext("b") //최신 옵저버블이 아니기 떄문에 구독자에게 전달되지 않는다

source.onNext(b) // 이제 b가 최신 옵저버블
a.onNext("3")
b.onNext("C")

source.onNext(a)
a.onNext("602")

a.onCompleted()
b.onCompleted() // 구독자에게 전달되지 않는다

source.onCompleted() // 구독자에게 전달

a.onError(MyError.error)
b.onError(MyError.error) // error는 completed와 다르게 구독자에게 바로 전달된다.








