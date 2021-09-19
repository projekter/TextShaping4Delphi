// Translation of the ICU interface into Delphi Language/Object Pascal
// Based on version 69.1.
// This header file is Copyright (C) 2021 by Benjamin Desef
// You may use it under the same conditions as ICU itself.
// The original ICU copyright header is
// © 2016 and later: Unicode, Inc. and others.
// License & terms of use: http://www.unicode.org/copyright.html
{$Z4}
Unit uICU;

Interface

{$IFDEF FPC}
{$MODE Delphi}
{$MESSAGE FATAL 'Replace every instance of "[Ref] Const" in this file by "Constref", then disable this error.'}
{$ENDIF}

Uses SysUtils;

Const
   ICUDLLcommon = 'icuuc69.dll';
   ICUDLLsuffix = '_69';

Type
   EICU = Class(Exception)
   End;

{$REGION 'utypes.h'}

Type
   UDate = Type Double;

   UDateHelper = Record Helper For UDate
   Const
      MillisPerSecond = 1000;
      MillisPerMinute = 60000;
      MillisPerHour   = 3600000;
      MillisPerDay    = 86400000;
   End;

   TICUErrorCode = (icuecUsingFallbackWarning = -128, icuecErrorWarningStart = -128, icuecUsingDefaultWarning = -127, icuecSafecloneAllocatedWarning = -126, icuecStateOldWarning = -125,
      icuecStringNotTerminatedWarning = -124, icuecSortKeyTooShortWarning = -123, icuecAmbiguousAliasWarning = -122, icuecDifferentUcaVersion = -121, icuecPluginChangedLevelWarning = -120,
      icuecZeroError = 0, icuecIllegalArgumentError = 1, icuecMissingResourceError = 2, icuecInvalidFormatError = 3, icuecFileAccessError = 4, icuecInternalProgramError = 5,
      icuecMessageParseError = 6, icuecMemoryAllocationError = 7, icuecIndexOutofboundsError = 8, icuecParseError = 9, icuecInvalidCharFound = 10, icuecTruncatedCharFound = 11,
      icuecIllegalCharFound = 12, icuecInvalidTableFormat = 13, icuecInvalidTableFile = 14, icuecBufferOverflowError = 15, icuecUnsupportedError = 16, icuecResourceTypeMismatch = 17,
      icuecIllegalEscapeSequence = 18, icuecUnsupportedEscapeSequence = 19, icuecNoSpaceAvailable = 20, icuecCeNotFoundError = 21, icuecPrimaryTooLongError = 22, icuecStateTooOldError = 23,
      icuecTooManyAliasesError = 24, icuecEnumOutOfSyncError = 25, icuecInvariantConversionError = 26, icuecInvalidStateError = 27, icuecCollatorVersionMismatch = 28, icuecUselessCollatorError = 29,
      icuecNoWritePermission = 30, icuecInputTooLongError = 31, icuecBadVariableDefinition = $10000, icuecParseErrorStart = $10000, icuecMalformedRule, icuecMalformedSet,
      icuecMalformedSymbolReference, icuecMalformedUnicodeEscape, icuecMalformedVariableDefinition, icuecMalformedVariableReference, icuecMismatchedSegmentDelimiters, icuecMisplacedAnchorStart,
      icuecMisplacedCursorOffset, icuecMisplacedQuantifier, icuecMissingOperator, icuecMissingSegmentClose, icuecMultipleAnteContexts, icuecMultipleCursors, icuecMultiplePostContexts,
      icuecTrailingBackslash, icuecUndefinedSegmentReference, icuecUndefinedVariable, icuecUnquotedSpecial, icuecUnterminatedQuote, icuecRuleMaskError, icuecMisplacedCompoundFilter,
      icuecMultipleCompoundFilters, icuecInvalidRbtSyntax, icuecInvalidPropertyPattern, icuecMalformedPragma, icuecUnclosedSegment, icuecIllegalCharInSegment, icuecVariableRangeExhausted,
      icuecVariableRangeOverlap, icuecIllegalCharacter, icuecInternalTransliteratorError, icuecInvalidId, icuecInvalidFunction, icuecUnexpectedToken = $10100, icuecFmtParseErrorStart = $10100,
      icuecMultipleDecimalSeparators, icuecMultipleDecimalSeperators = icuecMultipleDecimalSeparators, icuecMultipleExponentialSymbols, icuecMalformedExponentialPattern, icuecMultiplePercentSymbols,
      icuecMultiplePermillSymbols, icuecMultiplePadSpecifiers, icuecPatternSyntaxError, icuecIllegalPadPosition, icuecUnmatchedBraces, icuecUnsupportedProperty, icuecUnsupportedAttribute,
      icuecArgumentTypeMismatch, icuecDuplicateKeyword, icuecUndefinedKeyword, icuecDefaultKeywordMissing, icuecDecimalNumberSyntaxError, icuecFormatInexactError, icuecNumberArgOutofboundsError,
      icuecNumberSkeletonSyntaxError, icuecBrkInternalError = $10200, icuecBrkErrorStart = $10200, icuecBrkHexDigitsExpected, icuecBrkSemicolonExpected, icuecBrkRuleSyntax, icuecBrkUnclosedSet,
      icuecBrkAssignError, icuecBrkVariableRedfinition, icuecBrkMismatchedParen, icuecBrkNewLineInQuotedString, icuecBrkUndefinedVariable, icuecBrkInitError, icuecBrkRuleEmptySet,
      icuecBrkUnrecognizedOption, icuecBrkMalformedRuleTag, icuecRegexInternalError = $10300, icuecRegexErrorStart = $10300, icuecRegexRuleSyntax, icuecRegexInvalidState, icuecRegexBadEscapeSequence,
      icuecRegexPropertySyntax, icuecRegexUnimplemented, icuecRegexMismatchedParen, icuecRegexNumberTooBig, icuecRegexBadInterval, icuecRegexMaxLtMin, icuecRegexInvalidBackRef, icuecRegexInvalidFlag,
      icuecRegexLookBehindLimit, icuecRegexSetContainsString, icuecRegexMissingCloseBracket = icuecRegexSetContainsString + 2, icuecRegexInvalidRange, icuecRegexStackOverflow, icuecRegexTimeOut,
      icuecRegexStoppedByCaller, icuecRegexPatternTooBig, icuecRegexInvalidCaptureGroupName, icuecIdnaProhibitedError = $10400, icuecIdnaErrorStart = $10400, icuecIdnaUnassignedError,
      icuecIdnaCheckBidiError, icuecIdnaStd3AsciiRulesError, icuecIdnaAcePrefixError, icuecIdnaVerificationError, icuecIdnaLabelTooLongError, icuecIdnaZeroLengthLabelError,
      icuecIdnaDomainNameTooLongError, icuecStringprepProhibitedError = icuecIdnaProhibitedError, icuecStringprepUnassignedError = icuecIdnaUnassignedError,
      icuecStringprepCheckBidiError = icuecIdnaCheckBidiError, icuecPluginErrorStart = $10500, icuecPluginTooHigh = $10500, icuecPluginDidntSetLevel);

   TICUErrorCodeHelper = Record Helper For TICUErrorCode
      Function ToString: UnicodeString; Inline;
      Function Success: Boolean; Inline;
      Function Failure: Boolean; Inline;
   End;
{$ENDREGION}
{$REGION 'uvernum.h / uversion.h'}

Type
   TICUVersionInfo = Type Cardinal;

   TICUVersionInfoHelper = Record Helper For TICUVersionInfo
   Public Const
      cCopyrightStringLength  = 128;
      cMaxVersionLength       = 4;
      cVersionDelimiter       = AnsiChar('.');
      cMaxVersionStringLength = 20;

      Class Function FromString(Const AValue: UnicodeString): TICUVersionInfo; Static; Inline;
      Function ToString: UnicodeString; Inline;
      Class Function GetVersion: TICUVersionInfo; Static; Inline;
   End;

   TICUManager = Class Abstract
   Strict Private
      Class Var FMajor, FMinor, FMicro: Cardinal;
   Private
      Class Procedure Initialize; Static;
   Private Const
      cCopyrightString     = ' Copyright (C) 2016 and later: Unicode, Inc. and others. License & terms of use: http://www.unicode.org/copyright.html ';
      ICUVersionMajor      = 69;
      ICUVersionMinor      = 1;
      ICUVersionPatchlevel = 0;
      ICUVersionBuildlevel = 0;
      ICUVersion           = AnsiString('69.1');
      ICUVersionShort      = AnsiString('69');
      ICUDataVersion       = AnsiString('69.1');
      ColRuntimeVersion    = 9;
      ColBuilderVersion    = 9;
      UnicodeVersion       = AnsiString('13.0'); // uchar.h

      sError = 'The error %d occured in an ICU call: %s.';
   Public
      Class Function VersionString: UnicodeString; Static; Inline;
      Class Procedure Error(Const AErrorCode: TICUErrorCode); Static; // Inline;

      Class Property MajorVersion: Cardinal Read FMajor;
      Class Property MinorVersion: Cardinal Read FMinor;
      Class Property MicroVersion: Cardinal Read FMicro;
   End;
{$ENDREGION}
{$REGION 'umachine.h'}

Type
   UBool      = ByteBool;
   UChar      = WideChar;
   OldUChar   = WideChar;
   TICUChar32 = Type Integer;

Const
   USentinel = Integer( -1);
{$ENDREGION}
{$REGION 'uenum.h'}

Type
   TICUEnumeration = Record
   Strict Private
{$HINTS OFF}
      FValue: Pointer;
{$HINTS ON}
   Public
      Procedure Destroy; Inline;
      Function Count: Integer; Inline;
      Function UNext: UnicodeString; Inline;
      Function Next: AnsiString; Inline;
      Procedure Reset; Inline;

      Class Function UCreate(Const AStrings: TArray<String>): TICUEnumeration; Static;
      Class Function Create(Const AStrings: TArray<AnsiString>): TICUEnumeration; Overload; Static;
      Class Function Create(Const AStrings: TArray<PAnsiChar>): TICUEnumeration; Overload; Static;
   End;
{$ENDREGION}
{$REGION 'uloc.h'}

   TICULocaleDataType = (iculdtActualLocale, iculdtValidLocale, iculdtRequestedLocale, iculdtDataLocaleTypeLimit);

   TICULocaleAvailableType = (iculatDefault, iculatAvailableOnlyLegacyAliases, iculatAvailableWithLegacyAliases, iculatAvailableCount);

   TICULayoutType = (icultLTR, icultRTL, icultTTB, icultBTT, icultUnknown);

   TICUAcceptResult = (icuarAcceptFailed, icuarAcceptValid, icuarAcceptFallback);

   TICULocale = Record
   Private
      FValue: AnsiString;

   Strict Private
   Type
      TGetFunc        = Function(Const ALocaleID: PAnsiChar; Buf: PAnsiChar; Const ABufCapacity: Integer; Out OError: TICUErrorCode): Integer; Cdecl;
      TGetDisplayFunc = Function(Const ALocaleID, ADisplayLocale: PAnsiChar; Dest: PWideChar; Const ABufCapacity: Integer; Out OError: TICUErrorCode): Integer; Cdecl;
   Strict Private
      Function Get(Const AFunc: TGetFunc; Const AMaxSize: Integer): AnsiString; Overload; Inline;
      Function Get(Const AFunc: TGetDisplayFunc; Const ADisplayLocale: TICULocale): UnicodeString; Overload; Inline;
   Public Const
      capLang             = 12;
      capCountry          = 4;
      capFullName         = 157;
      capScript           = 6;
      capKeywords         = 96;
      capKeywordAndValues = 100;

      kwSeparator            = '@';
      kwSeparatorUnicode     = $40;
      kwAssign               = '=';
      kwAssignUnicode        = $3D;
      kwItemSeparator        = ';';
      kwItemSeparatorUnicode = $3B;

      Class Function GetDefault: TICULocale; Static; Inline;
      Procedure SetDefault; Inline;
      Function GetLanguage: AnsiString; Inline;
      Function GetScript: AnsiString; Inline;
      Function GetCountry: AnsiString; Inline;
      Function GetVariant: AnsiString; Inline;
      Function GetName: AnsiString; Inline;
      Function Canonicalize: TICULocale; Inline;
      Function GetISO3Language: AnsiString; Inline;
      Function GetISO3Country: AnsiString; Inline;
      Function GetLCID: Integer; Inline;
      Function GetDisplayLanguage(Const ADisplayLocale: TICULocale): UnicodeString; Inline;
      Function GetDisplayScript(Const ADisplayLocale: TICULocale): UnicodeString; Inline;
      Function GetDisplayCountry(Const ADisplayLocale: TICULocale): UnicodeString; Inline;
      Function GetDisplayVariant(Const ADisplayLocale: TICULocale): UnicodeString; Inline;
      Class Function GetDisplayKeyword(Const AKeyword: AnsiString; Const ADisplayLocale: TICULocale): UnicodeString; Static; Inline;
      Function GetDisplayKeywordValue(Const AKeyword: AnsiString; Const ADisplayLocale: TICULocale): UnicodeString; Inline;
      Function GetDisplayName(Const AInLocale: TICULocale): UnicodeString; Inline;
      Class Function GetAvailable(Const AN: Integer): TICULocale; Static; Inline;
      Class Function CountAvailable: Integer; Static; Inline;
      Class Function OpenAvailableByType(Const AType: TICULocaleAvailableType): TArray<TICULocale>; Static; Inline;
      Class Function GetISOLanguages: TArray<AnsiString>; Static;
      Class Function GetISOCountries: TArray<AnsiString>; Static;
      Function GetParent: TICULocale; Inline;
      Function GetBaseName: AnsiString; Inline;
      Function OpenKeywords: TICUEnumeration; Inline;
      Function GetKeywordValue(Const AKeyword: AnsiString): AnsiString; Inline;
      Procedure SetKeywordValue(Const AKeyword, AValue: AnsiString); Inline;
      Function IsRightToLeft: Boolean; Inline;
      Function GetCharacterOrientation: TICULayoutType; Inline;
      Function GetLineOrientation: TICULayoutType; Inline;
      Class Function AcceptLanguageFromHTTP(Const AHTTPAcceptLanguage: AnsiString; Const AAvailableLocales: TArray<TICULocale>; Out OResult: TICUAcceptResult): TICULocale; Static; Inline;
      Class Function AcceptLanguage(Const AAcceptList: TArray<AnsiString>; Const AAvailableLocales: TArray<TICULocale>; Out OResult: TICUAcceptResult): TICULocale; Static; Inline;
      Class Function GetLocaleForLCID(Const AHostID: Cardinal): TICULocale; Static; Inline;
      Function AddLikelySubtags: TICULocale; Inline;
      Function MinimizeSubtags: TICULocale; Inline;
      Class Function ForLanguageTag(Const ALanguageTag: AnsiString): TICULocale; Static; Inline;
      Function ToLanguageTag(Const AStrict: Boolean): AnsiString; Inline;
      Class Function ToUnicodeLocaleKey(Const AKeyword: AnsiString): AnsiString; Static; Inline;
      Class Function ToUnicodeLocaleType(Const AKeyword, AValue: AnsiString): AnsiString; Static; Inline;
      Class Function ToLegacyKey(Const AKeyword: AnsiString): AnsiString; Static; Inline;
      Class Function ToLegacyType(Const AKeyword, AValue: AnsiString): AnsiString; Static; Inline;

      Property Value: AnsiString Read FValue Write FValue;
   End;

   TICULocaleHelper = Record Helper For TICULocale
   Public Const
      locChinese: TICULocale            = (FValue: 'zh');
      locEnglish: TICULocale            = (FValue: 'en');
      locFrench: TICULocale             = (FValue: 'fr');
      locGerman: TICULocale             = (FValue: 'de');
      locItalian: TICULocale            = (FValue: 'it');
      locJapanese: TICULocale           = (FValue: 'ja');
      locKorean: TICULocale             = (FValue: 'ko');
      locSimplifiedChinese: TICULocale  = (FValue: 'zh_CN');
      locTraditionalChinese: TICULocale = (FValue: 'zh_TW');
      locCanada: TICULocale             = (FValue: 'en_CA');
      locCanadaFrench: TICULocale       = (FValue: 'fr_CA');
      locChina: TICULocale              = (FValue: 'zh_CN');
      locPRC: TICULocale                = (FValue: 'zh_CN');
      locFrance: TICULocale             = (FValue: 'fr_FR');
      locGermany: TICULocale            = (FValue: 'de_DE');
      locItaly: TICULocale              = (FValue: 'it_IT');
      locJapan: TICULocale              = (FValue: 'ja_JP');
      locKorea: TICULocale              = (FValue: 'ko_KR');
      locTaiwan: TICULocale             = (FValue: 'zh_TW');
      locUK: TICULocale                 = (FValue: 'en_GB');
      locUS: TICULocale                 = (FValue: 'en_US');
   End;
{$ENDREGION}
{$REGION 'stringoptions.h'}

   TICUStringOptions = Record

   Const
      cFoldCaseDefault            = 0;
      cFoldCaseExcludeSpecialI    = 1;
      cTitlecaseWholeString       = $20;
      cTitlecaseSentences         = $40;
      cTitlecaseNoLowercase       = $100;
      cTitlecaseNoBreakAdjustment = $200;
      cTitlecaseAdjustToCased     = $400;
      cEditsNoReset               = $2000;
      cOmitUnchangedText          = $4000;
      cCompareCodePointOrder      = $8000;
      cCompareIgnoreCase          = $10000;
      cUnormInputIsFCD            = $20000;

   End;
{$ENDREGION}
{$REGION 'ucpmap.h'}

   TICUCPMapRangeOption = (cpmroRangeNormal, cmproRangeFixedLeadSurrogates, cmproRangeFixedAllSurrogates);

   TICUCPMapValueFilter = Function(Const Context; Const AValue: Cardinal): Cardinal; Cdecl;

   TICUCPMap = Record
   Strict Private
{$HINTS OFF}
      FValue: Pointer;
{$HINTS ON}
   Public
      Function Get(Const AC: TICUChar32): Cardinal;
      Function GetRange(Const AStart: TICUChar32; Const AOption: TICUCPMapRangeOption; Const ASurrogateValue: Cardinal; Const AFilter: TICUCPMapValueFilter; Const Context; Out OPValue: Cardinal)
         : TICUChar32; Overload;
      Function GetRange(Const AStart: TICUChar32; Const AOption: TICUCPMapRangeOption; Const ASurrogateValue: Cardinal; Const AFilter: TICUCPMapValueFilter; Const Context): TICUChar32; Overload;
   End;
{$ENDREGION}
{$REGION 'uchar.h'}

