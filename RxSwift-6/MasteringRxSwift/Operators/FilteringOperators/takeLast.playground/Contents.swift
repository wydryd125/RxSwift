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
 # takeLast
 */
/*
 takeLast(count: int)
 마지막 count 요소들만 전달.
 */

let disposeBag = DisposeBag()

let subject = PublishSubject<Int>()

subject.takeLast(2) // 마지막 두개만 저장
  .subscribe { print($0) }
  .disposed(by: disposeBag)

(1...10).forEach { subject.onNext($0) } //9,10 저장
//subject.onCompleted()

subject.onNext(11) // 10,11 저장

subject.onCompleted() // onCompleted를 전달하면 마지막 저장요소10,11)를 구독자에게 방출

enum MyError: Error {
  case error
}

subject.onError(MyError.error) // onError를 전달하면 버퍼에 저장되어 있는이벤트를 버리고 error만 전달




