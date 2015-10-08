//
//  DefaultApps.swift
//  Opener
//
//  Created by Jan Dědeček on 08/10/15.
//  Copyright © 2015 Jan Dědeček. All rights reserved.
//

import UIKit

func defaulApps(application: UIApplication, openURL url: NSURL, scheme: String) -> Bool
{
  if url.scheme == scheme, let host = url.host where host == "x-callback-url",
    let query = url.query?.dictionaryFromQueryComponents(true),
    let urlString = query["url"]?.first,
    let url = NSURL(string: urlString) {
      dispatch_async(dispatch_get_main_queue()) { () -> Void in
        application.openURL(url)
      }
      return true
  }
  return false
}