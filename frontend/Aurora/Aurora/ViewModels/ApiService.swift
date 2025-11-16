import Foundation
import Amplify
import AWSPluginsCore

actor ApiService {
    static let shared = ApiService()
    
    private let endpoint =
        "https://toibg0mn5m.execute-api.ca-central-1.amazonaws.com/dev/asr"

    private func fetchIdToken() async throws -> String {
        let session = try await Amplify.Auth.fetchAuthSession()

        guard let tokenProvider = session as? AuthCognitoTokensProvider else {
            throw NSError(
                domain: "Auth",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Session does not provide Cognito user pool tokens"]
            )
        }

        // FETCH JWT TOKENS (ID + ACCESS + REFRESH)
        let tokens = try tokenProvider.getCognitoTokens().get()

        return tokens.idToken
    }

    func sendTranscript(_ text: String) async throws -> String {
        let token = try await fetchIdToken()
        guard let url = URL(string: endpoint) else { return "Invalid URL" }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try JSONSerialization.data(withJSONObject: ["text": text])

        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse {
            print("API Status:", http.statusCode)
        }

        return String(data: data, encoding: .utf8) ?? "No response"
    }
}
