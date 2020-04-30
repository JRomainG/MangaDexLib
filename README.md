# MangaDexLib

`MangaDexLib` is a Swift framework to interact with the MangaDex website. Its goal is to offer a robust abstract interface to access the website's core features. It relies on [SwiftSoup](https://github.com/scinfu/SwiftSoup), a pure Swift library allowing to parse HTML content.

## Example usage

Here are a few example of how to use the API:

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

To login to the user's account:

```swift
let authInfo = MDAuth(username: "username", password: "password", type: .regular, remember: true)
api.login(with: auth) { (response) in
    print(api.isLoggedIn())
}
```

## Contributing

If you found a bug, or would like to see a new feature added, feel free to open an issue on the Github page. Merge Requests are welcome!

If you can, also consider [supporting MangaDex](https://mangadex.org/support) and the team behind the website.

## License

The project is available under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.en.html) license.

## Disclaimer

This project is not related to the [MangaDex website](https://mangadex.org/), and is independently developed.