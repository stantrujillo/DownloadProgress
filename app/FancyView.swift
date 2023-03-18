//
//  View.swift
//  DownloadProgress
//
//  Created by Stan Trujillo on 13/08/2023.
//

import UIKit

protocol FancyViewProtocol {
    func configureView()
    func configureSubviews()
    func configureConstraints()
}

class FancyView: UIView, FancyViewProtocol {
    required init() {
        super.init(frame: .zero)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        configureView()
        configureSubviews()
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureView() { }
    func configureSubviews() { }
    func configureConstraints() { }
}

class ViewControllerWithFancyView<ContentView: FancyView>: UIViewController {
    var contentView: ContentView {
        return view as! ContentView
    }

    override func loadView() {
        view = ContentView()
    }
}


