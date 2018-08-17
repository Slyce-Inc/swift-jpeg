// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Clibjpeg",
    providers: [
        .apt(["libjpeg-dev"])
    ],
    products: [ .library(name: "Clibjpeg", targets: ["Clibjpeg"]) ],
    dependencies: [
    ]
)
