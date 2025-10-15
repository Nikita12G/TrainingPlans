//
//  LoadingVCTests.swift.swift
//  TrainingPlansUnitTest
//
//  Created by Никита Гуляев on 15.10.2025.
//

import XCTest
import UIKit
@testable import TrainingPlans

import XCTest
import UIKit
@testable import TrainingPlans

final class LoadingVCTests: XCTestCase {
    var sut: LoadingVC!

    /// Если true — при следующем запуске теста обновится эталон.
    /// Обычно ставится `false`, чтобы просто сравнивать.
    private let recordMode = false

    override func setUp() {
        super.setUp()
        sut = LoadingVC()
        sut.overrideUserInterfaceStyle = .light
        sut.loadViewIfNeeded()
        sut.view.layoutIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_activityIndicator_isAnimating() {
        let activity = sut.view.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
        XCTAssertNotNil(activity)
        XCTAssertTrue(activity?.isAnimating ?? false)
    }

    func test_titleLabel_hasCorrectText() {
        let label = sut.view.subviews.compactMap { $0 as? UILabel }.first
        XCTAssertEqual(label?.text, "Загрузка данных...")
    }

    func test_activityIndicator_stopsOnDisappear() {
        let activity = sut.view.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
        sut.viewDidDisappear(false)
        XCTAssertFalse(activity?.isAnimating ?? true)
    }

    func test_snapshot_loadingVC_matchesReference() throws {
        let size = sut.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let image = renderViewToImage(view: sut.view, size: CGSize(width: max(320, size.width), height: max(200, size.height)))
        let data = image.pngData()!
        let refName = "LoadingVC_ref.png"

        let fileManager = FileManager.default
        let testBundle = Bundle(for: type(of: self))
        let referenceURL = testBundle.bundleURL.appendingPathComponent(refName)

        // Если нужно записать новый эталон — включи recordMode = true
        if recordMode || !fileManager.fileExists(atPath: referenceURL.path) {
            try data.write(to: referenceURL)
            XCTFail("📸 Эталон обновлён или создан по пути: \(referenceURL.path)")
            return
        }

        let refData = try Data(contentsOf: referenceURL)
        guard let refImage = UIImage(data: refData) else {
            XCTFail("Не удалось загрузить эталонное изображение")
            return
        }

        let diff = imagePixelDiff(image1: image, image2: refImage)
        XCTAssertLessThan(diff, 0.01, "Snapshot отличается более чем на 1% пикселей (\(diff * 100)%)")
    }

    // MARK: - Helpers

    private func renderViewToImage(view: UIView, size: CGSize) -> UIImage {
        view.bounds = CGRect(origin: .zero, size: size)
        view.layoutIfNeeded()
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.scale = 2.0
        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
        return renderer.image { ctx in
            view.layer.render(in: ctx.cgContext)
        }
    }

    private func imagePixelDiff(image1: UIImage, image2: UIImage) -> Double {
        guard let cg1 = image1.cgImage, let cg2 = image2.cgImage,
              cg1.width == cg2.width, cg1.height == cg2.height else { return 1.0 }

        let width = cg1.width, height = cg1.height
        let bytesPerRow = width * 4
        var buf1 = [UInt8](repeating: 0, count: Int(bytesPerRow * height))
        var buf2 = [UInt8](repeating: 0, count: Int(bytesPerRow * height))

        guard let ctx1 = CGContext(data: &buf1, width: width, height: height, bitsPerComponent: 8,
                                   bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(),
                                   bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue),
              let ctx2 = CGContext(data: &buf2, width: width, height: height, bitsPerComponent: 8,
                                   bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceRGB(),
                                   bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else { return 1.0 }

        ctx1.draw(cg1, in: CGRect(x: 0, y: 0, width: width, height: height))
        ctx2.draw(cg2, in: CGRect(x: 0, y: 0, width: width, height: height))

        var diffCount = 0
        for i in 0..<buf1.count where buf1[i] != buf2[i] {
            diffCount += 1
        }
        return Double(diffCount) / Double(buf1.count)
    }
}