Const
   cICUCharMinValue = 0;
   cICUCharMaxValue = $10FFFF;

Type
   TICUProperty = (icupCharAlphabetic = 0, icupCharBinaryStart = icupCharAlphabetic, icupCharAsciiHexDigit = 1, icupCharBidiControl = 2, icupCharBidiMirrored = 3, icupCharDash = 4,
      icupCharDefaultIgnorableCodePoint = 5, icupCharDeprecated = 6, icupCharDiacritic = 7, icupCharExtender = 8, icupCharFullCompositionExclusion = 9, icupCharGraphemeBase = 10,
      icupCharGraphemeExtend = 11, icupCharGraphemeLink = 12, icupCharHexDigit = 13, icupCharHyphen = 14, icupCharIdContinue = 15, icupCharIdStart = 16, icupCharIdeographic = 17,
      icupCharIdsBinaryOperator = 18, icupCharIdsTrinaryOperator = 19, icupCharJoinControl = 20, icupCharLogicalOrderException = 21, icupCharLowercase = 22, icupCharMath = 23,
      icupCharNoncharacterCodePoint = 24, icupCharQuotationMark = 25, icupCharRadical = 26, icupCharSoftDotted = 27, icupCharTerminalPunctuation = 28, icupCharUnifiedIdeograph = 29,
      icupCharUppercase = 30, icupCharWhiteSpace = 31, icupCharXidContinue = 32, icupCharXidStart = 33, icupCharCaseSensitive = 34, icupCharSTerm = 35, icupCharVariationSelector = 36,
      icupCharNfdInert = 37, icupCharNfkdInert = 38, icupCharNfcInert = 39, icupCharNfkcInert = 40, icupCharSegmentStarter = 41, icupCharPatternSyntax = 42, icupCharPatternWhiteSpace = 43,
      icupCharPosixAlnum = 44, icupCharPosixBlank = 45, icupCharPosixGraph = 46, icupCharPosixPrint = 47, icupCharPosixXdigit = 48, icupCharCased = 49, icupCharCaseIgnorable = 50,
      icupCharChangesWhenLowercased = 51, icupCharChangesWhenUppercased = 52, icupCharChangesWhenTitlecased = 53, icupCharChangesWhenCasefolded = 54, icupCharChangesWhenCasemapped = 55,
      icupCharChangesWhenNfkcCasefolded = 56, icupCharEmoji = 57, icupCharEmojiPresentation = 58, icupCharEmojiModifier = 59, icupCharEmojiModifierBase = 60, icupCharEmojiComponent = 61,
      icupCharRegionalIndicator = 62, icupCharPrependedConcatenationMark = 63, icupCharExtendedPictographic = 64, //
      icupCharBinaryLimit, // deprecated
      icupCharBidiClass = $1000, icupCharIntStart = icupCharBidiClass, icupCharBlock = $1001, icupCharCanonicalCombiningClass = $1002, icupCharDecompositionType = $1003,
      icupCharEastAsianWidth = $1004, icupCharGeneralCategory = $1005, icupCharJoiningGroup = $1006, icupCharJoiningType = $1007, icupCharLineBreak = $1008, icupCharNumericType = $1009,
      icupCharScript = $100A, icupCharHangulSyllableType = $100B, icupCharNfdQuickCheck = $100C, icupCharNfkdQuickCheck = $100D, icupCharNfcQuickCheck = $100E, icupCharNfkcQuickCheck = $100F,
      icupCharLeadCanonicalCombiningClass = $1010, icupCharTrailCanonicalCombiningClass = $1011, icupCharGraphemeClusterBreak = $1012, icupCharSentenceBreak = $1013, icupCharWordBreak = $1014,
      icupCharBidiPairedBracketType = $1015, icupCharIndicPositionalCategory = $1016, icupCharIndicSyllabicCategory = $1017, icupCharVerticalOrientation = $1018, //
      icupCharIntLimit = $1019, // deprecated
      icupCharGeneralCategoryMask = $2000, icupCharMaskStart = icupCharGeneralCategoryMask, //
      icupCharMaskLimit = $2001, // deprecated
      icupCharNumericValue = $3000, icupCharDoubleStart = icupCharNumericValue, icupCharDoubleLimit = $3001, // deprecated
      icupCharAge = $4000, icupCharStringStart = icupCharAge, icupCharBidiMirroringGlyph = $4001, icupCharCaseFolding = $4002, //
      icupCharIsoComment = $4003, // deprecated
      icupCharLowercaseMapping = $4004, icupCharName = $4005, icupCharSimpleCaseFolding = $4006, icupCharSimpleLowercaseMapping = $4007, icupCharSimpleTitlecaseMapping = $4008,
      icupCharSimpleUppercaseMapping = $4009, icupCharTitlecaseMapping = $400A, //
      icupCharUnicode1Name = $400B, // deprecated
      icupCharUppercaseMapping = $400C, icupCharBidiPairedBracket = $400D, //
      icupCharStringLimit = $400E, // deprecated
      icupCharScriptExtensions = $7000, icupCharOtherPropertyStart = icupCharScriptExtensions, //
      icupCharOtherPropertyLimit = $7001, // deprecated
      icupCharInvalidCode = -1);

   TICUSet = Record
   Strict Private
{$HINTS OFF}
      FValue: Pointer;
{$HINTS ON}
   Public
      Class Function GetBinaryPropertySet(Const AProperty: TICUProperty): TICUSet; Static; Inline;
   End;

   TICUCharCategory = (icuccUnassigned = 0, icuccGeneralOtherTypes = 0, icuccUppercaseLetter = 1, icuccLowercaseLetter = 2, icuccTitlecaseLetter = 3, icuccModifierLetter = 4, icuccOtherLetter = 5,
      icuccNonSpacingMark = 6, icuccEnclosingMark = 7, icuccCombiningSpacingMark = 8, icuccDecimalDigitNumber = 9, icuccLetterNumber = 10, icuccOtherNumber = 11, icuccSpaceSeparator = 12,
      icuccLineSeparator = 13, icuccParagraphSeparator = 14, icuccControlChar = 15, icuccFormatChar = 16, icuccPrivateUseChar = 17, icuccSurrogate = 18, icuccDashPunctuation = 19,
      icuccStartPunctuation = 20, icuccEndPunctuation = 21, icuccConnectorPunctuation = 22, icuccOtherPunctuation = 23, icuccMathSymbol = 24, icuccCurrencySymbol = 25, icuccModifierSymbol = 26,
      icuccOtherSymbol = 27, icuccInitialPunctuation = 28, icuccFinalPunctuation = 29, icuccCharCategoryCount);

   TICUCharCategories = Set Of TICUCharCategory;

   TICUCharCategoriesHelper = Record Helper For TICUCharCategories
   Const
      gcLetters      = [icuccUppercaseLetter, icuccLowercaseLetter, icuccTitlecaseLetter, icuccModifierLetter, icuccOtherLetter];
      gcLettersCased = [icuccUppercaseLetter, icuccLowercaseLetter, icuccTitlecaseLetter];
      gcMarks        = [icuccNonSpacingMark, icuccEnclosingMark, icuccCombiningSpacingMark];
      gcNumbers      = [icuccDecimalDigitNumber, icuccLetterNumber, icuccOtherNumber];
      gcSeparators   = [icuccSpaceSeparator, icuccLineSeparator, icuccParagraphSeparator];
      gcOthers       = [icuccGeneralOtherTypes, icuccControlChar, icuccFormatChar, icuccPrivateUseChar, icuccSurrogate];
      gcPunctuation  = [icuccDashPunctuation, icuccStartPunctuation, icuccEndPunctuation, icuccConnectorPunctuation, icuccOtherLetter, icuccInitialPunctuation, icuccFinalPunctuation];
      gcSymbols      = [icuccMathSymbol, icuccCurrencySymbol, icuccModifierSymbol, icuccOtherSymbol];
   End;

   TICUCharDirection = (icucdLeftToRight = 0, icucdRightToLeft = 1, icucdEuropeanNumber = 2, icucdEuropeanNumberSeparator = 3, icucdEuropeanNumberTerminator = 4, icucdArabicNumber = 5,
      icucdCommonNumberSeparator = 6, icucdBlockSeparator = 7, icucdSegmentSeparator = 8, icucdWhiteSpaceNeutral = 9, icucdOtherNeutral = 10, icucdLeftToRightEmbedding = 11,
      icucdLeftToRightOverride = 12, icucdRightToLeftArabic = 13, icucdRightToLeftEmbedding = 14, icucdRightToLeftOverride = 15, icucdPopDirectionalFormat = 16, icucdDirNonSpacingMark = 17,
      icucdBoundaryNeutral = 18, icucdFirstStrongIsolate = 19, icucdLeftToRightIsolate = 20, icucdRightToLeftIsolate = 21, icucdPopDirectionalIsolate = 22, //
      icucdCharDirectionCount // deprecated
      );

   TICUBidiPairedBracketType = (icubpbtBptNone, icubpbtBptOpen, icubpbtBptClose, //
      icubpbtBptCount // deprecated
      );

   TICUBlockCode = (icubcBlockNoBlock = 0, icubcBlockBasicLatin = 1, icubcBlockLatin1Supplement = 2, icubcBlockLatinExtendedA = 3, icubcBlockLatinExtendedB = 4, icubcBlockIpaExtensions = 5,
      icubcBlockSpacingModifierLetters = 6, icubcBlockCombiningDiacriticalMarks = 7, icubcBlockGreek = 8, icubcBlockCyrillic = 9, icubcBlockArmenian = 10, icubcBlockHebrew = 11, icubcBlockArabic = 12,
      icubcBlockSyriac = 13, icubcBlockThaana = 14, icubcBlockDevanagari = 15, icubcBlockBengali = 16, icubcBlockGurmukhi = 17, icubcBlockGujarati = 18, icubcBlockOriya = 19, icubcBlockTamil = 20,
      icubcBlockTelugu = 21, icubcBlockKannada = 22, icubcBlockMalayalam = 23, icubcBlockSinhala = 24, icubcBlockThai = 25, icubcBlockLao = 26, icubcBlockTibetan = 27, icubcBlockMyanmar = 28,
      icubcBlockGeorgian = 29, icubcBlockHangulJamo = 30, icubcBlockEthiopic = 31, icubcBlockCherokee = 32, icubcBlockUnifiedCanadianAboriginalSyllabics = 33, icubcBlockOgham = 34,
      icubcBlockRunic = 35, icubcBlockKhmer = 36, icubcBlockMongolian = 37, icubcBlockLatinExtendedAdditional = 38, icubcBlockGreekExtended = 39, icubcBlockGeneralPunctuation = 40,
      icubcBlockSuperscriptsAndSubscripts = 41, icubcBlockCurrencySymbols = 42, icubcBlockCombiningMarksForSymbols = 43, icubcBlockLetterlikeSymbols = 44, icubcBlockNumberForms = 45,
      icubcBlockArrows = 46, icubcBlockMathematicalOperators = 47, icubcBlockMiscellaneousTechnical = 48, icubcBlockControlPictures = 49, icubcBlockOpticalCharacterRecognition = 50,
      icubcBlockEnclosedAlphanumerics = 51, icubcBlockBoxDrawing = 52, icubcBlockBlockElements = 53, icubcBlockGeometricShapes = 54, icubcBlockMiscellaneousSymbols = 55, icubcBlockDingbats = 56,
      icubcBlockBraillePatterns = 57, icubcBlockCjkRadicalsSupplement = 58, icubcBlockKangxiRadicals = 59, icubcBlockIdeographicDescriptionCharacters = 60, icubcBlockCjkSymbolsAndPunctuation = 61,
      icubcBlockHiragana = 62, icubcBlockKatakana = 63, icubcBlockBopomofo = 64, icubcBlockHangulCompatibilityJamo = 65, icubcBlockKanbun = 66, icubcBlockBopomofoExtended = 67,
      icubcBlockEnclosedCjkLettersAndMonths = 68, icubcBlockCjkCompatibility = 69, icubcBlockCjkUnifiedIdeographsExtensionA = 70, icubcBlockCjkUnifiedIdeographs = 71, icubcBlockYiSyllables = 72,
      icubcBlockYiRadicals = 73, icubcBlockHangulSyllables = 74, icubcBlockHighSurrogates = 75, icubcBlockHighPrivateUseSurrogates = 76, icubcBlockLowSurrogates = 77, icubcBlockPrivateUseArea = 78,
      icubcBlockPrivateUse = icubcBlockPrivateUseArea, icubcBlockCjkCompatibilityIdeographs = 79, icubcBlockAlphabeticPresentationForms = 80, icubcBlockArabicPresentationFormsA = 81,
      icubcBlockCombiningHalfMarks = 82, icubcBlockCjkCompatibilityForms = 83, icubcBlockSmallFormVariants = 84, icubcBlockArabicPresentationFormsB = 85, icubcBlockSpecials = 86,
      icubcBlockHalfwidthAndFullwidthForms = 87, icubcBlockOldItalic = 88, icubcBlockGothic = 89, icubcBlockDeseret = 90, icubcBlockByzantineMusicalSymbols = 91, icubcBlockMusicalSymbols = 92,
      icubcBlockMathematicalAlphanumericSymbols = 93, icubcBlockCjkUnifiedIdeographsExtensionB = 94, icubcBlockCjkCompatibilityIdeographsSupplement = 95, icubcBlockTags = 96,
      icubcBlockCyrillicSupplement = 97, icubcBlockCyrillicSupplementary = icubcBlockCyrillicSupplement, icubcBlockTagalog = 98, icubcBlockHanunoo = 99, icubcBlockBuhid = 100,
      icubcBlockTagbanwa = 101, icubcBlockMiscellaneousMathematicalSymbolsA = 102, icubcBlockSupplementalArrowsA = 103, icubcBlockSupplementalArrowsB = 104,
      icubcBlockMiscellaneousMathematicalSymbolsB = 105, icubcBlockSupplementalMathematicalOperators = 106, icubcBlockKatakanaPhoneticExtensions = 107, icubcBlockVariationSelectors = 108,
      icubcBlockSupplementaryPrivateUseAreaA = 109, icubcBlockSupplementaryPrivateUseAreaB = 110, icubcBlockLimbu = 111, icubcBlockTaiLe = 112, icubcBlockKhmerSymbols = 113,
      icubcBlockPhoneticExtensions = 114, icubcBlockMiscellaneousSymbolsAndArrows = 115, icubcBlockYijingHexagramSymbols = 116, icubcBlockLinearBSyllabary = 117, icubcBlockLinearBIdeograms = 118,
      icubcBlockAegeanNumbers = 119, icubcBlockUgaritic = 120, icubcBlockShavian = 121, icubcBlockOsmanya = 122, icubcBlockCypriotSyllabary = 123, icubcBlockTaiXuanJingSymbols = 124,
      icubcBlockVariationSelectorsSupplement = 125, icubcBlockAncientGreekMusicalNotation = 126, icubcBlockAncientGreekNumbers = 127, icubcBlockArabicSupplement = 128, icubcBlockBuginese = 129,
      icubcBlockCjkStrokes = 130, icubcBlockCombiningDiacriticalMarksSupplement = 131, icubcBlockCoptic = 132, icubcBlockEthiopicExtended = 133, icubcBlockEthiopicSupplement = 134,
      icubcBlockGeorgianSupplement = 135, icubcBlockGlagolitic = 136, icubcBlockKharoshthi = 137, icubcBlockModifierToneLetters = 138, icubcBlockNewTaiLue = 139, icubcBlockOldPersian = 140,
      icubcBlockPhoneticExtensionsSupplement = 141, icubcBlockSupplementalPunctuation = 142, icubcBlockSylotiNagri = 143, icubcBlockTifinagh = 144, icubcBlockVerticalForms = 145, icubcBlockNko = 146,
      icubcBlockBalinese = 147, icubcBlockLatinExtendedC = 148, icubcBlockLatinExtendedD = 149, icubcBlockPhagsPa = 150, icubcBlockPhoenician = 151, icubcBlockCuneiform = 152,
      icubcBlockCuneiformNumbersAndPunctuation = 153, icubcBlockCountingRodNumerals = 154, icubcBlockSundanese = 155, icubcBlockLepcha = 156, icubcBlockOlChiki = 157,
      icubcBlockCyrillicExtendedA = 158, icubcBlockVai = 159, icubcBlockCyrillicExtendedB = 160, icubcBlockSaurashtra = 161, icubcBlockKayahLi = 162, icubcBlockRejang = 163, icubcBlockCham = 164,
      icubcBlockAncientSymbols = 165, icubcBlockPhaistosDisc = 166, icubcBlockLycian = 167, icubcBlockCarian = 168, icubcBlockLydian = 169, icubcBlockMahjongTiles = 170, icubcBlockDominoTiles = 171,
      icubcBlockSamaritan = 172, icubcBlockUnifiedCanadianAboriginalSyllabicsExtended = 173, icubcBlockTaiTham = 174, icubcBlockVedicExtensions = 175, icubcBlockLisu = 176, icubcBlockBamum = 177,
      icubcBlockCommonIndicNumberForms = 178, icubcBlockDevanagariExtended = 179, icubcBlockHangulJamoExtendedA = 180, icubcBlockJavanese = 181, icubcBlockMyanmarExtendedA = 182,
      icubcBlockTaiViet = 183, icubcBlockMeeteiMayek = 184, icubcBlockHangulJamoExtendedB = 185, icubcBlockImperialAramaic = 186, icubcBlockOldSouthArabian = 187, icubcBlockAvestan = 188,
      icubcBlockInscriptionalParthian = 189, icubcBlockInscriptionalPahlavi = 190, icubcBlockOldTurkic = 191, icubcBlockRumiNumeralSymbols = 192, icubcBlockKaithi = 193,
      icubcBlockEgyptianHieroglyphs = 194, icubcBlockEnclosedAlphanumericSupplement = 195, icubcBlockEnclosedIdeographicSupplement = 196, icubcBlockCjkUnifiedIdeographsExtensionC = 197,
      icubcBlockMandaic = 198, icubcBlockBatak = 199, icubcBlockEthiopicExtendedA = 200, icubcBlockBrahmi = 201, icubcBlockBamumSupplement = 202, icubcBlockKanaSupplement = 203,
      icubcBlockPlayingCards = 204, icubcBlockMiscellaneousSymbolsAndPictographs = 205, icubcBlockEmoticons = 206, icubcBlockTransportAndMapSymbols = 207, icubcBlockAlchemicalSymbols = 208,
      icubcBlockCjkUnifiedIdeographsExtensionD = 209, icubcBlockArabicExtendedA = 210, icubcBlockArabicMathematicalAlphabeticSymbols = 211, icubcBlockChakma = 212,
      icubcBlockMeeteiMayekExtensions = 213, icubcBlockMeroiticCursive = 214, icubcBlockMeroiticHieroglyphs = 215, icubcBlockMiao = 216, icubcBlockSharada = 217, icubcBlockSoraSompeng = 218,
      icubcBlockSundaneseSupplement = 219, icubcBlockTakri = 220, icubcBlockBassaVah = 221, icubcBlockCaucasianAlbanian = 222, icubcBlockCopticEpactNumbers = 223,
      icubcBlockCombiningDiacriticalMarksExtended = 224, icubcBlockDuployan = 225, icubcBlockElbasan = 226, icubcBlockGeometricShapesExtended = 227, icubcBlockGrantha = 228, icubcBlockKhojki = 229,
      icubcBlockKhudawadi = 230, icubcBlockLatinExtendedE = 231, icubcBlockLinearA = 232, icubcBlockMahajani = 233, icubcBlockManichaean = 234, icubcBlockMendeKikakui = 235, icubcBlockModi = 236,
      icubcBlockMro = 237, icubcBlockMyanmarExtendedB = 238, icubcBlockNabataean = 239, icubcBlockOldNorthArabian = 240, icubcBlockOldPermic = 241, icubcBlockOrnamentalDingbats = 242,
      icubcBlockPahawhHmong = 243, icubcBlockPalmyrene = 244, icubcBlockPauCinHau = 245, icubcBlockPsalterPahlavi = 246, icubcBlockShorthandFormatControls = 247, icubcBlockSiddham = 248,
      icubcBlockSinhalaArchaicNumbers = 249, icubcBlockSupplementalArrowsC = 250, icubcBlockTirhuta = 251, icubcBlockWarangCiti = 252, icubcBlockAhom = 253, icubcBlockAnatolianHieroglyphs = 254,
      icubcBlockCherokeeSupplement = 255, icubcBlockCjkUnifiedIdeographsExtensionE = 256, icubcBlockEarlyDynasticCuneiform = 257, icubcBlockHatran = 258, icubcBlockMultani = 259,
      icubcBlockOldHungarian = 260, icubcBlockSupplementalSymbolsAndPictographs = 261, icubcBlockSuttonSignwriting = 262, icubcBlockAdlam = 263, icubcBlockBhaiksuki = 264,
      icubcBlockCyrillicExtendedC = 265, icubcBlockGlagoliticSupplement = 266, icubcBlockIdeographicSymbolsAndPunctuation = 267, icubcBlockMarchen = 268, icubcBlockMongolianSupplement = 269,
      icubcBlockNewa = 270, icubcBlockOsage = 271, icubcBlockTangut = 272, icubcBlockTangutComponents = 273, icubcBlockCjkUnifiedIdeographsExtensionF = 274, icubcBlockKanaExtendedA = 275,
      icubcBlockMasaramGondi = 276, icubcBlockNushu = 277, icubcBlockSoyombo = 278, icubcBlockSyriacSupplement = 279, icubcBlockZanabazarSquare = 280, icubcBlockChessSymbols = 281,
      icubcBlockDogra = 282, icubcBlockGeorgianExtended = 283, icubcBlockGunjalaGondi = 284, icubcBlockHanifiRohingya = 285, icubcBlockIndicSiyaqNumbers = 286, icubcBlockMakasar = 287,
      icubcBlockMayanNumerals = 288, icubcBlockMedefaidrin = 289, icubcBlockOldSogdian = 290, icubcBlockSogdian = 291, icubcBlockEgyptianHieroglyphFormatControls = 292, icubcBlockElymaic = 293,
      icubcBlockNandinagari = 294, icubcBlockNyiakengPuachueHmong = 295, icubcBlockOttomanSiyaqNumbers = 296, icubcBlockSmallKanaExtension = 297, icubcBlockSymbolsAndPictographsExtendedA = 298,
      icubcBlockTamilSupplement = 299, icubcBlockWancho = 300, icubcBlockChorasmian = 301, icubcBlockCjkUnifiedIdeographsExtensionG = 302, icubcBlockDivesAkuru = 303,
      icubcBlockKhitanSmallScript = 304, icubcBlockLisuSupplement = 305, icubcBlockSymbolsForLegacyComputing = 306, icubcBlockTangutSupplement = 307, icubcBlockYezidi = 308, //
      icubcBlockCount = 309, // deprecated
      icubcBlockInvalidCode = -1);

   TICUEastAsianWidth = (icueawEaNeutral, icueawEaAmbiguous, icueawEaHalfwidth, icueawEaFullwidth, icueawEaNarrow, icueawEaWide, //
      icueawEaCount // deprecated
      );

   TICUCharNameChoice = (icucncUnicodeCharName, //
      icucncUnicode10CharName,                  // deprecated
      icucncExtendedCharName = icucncUnicodeCharName + 2, icucncCharNameAlias, //
      icucncCharNameChoiceCount // deprecated
      );

   TICUPropertyNameChoice = (icupncShortPropertyName, icupncLongPropertyName, //
      icupncPropertyNameChoiceCount // deprecated
      );

   TICUPropertyHelper = Record Helper For TICUProperty
   Public
      Function HasBinaryProperty(Const AC: TICUChar32): Boolean; Inline;
      Function GetIntPropertyValue(Const AC: TICUChar32): Integer; Inline;
      Function GetIntPropertyMinValue: Integer; Inline;
      Function GetIntPropertyMaxValue: Integer; Inline;
      Function GetIntPropertyMap: TICUCPMap; Inline;
      Function GetPropertyName(Const ANameChoice: TICUPropertyNameChoice): AnsiString; Inline;
      Class Function GetPropertyEnum(Const AAlias: AnsiString): TICUProperty; Static; Inline;
      Function GetPropertyValueName(Const AValue: Integer; Const ANameChoice: TICUPropertyNameChoice): AnsiString; Inline;
      Function GetPropertyValueEnum(Const AAlias: AnsiString): Integer; Inline;
   End;

   TICUDecompositionType = (icudtDtNone, icudtDtCanonical, icudtDtCompat, icudtDtCircle, icudtDtFinal, icudtDtFont, icudtDtFraction, icudtDtInitial, icudtDtIsolated, icudtDtMedial, icudtDtNarrow,
      icudtDtNobreak, icudtDtSmall, icudtDtSquare, icudtDtSub, icudtDtSuper, icudtDtVertical, icudtDtWide, //
      icudtDtCount // deprecated
      );

   TICUJoiningType = (icujtJtNonJoining, icujtJtJoinCausing, icujtJtDualJoining, icujtJtLeftJoining, icujtJtRightJoining, icujtJtTransparent, //
      icujtJtCount // deprecated
      );

   TICUJoiningGroup = (icujgJgNoJoiningGroup, icujgJgAin, icujgJgAlaph, icujgJgAlef, icujgJgBeh, icujgJgBeth, icujgJgDal, icujgJgDalathRish, icujgJgE, icujgJgFeh, icujgJgFinalSemkath, icujgJgGaf,
      icujgJgGamal, icujgJgHah, icujgJgTehMarbutaGoal, icujgJgHamzaOnHehGoal = icujgJgTehMarbutaGoal, icujgJgHe, icujgJgHeh, icujgJgHehGoal, icujgJgHeth, icujgJgKaf, icujgJgKaph, icujgJgKnottedHeh,
      icujgJgLam, icujgJgLamadh, icujgJgMeem, icujgJgMim, icujgJgNoon, icujgJgNun, icujgJgPe, icujgJgQaf, icujgJgQaph, icujgJgReh, icujgJgReversedPe, icujgJgSad, icujgJgSadhe, icujgJgSeen,
      icujgJgSemkath, icujgJgShin, icujgJgSwashKaf, icujgJgSyriacWaw, icujgJgTah, icujgJgTaw, icujgJgTehMarbuta, icujgJgTeth, icujgJgWaw, icujgJgYeh, icujgJgYehBarree, icujgJgYehWithTail, icujgJgYudh,
      icujgJgYudhHe, icujgJgZain, icujgJgFe, icujgJgKhaph, icujgJgZhain, icujgJgBurushaskiYehBarree, icujgJgFarsiYeh, icujgJgNya, icujgJgRohingyaYeh, icujgJgManichaeanAleph, icujgJgManichaeanAyin,
      icujgJgManichaeanBeth, icujgJgManichaeanDaleth, icujgJgManichaeanDhamedh, icujgJgManichaeanFive, icujgJgManichaeanGimel, icujgJgManichaeanHeth, icujgJgManichaeanHundred, icujgJgManichaeanKaph,
      icujgJgManichaeanLamedh, icujgJgManichaeanMem, icujgJgManichaeanNun, icujgJgManichaeanOne, icujgJgManichaeanPe, icujgJgManichaeanQoph, icujgJgManichaeanResh, icujgJgManichaeanSadhe,
      icujgJgManichaeanSamekh, icujgJgManichaeanTaw, icujgJgManichaeanTen, icujgJgManichaeanTeth, icujgJgManichaeanThamedh, icujgJgManichaeanTwenty, icujgJgManichaeanWaw, icujgJgManichaeanYodh,
      icujgJgManichaeanZayin, icujgJgStraightWaw, icujgJgAfricanFeh, icujgJgAfricanNoon, icujgJgAfricanQaf, icujgJgMalayalamBha, icujgJgMalayalamJa, icujgJgMalayalamLla, icujgJgMalayalamLlla,
      icujgJgMalayalamNga, icujgJgMalayalamNna, icujgJgMalayalamNnna, icujgJgMalayalamNya, icujgJgMalayalamRa, icujgJgMalayalamSsa, icujgJgMalayalamTta, icujgJgHanifiRohingyaKinnaYa,
      icujgJgHanifiRohingyaPa, //
      icujgJgCount             // deprecated
      );

   TICUGraphemeClusterBreak = (icugcbGcbOther = 0, icugcbGcbControl = 1, icugcbGcbCr = 2, icugcbGcbExtend = 3, icugcbGcbL = 4, icugcbGcbLf = 5, icugcbGcbLv = 6, icugcbGcbLvt = 7, icugcbGcbT = 8,
      icugcbGcbV = 9, icugcbGcbSpacingMark = 10, icugcbGcbPrepend = 11, icugcbGcbRegionalIndicator = 12, icugcbGcbEBase = 13, icugcbGcbEBaseGaz = 14, icugcbGcbEModifier = 15,
      icugcbGcbGlueAfterZwj = 16, icugcbGcbZwj = 17, //
      icugcbGcbCount = 18                            // deprecated
      );

   TICUWordBreakValues = (icuwbvWbOther = 0, icuwbvWbAletter = 1, icuwbvWbFormat = 2, icuwbvWbKatakana = 3, icuwbvWbMidletter = 4, icuwbvWbMidnum = 5, icuwbvWbNumeric = 6, icuwbvWbExtendnumlet = 7,
      icuwbvWbCr = 8, icuwbvWbExtend = 9, icuwbvWbLf = 10, icuwbvWbMidnumlet = 11, icuwbvWbNewline = 12, icuwbvWbRegionalIndicator = 13, icuwbvWbHebrewLetter = 14, icuwbvWbSingleQuote = 15,
      icuwbvWbDoubleQuote = 16, icuwbvWbEBase = 17, icuwbvWbEBaseGaz = 18, icuwbvWbEModifier = 19, icuwbvWbGlueAfterZwj = 20, icuwbvWbZwj = 21, icuwbvWbWsegspace = 22, //
      icuwbvWbCount = 23 // deprecated
      );

   TICUSentenceBreak = (icusbSbOther = 0, icusbSbAterm = 1, icusbSbClose = 2, icusbSbFormat = 3, icusbSbLower = 4, icusbSbNumeric = 5, icusbSbOletter = 6, icusbSbSep = 7, icusbSbSp = 8,
      icusbSbSterm = 9, icusbSbUpper = 10, icusbSbCr = 11, icusbSbExtend = 12, icusbSbLf = 13, icusbSbScontinue = 14, //
      icusbSbCount = 15 // deprecated
      );

   TICULineBreak = (iculbLbUnknown = 0, iculbLbAmbiguous = 1, iculbLbAlphabetic = 2, iculbLbBreakBoth = 3, iculbLbBreakAfter = 4, iculbLbBreakBefore = 5, iculbLbMandatoryBreak = 6,
      iculbLbContingentBreak = 7, iculbLbClosePunctuation = 8, iculbLbCombiningMark = 9, iculbLbCarriageReturn = 10, iculbLbExclamation = 11, iculbLbGlue = 12, iculbLbHyphen = 13,
      iculbLbIdeographic = 14, iculbLbInseparable = 15, iculbLbInseperable = iculbLbInseparable, iculbLbInfixNumeric = 16, iculbLbLineFeed = 17, iculbLbNonstarter = 18, iculbLbNumeric = 19,
      iculbLbOpenPunctuation = 20, iculbLbPostfixNumeric = 21, iculbLbPrefixNumeric = 22, iculbLbQuotation = 23, iculbLbComplexContext = 24, iculbLbSurrogate = 25, iculbLbSpace = 26,
      iculbLbBreakSymbols = 27, iculbLbZwspace = 28, iculbLbNextLine = 29, iculbLbWordJoiner = 30, iculbLbH2 = 31, iculbLbH3 = 32, iculbLbJl = 33, iculbLbJt = 34, iculbLbJv = 35,
      iculbLbCloseParenthesis = 36, iculbLbConditionalJapaneseStarter = 37, iculbLbHebrewLetter = 38, iculbLbRegionalIndicator = 39, iculbLbEBase = 40, iculbLbEModifier = 41, iculbLbZwj = 42, //
      iculbLbCount = 43 // deprecated
      );

   TICUNumericType = (icuntNtNone, icuntNtDecimal, icuntNtDigit, icuntNtNumeric, //
      icuntNtCount // deprecated
      );

   TICUHangulSyllableType = (icuhstHstNotApplicable, icuhstHstLeadingJamo, icuhstHstVowelJamo, icuhstHstTrailingJamo, icuhstHstLvSyllable, icuhstHstLvtSyllable, //
      icuhstHstCount // deprecated
      );

   TICUIndicPositionalCategory = (icuipcInpcNa, icuipcInpcBottom, icuipcInpcBottomAndLeft, icuipcInpcBottomAndRight, icuipcInpcLeft, icuipcInpcLeftAndRight, icuipcInpcOverstruck, icuipcInpcRight,
      icuipcInpcTop, icuipcInpcTopAndBottom, icuipcInpcTopAndBottomAndRight, icuipcInpcTopAndLeft, icuipcInpcTopAndLeftAndRight, icuipcInpcTopAndRight, icuipcInpcVisualOrderLeft,
      icuipcInpcTopAndBottomAndLeft);

   TICUIndicSyllabicCategory = (icuiscInscOther, icuiscInscAvagraha, icuiscInscBindu, icuiscInscBrahmiJoiningNumber, icuiscInscCantillationMark, icuiscInscConsonant, icuiscInscConsonantDead,
      icuiscInscConsonantFinal, icuiscInscConsonantHeadLetter, icuiscInscConsonantInitialPostfixed, icuiscInscConsonantKiller, icuiscInscConsonantMedial, icuiscInscConsonantPlaceholder,
      icuiscInscConsonantPrecedingRepha, icuiscInscConsonantPrefixed, icuiscInscConsonantSubjoined, icuiscInscConsonantSucceedingRepha, icuiscInscConsonantWithStacker, icuiscInscGeminationMark,
      icuiscInscInvisibleStacker, icuiscInscJoiner, icuiscInscModifyingLetter, icuiscInscNonJoiner, icuiscInscNukta, icuiscInscNumber, icuiscInscNumberJoiner, icuiscInscPureKiller,
      icuiscInscRegisterShifter, icuiscInscSyllableModifier, icuiscInscToneLetter, icuiscInscToneMark, icuiscInscVirama, icuiscInscVisarga, icuiscInscVowel, icuiscInscVowelDependent,
      icuiscInscVowelIndependent);

   TICUVerticalOrientation = (icuvoVoRotated, icuvoVoTransformedRotated, icuvoVoTransformedUpright, icuvoVoUpright);

