// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "appsonair_flutter_appremark",
    platforms: [
        .iOS("14.0")
    ],
    products: [
        .library(name: "appsonair-flutter-appremark", targets: ["appsonair_flutter_appremark"])
    ],
    dependencies: [
        .package(url: "https://github.com/apps-on-air/AppsOnAir-iOS-AppRemark.git", exact: "1.2.1")
    ],
    targets: [
        .target(
            name: "appsonair_flutter_appremark",
            dependencies: [
                .product(name: "AppsOnAir-AppRemark", package: "AppsOnAir-iOS-AppRemark")
            ],
            path: ".",
            // Explicitly list only the Swift file.
            // SPM does not support mixed Swift + ObjC in one target.
            // The ObjC bridge files (AppRemarkFlutterSdkPlugin.h/.m) are
            // used by CocoaPods only and must be excluded from SPM.
            sources: [
                "Sources/appsonair_flutter_appremark/AppsonairFlutterAppRemarkPlugin.swift"
            ]
        )
    ]
)
