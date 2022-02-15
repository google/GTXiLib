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

#import "GTXLocalizedStringsManagerUtils.h"

#include <string>
#include <vector>

#import "NSString+GTXAdditions.h"
#include "localized_strings_manager.h"

static NSString *const kGTXTranslationsBundleResourceName = @"ios_translations.bundle";

@implementation GTXLocalizedStringsManagerUtils

+ (std::unique_ptr<gtx::LocalizedStringsManager>)defaultLocalizedStringsManager {
  NSString *subbundlePath =
      [[NSBundle bundleForClass:self] pathForResource:kGTXTranslationsBundleResourceName
                                               ofType:nil];
  std::string strings_directory =
      [[[NSBundle bundleWithPath:subbundlePath] resourcePath] gtx_stdString];
  std::vector<gtx::Locale> locales(gtx::kDefaultLocales.begin(), gtx::kDefaultLocales.end());
  return gtx::LocalizedStringsManager::LocalizedStringsManagerWithLocalesInDirectory(
      locales, strings_directory);
}

@end
