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
import RxCocoa


class HelloRxCocoaViewController: UIViewController {
  
  let bag = DisposeBag()
  
  @IBOutlet weak var valueLabel: UILabel!
  
  @IBOutlet weak var tapButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //tap 할때마다 next 이벤트 방출
    tapButton.rx.tap
      .map { "Hello, RxCocoa" }
    //        .subscribe(onNext: { [weak self] str in
    //          self?.valueLabel.text = str
    //        })
      .bind(to: valueLabel.rx.text)
    //위와 결과는 같음. rx가 들어가면 binder, 일반 타입과는 속성이 다르다.
      .disposed(by: bag)
    
  }
}
