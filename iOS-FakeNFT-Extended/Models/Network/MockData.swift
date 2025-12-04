import Foundation

extension OrderResponse {
    static var mockFilled: OrderResponse {
        OrderResponse(
            nfts: ["fa03574c-9067-45ad-9379-e3ed2d70df78", "b2f44171-7dcd-46d7-a6d3-e2109aacf520"],
            id: "9d3a58fd-9726-441c-a367-d85f80ad291c"
        )
    }

    static var mockEmpty: OrderResponse {
        OrderResponse(nfts: [], id: "9d3a58fd-9726-441c-a367-d85f80ad291c")
    }
}

extension NFTItem {
    static var mock1: NFTItem {
        NFTItem(
            createdAt: "2023-11-05T03:11:10.168Z[GMT]",
            name: "Grady Ferguson",
            images: [
                "https://code.s3.yandex.net/Mobile/iOS/NFT/White/Paddy/1.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/White/Paddy/2.png",
                "https://code.s3.yandex.net/Mobile/iOS/NFT/White/Paddy/3.png"
            ],
            rating: 2,
            description: "fusce sit in quis definitionem sem noster sollicitudin",
            price: 47.02,
            author: "https://hardcore_robinson.fakenfts.org/",
            id: "fa03574c-9067-45ad-9379-e3ed2d70df78"
        )
    }

    static var mock2: NFTItem {
        NFTItem(
            createdAt: "2023-08-04T17:04:46.661Z[GMT]",
            name: "Murray Albert",
            images: [
                "https://code.s3.yandex.net/Mobile/iOS/NFT/Yellow/Mowgli/1.png"
            ],
            rating: 2,
            description: "dolores doctus enim maximus doming",
            price: 47.39,
            author: "https://focused_solomon.fakenfts.org/",
            id: "b2f44171-7dcd-46d7-a6d3-e2109aacf520"
        )
    }

    static var mockCart: [NFTItem] = [mock1, mock2]
}

extension Currency {
    static let mockCurrencies: [Currency] = [
        Currency(id: "0", title: "Shiba Inu", name: "SHIB", image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Shiba_Inu_(SHIB).png"),
        Currency(id: "1", title: "Cardano", name: "ADA", image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Cardano_(ADA).png"),
        Currency(id: "2", title: "Tether", name: "USDT", image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Tether_(USDT).png"),
        Currency(id: "3", title: "ApeCoin", name: "APE", image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/ApeCoin_(APE).png"),
        Currency(id: "4", title: "Solana", name: "SOL", image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Solana_(SOL).png"),
        Currency(id: "5", title: "Bitcoin", name: "BTC", image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Bitcoin_(BTC).png"),
        Currency(id: "6", title: "Dogecoin", name: "DOGE", image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Dogecoin_(DOGE).png"),
        Currency(id: "7", title: "Ethereum", name: "ETH", image: "https://code.s3.yandex.net/Mobile/iOS/Currencies/Ethereum_(ETH).png")
    ]
}
