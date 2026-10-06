#import "FinEngineBridge.h"

@implementation NexaEmuFinEngine
+ (instancetype)shared {
    static NexaEmuFinEngine *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = [NexaEmuFinEngine new]; });
    return instance;
}

- (BOOL)prepareGameAtURL:(NSURL *)url error:(NSError **)error {
    if (!url || !url.isFileURL) {
        if (error) *error = [NSError errorWithDomain:@"NexaEmu.Engine" code:1 userInfo:@{NSLocalizedDescriptionKey: @"Invalid game file URL."}];
        return NO;
    }
    // The native Fin/DolphiniOS project owns the real Dolphin boot lifecycle.
    // This boundary will be linked to its public/native service in the engine target.
    if (error) *error = [NSError errorWithDomain:@"NexaEmu.Engine" code:2 userInfo:@{NSLocalizedDescriptionKey: @"Native Fin/Dolphin engine is not linked into this target yet."}];
    return NO;
}

- (void)stop {}
@end
