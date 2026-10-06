#import "FinEngineBridge.h"
@implementation NexaEmuFinEngine
+ (instancetype)shared { static NexaEmuFinEngine *x; static dispatch_once_t once; dispatch_once(&once, ^{ x=[NexaEmuFinEngine new]; }); return x; }
- (BOOL)prepareGameAtURL:(NSURL *)url error:(NSError **)error {
  if (!url.isFileURL) { if(error)*error=[NSError errorWithDomain:@"NexaEmu.Engine" code:1 userInfo:@{NSLocalizedDescriptionKey:@"Invalid game file."}]; return NO; }
  if(error)*error=[NSError errorWithDomain:@"NexaEmu.Engine" code:2 userInfo:@{NSLocalizedDescriptionKey:@"Native Fin/Dolphin target is not linked yet."}];
  return NO;
}
- (void)stop {}
@end
