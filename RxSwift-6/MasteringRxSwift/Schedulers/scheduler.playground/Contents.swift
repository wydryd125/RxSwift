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
 # Scheduler
 */
/*
 thread 처리를 위한 연산자.
 
   GCD            RxSwift
 main Queue    Main Scheduler
 global Gueue  Backgound Scheduler
 
 scheduler 지정하는 연산자
 .observe(on:) - 연산자를 실행한 스케쥴러를 지정, 호출 전에 있는 연산자에겐 영향을 주지 않는다.
 .subscribe(on:) - 구독을 시작하고 종료할 때 사용한 스케쥴러를 지정, 호출 시점에 영향받지 않는다.
 */

let bag = DisposeBag()

let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
// 백그라운드 스케쥴러

Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
  .subscribe(on: MainScheduler.instance) // 메인스케쥴러
  .filter { num -> Bool in
    print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
    return num.isMultiple(of: 2)
  }
  .observe(on: backgroundScheduler)
//.map과 .subscribe을 thread를(main -> background) 바꾸고 싶다면 .observe(on:) or .subscribe(on:) 메소드 이용.
//.observe(on:) 호출 전에 있는 연산자에겐 영향을 주지 않는다.
//.subscribe(on:) 호출 시점에 영향받지 않는다.
  .map { num -> Int in
    print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
    return num * 2
  }
  .observe(on: MainScheduler.instance)
//.observe(on:) 한번 더 호출하여 .subscribe는 Main Thread로 바뀌게 된다.

  .subscribe {
// 옵저버블이 생성되고 연산자가 호출되는 시점.
    print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> subscribe")
    print($0)
  }
  .disposed(by: bag)
