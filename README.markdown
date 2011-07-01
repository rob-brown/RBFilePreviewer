#RBFilePreviewer

##Summary
`RBFilePreviewer` is a subclass of `QLPreviewController`. It is intended to make it easy to preview any `QLPreviewItem`. All you need to do is pass it the desired item(s) to preview to the appropriate initializer. You may use the provided `RBFile` class or any other class that conforms to `QLPreviewItem` (including `NSURL`).

##Dependencies
`RBFile` requires my `NSURL+RBExtras` category. It can be found in my [RBCategories repository][1]. `RBFile` is optional, so if you don't include it, then you don't need to include `NSURL+RBExtras`.

##License

`RBFilePreviewer` is licensed under the MIT license, which is reproduced in its entirety here:

>Copyright (c) 2011 Robert Brown
>
>Permission is hereby granted, free of charge, to any person obtaining a copy
>of this software and associated documentation files (the "Software"), to deal
>in the Software without restriction, including without limitation the rights
>to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>copies of the Software, and to permit persons to whom the Software is
>furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in
>all copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>THE SOFTWARE.

  [1]: https://github.com/rob-brown/RBCategories
