// The MIT License (MIT)
//
// Copyright (c) 2016 Luke Zhao <me@lkzhao.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import Hero

class ListTableViewCell:UITableViewCell{
  override func layoutSubviews() {
    super.layoutSubviews()
    imageView?.frame.origin.x = 0
    textLabel?.frame.origin.x -= 15
    detailTextLabel?.frame.origin.x -= 15
  }
}


class ListTableViewController: UITableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 50
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)

    cell.heroModifiers = "fade translate(-100, 0)"
    cell.imageView?.heroID = "image_\(indexPath.item)"
    cell.imageView?.heroModifiers = "arc zPosition(10)"
    cell.imageView?.image = UIImage(named: "Unsplash\(indexPath.item % 10)")
    cell.textLabel?.text = "Item \(indexPath.item)"
    cell.detailTextLabel?.text = "Description \(indexPath.item)"
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 52
  }
  
  @IBAction func toGrid(_ sender: Any) {
    let next = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "grid") as! GridCollectionViewController
    next.collectionView?.contentOffset.y = tableView.contentOffset.y + tableView.contentInset.top
    heroReplaceViewController(with: next)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let currentCell = sender as? ListTableViewCell,
      let vc = segue.destination as? ImageViewController,
      let currentCellIndex = tableView.indexPath(for: currentCell){
      vc.selectedIndex = currentCellIndex
      vc.view.backgroundColor = UIColor.white
      vc.collectionView!.backgroundColor = UIColor.white
    }
  }
}

extension ListTableViewController:HeroViewControllerDelegate{
  func heroWillStartAnimatingTo(viewController: UIViewController) {
    if let _ = viewController as? GridCollectionViewController{
      tableView.heroModifiers = "clearSubviewModifiers"
    } else {
      tableView.heroModifiers = "cascade(0.02)"
    }
  }
  func heroWillStartAnimatingFrom(viewController: UIViewController) {
    if let _ = viewController as? GridCollectionViewController{
      tableView.heroModifiers = "clearSubviewModifiers"
    } else {
      tableView.heroModifiers = "cascade(0.02)"
    }
    if let vc = viewController as? ImageViewController,
      let originalCellIndex = vc.selectedIndex,
      let currentCellIndex = vc.collectionView?.indexPathsForVisibleItems[0] {
      if tableView.indexPathsForVisibleRows?.contains(currentCellIndex) != true{
        // make the cell visible
        tableView.scrollToRow(at: currentCellIndex,
                              at: originalCellIndex < currentCellIndex ? .bottom : .top,
                              animated: false)
      }
    }
  }
}