Const
   cICUNoNumericValue = Double( -123456789);

Type
   TICUCharEnumTypeRange = Function(Const AContext; Const AStart, ALimit: TICUChar32; Const AType: TICUCharCategory): ByteBool; Cdecl;

   TICUEnumCharNamesFn = Function(Var Context; Const ACode: TICUChar32; Const ANameChoice: TICUCharNameChoice; Const AName: PAnsiChar; Const ALength: Integer): ByteBool; Cdecl;

   TICUCharHelper = Record Helper For TICUChar32
   Public
      Function HasBinaryProperty(Const AWhich: TICUProperty): Boolean; Inline;
      Function IsUAlphabetic: Boolean; Inline;
      Function IsULowercase: Boolean; Inline;
      Function IsUUppercase: Boolean; Inline;
      Function IsUWhitespace: Boolean; Inline;
      Function GetIntPropertyValue(Const AWhich: TICUProperty): Integer; Inline;
      Function GetNumericValue: Double; Inline;
      Function IsLower: Boolean; Inline;
      Function IsUpper: Boolean; Inline;
      Function IsTitle: Boolean; Inline;
      Function IsDigit: Boolean; Inline;
      Function IsAlpha: Boolean; Inline;
      Function IsAlNum: Boolean; Inline;
      Function IsXDigit: Boolean; Inline;
      Function IsPunct: Boolean; Inline;
      Function IsGraph: Boolean; Inline;
      Function IsBlank: Boolean; Inline;
      Function IsDefined: Boolean; Inline;
      Function IsSpace: Boolean; Inline;
      Function IsJavaSpaceChar: Boolean; Inline;
      Function IsWhitespace: Boolean; Inline;
      Function IsCntrl: Boolean; Inline;
      Function IsISOControl: Boolean; Inline;
      Function IsPrint: Boolean; Inline;
      Function IsBase: Boolean; Inline;
      Function CharDirection: TICUCharDirection; Inline;
      Function IsMirrored: Boolean; Inline;
      Function CharMirror: TICUChar32; Inline;
      Function GetBidiPairedBracket: TICUChar32; Inline;
      Function CharType: TICUCharCategory; Inline;
      Class Procedure EnumCharTypes(Const AEnumRange: TICUCharEnumTypeRange; Const AContext); Static; Inline;
      Function GetCombiningClass: ShortInt; Inline;
      Function CharDigitValue: Integer; Inline;
      Function BlockGetCode: TICUBlockCode; Inline;
      Function CharName(Const ANameChoice: TICUCharNameChoice): AnsiString; Inline;
      Function GetISOComment: AnsiString; Deprecated; Inline;
      Class Function CharFromName(Const ANameChoice: TICUCharNameChoice; Const AName: AnsiString): TICUChar32; Static; Inline;
      Class Procedure EnumCharNames(Const AStart, ALimit: TICUChar32; Const AFn: TICUEnumCharNamesFn; Var Context; Const ANameChoice: TICUCharNameChoice); Static; Inline;
      Function IsIDStart: Boolean; Inline;
      Function IsIDPart: Boolean; Inline;
      Function IsIDIgnorable: Boolean; Inline;
      Function IsJavaIDStart: Boolean; Inline;
      Function IsJavaIDPart: Boolean; Inline;
      Function ToLower: TICUChar32; Inline;
      Function ToUpper: TICUChar32; Inline;
      Function ToTitle: TICUChar32; Inline;
      Function FoldCase(Const AOptions: Cardinal): TICUChar32; Inline;
      Function Digit(Const ARadix: ShortInt): Integer; Inline;
      Class Function ForDigit(Const ADigit: Integer; Const ARadix: ShortInt): TICUChar32; Static; Inline;
      Function CharAge: TICUVersionInfo; Inline;
      Function GetFC_NFKC_Closure: UnicodeString; Inline;
   End;
{$ENDREGION}
{$REGION 'utext.h'}

   PICUText = ^TICUText;

   PICUTextFuncs = ^TICUTextFuncs;

   TICUText = Record
   Strict Private
{$HINTS OFF}
      FMagic: Cardinal;
      FFlags: Integer;
   Private
      FProviderProperties, FSizeOfStruct: Integer;
      FChunkNativeLimit:                  Int64;
      FExtraSize, FNativeIndexingLimit:   Integer;
      FChunkNativeStart:                  Int64;
      FChunkOffset, FChunkLength:         Integer;
      FChunkContents:                     PWideChar;
      FPFuncs:                            PICUTextFuncs;
      FPExtra, FContext, FP, FQ, FR:      Pointer;
   Strict Private
      FPrivP: Pointer;
   Private
      FA:     Int64;
      FB, FC: Integer;
   Strict Private
      FPrivA:         Int64;
      FPrivB, FPrivC: Integer;
{$HINTS ON}
   Public
      Procedure Destroy; Inline;
      Class Function CreateUTF8(Const &AS: AnsiString): PICUText; Static; Inline;
      Procedure OpenUTF8(Const &AS: AnsiString); Inline;
      Class Function CreateUChars(Const &AS: UnicodeString): PICUText; Static; Inline;
      Procedure OpenUChars(Const &AS: UnicodeString); Inline;
      Function Clone(Const ADeep, AReadOnly: Boolean): PICUText; Inline;
      Procedure CloneInto(Var ATo: TICUText; Const ADeep, AReadOnly: Boolean); Inline;
      Class Operator Equal([Ref] Const AA, AB: TICUText): Boolean; Inline;
      Function NativeLength: Int64; Inline;
      Function IsLengthExpensive: Boolean; Inline;
      Function Char32At(Const ANativeIndex: Int64): TICUChar32; Inline;
      Function Current32: TICUChar32; Inline;
      Function Next32: TICUChar32; Inline;
      Function Previous32: TICUChar32; Inline;
      Function Next32From(Const ANativeIndex: Int64): TICUChar32; Inline;
      Function Previous32From(Const ANativeIndex: Int64): TICUChar32; Inline;
      Function GetNativeIndex: Int64; Inline;
      Procedure SetNativeIndex(Const ANativeIndex: Int64); Inline;
      Function MoveIndex32(Const ADelta: Integer): Boolean; Inline;
      Function GetPreviousNativeIndex: Int64; Inline;
      Function Extract(Const ANativeStart, ANativeLimit: Int64): UnicodeString; Inline;
      Function IsWritable: Boolean; Inline;
      Function HasMetaData: Boolean; Inline;
      Procedure Replace(Const ANativeStart, ANativeLimit: Int64; Const AReplacementText: UnicodeString); Inline;
      Procedure Copy(Const ANativeStart, ANativeLimit, ADestIndex: Int64; Const AMove: Boolean); Inline;
      Procedure Freeze; Inline;
      Procedure Setup(Const AExtraSpace: Integer); Inline;
      Class Function Create(Const AExtraSpace: Integer): PICUText; Static; Inline;

      Function InlineCurrent32: TICUChar32; Inline;
      Function InlineNext32: TICUChar32; Inline;
      Function InlinePrevious32: TICUChar32; Inline;
      Function InlineGetNativeIndex: Int64; Inline;
      Procedure InlineSetNativeIndex(Const ANativeIndex: Int64); Inline;
   End;

   TICUTextHelper = Record Helper For TICUText
   Private Const
      cMagic = $345AD82C;
   Public Const
      cInitializater: TICUText = (FMagic: cMagic; FFlags: 0; FProviderProperties: 0; FSizeOfStruct: SizeOf(TICUText); FChunkNativeLimit: 0; FExtraSize: 0; FNativeIndexingLimit: 0;
         FChunkNativeStart: 0; FChunkOffset: 0; FChunkLength: 0; FChunkContents: NIL; FPFuncs: NIL; FPExtra: NIL; FContext: NIL; FP: NIL; FQ: NIL; FR: NIL; FPrivP: NIL; FA: 0; FB: 0; FC: 0; FPrivA: 0;
         FPrivB: 0; FPrivC: 0);
   End;

   TICUTextFuncs = Record
   Public Type
      TICUTextClone        = Function(Dest: PICUText; Const ASrc: PICUText; Const ADeep: ByteBool; Out OErrorCode: TICUErrorCode): PICUText; Cdecl;
      TICUTextNativeLength = Function(UT: PICUText): Int64; Cdecl;
      TICUTextAccess       = Function(UT: PICUText; Const ANativeIndex: Int64; Const AForward: ByteBool): ByteBool; Cdecl;
      TICUTextExtract      = Function(UT: PICUText; Const ANativeStart, ANativeLimit: Int64; Dest: PWideChar; Const ADestCapacity: Integer; Out OStatus: TICUErrorCode): Integer; Cdecl;
      TICUTextReplace      = Function(UT: PICUText; Const ANativeStart, ANativeLimit: Int64; Const AReplacementText: PWideChar; Const AReplacementLength: Integer; Out OStatus: TICUErrorCode)
         : Integer; Cdecl;
      TICUTextCopy                  = Procedure(UT: PICUText; Const ANativeStart, ANativeLimit, ADestIndex: Int64; Const AMove: ByteBool; Out OStatus: TICUErrorCode); Cdecl;
      TICUTextMapOffsetToNative     = Function([Ref] Const AUT: TICUText): Int64; Cdecl;
      TICUTextMapNativeIndexToUTF16 = Function([Ref] Const AUT: TICUText; Const ANativeIndex: Int64): Integer; Cdecl;
      TICUTextClose                 = Procedure(UT: PICUText); Cdecl;

   Var
      TableSize: Integer;
   Strict Private
{$HINTS OFF}
      Reserved1, Reserved2, Reserved3: Integer;
{$HINTS ON}
   Public
      Clone:                 TICUTextClone;
      NativeLength:          TICUTextNativeLength;
      Access:                TICUTextAccess;
      Extract:               TICUTextExtract;
      Replace:               TICUTextReplace;
      Copy:                  TICUTextCopy;
      MapOffsetToNative:     TICUTextMapOffsetToNative;
      MapNativeIndexToUTF16: TICUTextMapNativeIndexToUTF16;
      Close:                 TICUTextClose;
   Strict Private
{$HINTS OFF}
      Spare1, Spare2, Spare3: TICUTextClose;
{$HINTS ON}
   End;
{$ENDREGION}
{$REGION 'parseerr.h'}

   TICUParseError = Record
   Public Const
      cParseContextLen = 16;

   Var
      Line, Offset:            Integer;
      PreContext, PostContext: Array [0 .. cParseContextLen - 1] Of WideChar;
   End;
{$ENDREGION}
{$REGION 'ubrk.h'}

   TICUBreakIteratorType = (icubitCharacter, icubitWord, icubitLine, icubitSentence, //
      icubitTitle, // deprecated
      icubitCount // deprecated
      );

   TICUWordBreak = (icuwbBrkWordNone = 0, icuwbBrkWordNoneLimit = 100, icuwbBrkWordNumber = 100, icuwbBrkWordNumberLimit = 200, icuwbBrkWordLetter = 200, icuwbBrkWordLetterLimit = 300,
      icuwbBrkWordKana = 300, icuwbBrkWordKanaLimit = 400, icuwbBrkWordIdeo = 400, icuwbBrkWordIdeoLimit = 500);
   TICULineBreakTag     = (iculbtBrkLineSoft = 0, iculbtBrkLineSoftLimit = 100, iculbtBrkLineHard = 100, iculbtBrkLineHardLimit = 200);
   TICUSentenceBreakTag = (icusbtBrkSentenceTerm = 0, icusbtBrkSentenceTermLimit = 100, icusbtBrkSentenceSep = 100, icusbtBrkSentenceSepLimit = 200);

   TICUBreakIterator = Record
   Strict Private
{$HINTS OFF}
      FData: Pointer;
{$HINTS ON}
   Public Const
      cBrkDone = Integer( -1);

      Class Function Create(Const AType: TICUBreakIteratorType; Const ALocale: TICULocale; Const AText: UnicodeString): TICUBreakIterator; Static; Inline;
      Class Function CreateRules(Const ARules, AText: UnicodeString; Out OParseErr: TICUParseError): TICUBreakIterator; Static; Inline;
      Class Function CreateBinaryRules(Const ABinaryRules: TBytes; Const AText: UnicodeString): TICUBreakIterator; Static; Inline;
      Function SafeClone: TICUBreakIterator; Deprecated; Inline;
      Function Clone: TICUBreakIterator; Experimental; Inline;
      Procedure Destroy; Inline;
      Procedure SetText(Const AText: UnicodeString); Inline;
      Procedure SetUText(Var Text: TICUText); Inline;
      Function Current: Integer; Inline;
      Function Next: Integer; Inline;
      Function Previous: Integer; Inline;
      Function First: Integer; Inline;
      Function Last: Integer; Inline;
      Function Preceding(Const AOffset: Integer): Integer; Inline;
      Function Following(Const AOffset: Integer): Integer; Inline;
      Class Function GetAvailable(Const AIndex: Integer): AnsiString; Static; Inline;
      Class Function CountAvailable: Integer; Static; Inline;
      Function IsBoundary(Const AOffset: Integer): Boolean; Inline;
      Function GetRuleStatus: Integer; Inline;
      Function GetRuleStatusVec: TArray<Integer>; Inline;
      Function GetLocaleByType(Const AType: TICULocaleDataType): TICULocale; Inline;
      Procedure RefreshUText(Var Text: TICUText); Inline;
      Function GetBinaryRules: TBytes; Inline;
   End;
{$ENDREGION}

