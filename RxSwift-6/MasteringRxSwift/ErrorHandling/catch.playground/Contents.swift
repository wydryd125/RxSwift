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
 # catch(_:)
 */
/*
 next, completed는 그대로 방출하지만 error 방출하지 않고 새로운 옵저버블이나 기본 값을 방출한다.
 네트워크 요청 코드에서 많이 사용한다.
 */

let bag = DisposeBag()

enum MyError: Error {
  case error
}

let subject = PublishSubject<Int>()
let recovery = PublishSubject<Int>()

subject
  .catch { _ in recovery }
  .subscribe { print($0) }
  .disposed(by: bag)

subject.onError(MyError.error)

subject.onNext(123)
subject.onNext(11)
//-----error 전달xx
// catch 연산자가 recovery subject로 교체했기 때문에 구독자에게 error가 전달되지 않는다.

recovery.onNext(22)
recovery.onNext(602)
recovery.onCompleted()
// recovery는 아무 문제가 없어 새로운 이벤트를 추가하면 구독자에게 방출한다.
// onCompleted 하여 안전하게 종료


