//
//  String+Encoding.swift
//  Default Apps
//
//  Created by Jan Dědeček on 01/10/15.
//  Copyright © 2015 Jan Dědeček. All rights reserved.
//

import Foundation

private let set = { () -> NSCharacterSet in
  let set = NSCharacterSet.URLQueryAllowedCharacterSet().mutableCopy() as! NSMutableCharacterSet
  set.removeCharactersInString("=+?&:/.")
  return set
  }()

extension String
{
  func stringByDecodingURLFormat() -> String?
  {
    return stringByRemovingPercentEncoding
  }

  func stringByEncodingURLFormat() -> String?
  {
    return stringByAddingPercentEncodingWithAllowedCharacters(set)
  }

  func dictionaryFromQueryComponents(decodeValues: Bool = true) -> [String: [String]]
  {
    var queryComponents = [String: [String]]()
    for keyValuePairString in componentsSeparatedByString("&") {
      let keyValuePairArray = keyValuePairString.componentsSeparatedByString("=")
      if keyValuePairArray.count < 2 {
        continue
      }

      if let key = keyValuePairArray[0].stringByDecodingURLFormat(),
        let value = (decodeValues ? keyValuePairArray[1].stringByDecodingURLFormat() : keyValuePairArray[1]) {

          var results = queryComponents[key] ?? [String]()
          results.append(value)
          queryComponents[key] = results
      }
    }
    return queryComponents;
  }

  static func queryStringFromDictionary(query: [String: [String]], encodeValues: Bool = false) -> String
  {
    return query.reduce("") { (query, e) -> String in

      if let key = e.0.stringByEncodingURLFormat() {
        let q = e.1.reduce("", combine: { (q, e) -> String in
          let value: String
          if encodeValues {
            guard let encoded = e.stringByEncodingURLFormat() else {
              return q
            }
            value = encoded
          } else {
            value = e
          }

          if q.isEmpty {
            return "\(key)=\(value)"
          } else {
            return q + "&\(key)=\(value)"
          }
        })

        if q.isEmpty {
          return query
        } else if query.isEmpty {
          return q
        } else {
          return query  + "&\(q)"
        }
      }
      
      return query
    }
  }
}