//

{$REGION 'uversion.h'}

Procedure ICUversionFromString(Out OVersionArray: TICUVersionInfo; Const AVersionString: PAnsiChar); Cdecl; External ICUDLLcommon Name 'u_versionFromString' + ICUDLLsuffix;
Procedure ICUversionFromUString(Out OVersionArray: TICUVersionInfo; Const AVersionString: PWideChar); Cdecl; External ICUDLLcommon Name 'u_versionFromStringU' + ICUDLLsuffix;
Procedure ICUversionToString([Ref] Const AVersionArray: TICUVersionInfo; VersionString: PAnsiChar); Cdecl; External ICUDLLcommon Name 'u_versionToString' + ICUDLLsuffix;
Procedure ICUgetVersion(Out OVersionArray: TICUVersionInfo); Cdecl; External ICUDLLcommon Name 'u_getVersion' + ICUDLLsuffix;
{$ENDREGION}
{$REGION 'utypes.h'}
Function ICUerrorName(Const AUErrorCode: TICUErrorCode): PAnsiChar; Cdecl; External ICUDLLcommon Name 'u_errorName' + ICUDLLsuffix;
{$ENDREGION}
{$REGION 'uenum.h'}
Procedure ICUenum_close(En: TICUEnumeration); Cdecl; External ICUDLLcommon Name 'uenum_close' + ICUDLLsuffix;
Function ICUenum_count(Const AEn: TICUEnumeration; Out OStatus: TICUErrorCode): Integer; Cdecl; External ICUDLLcommon Name 'uenum_count' + ICUDLLsuffix;
Function ICUenum_unext(En: TICUEnumeration; Out OResultLength: Integer; Out OStatus: TICUErrorCode): PWideChar; Cdecl; External ICUDLLcommon Name 'uenum_unext' + ICUDLLsuffix;
Function ICUenum_next(En: TICUEnumeration; Out OResultLength: Integer; Out OStatus: TICUErrorCode): PAnsiChar; Cdecl; External ICUDLLcommon Name 'uenum_next' + ICUDLLsuffix;
Procedure ICUenum_reset(En: TICUEnumeration; Out OStatus: TICUErrorCode); Cdecl; External ICUDLLcommon Name 'uenum_reset' + ICUDLLsuffix;
Function ICUenum_openUCharStringsEnumeration(Const AStrings: PPWideChar; Const ACount: Integer; Out OEc: TICUErrorCode): TICUEnumeration; Cdecl;
   External ICUDLLcommon Name 'uenum_openUCharStringsEnumeration' + ICUDLLsuffix;
