//
//  OnboardingScreen.swift
//  PerfectWeather
//
//  Created by Artem Sviridov on 22.04.2023.
//

import UIKit
import CoreLocation

final class OnboardingScreen: UIViewController {
    private lazy var contentView: OnboardingViewProtocol = OnboardingView(delegate: self)

    private let locationManager = CLLocationManager()

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - OnboardingViewDelegate

extension OnboardingScreen: OnboardingViewDelegate {
    func didTapButton(_ hasAccess: Bool) {
        if hasAccess {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}
