//
//  WalkthroughView.swift
//  ProjectArduino
//
//  Created by Abhishek Kumar Ravi on 04/11/18.
//  Copyright © 2018 Abhishek  Kumar Ravi. All rights reserved.
//

import UIKit

class WalkthroughView: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initializeView() {

        scrollView.delegate = self

        let source = getSlides()
        pageControl.numberOfPages = source.count

        self.setupSlideView(source)
        view.bringSubview(toFront: pageControl)
    }

    func getSlides() -> [Slide] {

        let firstIntroduction = Slide().getView(image: #imageLiteral(resourceName: "intro_first"), message: "First Intro")
        let secondIntroduction = Slide().getView(image: #imageLiteral(resourceName: "app_logo"), message: "Second Intro")
        let thridIntroduction = Slide().getView(image: #imageLiteral(resourceName: "img_red_dot"), message: "Third Intro")

        return [firstIntroduction, secondIntroduction, thridIntroduction]
    }

    func setupSlideView(_ slides: [Slide]) {

        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: 500)
        scrollView.isPagingEnabled = true

        for index in 0 ..< slides.count {

            slides[index].frame = CGRect(x: view.frame.width * CGFloat(index), y: 0, width: view.frame.width, height: view.frame.height)

             let state = index == (slides.count - 1) ? true : false

            slides[index].buttonDismiss.isHidden = !state

            scrollView.addSubview(slides[index])
        }

    }
}

extension WalkthroughView {

    static func instance() -> WalkthroughView {
        return UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "WalkthroughView") as! WalkthroughView
    }
}

extension WalkthroughView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex) ?? 0

    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

    }


}
