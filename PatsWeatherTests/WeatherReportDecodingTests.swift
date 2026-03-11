import Testing
import Foundation
@testable import PatsWeather

//@Suite("WeatherReport Decoding")
//struct WeatherReportDecodingTests {
//    @Test("Decode valid WeatherReport JSON")
//    func decodeValidWeatherReport() throws {
//        let data = Data(MockData.sampleWeatherJSON.utf8)
//        let decoder = JSONDecoder()
//        let report = try decoder.decode(WeatherReport.self, from: data)
//        #expect(report.current.temperature == 20.5)
//        #expect(report.current.feelsLike == 19.0)
//        #expect(report.current.humidity == 54)
//        #expect(report.current.windSpeed == 3.5)
//        #expect(report.current.condition.description == "clear sky")
//        #expect(report.current.condition.icon == "01d")
//    }
//    
//    @Test("Fail to decode invalid WeatherReport JSON")
//    func decodeInvalidWeatherReport() throws {
//        let badJSON = "{\"current\": {\"temperature\": \"not-a-number\"}}"
//        let data = Data(badJSON.utf8)
//        let decoder = JSONDecoder()
//        do {
//            _ = try decoder.decode(WeatherReport.self, from: data)
//            // Should have thrown
//            #expect(false, "Should have failed decoding")
//        } catch {
//            // Success: decoding should fail
//            #expect(true)
//        }
//    }
//}
