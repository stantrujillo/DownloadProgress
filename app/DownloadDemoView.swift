//
//  DownloadDemoView.swift
//  DownloadProgress
//
//  Created by Stan Trujillo on 13/08/2023.
//

import UIKit

protocol CAShapeLayerContainer {
    func initShaperLayer()
}

class ShapeLayerContainer: UIView, CAShapeLayerContainer {
    
    var progressLayer: CAShapeLayer!
    
    func initShaperLayer() {
        let w = frame.size.width
        let h = frame.size.height
        let rect = CGRect(x: 10, y: 10, width: w - 20, height: h - 20)
        
        progressLayer = CAShapeLayer()
        let corners = CGSize(width: 4.0, height: 4.0)
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: corners)
        progressLayer.path = path.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 1.0
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
        progressLayer.strokeColor = UIColor.systemBlue.cgColor
        
        layer.addSublayer(progressLayer)
    }
}

class DownloadDemoView : FancyView, DownloadProgressDelegate {

    private let networkService: NetworkService = NetworkService()
    
    lazy var headerViewLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.textAlignment = .center
        view.textColor = .brown
        view.text = "Download Progress Demo"
        
        return view
    }()
    
    lazy var progressView: ShapeLayerContainer = {
        let view = ShapeLayerContainer()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    lazy var progressLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.textAlignment = .center
        view.textColor = .systemBlue
        
        return view
    }()
    
    lazy var downLoadButton: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.setTitle("Start download", for: .normal)
        view.setTitle("downloading...", for: .disabled)
        view.addTarget(self, action: #selector(performDownload), for: .touchUpInside)
        
        return view
    }()
    
    lazy var controlStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        
        view.addArrangedSubview(headerViewLabel)
        view.addArrangedSubview(downLoadButton)
        view.addArrangedSubview(progressView)
        
        return view
    }()
    
    @objc func performDownload(sender: UIButton) {
        
        // This has to be done late, after layout has been done, so we wait until the button is tapped.
        progressView.initShaperLayer()
        
        downLoadButton.isEnabled = false
        progressView.alpha = 1.0

        Task {
            // let url = URL(string: "https://bit.ly/Colttaine")! // 5gb
            // let url = URL(string: "https://bit.ly/1GB-testfile")! // 1gb
            let url = URL(string: "https://sabnzbd.org/tests/internetspeed/50MB.bin")! // 50mb
            let _ = try await networkService.actor.downloadFile(url: url, delegate: self)
            print("got data")
  
            // Inside a Task block, we're no longer on the main thread,
            // so we have to switch back to main to update the UI.
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.downLoadButton.isEnabled = true
            }
        }
    }
    
    override func configureView() {
        backgroundColor = .white
        progressView.alpha = 0.0
    }
    
    override func configureSubviews() {
        addSubview(controlStack)
        progressView.addSubview(progressLabel)
    }
    
    override func configureConstraints() {
        
        controlStack.constrainHorizontalsToSuperview()
        controlStack.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 100.0).isActive = true
        controlStack.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        progressLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor).isActive = true
        progressLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor).isActive = true
    }
    
    func progress(percent: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.progressView.progressLayer.strokeEnd = percent
            strongSelf.progressLabel.text = "\(Int(percent * 100.0))%"
        }
    }
}
