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

class ControlPropertyControlEventRxCocoaViewController: UIViewController {
  
  let bag = DisposeBag()
  
  @IBOutlet weak var colorView: UIView!
  
  @IBOutlet weak var redSlider: UISlider!
  @IBOutlet weak var greenSlider: UISlider!
  @IBOutlet weak var blueSlider: UISlider!
  
  @IBOutlet weak var redComponentLabel: UILabel!
  @IBOutlet weak var greenComponentLabel: UILabel!
  @IBOutlet weak var blueComponentLabel: UILabel!
  
  @IBOutlet weak var resetButton: UIButton!
  
  private func updateComponentLabel() {
    redComponentLabel.text = "\(Int(redSlider.value))"
    greenComponentLabel.text = "\(Int(greenSlider.value))"
    blueComponentLabel.text = "\(Int(blueSlider.value))"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    redSlider.rx.value
      .map { "\(Int($0))" }
      .bind(to: redComponentLabel.rx.text)
      .disposed(by: bag)
    
    greenSlider.rx.value
      .map { "\(Int($0))" }
      .bind(to: greenComponentLabel.rx.text)
      .disposed(by: bag)
    
    blueSlider.rx.value
      .map { "\(Int($0))" }
      .bind(to: blueComponentLabel.rx.text)
      .disposed(by: bag)
    
    //.bind는 main thread에서 사용된다.
    
    Observable.combineLatest(redSlider.rx.value, greenSlider.rx.value, blueSlider.rx.value)
      .map { (red, green, blue) -> UIColor in
        UIColor(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1.0)
      }
      .bind(to: colorView.rx.backgroundColor)
      .disposed(by: bag)
    
    //reset
    resetButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.colorView.backgroundColor = UIColor.black
        
        self?.redSlider.value = 0
        self?.greenSlider.value = 0
        self?.blueSlider.value = 0
        
        self?.updateComponentLabel()
        
        // thread를(main -> background) 바꾸고 싶다면 .observe(on:) or .subscribe(on:) 메소드 이용.
      })
      .disposed(by: bag)
  }
}
