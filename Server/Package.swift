import PackageDescription

let package = Package(
    name: "Server",
    exclude: ["views", "dist", "public"],
    dependencies: [
        .Package(url: "https://github.com/crossroadlabs/Express.git", majorVersion: 0, minor: 3),
    ]
)
