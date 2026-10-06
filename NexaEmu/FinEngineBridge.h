#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Thin boundary reserved for the Fin/DolphiniOS Dolphin engine.
/// The implementation is intentionally isolated so the SwiftUI app does not
/// depend on private or guessed Dolphin symbols.
@interface NexaEmuFinEngine : NSObject
+ (instancetype)shared;
- (BOOL)prepareGameAtURL:(NSURL *)url error:(NSError * _Nullable * _Nullable)error;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
