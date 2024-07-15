
import Foundation
import SwiftCLI

struct LicenseInfo: Codable {
  let packageName: String
  let licenseName: String
  let copyright: String
  let conditions: String
  let disclaimer: String
}

extension String {
  var red: String { return "\u{001B}[0;31m" + self + "\u{001B}[0m" }
  var green: String { return "\u{001B}[0;32m" + self + "\u{001B}[0m" }
  var yellow: String { return "\u{001B}[0;33m" + self + "\u{001B}[0m" }
}

class FetchLicensesCommand: Command {
  let name = "fetch-licenses"
  let shortDescription = "Fetch licenses for dependencies and write to a file"

  func execute() throws {

    let fileManager = FileManager.default
    let currentDirectoryPath = fileManager.currentDirectoryPath
    let outputFile = currentDirectoryPath + "/../../licenses.json"

    print("Reading Package.resolved and fetching licenses...".yellow)
    let packageResolvedPath = currentDirectoryPath + "/../Package.resolved"
    let packageResolvedURL = URL(fileURLWithPath: packageResolvedPath)

    do {
      let packageResolvedData = try Data(contentsOf: packageResolvedURL)
      guard let packageResolvedJSON = try JSONSerialization.jsonObject(with: packageResolvedData, options: []) as? [String: Any]
      else {
        throw CLI.Error(message: "Invalid Package.resolved format".red)
      }

      guard let pins = packageResolvedJSON["pins"] as? [[String: Any]] else {
        throw CLI.Error(message: "Could not parse 'pins' from JSON".red)
      }

      var licenses: [LicenseInfo] = []

      for pin in pins {
        guard let package = pin["identity"] as? String,
              let repositoryURL = pin["location"] as? String else {
          throw CLI.Error(message: "Invalid pin format: \(pin)".red)
          continue
        }

        if let licenseInfo = fetchLicenseInfo(for: repositoryURL, packageName: package) {
          licenses.append(licenseInfo)
          print("Fetched license for \(package)".green)
        } else {
          throw CLI.Error(message: "Could not fetch license for \(package) from \(repositoryURL)".red)
        }
      }

      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let jsonData = try encoder.encode(licenses)
      let outputURL = URL(fileURLWithPath: outputFile)
      try jsonData.write(to: outputURL, options: .atomicWrite)

      print("Licenses successfully written to \(outputFile)".green)

    } catch {
      throw CLI.Error(message: "Error reading Package.resolved: \(error)".red)
    }
  }

  private func fetchLicenseInfo(for repositoryURL: String, packageName: String) -> LicenseInfo? {
    let possibleLicensePaths = [
      "LICENSE",
      "LICENSE.txt",
      "LICENSE.md",
      "LICENSE.rst"
    ]

    for path in possibleLicensePaths {
      let licenseURL = repositoryURL.replacingOccurrences(of: ".git", with: "") + "/raw/master/" + path
      if let url = URL(string: licenseURL),
         let licenseText = try? String(contentsOf: url, encoding: .utf8) {
        return parseLicenseText(licenseText, packageName: packageName)
      }
    }

    return nil
  }

  private func parseLicenseText(_ text: String, packageName: String) -> LicenseInfo? {
    let lines = text.split(separator: "\n")
    var licenseName = ""
    var copyright = ""
    var conditions = ""
    var disclaimer = ""
    var currentSection = ""

    for line in lines {
      if line.contains("MIT License") {
        licenseName = "MIT License"
      } else if line.contains("Apache License") {
        licenseName = "Apache License 2.0"
      } else if line.contains("GNU GENERAL PUBLIC LICENSE") {
        licenseName = "GNU General Public License"
      }

      if line.contains("Copyright") {
        copyright += line + "\n"
      }

      if line.contains("conditions") || line.contains("Permission") {
        currentSection = "conditions"
      } else if line.contains("disclaimer") || line.contains("AS IS") {
        currentSection = "disclaimer"
      }

      switch currentSection {
      case "conditions":
        conditions += line + "\n"
      case "disclaimer":
        disclaimer += line + "\n"
      default:
        break
      }
    }

    return LicenseInfo(
      packageName: packageName,
      licenseName: licenseName,
      copyright: copyright,
      conditions: conditions,
      disclaimer: disclaimer
    )
  }
}

let cli = CLI(name: "LicenseFetcher", version: "1.0", description: "A tool to fetch licenses of dependencies")
cli.commands = [FetchLicensesCommand()]
cli.goAndExit()