Function ICUenum_openCharStringsEnumeration(Const AStrings: PPAnsiChar; Const ACount: Integer; Out OEc: TICUErrorCode): TICUEnumeration; Cdecl;
   External ICUDLLcommon Name 'uenum_openCharStringsEnumeration' + ICUDLLsuffix;
{$ENDREGION}
{$REGION 'uloc.h'}
Function ICUloc_getDefault: PAnsiChar; Cdecl; External ICUDLLcommon Name 'uloc_getDefault' + ICUDLLsuffix;
Procedure ICUloc_setDefault(Const ALocaleID: PAnsiChar; Out OStatus: TICUErrorCode); Cdecl; External ICUDLLcommon Name 'uloc_setDefault' + ICUDLLsuffix;
Function ICUloc_getLanguage(Const ALocaleID: PAnsiChar; Language: PAnsiChar; Const ALanguageCapacity: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_getLanguage' + ICUDLLsuffix;
Function ICUloc_getScript(Const ALocaleID: PAnsiChar; Script: PAnsiChar; Const AScriptCapacity: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_getScript' + ICUDLLsuffix;
Function ICUloc_getCountry(Const ALocaleID: PAnsiChar; Country: PAnsiChar; Const ACountryCapacity: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_getCountry' + ICUDLLsuffix;
Function ICUloc_getVariant(Const ALocaleID: PAnsiChar; Variant: PAnsiChar; Const AVariantCapacity: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_getVariant' + ICUDLLsuffix;
Function ICUloc_getName(Const ALocaleID: PAnsiChar; Name: PAnsiChar; Const ANameCapacity: Integer; Out OErr: TICUErrorCode): Integer; Cdecl; External ICUDLLcommon Name 'uloc_getName' + ICUDLLsuffix;
Function ICUloc_canonicalize(Const ALocaleID: PAnsiChar; Name: PAnsiChar; Const ANameCapacity: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_canonicalize' + ICUDLLsuffix;
Function ICUloc_getISO3Language(Const ALocaleID: PAnsiChar): PAnsiChar; Cdecl; External ICUDLLcommon Name 'uloc_getISO3Language' + ICUDLLsuffix;
Function ICUloc_getISO3Country(Const ALocaleID: PAnsiChar): PAnsiChar; Cdecl; External ICUDLLcommon Name 'uloc_getISO3Country' + ICUDLLsuffix;
Function ICUloc_getLCID(Const ALocaleID: PAnsiChar): Integer; Cdecl; External ICUDLLcommon Name 'uloc_getLCID' + ICUDLLsuffix;
Function ICUloc_getDisplayLanguage(Const ALocaleID, ADisplayLocale: PAnsiChar; Language: PWideChar; Const ALanguageCapacity: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_getDisplayLanguage' + ICUDLLsuffix;
Function ICUloc_getDisplayScript(Const ALocaleID, ADisplayLocale: PAnsiChar; Script: PWideChar; Const AScriptCapacity: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_getDisplayScript' + ICUDLLsuffix;
Function ICUloc_getDisplayCountry(Const ALocaleID, ADisplayLocale: PAnsiChar; Country: PWideChar; Const ACountryCapacity: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_getDisplayCountry' + ICUDLLsuffix;
Function ICUloc_getDisplayVariant(Const ALocaleID, ADisplayLocale: PAnsiChar; Variant: PWideChar; Const AVariantCapacity: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_getDisplayVariant' + ICUDLLsuffix;
Function ICUloc_getDisplayKeyword(Const AKeyword, ADisplayLocale: PAnsiChar; Dest: PWideChar; Const ADestCapacity: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_getDisplayKeyword' + ICUDLLsuffix;
Function ICUloc_getDisplayKeywordValue(Const ALocale, AKeyword, ADisplayLocale: PAnsiChar; Dest: PWideChar; Const ADestCapacity: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_getDisplayKeywordValue' + ICUDLLsuffix;
Function ICUloc_getDisplayName(Const ALocaleID, AInLocaleID: PAnsiChar; Result: PWideChar; Const AMaxResultSize: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_getDisplayName' + ICUDLLsuffix;
Function ICUloc_getAvailable(Const AN: Integer): PAnsiChar; Cdecl; External ICUDLLcommon Name 'uloc_getAvailable' + ICUDLLsuffix;
Function ICUloc_countAvailable: Integer; Cdecl; External ICUDLLcommon Name 'uloc_countAvailable' + ICUDLLsuffix;
Function ICUloc_openAvailableByType(Const AType: TICULocaleAvailableType; Out OStatus: TICUErrorCode): TICUEnumeration; Cdecl; External ICUDLLcommon Name 'uloc_openAvailableByType' + ICUDLLsuffix;
Function ICUloc_getISOLanguages: PPAnsiChar; Cdecl; External ICUDLLcommon Name 'uloc_getISOLanguages' + ICUDLLsuffix;
Function ICUloc_getISOCountries: PPAnsiChar; Cdecl; External ICUDLLcommon Name 'uloc_getISOCountries' + ICUDLLsuffix;
Function ICUloc_getParent(Const ALocaleID: PAnsiChar; Parent: PAnsiChar; Const AParentCapacity: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_getParent' + ICUDLLsuffix;
Function ICUloc_getBaseName(Const ALocaleID: PAnsiChar; Name: PAnsiChar; Const ANameCapacity: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_getBaseName' + ICUDLLsuffix;
Function ICUloc_openKeywords(Const ALocaleID: PAnsiChar; Out OStatus: TICUErrorCode): TICUEnumeration; Cdecl; External ICUDLLcommon Name 'uloc_openKeywords' + ICUDLLsuffix;
Function ICUloc_getKeywordValue(Const ALocaleID, AKeywordName: PAnsiChar; Buffer: PAnsiChar; Const ABufferCapacity: Integer; Out OStatus: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_getKeywordValue' + ICUDLLsuffix;
Function ICUloc_setKeywordValue(Const AKeywordName, AKeywordValue: PAnsiChar; Buffer: PAnsiChar; Const ABufferCapacity: Integer; Out OStatus: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_setKeywordValue' + ICUDLLsuffix;
Function ICUloc_isRightToLeft(Const ALocale: PAnsiChar): ByteBool; Cdecl; External ICUDLLcommon Name 'uloc_isRightToLeft' + ICUDLLsuffix;
Function ICUloc_getCharacterOrientation(Const ALocaleID: PAnsiChar; Out OStatus: TICUErrorCode): TICULayoutType; Cdecl; External ICUDLLcommon Name 'uloc_getCharacterOrientation' + ICUDLLsuffix;
Function ICUloc_getLineOrientation(Const ALocaleID: PAnsiChar; Out OStatus: TICUErrorCode): TICULayoutType; Cdecl; External ICUDLLcommon Name 'uloc_getLineOrientation' + ICUDLLsuffix;
Function ICUloc_acceptLanguageFromHTTP(Result: PAnsiChar; Const AResultAvailable: Integer; Out OResult: TICUAcceptResult; Const AHTTPAcceptLanguage: PAnsiChar;
   Const AAvailableLocales: TICUEnumeration; Out OStatus: TICUErrorCode): Integer; Cdecl; External ICUDLLcommon Name 'uloc_acceptLanguageFromHTTP' + ICUDLLsuffix;
Function ICUloc_acceptLanguage(Result: PAnsiChar; Const AResultAvailable: Integer; Out OResult: TICUAcceptResult; Const AAcceptList: PPAnsiChar; Const AAcceptListCount: Integer;
   Const AAvailableLocales: TICUEnumeration; Out OStatus: TICUErrorCode): Integer; Cdecl; External ICUDLLcommon Name 'uloc_acceptLanguage' + ICUDLLsuffix;
Function ICUloc_getLocaleForLCID(Const AHostID: Cardinal; Locale: PAnsiChar; Const ALocaleCapacity: Integer; Out OStatus: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_getLocaleForLCID' + ICUDLLsuffix;
Function ICUloc_addLikelySubtags(Const ALocaleID: PAnsiChar; MaximizedLocaleID: PAnsiChar; Const AMaximizedLocaleIDCapacity: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_addLikelySubtags' + ICUDLLsuffix;
Function ICUloc_minimizeSubtags(Const ALocaleID: PAnsiChar; MinimizedLocaleID: PAnsiChar; Const AMinimizedLocaleIDCapacity: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_minimizeSubtags' + ICUDLLsuffix;
Function ICUloc_forLanguageTag(Const ALangTag: PAnsiChar; LocaleID: PAnsiChar; Const ALocaleIDCapacity: Integer; Out OParsedLength: Integer; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_forLanguageTag' + ICUDLLsuffix;
Function ICUloc_toLanguageTag(Const ALocaleID: PAnsiChar; LangTag: PAnsiChar; Const ALangTagCapacity: Integer; Const AStrict: ByteBool; Out OErr: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'uloc_toLanguageTag' + ICUDLLsuffix;
Function ICUloc_toUnicodeLocaleKey(Const AKeyword: PAnsiChar): PAnsiChar; Cdecl; External ICUDLLcommon Name 'uloc_toUnicodeLocaleKey' + ICUDLLsuffix;
Function ICUloc_toUnicodeLocaleType(Const AKeyword, AValue: PAnsiChar): PAnsiChar; Cdecl; External ICUDLLcommon Name 'uloc_toUnicodeLocaleType' + ICUDLLsuffix;
Function ICUloc_toLegacyKey(Const AKeyword: PAnsiChar): PAnsiChar; Cdecl; External ICUDLLcommon Name 'uloc_toLegacyKey' + ICUDLLsuffix;
Function ICUloc_toLegacyType(Const AKeyword, AValue: PAnsiChar): PAnsiChar; Cdecl; External ICUDLLcommon Name 'uloc_toLegacyType' + ICUDLLsuffix;
{$ENDREGION}
{$REGION 'ucpmap.h'}
Function ICUcpmap_get(Const AMap: TICUCPMap; Const AC: TICUChar32): Cardinal; Cdecl; External ICUDLLcommon Name 'ucpmap_get' + ICUDLLsuffix;
Function ICUcpmap_getRange(Const AMap: TICUCPMap; Const AStart: TICUChar32; Const AOption: TICUCPMapRangeOption; Const ASurrogateValue: Cardinal; Const AFilter: TICUCPMapValueFilter; Const Context;
   Out OPValue: Cardinal): TICUChar32; Cdecl; External ICUDLLcommon Name 'ucpmap_getRange' + ICUDLLsuffix;
{$ENDREGION}
{$REGION 'uchar.h'}
Function ICUhasBinaryProperty(Const AC: TICUChar32; Const AWhich: TICUProperty): ByteBool; Cdecl; External ICUDLLcommon Name 'u_hasBinaryProperty' + ICUDLLsuffix;
Function ICUgetBinaryPropertySet(Const AProperty: TICUProperty; Var Error: TICUErrorCode): TICUSet; Cdecl; External ICUDLLcommon Name 'u_getBinaryPropertySet' + ICUDLLsuffix;
Function ICUisUAlphabetic(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isUAlphabetic' + ICUDLLsuffix;
Function ICUisULowercase(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isULowercase' + ICUDLLsuffix;
Function ICUisUUppercase(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isUUppercase' + ICUDLLsuffix;
Function ICUisUWhitespace(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isUWhitespace' + ICUDLLsuffix;
Function ICUgetIntPropertyValue(Const AC: TICUChar32; Const AWhich: TICUProperty): Integer; Cdecl; External ICUDLLcommon Name 'u_getIntPropertyValue' + ICUDLLsuffix;
Function ICUgetIntPropertyMinValue(Const AWhich: TICUProperty): Integer; Cdecl; External ICUDLLcommon Name 'u_getIntPropertyMinValue' + ICUDLLsuffix;
Function ICUgetIntPropertyMaxValue(Const AWhich: TICUProperty): Integer; Cdecl; External ICUDLLcommon Name 'u_getIntPropertyMaxValue' + ICUDLLsuffix;
Function ICUgetIntPropertyMap(Const AWhich: TICUProperty; Var ErrorCode: TICUErrorCode): TICUCPMap; Cdecl; External ICUDLLcommon Name 'u_getIntPropertyMap' + ICUDLLsuffix;
Function ICUgetNumericValue(Const AC: TICUChar32): Double; Cdecl; External ICUDLLcommon Name 'u_getNumericValue' + ICUDLLsuffix;
Function ICUislower(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_islower' + ICUDLLsuffix;
Function ICUisupper(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isupper' + ICUDLLsuffix;
Function ICUistitle(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_istitle' + ICUDLLsuffix;
Function ICUisdigit(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isdigit' + ICUDLLsuffix;
Function ICUisalpha(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isalpha' + ICUDLLsuffix;
Function ICUisalnum(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isalnum' + ICUDLLsuffix;
Function ICUisxdigit(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isxdigit' + ICUDLLsuffix;
Function ICUispunct(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_ispunct' + ICUDLLsuffix;
Function ICUisgraph(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isgraph' + ICUDLLsuffix;
Function ICUisblank(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isblank' + ICUDLLsuffix;
Function ICUisdefined(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isdefined' + ICUDLLsuffix;
Function ICUisspace(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isspace' + ICUDLLsuffix;
Function ICUisJavaSpaceChar(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isJavaSpaceChar' + ICUDLLsuffix;
Function ICUisWhitespace(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isWhitespace' + ICUDLLsuffix;
Function ICUiscntrl(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_iscntrl' + ICUDLLsuffix;
Function ICUisISOControl(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isISOControl' + ICUDLLsuffix;
Function ICUisprint(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isprint' + ICUDLLsuffix;
Function ICUisbase(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isbase' + ICUDLLsuffix;
Function ICUcharDirection(Const AC: TICUChar32): TICUCharDirection; Cdecl; External ICUDLLcommon Name 'u_charDirection' + ICUDLLsuffix;
Function ICUisMirrored(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isMirrored' + ICUDLLsuffix;
Function ICUcharMirror(Const AC: TICUChar32): TICUChar32; Cdecl; External ICUDLLcommon Name 'u_charMirror' + ICUDLLsuffix;
Function ICUgetBidiPairedBracket(Const AC: TICUChar32): TICUChar32; Cdecl; External ICUDLLcommon Name 'u_getBidiPairedBracket' + ICUDLLsuffix;
Function ICUcharType(Const AC: TICUChar32): TICUCharCategory; Cdecl; External ICUDLLcommon Name 'u_charType' + ICUDLLsuffix;
Procedure ICUenumCharTypes(Const AEnumRange: TICUCharEnumTypeRange; Const AContext); Cdecl; External ICUDLLcommon Name 'u_enumCharTypes' + ICUDLLsuffix;
Function ICUgetCombiningClass(Const AC: TICUChar32): ShortInt; Cdecl; External ICUDLLcommon Name 'u_getCombiningClass' + ICUDLLsuffix;
Function ICUcharDigitValue(Const AC: TICUChar32): Integer; Cdecl; External ICUDLLcommon Name 'u_charDigitValue' + ICUDLLsuffix;
Function ICUblock_getCode(Const AC: TICUChar32): TICUBlockCode; Cdecl; External ICUDLLcommon Name 'ublock_getCode' + ICUDLLsuffix;
Function ICUcharName(Const ACode: TICUChar32; Const ANameChoice: TICUCharNameChoice; Buffer: PAnsiChar; Const ABufferLength: Integer; Out OErrorCode: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'u_charName' + ICUDLLsuffix;
Function ICUgetISOComment(Const AC: TICUChar32; Dest: PAnsiChar; Const ADestCapacity: Integer; Out OErrorCode: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'u_getISOComment' + ICUDLLsuffix; Deprecated;
Function ICUcharFromName(Const ANameChoice: TICUCharNameChoice; Const AName: PAnsiChar; Out OErrorCode: TICUErrorCode): TICUChar32; Cdecl; External ICUDLLcommon Name 'u_charFromName' + ICUDLLsuffix;
Procedure ICUenumCharNames(Const AStart, ALimit: TICUChar32; Const AFn: TICUEnumCharNamesFn; Var Context; Const ANameChoice: TICUCharNameChoice; Var ErrorCode: TICUErrorCode); Cdecl;
   External ICUDLLcommon Name 'u_enumCharNames' + ICUDLLsuffix;
Function ICUgetPropertyName(Const AProperty: TICUProperty; Const ANameChoice: TICUPropertyNameChoice): PAnsiChar; Cdecl; External ICUDLLcommon Name 'u_getPropertyName' + ICUDLLsuffix;
Function ICUgetPropertyEnum(Const AAlias: PAnsiChar): TICUProperty; Cdecl; External ICUDLLcommon Name 'u_getPropertyEnum' + ICUDLLsuffix;
Function ICUgetPropertyValueName(Const AProperty: TICUProperty; Const AValue: Integer; Const ANameChoice: TICUPropertyNameChoice): PAnsiChar; Cdecl;
   External ICUDLLcommon Name 'u_getPropertyValueName' + ICUDLLsuffix;
Function ICUgetPropertyValueEnum(Const AProperty: TICUProperty; Const AAlias: PAnsiChar): Integer; Cdecl; External ICUDLLcommon Name 'u_getPropertyValueEnum' + ICUDLLsuffix;
Function ICUisIDStart(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isIDStart' + ICUDLLsuffix;
Function ICUisIDPart(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isIDPart' + ICUDLLsuffix;
Function ICUisIDIgnorable(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isIDIgnorable' + ICUDLLsuffix;
Function ICUisJavaIDStart(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isJavaIDStart' + ICUDLLsuffix;
Function ICUisJavaIDPart(Const AC: TICUChar32): ByteBool; Cdecl; External ICUDLLcommon Name 'u_isJavaIDPart' + ICUDLLsuffix;
Function ICUtolower(Const AC: TICUChar32): TICUChar32; Cdecl; External ICUDLLcommon Name 'u_tolower' + ICUDLLsuffix;
Function ICUtoupper(Const AC: TICUChar32): TICUChar32; Cdecl; External ICUDLLcommon Name 'u_toupper' + ICUDLLsuffix;
Function ICUtotitle(Const AC: TICUChar32): TICUChar32; Cdecl; External ICUDLLcommon Name 'u_totitle' + ICUDLLsuffix;
Function ICUfoldCase(Const AC: TICUChar32; Const AOptions: Cardinal): TICUChar32; Cdecl; External ICUDLLcommon Name 'u_foldCase' + ICUDLLsuffix;
Function ICUdigit(Const AC: TICUChar32; Const ARadix: ShortInt): Integer; Cdecl; External ICUDLLcommon Name 'u_digit' + ICUDLLsuffix;
Function ICUforDigit(Const ADigit: Integer; Const ARadix: ShortInt): TICUChar32; Cdecl; External ICUDLLcommon Name 'u_forDigit' + ICUDLLsuffix;
Procedure ICUcharAge(Const AC: TICUChar32; Var VersionArray: TICUVersionInfo); Cdecl; External ICUDLLcommon Name 'u_charAge' + ICUDLLsuffix;
Procedure ICUgetUnicodeVersion(Var VersionArray: TICUVersionInfo); Cdecl; External ICUDLLcommon Name 'u_getUnicodeVersion' + ICUDLLsuffix;
Function ICUgetFC_NFKC_Closure(Const AC: TICUChar32; Dest: PWideChar; Const ADestCapacity: Integer; Out OErrorCode: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'u_getFC_NFKC_Closure' + ICUDLLsuffix;
{$ENDREGION}
{$REGION 'utext.h'}
Function ICUtext_close(Var UT: TICUText): PICUText; Cdecl; External ICUDLLcommon Name 'utext_close' + ICUDLLsuffix;
Function ICUtext_openUTF8(Var UT: TICUText; Const &AS: PAnsiChar; Const ALength: Int64; Out OStatus: TICUErrorCode): PICUText; Cdecl; External ICUDLLcommon Name 'utext_openUTF8' + ICUDLLsuffix;
Function ICUtext_openUChars(Var UT: TICUText; Const &AS: PWideChar; Const ALength: Int64; Out OStatus: TICUErrorCode): PICUText; Cdecl; External ICUDLLcommon Name 'utext_openUTF8' + ICUDLLsuffix;
Function ICUtext_clone(Var UT: TICUText; [Ref] Const &ASrc: TICUText; Const ADeep, AReadOnly: ByteBool; Out OStatus: TICUErrorCode): PICUText; Cdecl;
   External ICUDLLcommon Name 'utext_clone' + ICUDLLsuffix;
Function ICUtext_equals([Ref] Const AA, AB: TICUText): ByteBool; Cdecl; External ICUDLLcommon Name 'utext_equals' + ICUDLLsuffix;
Function ICUtext_nativeLength(Var UT: TICUText): Int64; Cdecl; External ICUDLLcommon Name 'utext_nativeLength' + ICUDLLsuffix;
Function ICUtext_isLengthExpensive([Ref] Const AUT: TICUText): ByteBool; Cdecl; External ICUDLLcommon Name 'utext_isLengthExpensive' + ICUDLLsuffix;
Function ICUtext_char32At(Var UT: TICUText; Const ANativeIndex: Int64): TICUChar32; Cdecl; External ICUDLLcommon Name 'utext_char32At' + ICUDLLsuffix;
Function ICUtext_current32(Var UT: TICUText): TICUChar32; Cdecl; External ICUDLLcommon Name 'utext_current32' + ICUDLLsuffix;
Function ICUtext_next32(Var UT: TICUText): TICUChar32; Cdecl; External ICUDLLcommon Name 'utext_next32' + ICUDLLsuffix;
Function ICUtext_previous32(Var UT: TICUText): TICUChar32; Cdecl; External ICUDLLcommon Name 'utext_previous32' + ICUDLLsuffix;
Function ICUtext_next32From(Var UT: TICUText; Const ANativeIndex: Int64): TICUChar32; Cdecl; External ICUDLLcommon Name 'utext_next32From' + ICUDLLsuffix;
Function ICUtext_previous32From(Var UT: TICUText; Const ANativeIndex: Int64): TICUChar32; Cdecl; External ICUDLLcommon Name 'utext_previous32From' + ICUDLLsuffix;
Function ICUtext_getNativeIndex([Ref] Const UT: TICUText): Int64; Cdecl; External ICUDLLcommon Name 'utext_getNativeIndex' + ICUDLLsuffix;
Procedure ICUtext_setNativeIndex(Var UT: TICUText; Const ANativeIndex: Int64); Cdecl; External ICUDLLcommon Name 'utext_setNativeIndex' + ICUDLLsuffix;
Function ICUtext_moveIndex32(Var UT: TICUText; Const ADelta: Integer): ByteBool; Cdecl; External ICUDLLcommon Name 'utext_moveIndex32' + ICUDLLsuffix;
Function ICUtext_getPreviousNativeIndex(Var UT: TICUText): Int64; Cdecl; External ICUDLLcommon Name 'utext_getPreviousNativeIndex' + ICUDLLsuffix;
Function ICUtext_extract(Var UT: TICUText; Const ANativeStart, ANativeLimit: Int64; Dest: PWideChar; Const ADestCapacity: Integer; Out OStatus: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'utext_extract' + ICUDLLsuffix;
Function ICUtext_isWritable([Ref] Const UT: TICUText): ByteBool; Cdecl; External ICUDLLcommon Name 'utext_isWritable' + ICUDLLsuffix;
Function ICUtext_hasMetaData([Ref] Const UT: TICUText): ByteBool; Cdecl; External ICUDLLcommon Name 'utext_hasMetaData' + ICUDLLsuffix;
Function ICUtext_replace(Var UT: TICUText; Const ANativeStart, ANativeLimit: Int64; Const AReplacementText: PWideChar; Const AReplacementLength: Integer; Out OStatus: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'utext_replace' + ICUDLLsuffix;
Procedure ICUtext_copy(Var UT: TICUText; Const ANativeStart, ANativeLimit, ADestIndex: Int64; Const AMove: ByteBool; Out OStatus: TICUErrorCode); Cdecl;
   External ICUDLLcommon Name 'utext_copy' + ICUDLLsuffix;
Procedure ICUtext_freeze(Var UT: TICUText); Cdecl; External ICUDLLcommon Name 'utext_freeze' + ICUDLLsuffix;
Function ICUtext_setup(Var UT: TICUText; Const AExtraSpace: Integer; Out OErrorCode: TICUErrorCode): PICUText; Cdecl; External ICUDLLcommon Name 'utext_setup' + ICUDLLsuffix;
{$ENDREGION}
{$REGION 'ubrk.h'}
Function ICUbrk_open(Const AType: TICUBreakIteratorType; Const ALocale: PAnsiChar; Const AText: PWideChar; Const ATextLength: Integer; Out OStatus: TICUErrorCode): TICUBreakIterator; Cdecl;
   External ICUDLLcommon Name 'ubrk_open' + ICUDLLsuffix;
Function ICUbrk_openRules(Const ARules: PWideChar; Const ARulesLength: Integer; Const AText: PWideChar; Const ATextLength: Integer; Out OParseErr: TICUParseError; Out OStatus: TICUErrorCode)
   : TICUBreakIterator; Cdecl; External ICUDLLcommon Name 'ubrk_openRules' + ICUDLLsuffix;
Function ICUbrk_openBinaryRules(Const ABinaryRules: PByte; Const ARulesLength: Integer; Const AText: PWideChar; Const ATextLength: Integer; Out OStatus: TICUErrorCode): TICUBreakIterator; Cdecl;
   External ICUDLLcommon Name 'ubrk_openBinaryRules' + ICUDLLsuffix;
Function ICUbrk_safeClone(Const ABI: TICUBreakIterator; Const AStackBuffer; PBufferSize: PInteger; Out OStatus: TICUErrorCode): TICUBreakIterator; Cdecl;
   External ICUDLLcommon Name 'ubrk_safeClone' + ICUDLLsuffix; Deprecated;
Function ICUbrk_clone(Const ABI: TICUBreakIterator; Out OStatus: TICUErrorCode): TICUBreakIterator; Cdecl; External ICUDLLcommon Name 'ubrk_clone' + ICUDLLsuffix;
Experimental;
Procedure ICUbrk_close(BI: TICUBreakIterator); Cdecl; External ICUDLLcommon Name 'ubrk_close' + ICUDLLsuffix;
Procedure ICUbrk_setText(BI: TICUBreakIterator; Const AText: PWideChar; Const ATextLength: Integer; Out OStatus: TICUErrorCode); Cdecl; External ICUDLLcommon Name 'ubrk_setText' + ICUDLLsuffix;
Procedure ICUbrk_setUText(BI: TICUBreakIterator; Var Text: TICUText; Out OStatus: TICUErrorCode); Cdecl; External ICUDLLcommon Name 'ubrk_setUText' + ICUDLLsuffix;
Function ICUbrk_current(Const ABI: TICUBreakIterator): Integer; Cdecl; External ICUDLLcommon Name 'ubrk_current' + ICUDLLsuffix;
Function ICUbrk_next(BI: TICUBreakIterator): Integer; Cdecl; External ICUDLLcommon Name 'ubrk_next' + ICUDLLsuffix;
Function ICUbrk_previous(BI: TICUBreakIterator): Integer; Cdecl; External ICUDLLcommon Name 'ubrk_previous' + ICUDLLsuffix;
Function ICUbrk_first(BI: TICUBreakIterator): Integer; Cdecl; External ICUDLLcommon Name 'ubrk_first' + ICUDLLsuffix;
Function ICUbrk_last(BI: TICUBreakIterator): Integer; Cdecl; External ICUDLLcommon Name 'ubrk_last' + ICUDLLsuffix;
Function ICUbrk_preceding(BI: TICUBreakIterator; Const AOffset: Integer): Integer; Cdecl; External ICUDLLcommon Name 'ubrk_preceding' + ICUDLLsuffix;
Function ICUbrk_following(BI: TICUBreakIterator; Const AOffset: Integer): Integer; Cdecl; External ICUDLLcommon Name 'ubrk_following' + ICUDLLsuffix;
Function ICUbrk_getAvailable(Const AIndex: Integer): PAnsiChar; Cdecl; External ICUDLLcommon Name 'ubrk_getAvailable' + ICUDLLsuffix;
Function ICUbrk_countAvailable: Integer; Cdecl; External ICUDLLcommon Name 'ubrk_countAvailable' + ICUDLLsuffix;
Function ICUbrk_isBoundary(BI: TICUBreakIterator; Const AOffset: Integer): ByteBool; Cdecl; External ICUDLLcommon Name 'ubrk_isBoundary' + ICUDLLsuffix;
Function ICUbrk_getRuleStatus(BI: TICUBreakIterator): Integer; Cdecl; External ICUDLLcommon Name 'ubrk_getRuleStatus' + ICUDLLsuffix;
Function ICUbrk_getRuleStatusVec(BI: TICUBreakIterator; FillInVec: PInteger; Const ACapacity: Integer; Out OStatus: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'ubrk_getRuleStatusVec' + ICUDLLsuffix;
Function ICUbrk_getLocaleByType(Const ABI: TICUBreakIterator; Const AType: TICULocaleDataType; Out OStatus: TICUErrorCode): PAnsiChar; Cdecl;
   External ICUDLLcommon Name 'ubrk_getLocaleByType' + ICUDLLsuffix;
Procedure ICUbrk_refreshUText(BI: TICUBreakIterator; Var Text: TICUText; Out OStatus: TICUErrorCode); Cdecl; External ICUDLLcommon Name 'ubrk_refreshUText' + ICUDLLsuffix;
Function ICUbrk_getBinaryRules(BI: TICUBreakIterator; BinaryRules: PByte; Const ARulesCapacity: Integer; Out OStatus: TICUErrorCode): Integer; Cdecl;
   External ICUDLLcommon Name 'ubrk_getBinaryRules' + ICUDLLsuffix;
{$ENDREGION}

Implementation

{ TICUManager }

Class Procedure TICUManager.Error(Const AErrorCode: TICUErrorCode);
Begin
   If AErrorCode.Failure Then
      Raise EICU.CreateFmt(sError, [Integer(AErrorCode), AErrorCode.ToString]);
End;

Class Procedure TICUManager.Initialize;
Var
   DLL, Header: TICUVersionInfo;
   DLLVersion:  PAnsiChar;
Begin
   ICUgetVersion(DLL);
   ICUversionFromString(Header, ICUVersion);
   If DLL <> Header Then Begin
      DLLVersion := AllocMem(20);
      ICUversionToString(DLL, DLLVersion);
      Raise EICU.CreateFmt('Version %s expected, got %s.', [ICUVersion, UnicodeString(DLLVersion)]);
   End;
End;

Class Function TICUManager.VersionString: UnicodeString;
Begin
   Result := UnicodeString(ICUVersion);
End;

{ TICUErrorCodeHelper }

Function TICUErrorCodeHelper.Failure: Boolean;
Begin
   Result := Integer(Self) > Integer(icuecZeroError);
End;

Function TICUErrorCodeHelper.Success: Boolean;
Begin
   Result := Integer(Self) <= Integer(icuecZeroError);
End;

Function TICUErrorCodeHelper.ToString: UnicodeString;
Begin
   Result := UnicodeString(ICUerrorName(Self));
End;

{ TICUCPMap }

Function TICUCPMap.Get(Const AC: TICUChar32): Cardinal;
Begin
   Result := ICUcpmap_get(Self, AC);
End;

Function TICUCPMap.GetRange(Const AStart: TICUChar32; Const AOption: TICUCPMapRangeOption; Const ASurrogateValue: Cardinal; Const AFilter: TICUCPMapValueFilter; Const Context; Out OPValue: Cardinal)
   : TICUChar32;
Begin
   Result := ICUcpmap_getRange(Self, AStart, AOption, ASurrogateValue, AFilter, Context, OPValue);
End;

Function TICUCPMap.GetRange(Const AStart: TICUChar32; Const AOption: TICUCPMapRangeOption; Const ASurrogateValue: Cardinal; Const AFilter: TICUCPMapValueFilter; Const Context): TICUChar32;
Begin
   Result := ICUcpmap_getRange(Self, AStart, AOption, ASurrogateValue, AFilter, Context, PCardinal(NIL)^);
End;

{ TICUEnumeration }

Procedure TICUEnumeration.Destroy;
Begin
   ICUenum_close(Self);
End;

Function TICUEnumeration.Count: Integer;
Var
   Status: TICUErrorCode;
Begin
   Result := ICUenum_count(Self, Status);
   If Status.Failure Then
      Raise EICU.CreateFmt('Enumeration count failed: %s', [Status.ToString]);
End;

Class Function TICUEnumeration.Create(Const AStrings: TArray<PAnsiChar>): TICUEnumeration;
Var
   Status: TICUErrorCode;
Begin
   If Assigned(AStrings) Then
      Result := ICUenum_openCharStringsEnumeration(@AStrings[0], Length(AStrings), Status)
   Else
      Result := ICUenum_openCharStringsEnumeration(NIL, 0, Status);
   If Status.Failure Then
      Raise EICU.CreateFmt('Enumeration create failed: %s', [Status.ToString]);
End;

Class Function TICUEnumeration.Create(Const AStrings: TArray<AnsiString>): TICUEnumeration;
Var
   Status: TICUErrorCode;
Begin
   // AnsiStrings are null-terminated
   If Assigned(AStrings) Then
      Result := ICUenum_openCharStringsEnumeration(@AStrings[0], Length(AStrings), Status)
   Else
      Result := ICUenum_openCharStringsEnumeration(NIL, 0, Status);
   If Status.Failure Then
      Raise EICU.CreateFmt('Enumeration create failed: %s', [Status.ToString]);
End;

Function TICUEnumeration.Next: AnsiString;
Var
   Status: TICUErrorCode;
Begin
   Result := ICUenum_next(Self, PInteger(NIL)^, Status);
   If Status.Failure Then
      Raise EICU.CreateFmt('Enumeration next failed: %s', [Status.ToString]);
End;

Procedure TICUEnumeration.Reset;
Var
   Status: TICUErrorCode;
Begin
   ICUenum_reset(Self, Status);
   If Status.Failure Then
      Raise EICU.CreateFmt('Enumeration reset failed: %s', [Status.ToString]);
End;

Class Function TICUEnumeration.UCreate(Const AStrings: TArray<String>): TICUEnumeration;
Var
   Status: TICUErrorCode;
Begin
   // UnicodeStrings are null-terminated
   If Assigned(AStrings) Then
      Result := ICUenum_openUCharStringsEnumeration(@AStrings[0], Length(AStrings), Status)
   Else
      Result := ICUenum_openUCharStringsEnumeration(NIL, 0, Status);
   If Status.Failure Then
      Raise EICU.CreateFmt('Enumeration ucreate failed: %s', [Status.ToString]);
End;

Function TICUEnumeration.UNext: UnicodeString;
Var
   Status: TICUErrorCode;
Begin
   Result := ICUenum_unext(Self, PInteger(NIL)^, Status);
   If Status.Failure Then
      Raise EICU.CreateFmt('Enumeration unext failed: %s', [Status.ToString]);
End;

{ TICUTextHelper }

Function TICUText.Char32At(Const ANativeIndex: Int64): TICUChar32;
Begin
   Result := ICUtext_char32At(Self, ANativeIndex);
End;

Function TICUText.Clone(Const ADeep, AReadOnly: Boolean): PICUText;
Var
   Err: TICUErrorCode;
Begin
   Result := ICUtext_clone(PICUText(NIL)^, Self, ADeep, AReadOnly, Err);
   TICUManager.Error(Err);
End;

Procedure TICUText.CloneInto(Var ATo: TICUText; Const ADeep, AReadOnly: Boolean);
Var
   Err: TICUErrorCode;
Begin
   ICUtext_clone(ATo, Self, ADeep, AReadOnly, Err);
   TICUManager.Error(Err);
End;

Procedure TICUText.Destroy;
Begin
   ICUtext_close(Self);
End;

Procedure TICUText.Copy(Const ANativeStart, ANativeLimit, ADestIndex: Int64; Const AMove: Boolean);
Var
   Err: TICUErrorCode;
Begin
   ICUtext_copy(Self, ANativeStart, ANativeLimit, ADestIndex, AMove, Err);
   TICUManager.Error(Err);
End;

Function TICUText.Current32: TICUChar32;
Begin
   Result := ICUtext_current32(Self);
End;

Class Operator TICUText.Equal([Ref] Const AA, AB: TICUText): Boolean;
Begin
   Result := ICUtext_equals(AA, AB);
End;

Function TICUText.Extract(Const ANativeStart, ANativeLimit: Int64): UnicodeString;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result, ICUtext_extract(Self, ANativeStart, ANativeLimit, NIL, 0, Err));
   SetLength(Result, ICUtext_extract(Self, ANativeStart, ANativeLimit, PWideChar(Result), Length(Result), Err));
   TICUManager.Error(Err);
End;

Procedure TICUText.Freeze;
Begin
   ICUtext_freeze(Self);
End;

Function TICUText.GetNativeIndex: Int64;
Begin
   Result := ICUtext_getNativeIndex(Self);
End;

Function TICUText.GetPreviousNativeIndex: Int64;
Begin
   Result := ICUtext_getPreviousNativeIndex(Self);
End;

Function TICUText.HasMetaData: Boolean;
Begin
   Result := ICUtext_hasMetaData(Self);
End;

Function TICUText.InlineCurrent32: TICUChar32;
Begin
   If (FChunkOffset < FChunkLength) And (PWord(NativeInt(FChunkContents) + FChunkOffset)^ < $D800) Then
      Result := PWord(NativeInt(FChunkContents) + FChunkOffset)^
   Else
      Result := ICUtext_current32(Self);
End;

Function TICUText.InlineGetNativeIndex: Int64;
Begin
   If FChunkOffset < FNativeIndexingLimit Then
      Result := FChunkNativeStart + FChunkOffset
   Else
      Result := FPFuncs.MapOffsetToNative(Self);
End;

Function TICUText.InlineNext32: TICUChar32;
Begin
   If (FChunkOffset < FChunkLength) And (PWord(NativeInt(FChunkContents) + FChunkOffset)^ < $D800) Then Begin
      Result := PWord(NativeInt(FChunkContents) + FChunkOffset)^;
      Inc(FChunkOffset);
   End
   Else
      Result := ICUtext_next32(Self);
End;

Function TICUText.InlinePrevious32: TICUChar32;
Begin
   If (FChunkOffset > 0) And (PWord(NativeInt(FChunkContents) + FChunkOffset - 1)^ < $D800) Then Begin
      Dec(FChunkOffset);
      Result := PWord(NativeInt(FChunkContents) + FChunkOffset)^;
   End
   Else
      Result := ICUtext_previous32(Self);
End;

Procedure TICUText.InlineSetNativeIndex(Const ANativeIndex: Int64);
Var
   Offset: Int64;
Begin
   Offset := ANativeIndex - FChunkNativeStart;
   If (Offset >= 0) And (Offset < FNativeIndexingLimit) And (PWord(NativeInt(FChunkContents) + Offset)^ <= $DC00) Then
      FChunkOffset := Integer(Offset)
   Else
      ICUtext_setNativeIndex(Self, ANativeIndex);
End;

Function TICUText.IsLengthExpensive: Boolean;
Begin
   Result := ICUtext_isLengthExpensive(Self);
End;

Function TICUText.IsWritable: Boolean;
Begin
   Result := ICUtext_isWritable(Self);
End;

Function TICUText.MoveIndex32(Const ADelta: Integer): Boolean;
Begin
   Result := ICUtext_moveIndex32(Self, ADelta);
End;

Function TICUText.NativeLength: Int64;
Begin
   Result := ICUtext_nativeLength(Self);
End;

Function TICUText.Next32: TICUChar32;
Begin
   Result := ICUtext_next32(Self);
End;

Function TICUText.Next32From(Const ANativeIndex: Int64): TICUChar32;
Begin
   Result := ICUtext_next32From(Self, ANativeIndex);
End;

Procedure TICUText.OpenUChars(Const &AS: UnicodeString);
Var
   Err: TICUErrorCode;
Begin
   ICUtext_openUChars(Self, @&AS[1], Length(&AS), Err);
   TICUManager.Error(Err);
End;

Class Function TICUText.CreateUChars(Const &AS: UnicodeString): PICUText;
Var
   Err: TICUErrorCode;
Begin
   Result := ICUtext_openUChars(PICUText(NIL)^, @&AS[1], Length(&AS), Err);
   TICUManager.Error(Err);
End;

Procedure TICUText.OpenUTF8(Const &AS: AnsiString);
Var
   Err: TICUErrorCode;
Begin
   ICUtext_openUTF8(Self, @&AS[1], Length(&AS), Err);
   TICUManager.Error(Err);
End;

Class Function TICUText.CreateUTF8(Const &AS: AnsiString): PICUText;
Var
   Err: TICUErrorCode;
Begin
   Result := ICUtext_openUTF8(PICUText(NIL)^, @&AS[1], Length(&AS), Err);
   TICUManager.Error(Err);
End;

Function TICUText.Previous32: TICUChar32;
Begin
   Result := ICUtext_previous32(Self);
End;

Function TICUText.Previous32From(Const ANativeIndex: Int64): TICUChar32;
Begin
   Result := ICUtext_previous32From(Self, ANativeIndex);
End;

Procedure TICUText.Replace(Const ANativeStart, ANativeLimit: Int64; Const AReplacementText: UnicodeString);
Var
   Err: TICUErrorCode;
Begin
   ICUtext_replace(Self, ANativeStart, ANativeLimit, @AReplacementText[1], Length(AReplacementText), Err);
   TICUManager.Error(Err);
End;

Procedure TICUText.SetNativeIndex(Const ANativeIndex: Int64);
Begin
   ICUtext_setNativeIndex(Self, ANativeIndex);
End;

Procedure TICUText.Setup(Const AExtraSpace: Integer);
Var
   Err: TICUErrorCode;
Begin
   ICUtext_setup(Self, AExtraSpace, Err);
   TICUManager.Error(Err);
End;

Class Function TICUText.Create(Const AExtraSpace: Integer): PICUText;
Var
   Err: TICUErrorCode;
Begin
   Result := ICUtext_setup(PICUText(NIL)^, AExtraSpace, Err);
   TICUManager.Error(Err);
End;

{ TICUVersionInfoHelper }

Class Function TICUVersionInfoHelper.FromString(Const AValue: UnicodeString): TICUVersionInfo;
Begin
   ICUversionFromUString(Result, PWideChar(AValue));
End;

Class Function TICUVersionInfoHelper.GetVersion: TICUVersionInfo;
Begin
   ICUgetVersion(Result);
End;

Function TICUVersionInfoHelper.ToString: UnicodeString;
Var
   Buf: String[cMaxVersionStringLength];
Begin
   ICUversionToString(Self, @Buf[1]);
   Result := UnicodeString(PAnsiChar(@Buf[1]));
End;

{ TICULocale }

Class Function TICULocale.AcceptLanguage(Const AAcceptList: TArray<AnsiString>; Const AAvailableLocales: TArray<TICULocale>; Out OResult: TICUAcceptResult): TICULocale;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result.FValue, capFullName);
   SetLength(Result.FValue, ICUloc_acceptLanguage(@Result.FValue[1], capFullName, OResult, PPAnsiChar(@AAcceptList[0]), Length(AAcceptList),
      TICUEnumeration.Create(TArray<PAnsiChar>(AAvailableLocales)), Err));
   TICUManager.Error(Err);
End;

Class Function TICULocale.AcceptLanguageFromHTTP(Const AHTTPAcceptLanguage: AnsiString; Const AAvailableLocales: TArray<TICULocale>; Out OResult: TICUAcceptResult): TICULocale;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result.FValue, capFullName);
   SetLength(Result.FValue, ICUloc_acceptLanguageFromHTTP(@Result.FValue[1], capFullName, OResult, PAnsiChar(AHTTPAcceptLanguage), TICUEnumeration.Create(TArray<PAnsiChar>(AAvailableLocales)), Err));
   TICUManager.Error(Err);
End;

Function TICULocale.AddLikelySubtags: TICULocale;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result.FValue, capFullName);
   SetLength(Result.FValue, ICUloc_addLikelySubtags(@FValue[1], @Result.FValue[1], capFullName, Err));
   TICUManager.Error(Err);
End;

Function TICULocale.Canonicalize: TICULocale;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result.FValue, capFullName);
   SetLength(Result.FValue, ICUloc_canonicalize(@FValue[1], @Result.FValue[1], capFullName, Err));
   TICUManager.Error(Err);
End;

Class Function TICULocale.CountAvailable: Integer;
Begin
   Result := ICUloc_countAvailable;
End;

Class Function TICULocale.ForLanguageTag(Const ALanguageTag: AnsiString): TICULocale;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result.FValue, capFullName);
   SetLength(Result.FValue, ICUloc_forLanguageTag(PAnsiChar(ALanguageTag), @Result.FValue[1], capFullName, PInteger(NIL)^, Err));
   TICUManager.Error(Err);
End;

Function TICULocale.Get(Const AFunc: TGetFunc; Const AMaxSize: Integer): AnsiString;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result, AMaxSize);
   SetLength(Result, AFunc(@FValue[1], @Result[1], AMaxSize, Err) - 1);
   TICUManager.Error(Err);
End;

Function TICULocale.Get(Const AFunc: TGetDisplayFunc; Const ADisplayLocale: TICULocale): UnicodeString;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result, 255);
   SetLength(Result, AFunc(@FValue[1], @ADisplayLocale.FValue[1], @Result[1], 255, Err) - 1);
   TICUManager.Error(Err);
End;

Class Function TICULocale.GetAvailable(Const AN: Integer): TICULocale;
Begin
   Result.FValue := AnsiString(ICUloc_getAvailable(AN));
End;

Function TICULocale.GetBaseName: AnsiString;
Begin
   Result := Get(ICUloc_getBaseName, capFullName);
End;

Function TICULocale.GetCharacterOrientation: TICULayoutType;
Var
   Err: TICUErrorCode;
Begin
   Result := ICUloc_getCharacterOrientation(@FValue[1], Err);
   TICUManager.Error(Err);
End;

Function TICULocale.GetCountry: AnsiString;
Begin
   Result := Get(ICUloc_getCountry, capCountry);
End;

Class Function TICULocale.GetDefault: TICULocale;
Begin
   Result.FValue := AnsiString(ICUloc_getDefault);
End;

Function TICULocale.GetDisplayCountry(Const ADisplayLocale: TICULocale): UnicodeString;
Begin
   Result := Get(ICUloc_getDisplayCountry, ADisplayLocale);
End;

Class Function TICULocale.GetDisplayKeyword(Const AKeyword: AnsiString; Const ADisplayLocale: TICULocale): UnicodeString;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result, 255);
   SetLength(Result, ICUloc_getDisplayKeyword(PAnsiChar(AKeyword), @ADisplayLocale.FValue[1], @Result[1], 255, Err) - 1);
   TICUManager.Error(Err);
End;

Function TICULocale.GetDisplayKeywordValue(Const AKeyword: AnsiString; Const ADisplayLocale: TICULocale): UnicodeString;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result, 255);
   SetLength(Result, ICUloc_getDisplayKeywordValue(@FValue[1], PAnsiChar(AKeyword), @ADisplayLocale.FValue[1], @Result[1], 255, Err) - 1);
   TICUManager.Error(Err);
End;

Function TICULocale.GetDisplayLanguage(Const ADisplayLocale: TICULocale): UnicodeString;
Begin
   Result := Get(ICUloc_getDisplayLanguage, ADisplayLocale);
End;

Function TICULocale.GetDisplayName(Const AInLocale: TICULocale): UnicodeString;
Begin
   Result := Get(ICUloc_getDisplayName, AInLocale);
End;

Function TICULocale.GetDisplayScript(Const ADisplayLocale: TICULocale): UnicodeString;
Begin
   Result := Get(ICUloc_getDisplayScript, ADisplayLocale);
End;

Function TICULocale.GetDisplayVariant(Const ADisplayLocale: TICULocale): UnicodeString;
Begin
   Result := Get(ICUloc_getDisplayVariant, ADisplayLocale);
End;

Function TICULocale.GetISO3Country: AnsiString;
Begin
   Result := AnsiString(ICUloc_getISO3Country(@FValue[1]));
End;

Function TICULocale.GetISO3Language: AnsiString;
Begin
   Result := AnsiString(ICUloc_getISO3Language(@FValue[1]));
End;

Class Function TICULocale.GetISOCountries: TArray<AnsiString>;
Var
   Countries, Cur: PPAnsiChar;
   Res:            PAnsiString;
Begin
   Countries := ICUloc_getISOCountries;
   Cur := Countries;
   While Assigned(Cur) Do
      Inc(Cur);
   SetLength(Result, NativeUInt(Cur) - NativeUInt(Countries));
   Cur := Countries;
   Res := @Result[0];
   While Assigned(Cur) Do Begin
      Res^ := AnsiString(Cur);
      Inc(Res);
      Inc(Cur);
   End;
End;

Class Function TICULocale.GetISOLanguages: TArray<AnsiString>;
Var
   Countries, Cur: PPAnsiChar;
   Res:            PAnsiString;
Begin
   Countries := ICUloc_getISOLanguages;
   Cur := Countries;
   While Assigned(Cur) Do
      Inc(Cur);
   SetLength(Result, NativeUInt(Cur) - NativeUInt(Countries));
   Cur := Countries;
   Res := @Result[0];
   While Assigned(Cur) Do Begin
      Res^ := AnsiString(Cur);
      Inc(Res);
      Inc(Cur);
   End;
End;

Function TICULocale.GetKeywordValue(Const AKeyword: AnsiString): AnsiString;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result, capKeywordAndValues);
   SetLength(Result, ICUloc_getKeywordValue(@FValue[1], PAnsiChar(AKeyword), @Result[1], capKeywordAndValues, Err) - 1);
   TICUManager.Error(Err);
End;

Function TICULocale.GetLanguage: AnsiString;
Begin
   Result := Get(ICUloc_getLanguage, capLang);
End;

Function TICULocale.GetLCID: Integer;
Begin
   Result := ICUloc_getLCID(@FValue[1]);
End;

Function TICULocale.GetLineOrientation: TICULayoutType;
Var
   Err: TICUErrorCode;
Begin
   Result := ICUloc_getLineOrientation(@FValue[1], Err);
   TICUManager.Error(Err);
End;

Class Function TICULocale.GetLocaleForLCID(Const AHostID: Cardinal): TICULocale;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result.FValue, capFullName);
   SetLength(Result.FValue, ICUloc_getLocaleForLCID(AHostID, @Result.FValue[1], capFullName, Err));
   TICUManager.Error(Err);
End;

Function TICULocale.GetName: AnsiString;
Begin
   Result := Get(ICUloc_getName, capFullName);
End;

Function TICULocale.GetParent: TICULocale;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result.FValue, capFullName);
   SetLength(Result.FValue, ICUloc_getParent(@FValue[1], @Result.FValue[1], capFullName, Err));
   TICUManager.Error(Err);
End;

Function TICULocale.GetScript: AnsiString;
Begin
   Result := Get(ICUloc_getScript, capScript);
End;

Function TICULocale.GetVariant: AnsiString;
Begin
   Result := Get(ICUloc_getVariant, capKeywordAndValues);
End;

Function TICULocale.IsRightToLeft: Boolean;
Begin
   Result := ICUloc_isRightToLeft(@FValue[1]);
End;

Function TICULocale.MinimizeSubtags: TICULocale;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result.FValue, capFullName);
   SetLength(Result.FValue, ICUloc_minimizeSubtags(@FValue[1], @Result.FValue[1], capFullName, Err));
   TICUManager.Error(Err);
End;

Class Function TICULocale.OpenAvailableByType(Const AType: TICULocaleAvailableType): TArray<TICULocale>;
Var
   Err:  TICUErrorCode;
   Enum: TICUEnumeration;
   I:    Integer;
Begin
   Enum := ICUloc_openAvailableByType(AType, Err);
   TICUManager.Error(Err);
   SetLength(Result, Enum.Count);
   For I := 0 To High(Result) Do Begin
      Result[I].FValue := ICUenum_next(Enum, PInteger(NIL)^, Err);
      TICUManager.Error(Err);
   End;
End;

Function TICULocale.OpenKeywords: TICUEnumeration;
Var
   Err: TICUErrorCode;
Begin
   Result := ICUloc_openKeywords(@FValue[1], Err);
   TICUManager.Error(Err);
End;

Procedure TICULocale.SetDefault;
Var
   Err: TICUErrorCode;
Begin
   ICUloc_setDefault(@FValue[1], Err);
   TICUManager.Error(Err);
End;

Procedure TICULocale.SetKeywordValue(Const AKeyword, AValue: AnsiString);
Var
   Err: TICUErrorCode;
Begin
   SetLength(FValue, capFullName);
   SetLength(FValue, ICUloc_setKeywordValue(PAnsiChar(AKeyword), PAnsiChar(AValue), @FValue[1], capFullName, Err));
   TICUManager.Error(Err);
End;

Function TICULocale.ToLanguageTag(Const AStrict: Boolean): AnsiString;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result, capLang);
   SetLength(Result, ICUloc_toLanguageTag(@FValue[1], @Result[1], capLang, AStrict, Err) - 1);
   TICUManager.Error(Err);
End;

Class Function TICULocale.ToLegacyKey(Const AKeyword: AnsiString): AnsiString;
Begin
   Result := AnsiString(ICUloc_toLegacyKey(PAnsiChar(AKeyword)));
End;

Class Function TICULocale.ToLegacyType(Const AKeyword, AValue: AnsiString): AnsiString;
Begin
   Result := AnsiString(ICUloc_toLegacyType(PAnsiChar(AKeyword), PAnsiChar(AValue)));
End;

Class Function TICULocale.ToUnicodeLocaleKey(Const AKeyword: AnsiString): AnsiString;
Begin
   Result := AnsiString(ICUloc_toUnicodeLocaleKey(PAnsiChar(AKeyword)));
End;

Class Function TICULocale.ToUnicodeLocaleType(Const AKeyword, AValue: AnsiString): AnsiString;
Begin
   Result := AnsiString(ICUloc_toUnicodeLocaleType(PAnsiChar(AKeyword), PAnsiChar(AValue)));
End;

{ TICUSet }

Class Function TICUSet.GetBinaryPropertySet(Const AProperty: TICUProperty): TICUSet;
Var
   Err: TICUErrorCode;
Begin
   Result := ICUgetBinaryPropertySet(AProperty, Err);
   TICUManager.Error(Err);
End;

{ TICUPropertyHelper }

Function TICUPropertyHelper.GetIntPropertyMap: TICUCPMap;
Var
   Err: TICUErrorCode;
Begin
   Result := ICUgetIntPropertyMap(Self, Err);
   TICUManager.Error(Err);
End;

Function TICUPropertyHelper.GetIntPropertyMaxValue: Integer;
Begin
   Result := ICUgetIntPropertyMaxValue(Self);
End;

Function TICUPropertyHelper.GetIntPropertyMinValue: Integer;
Begin
   Result := ICUgetIntPropertyMinValue(Self);
End;

Function TICUPropertyHelper.GetIntPropertyValue(Const AC: TICUChar32): Integer;
Begin
   Result := ICUgetIntPropertyValue(AC, Self);
End;

Class Function TICUPropertyHelper.GetPropertyEnum(Const AAlias: AnsiString): TICUProperty;
Begin
   Result := ICUgetPropertyEnum(PAnsiChar(AAlias));
End;

Function TICUPropertyHelper.GetPropertyName(Const ANameChoice: TICUPropertyNameChoice): AnsiString;
Begin
   Result := AnsiString(ICUgetPropertyName(Self, ANameChoice));
End;

Function TICUPropertyHelper.GetPropertyValueEnum(Const AAlias: AnsiString): Integer;
Begin
   Result := ICUgetPropertyValueEnum(Self, PAnsiChar(AAlias));
End;

Function TICUPropertyHelper.GetPropertyValueName(Const AValue: Integer; Const ANameChoice: TICUPropertyNameChoice): AnsiString;
Begin
   Result := AnsiString(ICUgetPropertyValueName(Self, AValue, ANameChoice));
End;

Function TICUPropertyHelper.HasBinaryProperty(Const AC: TICUChar32): Boolean;
Begin
   Result := ICUhasBinaryProperty(AC, Self);
End;

{ TICUCharHelper }

Function TICUCharHelper.BlockGetCode: TICUBlockCode;
Begin
   Result := ICUblock_getCode(Self);
End;

Function TICUCharHelper.CharAge: TICUVersionInfo;
Begin
   ICUcharAge(Self, Result);
End;

Function TICUCharHelper.CharDigitValue: Integer;
Begin
   Result := ICUcharDigitValue(Self);
End;

Function TICUCharHelper.CharDirection: TICUCharDirection;
Begin
   Result := ICUcharDirection(Self);
End;

Class Function TICUCharHelper.CharFromName(Const ANameChoice: TICUCharNameChoice; Const AName: AnsiString): TICUChar32;
Var
   Err: TICUErrorCode;
Begin
   Result := ICUcharFromName(ANameChoice, PAnsiChar(AName), Err);
   TICUManager.Error(Err);
End;

Function TICUCharHelper.CharMirror: TICUChar32;
Begin
   Result := ICUcharMirror(Self);
End;

Function TICUCharHelper.CharName(Const ANameChoice: TICUCharNameChoice): AnsiString;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result, 255);
   SetLength(Result, ICUcharName(Self, ANameChoice, @Result[1], 255, Err));
   TICUManager.Error(Err);
End;

Function TICUCharHelper.CharType: TICUCharCategory;
Begin
   Result := ICUcharType(Self);
End;

Function TICUCharHelper.Digit(Const ARadix: ShortInt): Integer;
Begin
   Result := ICUdigit(Self, ARadix);
End;

Class Procedure TICUCharHelper.EnumCharNames(Const AStart, ALimit: TICUChar32; Const AFn: TICUEnumCharNamesFn; Var Context; Const ANameChoice: TICUCharNameChoice);
Var
   Err: TICUErrorCode;
Begin
   ICUenumCharNames(AStart, ALimit, AFn, Context, ANameChoice, Err);
   TICUManager.Error(Err);
End;

Class Procedure TICUCharHelper.EnumCharTypes(Const AEnumRange: TICUCharEnumTypeRange; Const AContext);
Begin
   ICUenumCharTypes(AEnumRange, AContext);
End;

Function TICUCharHelper.FoldCase(Const AOptions: Cardinal): TICUChar32;
Begin
   Result := ICUfoldCase(Self, AOptions);
End;

Class Function TICUCharHelper.ForDigit(Const ADigit: Integer; Const ARadix: ShortInt): TICUChar32;
Begin
   Result := ICUforDigit(ADigit, ARadix);
End;

Function TICUCharHelper.GetBidiPairedBracket: TICUChar32;
Begin
   Result := ICUgetBidiPairedBracket(Self);
End;

Function TICUCharHelper.GetCombiningClass: ShortInt;
Begin
   Result := ICUgetCombiningClass(Self);
End;

Function TICUCharHelper.GetFC_NFKC_Closure: UnicodeString;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result, 255);
   SetLength(Result, ICUgetFC_NFKC_Closure(Self, @Result[1], 255, Err));
   TICUManager.Error(Err);
End;

Function TICUCharHelper.GetIntPropertyValue(Const AWhich: TICUProperty): Integer;
Begin
   Result := ICUgetIntPropertyValue(Self, AWhich);
End;

Function TICUCharHelper.GetISOComment: AnsiString;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result, 255);
{$WARN SYMBOL_DEPRECATED OFF}
   SetLength(Result, ICUgetISOComment(Self, @Result[1], 255, Err));
{$WARN SYMBOL_DEPRECATED DEFAULT}
   TICUManager.Error(Err);
End;

Function TICUCharHelper.GetNumericValue: Double;
Begin
   Result := ICUgetNumericValue(Self);
End;

Function TICUCharHelper.HasBinaryProperty(Const AWhich: TICUProperty): Boolean;
Begin
   Result := ICUhasBinaryProperty(Self, AWhich);
End;

Function TICUCharHelper.IsAlNum: Boolean;
Begin
   Result := ICUisalnum(Self);
End;

Function TICUCharHelper.IsAlpha: Boolean;
Begin
   Result := ICUisalpha(Self);
End;

Function TICUCharHelper.IsBase: Boolean;
Begin
   Result := ICUisbase(Self);
End;

Function TICUCharHelper.IsBlank: Boolean;
Begin
   Result := ICUisblank(Self);
End;

Function TICUCharHelper.IsCntrl: Boolean;
Begin
   Result := ICUiscntrl(Self);
End;

Function TICUCharHelper.IsDefined: Boolean;
Begin
   Result := ICUisdefined(Self);
End;

Function TICUCharHelper.IsDigit: Boolean;
Begin
   Result := ICUisdigit(Self);
End;

Function TICUCharHelper.IsGraph: Boolean;
Begin
   Result := ICUisgraph(Self);
End;

Function TICUCharHelper.IsIDIgnorable: Boolean;
Begin
   Result := ICUisIDIgnorable(Self);
End;

Function TICUCharHelper.IsIDPart: Boolean;
Begin
   Result := ICUisIDPart(Self);
End;

Function TICUCharHelper.IsIDStart: Boolean;
Begin
   Result := ICUisIDStart(Self);
End;

Function TICUCharHelper.IsISOControl: Boolean;
Begin
   Result := ICUisISOControl(Self);
End;

Function TICUCharHelper.IsJavaIDPart: Boolean;
Begin
   Result := ICUisJavaIDPart(Self);
End;

Function TICUCharHelper.IsJavaIDStart: Boolean;
Begin
   Result := ICUisJavaIDStart(Self);
End;

Function TICUCharHelper.IsJavaSpaceChar: Boolean;
Begin
   Result := ICUisJavaSpaceChar(Self);
End;

Function TICUCharHelper.IsLower: Boolean;
Begin
   Result := ICUislower(Self);
End;

Function TICUCharHelper.IsMirrored: Boolean;
Begin
   Result := ICUisMirrored(Self);
End;

Function TICUCharHelper.IsPrint: Boolean;
Begin
   Result := ICUisprint(Self);
End;

Function TICUCharHelper.IsPunct: Boolean;
Begin
   Result := ICUispunct(Self);
End;

Function TICUCharHelper.IsSpace: Boolean;
Begin
   Result := ICUisspace(Self);
End;

Function TICUCharHelper.IsTitle: Boolean;
Begin
   Result := ICUistitle(Self);
End;

Function TICUCharHelper.IsUAlphabetic: Boolean;
Begin
   Result := ICUisUAlphabetic(Self);
End;

Function TICUCharHelper.IsULowercase: Boolean;
Begin
   Result := ICUisULowercase(Self);
End;

Function TICUCharHelper.IsUpper: Boolean;
Begin
   Result := ICUisupper(Self);
End;

Function TICUCharHelper.IsUUppercase: Boolean;
Begin
   Result := ICUisUUppercase(Self);
End;

Function TICUCharHelper.IsUWhitespace: Boolean;
Begin
   Result := ICUisUWhitespace(Self);
End;

Function TICUCharHelper.IsWhitespace: Boolean;
Begin
   Result := ICUisWhitespace(Self);
End;

Function TICUCharHelper.IsXDigit: Boolean;
Begin
   Result := ICUisxdigit(Self);
End;

Function TICUCharHelper.ToLower: TICUChar32;
Begin
   Result := ICUtolower(Self);
End;

Function TICUCharHelper.ToTitle: TICUChar32;
Begin
   Result := ICUtotitle(Self);
End;

Function TICUCharHelper.ToUpper: TICUChar32;
Begin
   Result := ICUtoupper(Self);
End;

{ TICUBreakIterator }

Function TICUBreakIterator.Clone: TICUBreakIterator;
Var
   Err: TICUErrorCode;
Begin
{$WARN SYMBOL_EXPERIMENTAL OFF}
   Result := ICUbrk_clone(Self, Err);
{$WARN SYMBOL_EXPERIMENTAL DEFAULT}
   TICUManager.Error(Err);
End;

Procedure TICUBreakIterator.Destroy;
Begin
   ICUbrk_close(Self);
End;

Class Function TICUBreakIterator.CountAvailable: Integer;
Begin
   Result := ICUbrk_countAvailable;
End;

Function TICUBreakIterator.Current: Integer;
Begin
   Result := ICUbrk_current(Self);
End;

Function TICUBreakIterator.First: Integer;
Begin
   Result := ICUbrk_first(Self);
End;

Function TICUBreakIterator.Following(Const AOffset: Integer): Integer;
Begin
   Result := ICUbrk_following(Self, AOffset);
End;

Class Function TICUBreakIterator.GetAvailable(Const AIndex: Integer): AnsiString;
Begin
   Result := AnsiString(ICUbrk_getAvailable(AIndex));
End;

Function TICUBreakIterator.GetBinaryRules: TBytes;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result, ICUbrk_getBinaryRules(Self, NIL, 0, Err));
   TICUManager.Error(Err);
   ICUbrk_getBinaryRules(Self, @Result[0], Length(Result), Err);
   TICUManager.Error(Err);
End;

Function TICUBreakIterator.GetLocaleByType(Const AType: TICULocaleDataType): TICULocale;
Var
   Err: TICUErrorCode;
Begin
   Result.FValue := AnsiString(ICUbrk_getLocaleByType(Self, AType, Err));
   TICUManager.Error(Err);
End;

Function TICUBreakIterator.GetRuleStatus: Integer;
Begin
   Result := ICUbrk_getRuleStatus(Self);
End;

Function TICUBreakIterator.GetRuleStatusVec: TArray<Integer>;
Var
   Err: TICUErrorCode;
Begin
   SetLength(Result, ICUbrk_getRuleStatusVec(Self, NIL, 0, Err));
   TICUManager.Error(Err);
   ICUbrk_getRuleStatusVec(Self, @Result[0], Length(Result), Err);
   TICUManager.Error(Err);
End;

Function TICUBreakIterator.IsBoundary(Const AOffset: Integer): Boolean;
Begin
   Result := ICUbrk_isBoundary(Self, AOffset);
End;

Function TICUBreakIterator.Last: Integer;
Begin
   Result := ICUbrk_last(Self);
End;

Function TICUBreakIterator.Next: Integer;
Begin
   Result := ICUbrk_next(Self);
End;

Class Function TICUBreakIterator.Create(Const AType: TICUBreakIteratorType; Const ALocale: TICULocale; Const AText: UnicodeString): TICUBreakIterator;
Var
   Err: TICUErrorCode;
Begin
   Result := ICUbrk_open(AType, @ALocale.FValue[1], @AText[1], Length(AText), Err);
   TICUManager.Error(Err);
End;

Class Function TICUBreakIterator.CreateBinaryRules(Const ABinaryRules: TBytes; Const AText: UnicodeString): TICUBreakIterator;
Var
   Err: TICUErrorCode;
Begin
   Result := ICUbrk_openBinaryRules(@ABinaryRules[0], Length(ABinaryRules), @AText[1], Length(AText), Err);
   TICUManager.Error(Err);
End;

Class Function TICUBreakIterator.CreateRules(Const ARules, AText: UnicodeString; Out OParseErr: TICUParseError): TICUBreakIterator;
Var
   Err: TICUErrorCode;
Begin
   Result := ICUbrk_openRules(@ARules[1], Length(ARules), @AText[1], Length(AText), OParseErr, Err);
   TICUManager.Error(Err);
End;

Function TICUBreakIterator.Preceding(Const AOffset: Integer): Integer;
Begin
   Result := ICUbrk_preceding(Self, AOffset);
End;

Function TICUBreakIterator.Previous: Integer;
Begin
   Result := ICUbrk_previous(Self);
End;

Procedure TICUBreakIterator.RefreshUText(Var Text: TICUText);
Var
   Err: TICUErrorCode;
Begin
   ICUbrk_refreshUText(Self, Text, Err);
   TICUManager.Error(Err);
End;

Function TICUBreakIterator.SafeClone: TICUBreakIterator;
Var
   Err: TICUErrorCode;
Begin
{$WARN SYMBOL_DEPRECATED OFF}
   Result := ICUbrk_safeClone(Self, Pointer(NIL)^, NIL, Err);
{$WARN SYMBOL_DEPRECATED DEFAULT}
   TICUManager.Error(Err);
End;

Procedure TICUBreakIterator.SetText(Const AText: UnicodeString);
Var
   Err: TICUErrorCode;
Begin
   ICUbrk_setText(Self, @AText[1], Length(AText), Err);
   TICUManager.Error(Err);
End;

Procedure TICUBreakIterator.SetUText(Var Text: TICUText);
Var
   Err: TICUErrorCode;
Begin
   ICUbrk_setUText(Self, Text, Err);
   TICUManager.Error(Err);
End;

Initialization

TICUManager.Initialize;

End.
