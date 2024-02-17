//
//  PageVC.swift
//  AssessmentMVP
//
//  Created by 10362 on 2024/2/17.
//

import UIKit

class PageVC: UIPageViewController, UIPageViewControllerDelegate {
    
    var currentOfPage: Int = 0
    let mainV = MainView()
    let secV: UIViewController = {
        var vc = UIViewController()
        vc.view.backgroundColor = .red
        return vc
    }()
    let thirdV : UIViewController = {
        var vc = UIViewController()
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
        btn.setTitle(" wero ", for: .normal) //MainView
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
        view.backgroundColor = .brown
        // Do any additional setup after loading the view.
    }
    func setupBasic(){
        //..
    }
    func setupButton(){
        //..
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
        return arrayVC[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = arrayVC.firstIndex(of: viewController) else {
            return nil
        }
        self.currentOfPage = currentIndex
        let nextIndex = (currentIndex + 1) % arrayVC.count
        return arrayVC[nextIndex]
    }
    
    
}
