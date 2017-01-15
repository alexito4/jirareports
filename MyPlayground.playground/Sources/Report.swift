import Foundation

public struct Group {
    public let components: Array<String>
    
    public var jqlComponents: String {
        return components.map({ "\"" + $0 + "\"" }).joined(separator: ",")
    }
    
    public init(components: Array<String>) {
        self.components = components
    }
}

public struct ReportQuery {
    
    // Represents what you want to get from the report
    // Translates to specific columns in my spreadsheet
    public enum Focus {
        // All the issues, what the team commited to
        case commitment
        // Issues done by development
        case resolved
        // Issues done, tested and approved
        case completed
        
        public var jqlStatuses: String {
            let status: [Status]
            switch self {
            case .commitment:
                status = []
            case .resolved:
                status = [.resolved, .readyForTesting, .inTest, .tested, .closed]
            case .completed:
                status = [.tested, .closed]
            }
            return status.map({ "\"" + $0.rawValue + "\"" }).joined(separator: ",")
        }
    }
    
    public let sprint: String
    public let group: Group
    public let focus: Focus
    
    public init(sprint: String, group: Group, focus: Focus) {
        self.sprint = sprint
        self.group = group
        self.focus = focus
    }
    
    public var jql: String {
        
        let status: String
        if focus.jqlStatuses.isEmpty {
            status = ""
        } else {
            status = "AND status in (\(focus.jqlStatuses))"
        }
        
        let components: String
        if group.jqlComponents.isEmpty {
            components = ""
        } else {
            components = "AND component in (\(group.jqlComponents)) "
        }
        
        return "project = WAIOS \(status) AND issuetype in standardIssueTypes() \(components) AND Sprint = \"\(sprint)\" ORDER BY Rank ASC"
    }
}


