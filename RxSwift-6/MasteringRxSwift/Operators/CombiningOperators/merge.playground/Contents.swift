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
 # merge
 */
/*
 여러 옵저버블이 방출하는 이벤트를 하나의 옵저버블에서 방출하도록 병합
 */

let bag = DisposeBag()

enum MyError: Error {
  case error
}

let oddNumbers = BehaviorSubject(value: 1)
let evenNumbers = BehaviorSubject(value: 2)
let negativeNumbers = BehaviorSubject(value: -1)

let source = Observable.of(oddNumbers, evenNumbers, negativeNumbers)

source
//  .merge()
  .merge(maxConcurrent: 2)
  .subscribe { print($0) }
  .disposed(by: bag)

oddNumbers.onNext(3)
evenNumbers.onNext(4)

evenNumbers.onNext(6)
oddNumbers.onNext(5)

//oddNumbers.onCompleted() // evenNumbers는 completed가 되지 않아 evenNumbers 이벤트를 전달할수 있다.
//oddNumbers.onError(MyError.error) // 에러가 전달되면 그 이후의 이벤트는 전달 되지 않는다
//
//evenNumbers.onNext(602)
//evenNumbers.onCompleted()

negativeNumbers.onNext(-2) // .merge(maxConcurrent: 2) 2개(oddNumbers, evenNumbers)로 정해놓았기 때문에 negativeNumbers는 제외된다.

oddNumbers.onCompleted() // 한 개가 completed 되었기 때문에 negativeNumbers 이벤트를 전달할 수 있다.












