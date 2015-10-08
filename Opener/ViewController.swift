//
//  ViewController.swift
//  Opener
//
//  Created by Jan Dědeček on 30/09/15.
//  Copyright © 2015 Jan Dědeček. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate
{
  @IBOutlet weak var recipientLabel: UITextField?
  @IBOutlet weak var subjectLabel: UITextField?
  @IBOutlet weak var bodyLabel: UITextView?
  @IBOutlet weak var linkField: UITextField?
  @IBOutlet weak var mapView: MKMapView?

  var pointAnnotation: MKPointAnnotation?

  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func onViewTouched(sender: AnyObject)
  {
    for view in [recipientLabel, subjectLabel, bodyLabel, linkField] as [UIResponder?] {
      if view?.isFirstResponder() ?? false {
        view?.resignFirstResponder()
      }
    }
  }

  @IBAction func onSendMailTouched(sender: UIButton)
  {
    if let recipient = recipientLabel?.text?.stringByEncodingURLFormat(),
      let subject = subjectLabel?.text?.stringByEncodingURLFormat(),
      let body = bodyLabel?.text?.stringByEncodingURLFormat(),
      let url = NSURL(string: "defaultapps://x-callback-url/mail?to=\(recipient)&subject=\(subject)&body=\(body)&callerScheme=\(scheme)") {
        UIApplication.sharedApplication().openURL(url)
    }
  }

  @IBAction func onOpenCurrentLocationTouched(sender: UIButton)
  {
    if let p = pointAnnotation,
      let url = NSURL(string: "defaultapps://x-callback-url/maps?ll=\(p.coordinate.latitude),\(p.coordinate.longitude)&callerScheme=\(scheme)") {
        UIApplication.sharedApplication().openURL(url)
    }
  }

  @IBAction func onOpenLinkTouched(sender: UIButton)
  {
    if let link = linkField?.text?.stringByEncodingURLFormat(),
      let url = NSURL(string: "defaultapps://x-callback-url/open?url=\(link)&callerScheme=\(scheme)") {
        UIApplication.sharedApplication().openURL(url)
    }
  }

  @IBAction func onTapRecognized(recognizer: UITapGestureRecognizer)
  {
    let point = recognizer.locationInView(mapView)
    if let tapPoint = mapView?.convertPoint(point, toCoordinateFromView:mapView?.superview) {
      if let p = pointAnnotation {
        mapView?.removeAnnotation(p)
      }

      let point1 = MKPointAnnotation()
      point1.coordinate = tapPoint
      mapView?.addAnnotation(point1)

      pointAnnotation = point1
    }
  }

  // MARK: - MKMapViewDelegate

  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
  {
    return MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
  }

  // MARK: - UITextFieldDelegate

  func textFieldShouldReturn(textField: UITextField) -> Bool
  {
    textField.resignFirstResponder()
    return false
  }
}

