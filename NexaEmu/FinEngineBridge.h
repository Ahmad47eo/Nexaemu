#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NexaEmuFinEngine : NSObject
+ (instancetype)shared;
- (BOOL)prepareGameAtURL:(NSURL *)url error:(NSError * _Nullable * _Nullable)error;
- (void)stop;
@end
NS_ASSUME_NONNULL_END
