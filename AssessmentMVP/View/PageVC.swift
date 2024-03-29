//
//  PageVC.swift
//  AssessmentMVP
//
//  Created by 10362 on 2024/2/17.
//

import UIKit

class PageVC: UIPageViewController, UIPageViewControllerDelegate {
    
    let lbTitleRed = UILabel()
    let lbTitleWhite = UILabel()
    let simulatorSegment = UIView()
    
    var currentOfPage: Int = 0
    let mainV = MainView(apiPage: "rangers")
    let secV: UIViewController = {
        var vc = MainView(apiPage: "elastic")
        vc.view.backgroundColor = .red
        return vc
    }()
    let thirdV : UIViewController = {
        var vc = MainView(apiPage: "dynamo")
        vc.view.backgroundColor = .yellow
        return vc
    }()
    
    lazy var arrayVC : [UIViewController] = {
        var viewControllers = [UIViewController]()
        viewControllers.append(mainV)
        viewControllers.append(secV)
        viewControllers.append(thirdV)
        return viewControllers
    }()
    
    lazy var arrayBtn : [UIButton] = [btn1, btn2, btn3]
    var btn1: UIButton {
        let btn = UIButton()
        btn.setTitle(" Raners ", for: .normal) //MainView
        return btn
    }
    var btn2: UIButton {
        let btn = UIButton()
        btn.setTitle(" E34lastic ", for: .normal) //SecondaryView
        return btn
    }
    var btn3: UIButton {
        let btn = UIButton()
        btn.setTitle(" ET ", for: .normal) //ThirdView
        return btn
    }
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setViewControllers([arrayVC[0]], direction: .forward, animated: false, completion: nil)
        self.setupBasic()
        self.setupButton()
        // Do any additional setup after loading the view.
    }
    func setupBasic(){
        view.addSubview(lbTitleRed)
        view.addSubview(lbTitleWhite)
        lbTitleRed.text = "Red"
        lbTitleWhite.text = "So"
        lbTitleRed.textColor = UIColor.red
        lbTitleWhite.textColor = UIColor.white
        lbTitleRed.font = UIFont.systemFont(ofSize: 32, weight: .regular)
        lbTitleWhite.font = UIFont.systemFont(ofSize: 32, weight: .regular)
        
        lbTitleRed.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.right.equalTo(view.snp.centerX)
        }
        lbTitleWhite.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(lbTitleRed.snp.right)
        }
    }
    func setupButton(){
        view.addSubview(simulatorSegment)
        simulatorSegment.backgroundColor = .black
        for i in arrayBtn{
            i.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            i.setTitleColor(.white, for: .normal )
            i.layer.borderWidth = 1.0
            i.setTitleColor(UIColor.white, for: .highlighted)
            i.addTarget(self, action: #selector(self.btnDidTap(_:)), for: .touchUpInside)
            simulatorSegment.addSubview(i)
        }
        var previousButton: UIButton?
        for button in arrayBtn {
            button.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.8)
                make.width.equalTo(button.intrinsicContentSize.width)
                if let previousButton = previousButton {
                    make.left.equalTo(previousButton.snp.right)
                } else {
                    make.left.equalToSuperview()
                }
            }
            previousButton = button
        }
        arrayBtn[currentOfPage].addUnderline()
        simulatorSegment.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
            make.top.equalTo(self.lbTitleRed.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc
    func btnDidTap(_ sender: UIButton) {
        var direction = NavigationDirection.forward
        animateUnderLine(sender)
        if let index = arrayBtn.firstIndex(of: sender){
            switch currentOfPage > index {
            case true:
                direction = NavigationDirection.reverse
            case false:
                direction = NavigationDirection.forward
            }
            //pagecontrol 跳轉頁面控制功能，直接跳頁數
            setViewControllers([arrayVC[index]], direction: direction, animated: true, completion: nil)
            currentOfPage = index
        }
    }
    func animateUnderLine(_ button: UIButton) {
        for btn in simulatorSegment.subviews {
            if let otherButton = btn as? UIButton,
               otherButton != button {
                otherButton.removeUnderline()
            }
        }
        button.addUnderline()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PageVC : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = arrayVC.firstIndex(of: viewController) else {
            return nil
        }
        self.currentOfPage = currentIndex
        let previousIndex = (currentIndex - 1 + arrayVC.count) % arrayVC.count
        self.animateUnderLine(arrayBtn[currentIndex])
        return arrayVC[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = arrayVC.firstIndex(of: viewController) else {
            return nil
        }
        self.currentOfPage = currentIndex
        let nextIndex = (currentIndex + 1) % arrayVC.count
        self.animateUnderLine(arrayBtn[currentIndex])
        return arrayVC[nextIndex]
    }
    
    
}
extension UIButton {
    // 添加底線
    func removeUnderline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.removeAttribute(
            NSAttributedString.Key.underlineStyle,
            range: NSRange(location: 0, length: text.count)
        )
        self.setAttributedTitle(attributedString, for: .normal)
    }
    func addUnderline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            NSAttributedString.Key.underlineStyle,
            value: NSUnderlineStyle.thick.rawValue,
            range: NSRange(location: 0, length: text.count)
        )
        attributedString.addAttribute(
            NSAttributedString.Key.underlineColor,
            value: UIColor.white,
            range: NSRange(location: 0, length: text.count)
        )
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
