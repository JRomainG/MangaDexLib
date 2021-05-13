# MangaDexLib

`MangaDexLib` is a cross-platform Swift framework to interact with the [MangaDex](https://mangadex.org) website. Its goal is to offer a robust abstract interface to access the API's core features.

## Installing

MangaDexLib requires Swift 5 or newer.

### CocoaPods

SwiftSoup is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'MangaDexLib'
```

### Carthage

MangaDexLib is available [Carthage](https://github.com/Carthage/Carthage). To install it, simply add the following line to your Cartfile:

```ruby
github "JRomainG/MangaDexLib"
```

### Swift Package Manager

SwiftSoup is available through [Swift Package Manager](https://github.com/apple/swift-package-manager). To install it, simply add the dependency to your Package.Swift file:

```swift
...
dependencies: [
    .package(url: "https://github.com/JRomainG/MangaDexLib.git", .branch("master")),
],
targets: [
    .target(name: "YourTarget", dependencies: ["MangaDexLib"]),
]
...
```

### Sources

If you do not wish to use a package manager, you can also simply copy the `Sources` directory to your project.

## Example usage

Here are a few examples of how to use the API:

To get the website's featured manga list:

```swift
import MangaDexLib
let api = MDApi()
api.getFeaturedMangas { (response) in
    print(response.mangas)
}
```

To get the list of a manga's chapters:

```swift
let mangaId = 7139
let mangaTitle = "One Punch Man"
api.getMangaChapters(mangaId: mangaId, title: mangaTitle, page: 1) { (response) in
    print(response.chapters)
}
```

To get the links to a chapter's page images:

```swift
let chapterId = 867036
api.getChapterInfo(chapterId: chapterId) { (response) in
    print(response.chapter?.getPageUrls())
}
```

To login to a user's account:

```swift
let authInfo = MDAuth(username: "username", password: "password", type: .regular, remember: true)
api.login(with: auth) { (response) in
    print(api.isLoggedIn())
}
```

You should also check out [Kitsune](https://github.com/JRomainG/Kitsune-macOS), an open-source reader for macOS built using MangaDexLib!

## Documentation

The project is extensively documented through comments, and [Jazzy](https://github.com/realm/jazzy) is used to generate documentation. It is available from [this url](https://jean-romain.com/MangaDexLib), and updated each time a new version is released.

You can also access the official documentation for the MangaDex API [here](https://api.mangadex.org/docs.html).

## Development

To install, simply checkout the `dev` branch of this repository:

```bash
git clone https://github.com/JRomainG/MangaDexLib.git
git checkout dev
```

You will then be able to open the `MangaDexLib.xcodeproj` project.

This project uses [SwiftLint](https://github.com/realm/SwiftLint) to enforce Swift style and conventions. It also implements unit tests using [XCTest](https://developer.apple.com/documentation/xctest), which try to cover as many features as possible.

## Contributing

If you found a bug, or would like to see a new feature added, feel free to open an issue on the Github page. Pull requests are welcome!

If you can, also consider [supporting MangaDex](https://mangadex.org/support) and the team behind the website.

## License

The project is available under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html) license.

## Disclaimer

This project is not related to the [MangaDex](https://mangadex.org) team, and is independently developed.
