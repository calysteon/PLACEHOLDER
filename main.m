// g++ main.m -o main -framework CoreText -framework Foundation

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

void harness(const char *font_file)
{
    NSString *path = [NSString stringWithUTF8String:font_file];
    NSLog(@"Font file path: %@", path);

    // Read the file data into an NSData object
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        NSLog(@"Error reading font file at %@", path);
        return;
    }

    // Create a font descriptor from the data
    CTFontDescriptorRef descriptor = CTFontManagerCreateFontDescriptorFromData((__bridge CFDataRef)data);
    if (descriptor == NULL) {
        NSLog(@"Error when loading font file");
    } else {
        NSLog(@"Successfully loaded font file");
        CFRelease(descriptor);
    }
}

int main(int argc, const char *argv[]) {
    if (argc < 2) {
        NSLog(@"Usage: %s font_file", argv[0]);
        return 1;
    }
    harness(argv[1]);
    return 0;
}
