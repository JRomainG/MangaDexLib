//
//  MDPath+Constants.swift
//  MangaDexLib
//
//  Created by Jean-Romain on 01/05/2020.
//  Copyright © 2020 JustKodding. All rights reserved.
//

import Foundation

extension MDPath {

    /// Relative paths to the pages on MangaDex
    enum Path: String {
        /// Relative path to the list of sorted mangas
        case listedMangas = "titles"

        /// Relative path to the list of featured mangas
        case featuredMangas = "featured"

        /// Relative path to the list of recently updated mangas
        case latestMangas = "updates"

        /// Relative path to the user's latest updated follows
        case latestFollowed = "follows"

        /// Relative path to the search page
        case searchMangas = "search"

        /// Relative path to the random manga page
        case randomManga = "manga"

        /// Relative path to the user's history page
        case history = "history"

        /// Relative path to a manga's detail page
        case mangaPage = "title"

        /// Relative path to a chapter's page
        ///
        /// - Note: This is only used to get a chapter's comments
        /// as the page images are retreived through the JSON api
        case chapterPage = "chapter"

        /// Relative path to a groups's detail page
        case groupPage = "group"

        /// Relative path to a threads's page
        case thread = "thread"

        /// Relative path to a users's MDList page
        case mdList = "list"

        /// Relative path used for ajax actions
        case ajax = "ajax/actions.ajax.php"

        /// Relative path used for api calls
        case api = "api"
    }

    /// Type of resource hosted on MangaDex
    public enum ResourceType: String {
        /// Resource used to get the latest updated followed mangas
        /// and when querying the json api for a manga's info
        case manga = "manga"

        /// Resource used when querying the json api for a chapter's info
        case chapter = "chapter"

        /// Resource used to get the latest updated followed chapters
        case chapters = "chapters"

        /// Resource used to a manga or chapter's comments
        case comments = "comments"

        /// Resource used to get the latest updated followed groups
        ///
        /// - Note: this is not currently supported
        case groups = "groups"
    }

    /// Type of parameter used in a search request
    ///
    /// These parameters are the ones encoded in the URL to build the path
    enum SearchParam: String {
        /// Parameter used to specify a manga's title
        case title = "title"

        /// Parameter used to specify a manga's author
        case author = "author"

        /// Parameter used to specify a manga's artist
        case artist = "artist"

        /// Parameter used to specify a manga's original language
        case originalLanguage = "lang_id"

        /// Parameter used to specify a manga's target demographics
        case demographics = "demos"

        /// Parameter used to specify a manga's publication status
        case publicationStatuses = "statuses"

        /// Parameter used to specify a manga's tags
        case tags = "tags"

        /// Parameter used to specify a manga's tags inclusion mode
        case includeTagsMode = "tag_mode_inc"

        /// Parameter used to specify a manga's tags exclusion mode
        case excludeTagsMode = "tag_mode_exc"
    }

    /// Type of parameter used for Ajax post requests
    ///
    /// These parameters are the ones encoded in the URL to build the path
    enum AjaxParam: String {
        /// The keyword used to specify which function is being called
        /// (see `AjaxFunctions`)
        case function = "function"

        /// The keyword appended if javascript is disabled
        case noJS = "nojs"
    }

    /// Type of existing Ajax functions
    ///
    /// These parameters are the ones encoded in the URL to build the path
    enum AjaxFunction: String {
        /// Function used to login
        case login = "login"

        /// Function used to logout
        case logout = "logout"
    }

    /// Type of parameter used during api calls
    ///
    /// These parameters are the ones encoded in the URL to build the path
    enum ApiParam: String {
        /// The id of the resource to fetch
        case id = "id"

        /// The id of the content-delivery server
        ///
        /// See `MDServer`
        case server = "server"

        /// The type of resource to fetch
        ///
        /// Can be either `ResourceType.manga` or `ResourceType.chapter`
        case type = "type"
    }

}
