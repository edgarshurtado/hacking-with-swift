import UIKit

let defaults = UserDefaults.standard
defaults.set(25, forKey: "Age")
defaults.set(true, forKey: "UseTouchID")
defaults.set(CGFloat.pi, forKey: "Pi")
defaults.set(["Hello", "World"], forKey: "SavedArray")
defaults.set(["Name": "Paul", "Country": "UK"], forKey: "SavedDict")

let int = defaults.integer(forKey: "Age")
let bool = defaults.bool(forKey: "UseTouchID")
let float = defaults.float(forKey: "Pi")
let array: [String] = defaults.object(forKey: "SavedArray") as? [String] ?? [String]()
let dict: [String: String] = defaults.object(forKey: "SavedDict") as? [String:String] ?? [String:String]()

