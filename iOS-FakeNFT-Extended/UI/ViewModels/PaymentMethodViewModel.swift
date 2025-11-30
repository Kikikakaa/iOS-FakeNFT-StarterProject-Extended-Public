import Combine

@MainActor
final class PaymentMethodViewModel: ObservableObject {
    @Published var currencies: [Currency] = []
    @Published var selectedCurrency: Currency?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let client = DefaultNetworkClient()

    func loadCurrencies() async {
        isLoading = true
        errorMessage = nil

        do {
            let currencies: [Currency] = try await client.send(request: GetCurrenciesRequest())
            self.currencies = currencies
            self.selectedCurrency = currencies.first
        } catch {
            errorMessage = "Ошибка загрузки валют: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func pay() -> Currency? {
        return selectedCurrency
    }
}
