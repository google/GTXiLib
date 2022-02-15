#ifndef GTXILIB_OOPCLASSES_LOCALES_H_
#define GTXILIB_OOPCLASSES_LOCALES_H_

#include <string>

#include <abseil/absl/strings/string_view.h>

namespace gtx {

using Locale = absl::string_view;

inline constexpr Locale kLocaleChineseChina = "zh-rCN";
inline constexpr Locale kLocaleChineseTaiwan = "zh-rTW";
inline constexpr Locale kLocaleEnglish = "en";
inline constexpr Locale kLocaleEnglishGreatBritain = "en-rGB";
inline constexpr Locale kLocaleEnglishUnitedStates = "en-US";
inline constexpr Locale kLocaleFrench = "fr";
inline constexpr Locale kLocaleGerman = "de";
inline constexpr Locale kLocaleItalian = "it";
inline constexpr Locale kLocaleJapanese = "ja";
inline constexpr Locale kLocaleKorean = "ko";
inline constexpr Locale kLocalePortugueseBrazil = "pt-rBR";
inline constexpr Locale kLocaleSpanish = "b+es+419";

}  // namespace gtx

#endif  // GTXILIB_OOPCLASSES_LOCALES_H_
