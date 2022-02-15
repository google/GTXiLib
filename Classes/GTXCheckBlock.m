//
// Copyright 2018 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "GTXCheckBlock.h"

#import "NSError+GTXAdditions.h"

@implementation GTXCheckBlock {
  NSString *_name;
  GTXCheckHandlerBlock _block;
  BOOL _requiresWindow;
  NSMutableArray<GTXMessageProvider> *_messageProviders;
}

+ (id<GTXChecking>)GTXCheckWithName:(NSString *)name
                     requiresWindow:(BOOL)requiresWindow
                              block:(GTXCheckHandlerBlock)block {
  return [[GTXCheckBlock alloc] initWithName:name requiresWindow:requiresWindow block:block];
}

+ (id<GTXChecking>)GTXCheckWithName:(NSString *)name block:(GTXCheckHandlerBlock)block {
  // NOTE: requiresWindow is YES to ensure backward compatibility.
  return [self GTXCheckWithName:name requiresWindow:YES block:block];
}

- (instancetype)initWithName:(NSString *)name
              requiresWindow:(BOOL)requiresWindow
                       block:(GTXCheckHandlerBlock)block {
  NSParameterAssert(name);
  NSParameterAssert(block);

  self = [super init];
  if (self) {
    _name = [name copy];
    _block = [block copy];
    _requiresWindow = requiresWindow;
    _messageProviders = [[NSMutableArray alloc] init];
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ %p: %@", [self class], self, _name];
}

- (void)registerMessageProvider:(GTXMessageProvider)messageProvider {
  [_messageProviders addObject:messageProvider];
}

#pragma mark - GTXCheck

- (BOOL)check:(id)element error:(GTXErrorRefType)errorOrNil {
  BOOL success = _block(element, errorOrNil);
  if (!success && errorOrNil != nil && *errorOrNil != nil) {
    NSString *originalMessage = [[*errorOrNil userInfo] objectForKey:kGTXErrorDescriptionKey];
    if (originalMessage == nil) {
      originalMessage = [[*errorOrNil userInfo] objectForKey:NSLocalizedDescriptionKey];
    }
    [self gtx_runProvidersOnMessage:originalMessage element:element forError:errorOrNil];
  }
  return success;
}

- (NSString *)name {
  return _name;
}

- (BOOL)requiresWindowBeforeChecking {
  return _requiresWindow;
}

#pragma mark - Private

/**
 * Runs all registered message providers on @c originalMessage. The intermediate message is passed
 * to the next message provider until all message providers are run. The final message is stored
 * in the error pointed to by @c error.
 *
 * @param      originalMessage The original message produced by the check block.
 * @param      element The element failing the accessibility check.
 * @param[out] error The error set on failure. Must be non-nil.
 */
- (void)gtx_runProvidersOnMessage:(NSString *)originalMessage
                          element:(id)element
                         forError:(GTXErrorRefType)error {
  NSString *newMessage = originalMessage;
  for (GTXMessageProvider provider in _messageProviders) {
    newMessage = provider(newMessage, element, *error);
  }
  [NSError gtx_logOrSetGTXCheckFailedError:error
                                   element:element
                                      name:[self name]
                               description:newMessage];
}

@end
