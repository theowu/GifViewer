//
//  MasterViewController.swift
//  GifViewer
//
//  Created by Theo WU on 17/05/2016.
//  Copyright © 2016 Theo WU. All rights reserved.
//

import Cocoa

class MasterViewController: NSViewController {

    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var pageNumber: NSTextField!
    @IBOutlet weak var resetPageButton: NSButton!
    @IBOutlet weak var previousPageButton: NSButton!
    @IBOutlet weak var nextPageButton: NSButton!
    
    var pages = [PageInfo]()
    var currentPageNumber = 1
    
    //Very good stuff for determing an image file type here !!!
    /*func imageType(imgData : NSData) -> String
    {
        var c = [UInt8](count: 1, repeatedValue: 0)
        imgData.getBytes(&c, length: 1)
        let extensionString : String
        switch (c[0]) {
        case 0xFF:
            extensionString = "jpg"
        case 0x89:
            extensionString = "png"
        case 0x47:
            extensionString = "gif"
        case 0x49, 0x4D :
            extensionString = "tiff"
        default:
            extensionString = "" //unknown
        }
        return extensionString
    }*/
    
    func setupPages() {
        var pageName: String
        for i in 1...11 {
            if i < 10 {
                pageName = "0\(i)"
            } else {
                pageName = "\(i)"
            }
            
            if let testImage = NSImage(named: pageName + ".gif") {
                pages.append(PageInfo(number: i, name: pageName, image: testImage))
            } else {
                pages.append(PageInfo(number: i, name: pageName, image: NSImage(named: pageName)))
            }
        }
    }
    
    
    /*if image != nil && returnCode == NSModalResponseOK {
    self.bugImageView.image = image
    if let selectedDoc = selectedBugDoc() {
    selectedDoc.fullImage = image
    selectedDoc.thumbImage = image.imageByScalingAndCroppingForSize(CGSize(width: 44, height: 44))
    reloadSelectedBugRow()
    }
    }*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let recentPageNumber = NSUserDefaults.standardUserDefaults().integerForKey("recentPageNumber")
        if recentPageNumber >= 1 && recentPageNumber <= self.pages.count {
            self.currentPageNumber = recentPageNumber
        }
        selectAndDisplayPage(self.currentPageNumber)
        updateDetail(pages[self.currentPageNumber - 1])
    }
    
    func selectedPageInfo() -> PageInfo? {
        let selectedRow = self.tableView.selectedRow;
        if selectedRow >= 0 && selectedRow < self.pages.count {
            currentPageNumber = selectedRow + 1
            return self.pages[selectedRow]
        }
        return nil
    }
    
    func updateDetail(page: PageInfo?) {
        var name = ""
        var image: NSImage?
        
        if let pageInfo = page {
            name = pageInfo.name
            image = pageInfo.image
        }
        
        self.imageView.image = image
        self.imageView.animates = true
        self.pageNumber.stringValue = name
    }
    
    func updateButtonState() {
        self.resetPageButton.enabled = self.tableView.selectedRow > 0
        self.previousPageButton.enabled = self.tableView.selectedRow > 0
        self.nextPageButton.enabled = self.tableView.selectedRow < self.pages.count - 1
    }
    
    func selectAndDisplayPage (targetPageNumber: Int) {
        self.tableView.selectRowIndexes(NSIndexSet(index: targetPageNumber - 1), byExtendingSelection: false)
        self.tableView.scrollRowToVisible(targetPageNumber - 1)
    }
    
    func saveCurrentPage() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(currentPageNumber, forKey: "recentPageNumber")
        defaults.synchronize()
    }
}

//MARK:-NSTableViewDataSource
extension MasterViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return pages.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        //1
        let cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
    
        //2
        if tableColumn!.identifier == "GifViewerColumn" {
            //3
            let pageInfo = self.pages[row]
            cellView.imageView!.image = pageInfo.image
            cellView.textField!.stringValue = pageInfo.name
            return cellView
        }
        return cellView
    }
}

//MARK:-NSTableViewDelegate
extension MasterViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(notification: NSNotification) {
        let selectedPage = selectedPageInfo()
        updateDetail(selectedPage)
        updateButtonState()
        saveCurrentPage()
    }
}

//MARK:-IBAction
extension MasterViewController {
    @IBAction func resetPage(sender: AnyObject) {
        self.currentPageNumber = 1
        selectAndDisplayPage(self.currentPageNumber)
    }
    @IBAction func previousPage(sender: AnyObject) {
        if self.currentPageNumber > 1 && self.currentPageNumber <= self.pages.count {
            self.currentPageNumber = self.currentPageNumber - 1
            selectAndDisplayPage(self.currentPageNumber)
        }
    }
    @IBAction func nextPage(sender: AnyObject) {
        if self.currentPageNumber >= 1 && self.currentPageNumber < self.pages.count {
            self.currentPageNumber = self.currentPageNumber + 1
            selectAndDisplayPage(self.currentPageNumber)
        }
    }
    @IBAction func targetPageNumberDidEndEdit(sender: AnyObject) {
        let targetPageNumber = self.pageNumber.integerValue
        if targetPageNumber >= 1 && targetPageNumber <= self.pages.count {
            selectAndDisplayPage(targetPageNumber)
        }
    }
    
}