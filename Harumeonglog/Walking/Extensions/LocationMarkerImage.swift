//
//  LocationMarkerImage.swift
//  Harumeonglog
//
//  Created by 김민지 on 9/3/25.
//

import UIKit
import NMapsMap

/// 파란 점 + 바깥 그라데이션 원 이미지 생성
func makeLocationMarkerImage(size: CGFloat = 40) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
    return renderer.image { ctx in
        let center = CGPoint(x: size / 2, y: size / 2)
        
        // 바깥 원 (그라데이션)
        let outerRadius = size / 2
        let colors = [UIColor.blue00.withAlphaComponent(0.3).cgColor,
                      UIColor.clear.cgColor] as CFArray
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: [0, 1])!
        ctx.cgContext.drawRadialGradient(
            gradient,
            startCenter: center, startRadius: size * 0.1,
            endCenter: center, endRadius: outerRadius,
            options: .drawsAfterEndLocation
        )
        
        // 안쪽 원 (진한 파란 점)
        let innerRadius = size * 0.15
        ctx.cgContext.setFillColor(UIColor.blue01.cgColor)
        ctx.cgContext.addArc(center: center, radius: innerRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        ctx.cgContext.fillPath()
    }
}
