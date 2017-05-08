[![GitHub platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)]() 
[![GitHub language](https://img.shields.io/badge/language-objective--c-6BAEE4.svg)]()
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/tezpark/AlternateIconName-objC/master/LICENSE)

# TezActionSheet
Custom singleton actionSheet with block completion.

* Simple custom actionSheet.
* Using completion block and singleton.

![ios simulator screen shot 2015 5 31 9 22 47](https://cloud.githubusercontent.com/assets/389004/7901916/b6af6902-07db-11e5-8464-baeb41522deb.png)

# Todo
* Add
  * setting the button color function
* Remove 
  * 'NSString+TezSize' category class
  * 'UIImage+TezStretch' category class

# Usage
```objective-c
[[TezActionSheet sharedInstance] showActionSheetWithSelectButtonTitles:@[@"Button 1", @"Button 2", @"Button3"]
                                                     cancelButtonTitle:@"Cancel"
                                                           selectBlock:^(NSInteger index) {
                                                               NSLog(@"selcted button index : %ld", (long)index);
                                                           } cancelBlock:^{
                                                               NSLog(@"cancel");
                                                           }];
```


# License
The MIT License (MIT)

Copyright (c) 2015 Taesun Park

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
