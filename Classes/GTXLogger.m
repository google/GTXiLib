//
// Copyright 2021 Google Inc.
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

#import "GTXLogger.h"

#import "GTXAssertions.h"
#import "NSObject+GTXLogging.h"

/**
 *  The prefix used for all GTX logs.
 */
NSString *const kGTXLoggerPrefix = @"GTX_LOG";

/**
 *  The prefix used for all GTX error logs.
 */
NSString *const kGTXLoggerErrorLogPrefix = @"Error";

/**
 *  The prefix used for all GTX info logs.
 */
NSString *const kGTXLoggerInfoLogPrefix = @"Info";

/**
 *  The prefix used for all GTX warn logs.
 */
NSString *const kGTXLoggerWarningLogPrefix = @"Warn";

/**
 *  The prefix used for all GTX developer logs.
 */
NSString *const kGTXLoggerDeveloperLogPrefix = @"Dev ";

@interface GTXLogger ()

// Make -init available for implementation.
- (instancetype)init;

@end

@implementation GTXLogger {
  GTXLogLevel _logLevel;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _logLevel = GTXLogLevelError;
  }
  return self;
}

+ (instancetype)defaultLogger {
  static dispatch_once_t onceToken;
  static GTXLogger *logger;
  dispatch_once(&onceToken, ^{
    logger = [[GTXLogger alloc] init];
  });
  return logger;
}

- (void)setLogLevel:(GTXLogLevel)loglevel {
  _logLevel = loglevel;
}

- (void)logWithLevel:(GTXLogLevel)level format:(NSString *)format, ... {
  va_list args;
  va_start(args, format);
  [self gtx_logWithLevel:level format:format andArgs:args];
}

- (void)logWithMaxLevel:(GTXLogLevel)maxLevel
                 prefix:(NSString *)prefix
    descriptionOfObject:(NSObject *)object {
  [self logWithLevel:_logLevel
              format:@"%@%@", prefix,
                     [GTXLogger gtx_loggableDescriptionOfObject:object
                                                       logLevel:MIN(maxLevel, _logLevel)]];
}

+ (void)logInfoWithFormat:(NSString *)format, ... {
  va_list args;
  va_start(args, format);
  [[self defaultLogger] gtx_logWithLevel:GTXLogLevelInfo format:format andArgs:args];
}

#pragma mark - Private

/**
 *  @return A loggable description of the given @c object at the given @c logLevel.
 */
+ (NSString *)gtx_loggableDescriptionOfObject:(NSObject *)object logLevel:(GTXLogLevel)logLevel {
  NSString *elementDescription = @"";
  for (GTXLogProperty *prop in [object gtx_logProperties]) {
    if (prop.isDeveloperLogProperty && logLevel != GTXLogLevelDeveloper) {
      continue;
    }
    NSString *description = [prop descriptionForObject:object];
    if (description) {
      elementDescription = [elementDescription stringByAppendingFormat:@" %@", description];
    }
  }

  return [NSString
      stringWithFormat:@"<%@:%p%@>", NSStringFromClass([object class]), object, elementDescription];
}

/**
 *  @return Prefix string to be used for GTX logs for the given @c level.
 */
+ (NSString *)gtx_prefixStringFromLogLevel:(GTXLogLevel)level {
  NSString *prefix = kGTXLoggerPrefix;
  switch (level) {
    case GTXLogLevelSilent:
      return @"";

    case GTXLogLevelError: {
      prefix = [prefix stringByAppendingFormat:@" %@", kGTXLoggerErrorLogPrefix];
      break;
    }

    case GTXLogLevelWarning: {
      prefix = [prefix stringByAppendingFormat:@" %@", kGTXLoggerWarningLogPrefix];
      break;
    }

    case GTXLogLevelInfo: {
      prefix = [prefix stringByAppendingFormat:@" %@", kGTXLoggerInfoLogPrefix];
      break;
    }

    case GTXLogLevelDeveloper: {
      prefix = [prefix stringByAppendingFormat:@" %@", kGTXLoggerDeveloperLogPrefix];
      break;
    }
  }
  return [NSString stringWithFormat:@"[%@] ", prefix];
}

/**
 *  @return @c YES if this logger will output logs at this level, @c NO otherwise.
 */
- (BOOL)gtx_shouldLogWithLevel:(GTXLogLevel)level {
  return level <= _logLevel;
}

/**
 *  Output a log at the given level.
 *
 *  @param level The level at which log is to be output
 *  @param format The format of the log
 *  @param args Args for the log
 */
- (void)gtx_logWithLevel:(GTXLogLevel)level format:(NSString *)format andArgs:(va_list)args {
  GTX_ASSERT(level > GTXLogLevelSilent, @"Log level must be more than GTXLogLevelSilent");
  if ([self gtx_shouldLogWithLevel:level]) {
    NSString *gtxFormat =
        [[GTXLogger gtx_prefixStringFromLogLevel:level] stringByAppendingString:format];
    NSLogv(gtxFormat, args);
  }
}

@end
