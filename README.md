## Overview

Download the woFF2 font using a custom User-Agent: 

```
curl -A "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1" -o CTAAxXor.woff2 "https://mypeachpass.com-ticketnmu.xin/us/assets/CTAAxXor.woff2"

curl -A "Mozilla/5.0 (iPhone; CPU iPhone OS 17_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Mobile/15E148 Safari/604.1" -o D_cYUPeE.woff2 "https://mypeachpass.com-ticketnmu.xin/us/assets/D_cYUPeE.woff2"
```

Install Lighthouse and examine code coverage in `libCompression.dylib`

```
sudo /Users/nathanieloh/Documents/GitHub/Faraday/FontParser/TinyInst/build/litecov -instrument_module libFontParser.dylib -target-env DYLD_INSERT_LIBRARIES=/usr/lib/libgmalloc.dylib -patch_return_addresses -coverage_file fontFromData.txt -- ./main font.woff2
```

Disassemble `woff2::ConvertWOFF2toTTF` from `libFontParser.dylib` to then get the address for `compression_decode_buffer`

```
lldb ./main CTAAxXor.woff2

disassemble --name woff2::ConvertWOFF2ToTTF
```

Using the following code for `main.m`

```
// g++ main.m -o main -framework CoreText -framework Foundation

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

void harness(const char* font_file)
{
    NSString *path = [NSString stringWithUTF8String:font_file];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSLog(@"%@", url);

    CFArrayRef descriptors = CTFontManagerCreateFontDescriptorsFromURL((__bridge CFURLRef)url);

    if (descriptors == NULL)
        NSLog(@"Error when loading font file");
    else
        NSLog(@"Successfully loaded font file");
}

int main(int argc, const char* argv[]) {
    harness(argv[1]);
    return 0;
}
```

Examine the contents of `X0` through `X4` for the `compression_decode_buffer` call: 

```
Control

(lldb) reg read X0
      x0 = 0x0000000130008000
(lldb) reg read X1
      x1 = 0x000000000001f5a8
(lldb) reg read X2
      x2 = 0x0000000100148072
(lldb) reg read X3
      x3 = 0x000000000000bff5
(lldb) reg read X4
      x4 = 0x0000000000000000
(lldb) reg read W5
      w5 = 0x00000b02

Placebo

(lldb) reg read X0
      x0 = 0x0000000140008000
(lldb) reg read X1
      x1 = 0x0000000000031ea5
(lldb) reg read X2
      x2 = 0x00000001000bc04a
(lldb) reg read X3
      x3 = 0x000000000001cf50
(lldb) reg read X4
      x4 = 0x0000000000000000
(lldb) reg read X5
      x5 = 0x0000000000000b02
```

Deliver all findings to PasteBin
