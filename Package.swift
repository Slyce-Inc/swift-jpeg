// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "JPEG",
  products: [ 
    .library(name: "Clibjpeg", targets: ["Clibjpeg"]),
    .library(name: "JPEG", targets: ["JPEG"]) 
  ],
  targets: [
    .target(
      name: "JPEG",
      dependencies: [ "Clibjpeg" ]),
    .systemLibrary(
      name: "Clibjpeg", 
      pkgConfig: "libjpeg", 
      providers: [
        .apt([ "libjpeg-turbo8-dev" ]),
      ]), 
  ]
)
