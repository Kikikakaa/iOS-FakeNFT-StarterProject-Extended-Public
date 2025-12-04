import SwiftUI

extension Font {
    // Ниже приведены примеры шрифтов, настоящие шрифты надо взять из фигмы

    // Headline Fonts
    static var headline1 = Font.system(size: 34, weight: .bold)
    static var headline2 = Font.system(size: 28, weight: .bold)
    static var headline3 = Font.system(size: 22, weight: .bold)
    static var headline4 = Font.system(size: 20, weight: .bold)

    // Body Fonts
    static var bodyRegular = Font.system(size: 17, weight: .regular)
    static var bodyBold = Font.system(size: 17, weight: .bold)

    // Caption Fonts
    static var caption1 = Font.system(size: 15, weight: .regular)
    static var caption2 = Font.system(size: 13, weight: .regular)
}
