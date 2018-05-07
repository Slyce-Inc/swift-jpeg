// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "libjpeg",
    providers: [
        .apt(["libjpeg-dev"])
    ],
    products: [ .library(name: "libjpeg", targets: ["libjpeg"]) ],
    dependencies: [
    ]
)
