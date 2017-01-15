//: Playground - noun: a place where people can play

import Cocoa
import Security
import PlaygroundSupport

let KeychainJiraAuth = "jira_auth"
let jiraAuth = KeychainSwift().get(KeychainJiraAuth)!

let storyPointsField = "customfield_10004"
let jira = JIRA(basicAuth: jiraAuth)

let ios = Group(components: [])
let perks = Group(components: ["Cinemas", "Colleague Offers", "Daily Deals", "Gift Cards", "In-Store Offers", "Restaurants", "Rewards", "Shop Online", "Wallet"])
let work = Group(components: ["Directory", "Leaderboard", "News Feed", "Recognition", "Settings", "Settings ", "Sign up/in", "User Profile", "Walkthrough"])
let life = Group(components: ["Account Types", "Care Services", "Chat", "Counsellor Search", "Health Library", "Hippo CMS", "Online Authorisation", "Shim", "Wellness"])

let sp24 = "Sp.24 iOS 30Nov-13Dec"
let sp25 = "Sp.25 iOS 14Dec-10Jan*17"
let sp26 = "Sp.26 iOS 11Jan-24Jan*17"

//let reportQuery = ReportQuery(sprint: sp25, group: ios, focus: .completed)

// Prepare

let sprint = sp24

struct GroupReport {
    let groupName: String
    let queries: [ReportQuery]
}

let groupReports = [
    GroupReport(groupName: "iOS", queries: [
        ReportQuery(sprint: sprint, group: ios, focus: .commitment),
        ReportQuery(sprint: sprint, group: ios, focus: .resolved),
        ReportQuery(sprint: sprint, group: ios, focus: .completed)
    ]),
    GroupReport(groupName: "Perks", queries: [
        ReportQuery(sprint: sprint, group: perks, focus: .commitment),
        ReportQuery(sprint: sprint, group: perks, focus: .resolved),
        ReportQuery(sprint: sprint, group: perks, focus: .completed)
    ]),
    GroupReport(groupName: "Work", queries: [
        ReportQuery(sprint: sprint, group: work, focus: .commitment),
        ReportQuery(sprint: sprint, group: work, focus: .resolved),
        ReportQuery(sprint: sprint, group: work, focus: .completed)
    ]),
    GroupReport(groupName: "Life", queries: [
        ReportQuery(sprint: sprint, group: life, focus: .commitment),
        ReportQuery(sprint: sprint, group: life, focus: .resolved),
        ReportQuery(sprint: sprint, group: life, focus: .completed)
    ]),
]

// Report
print(sprint)
for groupReport in groupReports {
    print(groupReport.groupName)
    
    for query in groupReport.queries {
        let jql = query.jql
        //            print(jql)
        
        // Calculate the sum of story points for the issues
        let json = try! jira.search(withJQL: jql)
        let issues = json["issues"] as! Array<JSON>
        let storyPoints = issues.flatMap({ $0["fields"]![storyPointsField] as? Int })
        let sum = storyPoints.reduce(0, +)
        
        print("\(query.focus): \(sum)")
    }

}







