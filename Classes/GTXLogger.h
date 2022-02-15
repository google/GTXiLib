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

#import <Foundation/Foundation.h>

/**
 * Enum of all possible log types.
 */
typedef NS_ENUM(NSUInteger, GTXLogLevel) {
  /**
   * A placeholder log type for disabling all logs.
   */
  GTXLogLevelSilent,

  /**
   * GTXLogLevel for error logs, used for logging accessibility issues detected, fatal errors
   * etc.
   */
  GTXLogLevelError,

  /**
   * GTXLogLevel for warning logs, used for logging non-fatal errors, deprecated API usage etc.
   */
  GTXLogLevelWarning,

  /**
   *  GTXLogLevel for informational logs, used for logging useful debugging information.
   */
  GTXLogLevelInfo,

  /**
   *  GTXLogLevel for more detailed developer logs. Note that developer logs contain a lot of
   *  information from the app which can include user data that is showing up on the UI (for ex:
   *  text entered, account info showing up on a view etc). Users must exercise caution when sharing
   *  these logs or storing them on servers.
   */
  GTXLogLevelDeveloper,
};

/**
 *  Interface for handling GTXLib logging.
 */
@interface GTXLogger : NSObject

/**
 *  @return @c -init is unavailable, use @c +defaultLogger instead.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 *  @return The default @c GTXLogger instance. Note that the default log level is set to
 *          @c GTXLogLevelError.
 */
+ (instancetype)defaultLogger;

/**
 *  Sets the log level to the given @c loglevel, all logs below this level will not be output, to
 *  disable all logging use @c GTXLogLevelSilent.
 */
- (void)setLogLevel:(GTXLogLevel)loglevel;

/**
 *  Outputs a log at the given @c level with the given @c format. Note that depending on the level
 *  that this logger is set to using -setLogLevel, this log may never be output.
 *
 *  @param level The level at which this log is to be output, any enum in @c GTXLogLevel except
 *               @c GTXLogLevelSilent.
 *  @param format The format for the given log.
 */
- (void)logWithLevel:(GTXLogLevel)level format:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);

/**
 *  Logs a description of the given @c object with the given @c prefix, @note if the given @c
 * maxLevel is greater than internal @c logLevel (@see -setLogLevel:) the minimum of the two, i.e.
 * internal logLevel will be used and only the object properties valid at that level are logged.
 * However if the @c maxLevel is less than the internal @c logLevel then all the properties
 * associated with the object at the given @c maxLevel are logged.
 *
 *  @param maxLevel The max log level at which this log is to be output.
 *  @param prefix The prefix to be output.
 *  @param object The object whose description is to be output.
 */
- (void)logWithMaxLevel:(GTXLogLevel)maxLevel
                 prefix:(NSString *)prefix
    descriptionOfObject:(NSObject *)object;

/**
 *  A Convenience method to log with the given @c format and args at @c GTXLogLevelInfo log level.
 */
+ (void)logInfoWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

@end
