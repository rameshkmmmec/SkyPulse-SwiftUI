//
//  AppModule.swift
//  SkyPulse-SwiftUI
//
//  Created by Ramesh on 05/11/26.
//

import Foundation

// MARK: - Root Response
struct DashboardResponse: Codable {
    let status: String
    let apiVersion: String
    let sidemenu: SideMenu
    let homePage: HomePage

    enum CodingKeys: String, CodingKey {
        case status
        case apiVersion = "api_version"
        case sidemenu
        case homePage = "home_page"
    }
}

// MARK: - SideMenu Models
struct SideMenu: Codable {
    let userProfile: UserProfile
    let menuSections: [MenuSection]
    let footer: MenuFooter

    enum CodingKeys: String, CodingKey {
        case userProfile = "user_profile"
        case menuSections = "menu_sections"
        case footer
    }
}

struct UserProfile: Codable, Identifiable {
    let id: String
    let name: String
    let subtitle: String
    let avatarURL: URL?
    let membershipBadge: String?
    let profileRoute: String

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name, subtitle
        case avatarURL = "avatar_url"
        case membershipBadge = "membership_badge"
        case profileRoute = "profile_route"
    }
}

struct MenuSection: Codable, Identifiable {
    let id: String
    let sectionTitle: String
    let items: [MenuItem]

    enum CodingKeys: String, CodingKey {
        case id = "section_id"
        case sectionTitle = "section_title"
        case items
    }
}

struct MenuItem: Codable, Identifiable {
    let id: String
    let title: String
    let icon: String
    let route: String
    let badgeCount: Int
    let badgeColor: String?
    let isEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case id, title, icon, route
        case badgeCount = "badge_count"
        case badgeColor = "badge_color"
        case isEnabled = "is_enabled"
    }
}

struct MenuFooter: Codable {
    let appVersion: String
    let termsURL: URL?

    enum CodingKeys: String, CodingKey {
        case appVersion = "app_version"
        case termsURL = "terms_url"
    }
}

// MARK: - HomePage Models
struct HomePage: Codable {
    let pageTitle: String
    let themeMode: String
    let refreshIntervalSeconds: Int
    let modules: [HomeModule]

    enum CodingKeys: String, CodingKey {
        case pageTitle = "page_title"
        case themeMode = "theme_mode"
        case refreshIntervalSeconds = "refresh_interval_seconds"
        case modules
    }
}

// MARK: - Dynamic Server-Driven Module Parsing
struct HomeModule: Codable, Identifiable {
    let id: String
    let title: String
    let order: Int
    let isVisible: Bool
    let content: ModuleContent
    
    enum CodingKeys: String, CodingKey {
        case id = "module_id"
        case type, title, order
        case isVisible = "is_visible"
        case layout, data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        order = try container.decode(Int.self, forKey: .order)
        isVisible = try container.decode(Bool.self, forKey: .isVisible)

        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "banner_carousel":
            let layout = try container.decode(CarouselLayout.self, forKey: .layout)
            let items = try container.decode([BannerItem].self, forKey: .data)
            content = .bannerCarousel(layout: layout, items: items)

        case "grid_actions":
            let layout = try container.decode(GridLayout.self, forKey: .layout)
            let items = try container.decode([QuickActionItem].self, forKey: .data)
            content = .gridActions(layout: layout, items: items)

        case "horizontal_cards":
            let layout = try container.decode(CardListLayout.self, forKey: .layout)
            let items = try container.decode([DestinationCardItem].self, forKey: .data)
            content = .horizontalCards(layout: layout, items: items)

        case "banner_card":
            let layout = try container.decode(BannerCardLayout.self, forKey: .layout)
            let item = try container.decode(ReferralPromoData.self, forKey: .data)
            content = .bannerCard(layout: layout, item: item)

        default:
            content = .unknown
        }
    }

    func encode(to encoder: Encoder) throws {
        // Encodable logic agar reverse serialization chahiye
    }
}

// MARK: - Module Content Enum
enum ModuleContent {
    case bannerCarousel(layout: CarouselLayout, items: [BannerItem])
    case gridActions(layout: GridLayout, items: [QuickActionItem])
    case horizontalCards(layout: CardListLayout, items: [DestinationCardItem])
    case bannerCard(layout: BannerCardLayout, item: ReferralPromoData)
    case unknown
}

// MARK: - Layout Configurations
struct CarouselLayout: Codable {
    let aspectRatio: String
    let autoScroll: Bool
    let scrollIntervalSec: Int
    let cornerRadius: CGFloat
    let paddingHorizontal: CGFloat

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case autoScroll = "auto_scroll"
        case scrollIntervalSec = "scroll_interval_sec"
        case cornerRadius = "corner_radius"
        case paddingHorizontal = "padding_horizontal"
    }
}

struct GridLayout: Codable {
    let columns: Int
    let itemSpacing: CGFloat
    let cardBackground: String

    enum CodingKeys: String, CodingKey {
        case columns
        case itemSpacing = "item_spacing"
        case cardBackground = "card_background"
    }
}

struct CardListLayout: Codable {
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    let cornerRadius: CGFloat

    enum CodingKeys: String, CodingKey {
        case cardWidth = "card_width"
        case cardHeight = "card_height"
        case cornerRadius = "corner_radius"
    }
}

struct BannerCardLayout: Codable {
    let backgroundColor: String
    let accentColor: String

    enum CodingKeys: String, CodingKey {
        case backgroundColor = "background_color"
        case accentColor = "accent_color"
    }
}

// MARK: - Module Data Payloads
struct BannerItem: Codable, Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let badgeText: String?
    let imageURL: URL?
    let deepLink: String

    enum CodingKeys: String, CodingKey {
        case id, title, subtitle
        case badgeText = "badge_text"
        case imageURL = "image_url"
        case deepLink = "deep_link"
    }
}

struct QuickActionItem: Codable, Identifiable {
    let id: String
    let title: String
    let iconSystemName: String
    let badgeText: String?
    let badgeBgColor: String?
    let deepLink: String

    enum CodingKeys: String, CodingKey {
        case id, title
        case iconSystemName = "icon_system_name"
        case badgeText = "badge_text"
        case badgeBgColor = "badge_bg_color"
        case deepLink = "deep_link"
    }
}

struct DestinationCardItem: Codable, Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let rating: Double
    let startingPrice: String
    let imageURL: URL?
    let deepLink: String

    enum CodingKeys: String, CodingKey {
        case id, title, subtitle, rating
        case startingPrice = "starting_price"
        case imageURL = "image_url"
        case deepLink = "deep_link"
    }
}

struct ReferralPromoData: Codable {
    let headline: String
    let description: String
    let illustrationURL: URL?
    let ctaButtonText: String
    let ctaDeepLink: String

    enum CodingKeys: String, CodingKey {
        case headline, description
        case illustrationURL = "illustration_url"
        case ctaButtonText = "cta_button_text"
        case ctaDeepLink = "cta_deep_link"
    }
}
