//
//  ParsingJsonResponse.swift
//  RestfulApiWithPods
//
//  Created by Mina Gamil  on 12/26/19.
//  Copyright © 2019 Mina Gamil. All rights reserved.
//

import Foundation
// MARK: - WelcomeElement
struct WelcomeElement: Codable {
    var id: Int!
    var nodeID, name, fullName: String!
    var welcomePrivate: Bool!
    var owner: Owner!
    var htmlURL: String!
    var welcomeDescription: String?
    var fork: Bool!
    var url, forksURL: String!
    var keysURL, collaboratorsURL: String!
    var teamsURL, hooksURL: String!
    var issueEventsURL: String!
    var eventsURL: String!
    var assigneesURL, branchesURL: String!
    var tagsURL: String!
    var blobsURL, gitTagsURL, gitRefsURL, treesURL: String!
    var statusesURL: String!
    var languagesURL, stargazersURL, contributorsURL, subscribersURL: String!
    var subscriptionURL: String!
    var commitsURL, gitCommitsURL, commentsURL, issueCommentURL: String!
    var contentsURL, compareURL: String!
    var mergesURL: String!
    var archiveURL: String!
    var downloadsURL: String!
    var issuesURL, pullsURL, milestonesURL, notificationsURL: String!
    var labelsURL, releasesURL: String!
    var deploymentsURL: String!
    var createdAt, updatedAt, pushedAt: Date!
    var gitURL, sshURL: String!
    var cloneURL: String!
    var svnURL: String!
    var homepage: String?
    var size, stargazersCount, watchersCount: Int!
    var language: String?
    var hasIssues, hasProjects, hasDownloads, hasWiki: Bool!
    var hasPages: Bool!
    var forksCount: Int!
    var mirrorURL: JSONNull?
    var archived, disabled: Bool!
    var openIssuesCount: Int!
    var license: License?
    var forks, openIssues, watchers: Int!
    var defaultBranch: DefaultBranch!

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case welcomePrivate = "private"
        case owner
        case htmlURL = "html_url"
        case welcomeDescription = "description"
        case fork, url
        case forksURL = "forks_url"
        case keysURL = "keys_url"
        case collaboratorsURL = "collaborators_url"
        case teamsURL = "teams_url"
        case hooksURL = "hooks_url"
        case issueEventsURL = "issue_events_url"
        case eventsURL = "events_url"
        case assigneesURL = "assignees_url"
        case branchesURL = "branches_url"
        case tagsURL = "tags_url"
        case blobsURL = "blobs_url"
        case gitTagsURL = "git_tags_url"
        case gitRefsURL = "git_refs_url"
        case treesURL = "trees_url"
        case statusesURL = "statuses_url"
        case languagesURL = "languages_url"
        case stargazersURL = "stargazers_url"
        case contributorsURL = "contributors_url"
        case subscribersURL = "subscribers_url"
        case subscriptionURL = "subscription_url"
        case commitsURL = "commits_url"
        case gitCommitsURL = "git_commits_url"
        case commentsURL = "comments_url"
        case issueCommentURL = "issue_comment_url"
        case contentsURL = "contents_url"
        case compareURL = "compare_url"
        case mergesURL = "merges_url"
        case archiveURL = "archive_url"
        case downloadsURL = "downloads_url"
        case issuesURL = "issues_url"
        case pullsURL = "pulls_url"
        case milestonesURL = "milestones_url"
        case notificationsURL = "notifications_url"
        case labelsURL = "labels_url"
        case releasesURL = "releases_url"
        case deploymentsURL = "deployments_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
        case gitURL = "git_url"
        case sshURL = "ssh_url"
        case cloneURL = "clone_url"
        case svnURL = "svn_url"
        case homepage, size
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language
        case hasIssues = "has_issues"
        case hasProjects = "has_projects"
        case hasDownloads = "has_downloads"
        case hasWiki = "has_wiki"
        case hasPages = "has_pages"
        case forksCount = "forks_count"
        case mirrorURL = "mirror_url"
        case archived, disabled
        case openIssuesCount = "open_issues_count"
        case license, forks
        case openIssues = "open_issues"
        case watchers
        case defaultBranch = "default_branch"
    }
}

enum DefaultBranch: String, Codable {
    case master = "master"
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseLicense { response in
//     if let license = response.result.value {
//       ...
//     }
//   }

// MARK: - License
struct License: Codable {
    let key: Key
    let name: Name
    let spdxID: SpdxID
    let url: String?
    let nodeID: LicenseNodeID

    enum CodingKeys: String, CodingKey {
        case key, name
        case spdxID = "spdx_id"
        case url
        case nodeID = "node_id"
    }
}

enum Key: String, Codable {
    case apache20 = "apache-2.0"
    case mit = "mit"
    case other = "other"
}

enum Name: String, Codable {
    case apacheLicense20 = "Apache License 2.0"
    case mitLicense = "MIT License"
    case other = "Other"
}

enum LicenseNodeID: String, Codable {
    case mDc6TGljZW5ZZTA = "MDc6TGljZW5zZTA="
    case mDc6TGljZW5ZZTEz = "MDc6TGljZW5zZTEz"
    case mDc6TGljZW5ZZTI = "MDc6TGljZW5zZTI="
}

enum SpdxID: String, Codable {
    case apache20 = "Apache-2.0"
    case mit = "MIT"
    case noassertion = "NOASSERTION"
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseOwner { response in
//     if let owner = response.result.value {
//       ...
//     }
//   }

// MARK: - Owner
struct Owner: Codable {
    var login: Login!
    var id: Int!
    var nodeID: OwnerNodeID!
    var avatarURL: String!
    var gravatarID: String!
    var url, htmlURL, followersURL: String!
    var followingURL: FollowingURL!
    var gistsURL: GistsURL!
    var starredURL: StarredURL!
    var subscriptionsURL, organizationsURL, reposURL: String!
    var eventsURL: EventsURL!
    var receivedEventsURL: String!
    var type: TypeEnum!
    var siteAdmin: Bool!

    

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
    }
}

enum EventsURL: String, Codable {
    case httpsAPIGithubCOMUsersSquareEventsPrivacy = "https://api.github.com/users/square/events{/privacy}"
}

enum FollowingURL: String, Codable {
    case httpsAPIGithubCOMUsersSquareFollowingOtherUser = "https://api.github.com/users/square/following{/other_user}"
}

enum GistsURL: String, Codable {
    case httpsAPIGithubCOMUsersSquareGistsGistID = "https://api.github.com/users/square/gists{/gist_id}"
}

enum Login: String, Codable {
    case square = "square"
}

enum OwnerNodeID: String, Codable {
    case mdEyOk9YZ2FuaXphdGlvbjgyNTky = "MDEyOk9yZ2FuaXphdGlvbjgyNTky"
}

enum StarredURL: String, Codable {
    case httpsAPIGithubCOMUsersSquareStarredOwnerRepo = "https://api.github.com/users/square/starred{/owner}{/repo}"
}

enum TypeEnum: String, Codable {
    case organization = "Organization"
}

typealias Welcome = [WelcomeElement]

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}



// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

