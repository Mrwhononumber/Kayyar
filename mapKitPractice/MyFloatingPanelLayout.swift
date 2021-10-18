//
//  MyFloatingPanelLayout.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/17/21.
//

import Foundation
import FloatingPanel


class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide:  .safeArea),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 160.0, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
