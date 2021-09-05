// Translation of the HarfBuzz interface into Delphi Language/Object Pascal
// Based on version 2.9.0
// This header file is Copyright (C) 2021 by Benjamin Desef
// You may use it under the same conditions as HarfBuzz itself, i.e., the "Old MIT"
// license.
// The original HarfBuzz copyright header is
// Copyright © 2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020  Google, Inc.
// Copyright © 2018,2019,2020  Ebrahim Byagowi
// Copyright © 2019,2020  Facebook, Inc.
// Copyright © 2012  Mozilla Foundation
// Copyright © 2011  Codethink Limited
// Copyright © 2008,2010  Nokia Corporation and/or its subsidiary(-ies)
// Copyright © 2009  Keith Stribley
// Copyright © 2009  Martin Hosken and SIL International
// Copyright © 2007  Chris Wilson
// Copyright © 2006  Behdad Esfahbod
// Copyright © 2005  David Turner
// Copyright © 2004,2007,2008,2009,2010  Red Hat, Inc.
// Copyright © 1998-2004  David Turner and Werner Lemberg
//
// Permission is hereby granted, without written agreement and without
// license or royalty fees, to use, copy, modify, and distribute this
// software and its documentation for any purpose, provided that the
// above copyright notice and the following two paragraphs appear in
// all copies of this software.
//
// IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE TO ANY PARTY FOR
// DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
// ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
// IF THE COPYRIGHT HOLDER HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
// DAMAGE.
//
// THE COPYRIGHT HOLDER SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING,
// BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
// FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
// ON AN "AS IS" BASIS, AND THE COPYRIGHT HOLDER HAS NO OBLIGATION TO
// PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

{$Z4}
Unit uHarfBuzz;

Interface

{$IFDEF FPC}
{$MODE Delphi}
{$MESSAGE FATAL 'Replace every instance of "[Ref] Const" in this file by "Constref", then disable this error.'}
{$ENDIF}

Uses SysUtils{$IFNDEF VER230}, AnsiStrings{$ENDIF}, uFreeType;

Const
   HarfbuzzDLL = 'harfbuzz.dll';

Type
   EHarfBuzz = Class(Exception)

   End;

{$REGION 'hb-common.h'}

   THBBool = Type LongBool;

   PHBCodepoint = ^THBCodepoint;
   THBCodepoint = Type Cardinal;

   PHBPosition = ^THBPosition;
   THBPosition = Type Integer;

   THBMask = Type Cardinal;

   THBVarInt = Packed Record
      Case Byte Of
         0:
            (u32: Cardinal);
         1:
            (i32: Integer);
         2:
            (u16: Packed Array [0 .. 1] Of Word);
         3:
            (i16: Packed Array [0 .. 1] Of SmallInt);
         4:
            (u8: Packed Array [0 .. 3] Of Byte);
         5:
            (i8: Packed Array [0 .. 3] Of ShortInt);
   End;

   PHBTag = ^THBTag;
   THBTag = Type Cardinal;

   THBTagHelper = Record Helper For THBTag
   Public Type
      THBTagString = String[4];
   Public Const
      None      = THBTag($00000000);
      Max       = THBTag($FFFFFFFF);
      MaxSigned = THBTag($7FFFFFFF);
   Public
      Class Function FromString(Const AStr: AnsiString): THBTag; Static; Inline;
      Function ToString: THBTagString; Inline;
   End;

Type
   THBDirection = (hbdInvalid = 0, hbdLTR = 4, hbdRTL, hbdTTB, hbdBTT);

   THBDirectionHelper = Record Helper For THBDirection
   Public Type
      THBDirectionString = String[7]; // at most "invalid"
   Public
      Class Function FromString(Const AStr: AnsiString): THBDirection; Static; Inline;
      Function ToString: THBDirectionString; Inline;

      Function IsValid: Boolean; Inline;
      Function IsHorizontal: Boolean; Inline;
      Function IsVertical: Boolean; Inline;
      Function IsForward: Boolean; Inline;
      Function IsBackward: Boolean; Inline;
      Function Reverse: THBDirection; Inline;
   End;

   THBLanguage = Record
   Strict Private
      FValue: Pointer;
      // internal type
   Public
      Class Function FromString(Const AStr: AnsiString): THBLanguage; Static; Inline;
      Function ToString: AnsiString; Inline;
      Class Function Default: THBLanguage; Static; Inline;
      Class Operator Implicit(Const AValue: AnsiString): THBLanguage; Inline;
      Class Operator Implicit(Const AValue: THBLanguage): AnsiString; Inline;
   End;

   THBLanguageHelper = Record Helper For THBLanguage
   Public Const
      Invalid: THBLanguage = (FValue: NIL);
   End;

   THBScript = (hbsCommon = $5A797979 { Zyyy } , // 1.1
      hbsInherited = $5A696E68 { Zinh } ,        // 1.1
      hbsUnknown = $5A7A7A7A { Zzzz } ,          // 5.0

      hbsArabic = $41726162 { Arab } ,     // 1.1
      hbsArmenian = $41726D6E { Armn } ,   // 1.1
      hbsBengali = $42656E67 { Beng } ,    // 1.1
      hbsCyrillic = $4379726C { Cyrl } ,   // 1.1
      hbsDevanagari = $44657661 { Deva } , // 1.1
      hbsGeorgian = $47656F72 { Geor } ,   // 1.1
      hbsGreek = $4772656B { Grek } ,      // 1.1
      hbsGujarati = $47756A72 { Gujr } ,   // 1.1
      hbsGurmukhi = $47757275 { Guru } ,   // 1.1
      hbsHangul = $48616E67 { Hang } ,     // 1.1
      hbsHan = $48616E69 { Hani } ,        // 1.1
      hbsHebrew = $48656272 { Hebr } ,     // 1.1
      hbsHiragana = $48697261 { Hira } ,   // 1.1
      hbsKannada = $4B6E6461 { Knda } ,    // 1.1
      hbsKatakana = $4B616E61 { Kana } ,   // 1.1
      hbsLao = $4C616F6F { Laoo } ,        // 1.1
      hbsLatin = $4C61746E { Latn } ,      // 1.1
      hbsMalayalam = $4D6C796D { Mlym } ,  // 1.1
      hbsOriya = $4F727961 { Orya } ,      // 1.1
      hbsTamil = $54616D6C { Taml } ,      // 1.1
      hbsTelugu = $54656C75 { Telu } ,     // 1.1
      hbsThai = $54686169 { Thai } ,       // 1.1

      hbsTibetan = $54696274 { Tibt } , // 2.0

      hbsBopomofo = $426F706F { Bopo } ,          // 3.0
      hbsBraille = $42726169 { Brai } ,           // 3.0
      hbsCanadianSyllabics = $43616E73 { Cans } , // 3.0
      hbsCherokee = $43686572 { Cher } ,          // 3.0
      hbsEthiopic = $45746869 { Ethi } ,          // 3.0
      hbsKhmer = $4B686D72 { Khmr } ,             // 3.0
      hbsMongolian = $4D6F6E67 { Mong } ,         // 3.0
      hbsMyanmar = $4D796D72 { Mymr } ,           // 3.0
      hbsOgham = $4F67616D { Ogam } ,             // 3.0
      hbsRunic = $52756E72 { Runr } ,             // 3.0
      hbsSinhala = $53696E68 { Sinh } ,           // 3.0
      hbsSyriac = $53797263 { Syrc } ,            // 3.0
      hbsThaana = $54686161 { Thaa } ,            // 3.0
      hbsYi = $59696969 { Yiii } ,                // 3.0

      hbsDeseret = $44737274 { Dsrt } ,   // 3.1
      hbsGothic = $476F7468 { Goth } ,    // 3.1
      hbsOldItalic = $4974616C { Ital } , // 3.1

      hbsBuhid = $42756864 { Buhd } ,    // 3.2
      hbsHanunoo = $48616E6F { Hano } ,  // 3.2
      hbsTagalog = $54676C67 { Tglg } ,  // 3.2
      hbsTagbanwa = $54616762 { Tagb } , // 3.2

      hbsCypriot = $43707274 { Cprt } ,  // 4.0
      hbsLimbu = $4C696D62 { Limb } ,    // 4.0
      hbsLinearB = $4C696E62 { Linb } ,  // 4.0
      hbsOsmanya = $4F736D61 { Osma } ,  // 4.0
      hbsShavian = $53686177 { Shaw } ,  // 4.0
      hbsTaiLe = $54616C65 { Tale } ,    // 4.0
      hbsUgaritic = $55676172 { Ugar } , // 4.0

      hbsBuginese = $42756769 { Bugi } ,    // 4.1
      hbsCoptic = $436F7074 { Copt } ,      // 4.1
      hbsGlagolitic = $476C6167 { Glag } ,  // 4.1
      hbsKharoshthi = $4B686172 { Khar } ,  // 4.1
      hbsNewTaiLue = $54616C75 { Talu } ,   // 4.1
      hbsOldPersian = $5870656F { Xpeo } ,  // 4.1
      hbsSylotiNagri = $53796C6F { Sylo } , // 4.1
      hbsTifinagh = $54666E67 { Tfng } ,    // 4.1

      hbsBalinese = $42616C69 { Bali } ,   // 5.0
      hbsCuneiform = $58737578 { Xsux } ,  // 5.0
      hbsNko = $4E6B6F6F { Nkoo } ,        // 5.0
      hbsPhagsPa = $50686167 { Phag } ,    // 5.0
      hbsPhoenician = $50686E78 { Phnx } , // 5.0

      hbsCarian = $43617269 { Cari } ,     // 5.1
      hbsCham = $4368616D { Cham } ,       // 5.1
      hbsKayahLi = $4B616C69 { Kali } ,    // 5.1
      hbsLepcha = $4C657063 { Lepc } ,     // 5.1
      hbsLycian = $4C796369 { Lyci } ,     // 5.1
      hbsLydian = $4C796469 { Lydi } ,     // 5.1
      hbsOlChiki = $4F6C636B { Olck } ,    // 5.1
      hbsRejang = $526A6E67 { Rjng } ,     // 5.1
      hbsSaurashtra = $53617572 { Saur } , // 5.1
      hbsSundanese = $53756E64 { Sund } ,  // 5.1
      hbsVai = $56616969 { Vaii } ,        // 5.1

      hbsAvestan = $41767374 { Avst } ,               // 5.2
      hbsBamum = $42616D75 { Bamu } ,                 // 5.2
      hbsEgyptianHieroglyphs = $45677970 { Egyp } ,   // 5.2
      hbsImperialAramaic = $41726D69 { Armi } ,       // 5.2
      hbsInscriptionalPahlavi = $50686C69 { Phli } ,  // 5.2
      hbsInscriptionalParthian = $50727469 { Prti } , // 5.2
      hbsJavanese = $4A617661 { Java } ,              // 5.2
      hbsKaithi = $4B746869 { Kthi } ,                // 5.2
      hbsLisu = $4C697375 { Lisu } ,                  // 5.2
      hbsMeeteiMayek = $4D746569 { Mtei } ,           // 5.2
      hbsOldSouthArabian = $53617262 { Sarb } ,       // 5.2
      hbsOldTurkic = $4F726B68 { Orkh } ,             // 5.2
      hbsSamaritan = $53616D72 { Samr } ,             // 5.2
      hbsTaiTham = $4C616E61 { Lana } ,               // 5.2
      hbsTaiViet = $54617674 { Tavt } ,               // 5.2

      hbsBatak = $4261746B { Batk } ,   // 6.0
      hbsBrahmi = $42726168 { Brah } ,  // 6.0
      hbsMandaic = $4D616E64 { Mand } , // 6.0

      hbsChakma = $43616B6D { Cakm } ,              // 6.1
      hbsMeroiticCursive = $4D657263 { Merc } ,     // 6.1
      hbsMeroiticHieroglyphs = $4D65726F { Mero } , // 6.1
      hbsMiao = $506C7264 { Plrd } ,                // 6.1
      hbsSharada = $53687264 { Shrd } ,             // 6.1
      hbsSoraSompeng = $536F7261 { Sora } ,         // 6.1
      hbsTakri = $54616B72 { Takr } ,               // 6.1

      // Since: 0.9.30
      hbsBassaVah = $42617373 { Bass } ,          // 7.0
      hbsCaucasianAlbanian = $41676862 { Aghb } , // 7.0
      hbsDuployan = $4475706C { Dupl } ,          // 7.0
      hbsElbasan = $456C6261 { Elba } ,           // 7.0
      hbsGrantha = $4772616E { Gran } ,           // 7.0
      hbsKhojki = $4B686F6A { Khoj } ,            // 7.0
      hbsKhudawadi = $53696E64 { Sind } ,         // 7.0
      hbsLinearA = $4C696E61 { Lina } ,           // 7.0
      hbsMahajani = $4D61686A { Mahj } ,          // 7.0
      hbsManichaean = $4D616E69 { Mani } ,        // 7.0
      hbsMendeKikakui = $4D656E64 { Mend } ,      // 7.0
      hbsModi = $4D6F6469 { Modi } ,              // 7.0
      hbsMro = $4D726F6F { Mroo } ,               // 7.0
      hbsNabataean = $4E626174 { Nbat } ,         // 7.0
      hbsOldNorthArabian = $4E617262 { Narb } ,   // 7.0
      hbsOldPermic = $5065726D { Perm } ,         // 7.0
      hbsPahawhHmong = $486D6E67 { Hmng } ,       // 7.0
      hbsPalmyrene = $50616C6D { Palm } ,         // 7.0
      hbsPauCinHau = $50617563 { Pauc } ,         // 7.0
      hbsPsalterPahlavi = $50686C70 { Phlp } ,    // 7.0
      hbsSiddham = $53696464 { Sidd } ,           // 7.0
      hbsTirhuta = $54697268 { Tirh } ,           // 7.0
      hbsWarangCiti = $57617261 { Wara } ,        // 7.0

      hbsAhom = $41686F6D { Ahom } ,                 // 8.0
      hbsAnatolianHieroglyphs = $486C7577 { Hluw } , // 8.0
      hbsHatran = $48617472 { Hatr } ,               // 8.0
      hbsMultani = $4D756C74 { Mult } ,              // 8.0
      hbsOldHungarian = $48756E67 { Hung } ,         // 8.0
      hbsSignwriting = $53676E77 { Sgnw } ,          // 8.0

      // Since 1.3.0
      hbsAdlam = $41646C6D { Adlm } ,     // 9.0
      hbsBhaiksuki = $42686B73 { Bhks } , // 9.0
      hbsMarchen = $4D617263 { Marc } ,   // 9.0
      hbsOsage = $4F736765 { Osge } ,     // 9.0
      hbsTangut = $54616E67 { Tang } ,    // 9.0
      hbsNewa = $4E657761 { Newa } ,      // 9.0

      // Since 1.6.0
      hbsMasaramGondi = $476F6E6D { Gonm } ,    // 10.0
      hbsNushu = $4E736875 { Nshu } ,           // 10.0
      hbsSoyombo = $536F796F { Soyo } ,         // 10.0
      hbsZanabazarSquare = $5A616E62 { Zanb } , // 10.0

      // Since 1.8.0
      hbsDogra = $446F6772 { Dogr } ,          // 11.0
      hbsGunjalaGondi = $476F6E67 { Gong } ,   // 11.0
      hbsHanifiRohingya = $526F6867 { Rohg } , // 11.0
      hbsMakasar = $4D616B61 { Maka } ,        // 11.0
      hbsMedefaidrin = $4D656466 { Medf } ,    // 11.0
      hbsOldSogdian = $536F676F { Sogo } ,     // 11.0
      hbsSogdian = $536F6764 { Sogd } ,        // 11.0

      // Since 2.4.0
      hbsElymaic = $456C796D { Elym } ,              // 12.0
      hbsNandinagari = $4E616E64 { Nand } ,          // 12.0
      hbsNyiakengPuachueHmong = $486D6E70 { Hmnp } , // 12.0
      hbsWancho = $5763686F { Wcho } ,               // 12.0

      // Since 2.6.7
      hbsChorasmian = $43687273 { Chrs } ,        // 13.0
      hbsDivesAkuru = $4469616B { Diak } ,        // 13.0
      hbsKhitanSmallScript = $4B697473 { Kits } , // 13.0
      hbsYezidi = $59657A69 { Yezi } ,            // 13.0

      // No script set.
      hbsInvalid = THBTag.None);

   THBScriptHelper = Record Helper For THBScript
   Public
      Class Function FromISO15924(Const ATag: THBTag): THBScript; Static; Inline;
      Class Function FromString(Const AStr: AnsiString): THBScript; Static; Inline;
      Function ToISO15924: THBTag; Inline;

      Function GetHorizontalDirection: THBDirection; Inline;
   End;

   THBDestroyFunc = Procedure(UserData: Pointer); Cdecl;

   PHBFeature = ^THBFeature;

   THBFeature = Record
   Strict Private
   Const
      sInvalidFeatureString = 'Invalid feature string: %s';
   Public
      Tag:                THBTag;
      Value, Start, &End: Cardinal;
   Public Const
      cGlobalStart = 0;
      cGlobalEnd   = Cardinal( -1);
   Public
      Class Function FromString(Const AStr: AnsiString): THBFeature; Static; Inline;
      Function ToString: AnsiString; Inline;
   End;

   PHBVariation = ^THBVariation;

   THBVariation = Record
   Strict Private
   Const
      sInvalidVariationString = 'Invalid variation string: %s';
   Public
      Tag:   THBTag;
      Value: Single;

      Class Function FromString(Const AStr: AnsiString): THBVariation; Static; Inline;
      Function ToString: AnsiString; Inline;
   End;

   THBColor = Record
   Strict Private
      FValue: Packed Array [0 .. 3] Of Byte;
   Public
      Constructor Mix(Const B, G, R, A: Byte);
      Property Alpha: Byte Read FValue[0] Write FValue[0];
      Property Red: Byte Read FValue[1] Write FValue[1];
      Property Green: Byte Read FValue[2] Write FValue[2];
      Property Blue: Byte Read FValue[3] Write FValue[3];
   End;
{$ENDREGION}
{$REGION 'hb-blob.h'}

   THBMemoryMode = (hbmmDuplicate, hbmmReadonly, hbmmWritable, hbmmReadonlyMayMakeWritable);

   THBBlob = Record
   Strict Private
{$HINTS OFF}
      FValue: Pointer;
{$HINTS ON}
      // internal type
   Strict Private
   Const
      sErrorUserData  = 'Error setting blob user data';
      sCreationFailed = 'Blob creation failed';
   Public
      Class Function Create(Const AData: TBytes; Const AMode: THBMemoryMode; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc; Const AFailOnError: Boolean = False): THBBlob; Overload;
         Static; Inline;
      Class Function Create(Const AFileName: AnsiString; Const AFailOnError: Boolean = False): THBBlob; Overload; Static; Inline;
      Function CreateSubBlob(Const AOffset, ALength: Integer): THBBlob; Inline;
      Function CopyWritable: THBBlob; Inline;
      Class Function GetEmpty: THBBlob; Static; Inline;
      Function Reference: THBBlob; Inline;
      Procedure Destroy; Inline;
      Procedure SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: Boolean); Inline;
      Function GetUserData(Const AKey): Pointer; Inline;
      Procedure MakeImmutable; Inline;
      Function IsImmutable: Boolean; Inline;
      Function GetLength: Cardinal; Inline;
      Function GetData(Out OLength: Cardinal): PByte; Inline;
      Function GetDataWritable(Out OLength: Cardinal): PByte; Inline;
      Function GetFaceCount: Cardinal; Inline;
   End;
{$ENDREGION}
{$REGION 'hb-unicode.h'}

Const
   cHBUnicodeMax = Cardinal($10FFFF);

Type
   THBUnicodeGeneralCategory = ( //
      hbugcControl,              // Cc
      hbugcFormat,               // Cf
      hbugcUnassigned,           // Cn
      hbugcPrivateUse,           // Co
      hbugcSurrogate,            // Cs
      hbugcLowercaseLetter,      // Ll
      hbugcModifierLetter,       // Lm
      hbugcOtherLetter,          // Lo
      hbugcTitlecaseLetter,      // Lt
      hbugcUppercaseLetter,      // Lu
      hbugcSpacingMark,          // Mc
      hbugcEnclosingMark,        // Me
      hbugcNonSpacingMark,       // Mn
      hbugcDecimalNumber,        // Nd
      hbugcLetterNumber,         // Nl
      hbugcOtherNumber,          // No
      hbugcConnectPunctuation,   // Pc
      hbugcDashPunctuation,      // Pd
      hbugcClosePunctuation,     // Pe
      hbugcFinalPunctuation,     // Pf
      hbugcInitialPunctuation,   // Pi
      hbugcOtherPunctuation,     // Po
      hbugcOpenPunctuation,      // Ps
      hbugcCurrencySymbol,       // Sc
      hbugcModifierSymbol,       // Sk
      hbugcMathSymbol,           // Sm
      hbugcOtherSymbol,          // So
      hbugcLineSeparator,        // Zl
      hbugcParagraphSeparator,   // Zp
      hbugcSpaceSeparator        // Zs
      );
   THBUnicodeCombiningClass = ( //
      hbuccNotReordered = 0, hbuccOverlay = 1, hbuccNukta = 7, hbuccKanaVoicing = 8, hbuccVirama = 9,

      // Hebrew
      hbuccCcc10 = 10, hbuccCcc11 = 11, hbuccCcc12 = 12, hbuccCcc13 = 13, hbuccCcc14 = 14, hbuccCcc15 = 15, hbuccCcc16 = 16, hbuccCcc17 = 17, hbuccCcc18 = 18, hbuccCcc19 = 19, hbuccCcc20 = 20,
      hbuccCcc21 = 21, hbuccCcc22 = 22, hbuccCcc23 = 23, hbuccCcc24 = 24, hbuccCcc25 = 25, hbuccCcc26 = 26,

      // Arabic
      hbuccCcc27 = 27, hbuccCcc28 = 28, hbuccCcc29 = 29, hbuccCcc30 = 30, hbuccCcc31 = 31, hbuccCcc32 = 32, hbuccCcc33 = 33, hbuccCcc34 = 34, hbuccCcc35 = 35,

      // Syriac
      hbuccCcc36 = 36,

      // Telugu
      hbuccCcc84 = 84, hbuccCcc91 = 91,

      // Thai
      hbuccCcc103 = 103, hbuccCcc107 = 107,

      // Lao
      hbuccCcc118 = 118, hbuccCcc122 = 122,

      // Tibetan
      hbuccCcc129 = 129, hbuccCcc130 = 130, hbuccCcc133 = 132,

      hbuccAttachedBelowLeft = 200, hbuccAttachedBelow = 202, hbuccAttachedAbove = 214, hbuccAttachedAboveRight = 216, hbuccBelowLeft = 218, hbuccBelow = 220, hbuccBelowRight = 222, hbuccLeft = 224,
      hbuccRight = 226, hbuccAboveLeft = 228, hbuccAbove = 230, hbuccAboveRight = 232, hbuccDoubleBelow = 233, hbuccDoubleAbove = 234,

      hbuccIotaSubscript = 240,

      hbuccInvalid = 255);

   THBUnicodeFuncs = Record
   Strict Private
      FValue: Pointer;
      // internal type
   Public Type
      THBUnicodeCombiningClassFunc  = Function(Const uFuncs: THBUnicodeFuncs; Const AUnicode: THBCodepoint; Const AUserData: Pointer): THBUnicodeCombiningClass; Cdecl;
      THBUnicodeGeneralCategoryFunc = Function(Const uFuncs: THBUnicodeFuncs; Const AUnicode: THBCodepoint; Const AUserData: Pointer): THBUnicodeGeneralCategory; Cdecl;
      THBUnicodeMirroringFunc       = Function(Const uFuncs: THBUnicodeFuncs; Const AUnicode: THBCodepoint; Const AUserData: Pointer): THBCodepoint; Cdecl;
      THBUnicodeScriptFunc          = Function(Const uFuncs: THBUnicodeFuncs; Const AUnicode: THBCodepoint; Const AUserData: Pointer): THBScript; Cdecl;
      THBUnicodeComposeFunc         = Function(Const uFuncs: THBUnicodeFuncs; Const A, B: THBCodepoint; Out AB: THBCodepoint; Const AUserData: Pointer): THBBool; Cdecl;
      THBUnicodeDecomposeFunc       = Function(Const uFuncs: THBUnicodeFuncs; Const AB: THBCodepoint; Out A, B: THBCodepoint; Const AUserData: Pointer): THBBool; Cdecl;
   Public
      Class Function GetDefault: THBUnicodeFuncs; Static; Inline;
      Class Function Create(Parent: THBUnicodeFuncs): THBUnicodeFuncs; Overload; Static; Inline;
      Class Function Create: THBUnicodeFuncs; Overload; Static; Inline;
      Class Function GetEmpty: THBUnicodeFuncs; Static; Inline;
      Function Reference: THBUnicodeFuncs; Inline;
      Procedure Destroy; Inline;
      Procedure SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: Boolean); Inline;
      Function GetUserData(Const AKey): Pointer; Inline;
      Procedure MakeImmutable; Inline;
      Function IsImmutable: Boolean; Inline;
      Function GetParent: THBUnicodeFuncs; Inline;

      Procedure SetCombiningClassFunc(Const AFunc: THBUnicodeCombiningClassFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetGeneralCategoryFunc(Const AFunc: THBUnicodeGeneralCategoryFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetMirroringFunc(Const AFunc: THBUnicodeMirroringFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetScriptFunc(Const AFunc: THBUnicodeScriptFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetComposeFunc(Const AFunc: THBUnicodeComposeFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetDecomposeFunc(Const AFunc: THBUnicodeDecomposeFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Function CombiningClass(Const AUnicode: THBCodepoint): THBUnicodeCombiningClass; Inline;
      Function GeneralCategory(Const AUnicode: THBCodepoint): THBUnicodeGeneralCategory; Inline;
      Function Mirroring(Const AUnicode: THBCodepoint): THBCodepoint; Inline;
      Function Script(Const AUnicode: THBCodepoint): THBCodepoint; Inline;
      Function Compose(Const A, B: THBCodepoint; Out AB: THBCodepoint): Boolean; Inline;
      Function Decompose(Const AB: THBCodepoint; Out A, B: THBCodepoint): Boolean; Inline;
   End;

   THBUnicodeFuncsHelper = Record Helper For THBUnicodeFuncs
   Public Const
      cNIL: THBUnicodeFuncs = (FValue: NIL);
   End;
{$ENDREGION}
{$REGION 'hb-set.h'}

   THBSet = Record
   Strict Private
{$HINTS OFF}
      FValue: Pointer;
{$HINTS ON}
      // internal type
   Strict Private
   Const
      sErrorUserData = 'Error setting set user data';
   Public Const
      SetValueInvalid = THBCodepoint( -1);
   Public
      Class Function Create: THBSet; Static; Inline;
      Class Function GetEmpty: THBSet; Static; Inline;
      Function Reference: THBSet; Inline;
      Procedure Destroy; Inline;
      Procedure SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: Boolean); Inline;
      Function GetUserData(Const AKey): Pointer; Inline;
      Function AllocationSuccessful: Boolean; Inline;
      Function Copy: THBSet; Inline;
      Procedure Clear; Inline;
      Function IsEmpty: Boolean; Inline;
      Function Has(Const ACodepoint: THBCodepoint): Boolean; Inline;
      Procedure Add(Const ACodepoint: THBCodepoint); Inline;
      Procedure AddRange(Const AFirst, ALast: THBCodepoint); Inline;
      Procedure Delete(Const ACodepoint: THBCodepoint); Inline;
      Procedure DeleteRange(Const AFirst, ALast: THBCodepoint); Inline;
      Function IsEqual(Const AOther: THBSet): Boolean; Inline;
      Class Operator Equal(Const ASet, AOther: THBSet): Boolean; Inline;
      Function IsSubset(Const ALargerSet: THBSet): Boolean; Inline;
      Class Operator GreaterThanOrEqual(Const ASuperset, ASubset: THBSet): Boolean; Inline;
      Class Operator LessThanOrEqual(Const ASubset, ASuperset: THBSet): Boolean; Inline;
      Procedure Assign(Const AOther: THBSet); Inline;
      Procedure Union(Const AOther: THBSet); Inline;
      Procedure Intersect(Const AOther: THBSet); Inline;
      Procedure Subtract(Const AOther: THBSet); Inline;
      Procedure SymmetricDifference(Const AOther: THBSet); Inline;
      Function Count: Cardinal; Inline;
      Function Min: THBCodepoint; Inline;
      Function Max: THBCodepoint; Inline;
      Function Next(Var Codepoint: THBCodepoint): Boolean; Inline;
      Function GetNext(Const ACodepoint: THBCodepoint): THBCodepoint; Inline;
      Function Previous(Var Codepoint: THBCodepoint): Boolean; Inline;
      Function GetPrevious(Const ACodepoint: THBCodepoint): THBCodepoint; Inline;
      Function NextRange(Var First, Last: THBCodepoint): Boolean; Inline;
      Function PreviousRange(Var First, Last: THBCodepoint): Boolean; Inline;
   End;
{$ENDREGION}
{$REGION 'hb-face.h'}

   THBFace = Record
   Strict Private
{$HINTS OFF}
      FValue: Pointer;
{$HINTS ON}
      // internal type
   Strict Private
   Const
      sErrorAddBuilder = 'Error adding fact builder table';
   Strict Private
      Procedure SetIndex(Const AIndex: Cardinal); Inline;
      Function GetIndex: Cardinal; Inline;
      Procedure SetUpEM(Const AUpEM: Cardinal); Inline;
      Function GetUpEM: Cardinal; Inline;
      Procedure SetGlyphCount(Const AGlyphCount: Cardinal); Inline;
      Function GetGlyphCount: Cardinal; Inline;
   Public Type
      THBReferenceTableFunc = Function(Const AFace: THBFace; Const ATag: THBTag; Const AUserData: Pointer): THBBlob; Cdecl;
   Public
      Class Function Create(Blob: THBBlob; Const AIndex: Cardinal): THBFace; Overload; Static; Inline;
      Class Function Create(Const AReferenceTableFunc: THBReferenceTableFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc): THBFace; Overload; Static; Inline;
      Class Function Create(Const AFTFace: TFTFace; Const ADestroy: THBDestroyFunc): THBFace; Overload; Static; Inline;
      Class Function CreateCached(Const AFTFace: TFTFace): THBFace; Static; Inline;
      Class Function CreateReferenced(FTFace: TFTFace): THBFace; Static; Inline;
      Class Function GetEmpty: THBFace; Static; Inline;
      Function Reference: THBFace; Inline;
      Procedure Destroy; Inline;
      Procedure SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: Boolean); Inline;
      Function GetUserData(Const AKey): Pointer; Inline;
      Procedure MakeImmutable; Inline;
      Function IsImmutable: Boolean; Inline;
      Function ReferenceTable(Const ATag: THBTag): THBBlob; Inline;
      Function GetTableTags: TArray<THBTag>; Inline;
      Procedure CollectUnicodes(Into: THBSet); Inline;
      Procedure CollectVariationSelectors(Into: THBSet); Inline;
      Procedure CollectVariationUnicodes(Const AVariationSelector: THBCodepoint; Into: THBSet); Inline;
      Class Function BuilderCreate: THBFace; Static; Inline;
      Procedure BuilderAddTable(Const ATag: THBTag; Blob: THBBlob); Inline;

      Property Index: Cardinal Read GetIndex Write SetIndex;
      Property UpEM: Cardinal Read GetUpEM Write SetUpEM;
      Property GlyphCount: Cardinal Read GetGlyphCount Write SetGlyphCount;
   End;
{$ENDREGION}
{$REGION 'hb-font.h'}

   THBFontExtents = Record
   Public
      Ascender:           THBPosition;
      Descender, LineGap: THBPosition;
   Strict Private
{$HINTS OFF}
      FReserved9, FReserved8, FReserved7, FReserved6, FReserved5, FReserved4, FReserved3, FReserved2, FReserved1: THBPosition;
{$HINTS ON}
   End;

   THBGlyphExtents = Record
      XBearing, YBearing, Width, Height: THBPosition;
   End;

   THBFont = Record
   Strict Private
{$HINTS OFF}
      FValue: Pointer;
{$HINTS ON}
      // internal type
   Strict Private
   Const
      sErrorUserData = 'Error setting font user data';
   Public Type
      THBFontScale = Record
      Private
         FParent: Pointer;

         Function GetXScale: Integer; Inline;
         Function GetYScale: Integer; Inline;
         Procedure SetXScale(Const AValue: Integer); Inline;
         Procedure SetYScale(Const AValue: Integer); Inline;
      Public
         Property XScale: Integer Read GetXScale Write SetXScale;
         Property YScale: Integer Read GetYScale Write SetYScale;
      End;

      THBFontPpEM = Record
      Private
         FParent: Pointer;

         Function GetXPpEM: Cardinal; Inline;
         Function GetYPpEM: Cardinal; Inline;
         Procedure SetXPpEM(Const AValue: Cardinal); Inline;
         Procedure SetYPpEM(Const AValue: Cardinal); Inline;
      Public
         Property XPpEM: Cardinal Read GetXPpEM Write SetXPpEM;
         Property YPpEM: Cardinal Read GetYPpEM Write SetYPpEM;
      End;
   Strict Private
      Procedure SetParent(Const AParent: THBFont); Inline;
      Function GetParent: THBFont; Inline;
      Procedure SetFace(Const AFace: THBFace); Inline;
      Function GetFace: THBFace; Inline;
      Procedure SetScale(Const AValue: THBFontScale); Inline;
      Function GetScale: THBFontScale; Inline;
      Procedure SetPpEM(Const AValue: THBFontPpEM); Inline;
      Function GetPpEM: THBFontPpEM; Inline;
      Procedure SetPTEM(Const APtEM: Single); Inline;
      Function GetPTEM: Single; Inline;
      Procedure SetVarCoordsNormalized(Const ACoords2F14: TArray<Integer>); Inline;
      Function GetVarCoordsNormalized: TArray<Integer>; Inline;
      Procedure FTSetLoadFlags(Const ALoadFlags: TFTLoadFlags); Inline;
      Function FTGetLoadFlags: TFTLoadFlags; Inline;
   Public
      Function GetHExtents(Out OExtents: THBFontExtents): Boolean; Inline;
      Function GetVExtents(Out OExtents: THBFontExtents): Boolean; Inline;
      Function GetNominalGlyph(Const AUnicode: THBCodepoint; Out OGlyph: THBCodepoint): Boolean; Inline;
      Function GetVariationGlyph(Const AUnicode, AVariationSelector: THBCodepoint; Out OGlyph: THBCodepoint): Boolean; Inline;
      Function GetNominalGlyphs(Const ACount: Cardinal; Const AFirstUnicode: PHBCodepoint; Const AUnicodeStride: Cardinal; OFirstGlyph: PHBCodepoint; Const AGlyphStride: Cardinal): Integer; Inline;
      Function GetGlyphHAdvance(Const AGlyph: THBCodepoint): THBPosition; Inline;
      Function GetGlyphVAdvance(Const AGlyph: THBCodepoint): THBPosition; Inline;
      Procedure GetGlyphHAdvances(Const ACount: Cardinal; Const AFirstGlyph: PHBCodepoint; Const AGlyphStride: Cardinal; OFirstAdvance: PHBPosition; Const AAdvanceStride: Cardinal); Inline;
      Procedure GetGlyphVAdvances(Const ACount: Cardinal; Const AFirstGlyph: PHBCodepoint; Const AGlyphStride: Cardinal; OFirstAdvance: PHBPosition; Const AAdvanceStride: Cardinal); Inline;
      Function GetGlyphHOrigin(Const AGlyph: THBCodepoint; Out X, Y: THBPosition): Boolean; Inline;
      Function GetGlyphVOrigin(Const AGlyph: THBCodepoint; Out X, Y: THBPosition): Boolean; Inline;
      Function GetGlyphHKerning(Const ALeftGlyph, ARightGlyph: THBCodepoint): THBPosition; Inline;
      Function GetGlyphExtents(Const AGlyph: THBCodepoint; Out OExtents: THBGlyphExtents): Boolean; Inline;
      Function GetGlyphContourPoint(Const AGlyph: THBCodepoint; Const APointIndex: Cardinal; Out X, Y: THBPosition): Boolean; Inline;
      Function GetGlyphName(Const AGlyph: THBCodepoint): AnsiString; Inline;
      Function GetGlyphFromName(Const AName: AnsiString; Out OGlyph: THBCodepoint): Boolean; Inline;

      Function GetGlyph(Const AUnicode, AVariationSelector: THBCodepoint; Out OGlyph: THBCodepoint): Boolean; Inline;
      Procedure GetExtentsForDirection(Const ADirection: THBDirection; Out OExtents: THBFontExtents); Inline;
      Procedure GetGlyphAdvanceForDirection(Const AGlyph: THBCodepoint; Const ADirection: THBDirection; Out X, Y: THBPosition); Inline;
      Procedure GetGlyphAdvancesForDirection(Const ADirection: THBDirection; Const ACount: Cardinal; Const AFirstGlyph: PHBCodepoint; Const AGlyphStride: Cardinal; OFirstAdvance: PHBPosition;
         Const AAdvanceStride: Cardinal); Inline;
      Procedure GetGlyphOriginForDirection(Const AGlyph: THBCodepoint; Const ADirection: THBDirection; Out X, Y: THBPosition); Inline;
      Procedure AddGlyphOriginForDirection(Const AGlyph: THBCodepoint; Const ADirection: THBDirection; Out X, Y: THBPosition); Inline;
      Procedure SubtractGlyphOriginForDirection(Const AGlyph: THBCodepoint; Const ADirection: THBDirection; Out X, Y: THBPosition); Inline;
      Procedure GetGlyphKerningForDirection(Const AFirstGlyph, ASecondGlyph: THBCodepoint; Const ADirection: THBDirection; Out X, Y: THBPosition); Inline;
      Function GetGlyphExtentsForOrigin(Const AGlyph: THBCodepoint; Const ADirection: THBDirection; Out OExtents: THBGlyphExtents): Boolean; Inline;
      Function GetGlyphContourPointForOrigin(Const AGlyph: THBCodepoint; Const APointIndex: Cardinal; Const ADirection: THBDirection; Out X, Y: THBPosition): Boolean; Inline;
      Function GlyphToString(Const AGlyph: THBCodepoint): AnsiString; Inline;
      Function GlyphFromString(Const AString: AnsiString; Out OGlyph: THBCodepoint): Boolean; Inline;

      Class Function Create(Const AFace: THBFace): THBFont; Overload; Static; Inline;
      Class Function Create(Const AParent: THBFont): THBFont; Overload; Static; Inline;
      Class Function Create(Const AFTFace: TFTFace; Const ADestroy: THBDestroyFunc): THBFont; Overload; Static; Inline;
      Class Function CreateReferenced(FTFace: TFTFace): THBFont; Static; Inline;
      Class Function GetEmpty: THBFont; Static; Inline;
      Function Reference: THBFont; Inline;
      Procedure Destroy; Inline;
      Procedure SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: Boolean); Inline;
      Function GetUserData(Const AKey): Pointer; Inline;
      Procedure MakeImmutable; Inline;
      Function IsImmutable: Boolean; Inline;
      Procedure SetFuncsData(Const AFontData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetVariations(Const AVariations: TArray<THBVariation>); Inline;
      Procedure SetVarCoordsDesign(Const ACoords: TArray<Single>); Inline;
      Procedure SetVarNamedInstance(Const AInstanceIndex: Cardinal); Inline;

      Function FTGetFace: TFTFace; Inline;
      Function FTLockFace: TFTFace; Inline;
      Procedure FTUnlockFace; Inline;
      Procedure FTFontChanged; Inline;
      Procedure FTFontSetFuncs; Inline;

      Property Parent: THBFont Read GetParent Write SetParent;
      Property Face: THBFace Read GetFace Write SetFace;
      Property Scale: THBFontScale Read GetScale Write SetScale;
      Property PpEM: THBFontPpEM Read GetPpEM Write SetPpEM;
      Property PTEM: Single Read GetPTEM Write SetPTEM;
      Property VarCoordsNormalized: TArray<Integer> Read GetVarCoordsNormalized Write SetVarCoordsNormalized;
      Property FTLoadFlags: TFTLoadFlags Read FTGetLoadFlags Write FTSetLoadFlags;
   End;

   THBFaceHelper = Record Helper For THBFace
   Public
      Function CreateFont: THBFont; Inline;
   End;

   THBFontFuncs = Record
   Strict Private
{$HINTS OFF}
      FValue: Pointer;
{$HINTS ON}
      // internal type
   Strict Private
   Const
      sErrorUserData = 'Error setting font funcs user data';
   Public Type
      THBFontGetFontExtentsFunc    = Function(Const AFont: THBFont; Const AFontData: Pointer; Out OExtents: THBFontExtents; Const AUserData: Pointer): THBBool; Cdecl;
      THBFontGetFontHExtentsFunc   = THBFontGetFontExtentsFunc;
      THBFontGetFontVExtentsFunc   = THBFontGetFontExtentsFunc;
      THBFontGetNominalGlyphFunc   = Function(Const AFont: THBFont; Const AFontData: Pointer; Const AUnicode: THBCodepoint; Out OGlyph: THBCodepoint; Const AUserData: Pointer): THBBool; Cdecl;
      THBFontGetVariationGlyphFunc = Function(Const AFont: THBFont; Const AFontData: Pointer; Const AUnicode, AVariationSelector: THBCodepoint; Out OGlyph: THBCodepoint; Const AUserData: Pointer)
         : THBBool; Cdecl;
      THBFontGetNominalGlyphsFunc = Function(Const AFont: THBFont; Const AFontData: Pointer; Const ACount: Cardinal; Const AFirstUnicode: PHBCodepoint; Const AUnicodeStride: Cardinal;
         OFirstGlyph: PHBCodepoint; Const AGlyphStride: Cardinal; Const AUserData: Pointer): Cardinal; Cdecl;
      THBFontGetGlyphAdvanceFunc  = Function(Const AFont: THBFont; Const AFontData: Pointer; Const AGlyph: THBCodepoint; Const AUserData: Pointer): THBPosition; Cdecl;
      THBFontGetGlyphHAdvanceFunc = THBFontGetGlyphAdvanceFunc;
      THBFontGetGlyphVAdvanceFunc = THBFontGetGlyphAdvanceFunc;
      THBFontGetGlyphAdvancesFunc = Procedure(Const AFont: THBFont; Const AFontData: Pointer; Const ACount: Cardinal; Const AFirstGlyph: PHBCodepoint; Const AGlyphStride: Cardinal;
         OFirstAdvance: PHBPosition; Const AAdvanceStride: Cardinal; Const AUserData: Pointer); Cdecl;
      THBFontGetGlyphHAdvancesFunc    = THBFontGetGlyphAdvancesFunc;
      THBFontGetGlyphVAdvancesFunc    = THBFontGetGlyphAdvancesFunc;
      THBFontGetGlyphOriginFunc       = Function(Const AFont: THBFont; Const AFontData: Pointer; Const AGlyph: THBCodepoint; Out X, Y: THBPosition; Const AUserData: Pointer): THBBool; Cdecl;
      THBFontGetGlyphHOriginFunc      = THBFontGetGlyphOriginFunc;
      THBFontGetGlyphVOriginFunc      = THBFontGetGlyphOriginFunc;
      THBFontGetGlyphKerningFunc      = Function(Const AFont: THBFont; Const AFontData: Pointer; Const AFirstGlyph, ASecondGlyph: THBCodepoint; Const AUserData: Pointer): THBPosition; Cdecl;
      THBFontGetGlyphHKerningFunc     = THBFontGetGlyphKerningFunc;
      THBFontGetGlyphExtentsFunc      = Function(Const AFont: THBFont; Const AFontData: Pointer; Const AGlyph: THBCodepoint; Out OExtents: THBGlyphExtents; Const AUserData: Pointer): THBBool; Cdecl;
      THBFontGetGlyphContourPointFunc = Function(Const AFont: THBFont; Const AFontData: Pointer; Const AGlyph: THBCodepoint; Const APointIndex: Cardinal; Out X, Y: THBPosition;
         Const AUserData: Pointer): THBBool; Cdecl;
      THBFontGetGlyphNameFunc = Function(Const AFont: THBFont; Const AFontData: Pointer; Const AGlyph: THBCodepoint; Name: PAnsiChar; Const ASize: Cardinal; Const AUserData: Pointer): THBBool; Cdecl;
      THBFontGetGlyphFromNameFunc = Function(Const AFont: THBFont; Const AFontData: Pointer; Const AName: PAnsiChar; Const ALen: Integer; Out OGlyph: THBCodepoint; Const AUserData: Pointer)
         : THBBool; Cdecl;
   Public
      Class Function Create: THBFontFuncs; Static; Inline;
      Class Function GetEmpty: THBFontFuncs; Static; Inline;
      Function Reference: THBFontFuncs; Inline;
      Procedure Destroy; Inline;
      Procedure SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: Boolean); Inline;
      Function GetUserData(Const AKey): Pointer; Inline;
      Procedure MakeImmutable; Inline;
      Function IsImmutable: Boolean; Inline;

      Procedure SetFontHExtentsFunc(Const AFunc: THBFontGetFontHExtentsFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetFontVExtentsFunc(Const AFunc: THBFontGetFontVExtentsFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetNominalGlyphFunc(Const AFunc: THBFontGetNominalGlyphFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetNorminalGlyphsFunc(Const AFunc: THBFontGetNominalGlyphsFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetVariationGlyphFunc(Const AFunc: THBFontGetVariationGlyphFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetGlyphHAdvanceFunc(Const AFunc: THBFontGetGlyphHAdvanceFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetGlyphVAdvanceFunc(Const AFunc: THBFontGetGlyphVAdvanceFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetGlyphHAdvancesFunc(Const AFunc: THBFontGetGlyphHAdvancesFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetGlyphVAdvancesFunc(Const AFunc: THBFontGetGlyphVAdvancesFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetGlyphHOriginFunc(Const AFunc: THBFontGetGlyphHOriginFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetGlyphVOriginFunc(Const AFunc: THBFontGetGlyphVOriginFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetGlyphHKerningFunc(Const AFunc: THBFontGetGlyphHKerningFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetGlyphExtentsFunc(Const AFunc: THBFontGetGlyphExtentsFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetGlyphContourPointFunc(Const AFunc: THBFontGetGlyphContourPointFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetGlyphNameFunc(Const AFunc: THBFontGetGlyphNameFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure SetGlyphFromNameFunc(Const AFunc: THBFontGetGlyphFromNameFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
   End;

   THBFontHelper = Record Helper For THBFont
   Public
      Procedure SetFuncs(Const AClass: THBFontFuncs; Const AFontData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
   End;
{$ENDREGION}
{$REGION 'hb-buffer.h'}

   THBGlyphFlag  = (hbgfUnsafeToBreak);
   THBGlyphFlags = Set Of THBGlyphFlag;

   PHBGlyphInfo = ^THBGlyphInfo;

   THBGlyphInfo = Record
   Public
      Codepoint: THBCodepoint;
   Strict Private
      FMask: THBMask;
      Function GetGlyphFlags: THBGlyphFlags; Inline;
   Public
      Property GlyphFlags: THBGlyphFlags Read GetGlyphFlags;
   Public
      Cluster: Cardinal;
   Strict Private
{$HINTS OFF}
      Var1, Var2: THBVarInt;
{$HINTS ON}
   End;

   PHBGlyphPosition = ^THBGlyphPosition;

   THBGlyphPosition = Record
   Public
      XAdvance, YAdvance, XOffset, YOffset: THBPosition;
   Strict Private
{$HINTS OFF}
      FVar: THBVarInt;
{$HINTS ON}
   End;

   PHBSegmentProperties = ^THBSegmentProperties;

   THBSegmentProperties = Record
   Public
      Direction: THBDirection;
      Script:    THBScript;
      Language:  THBLanguage;
   Strict Private
      FReserved1, FReserved2: Pointer;
   Public
      Class Operator Equal(Const A, B: THBSegmentProperties): Boolean; Inline;
      Function Hash: Cardinal; Inline;
   End;

   THBSegmentPropertiesHelper = Record Helper For THBSegmentProperties
   Public Const
      // issue with typed constants: we cannot refer to THBLanguage.Invalid here - this is not recognized as a constant
      Default: THBSegmentProperties = (Direction: hbdInvalid; Script: hbsInvalid; Language: (); FReserved1: NIL; FReserved2: NIL);
   End;

   THBBufferContentType = (hbbctInvalid, hbbctUnicode, hbbctGlyphs);

   THBBufferFlag  = (hbbfBot, hbbfEot, hbbfPreserveDefaultIgnorables, hbbfRemoveDefaultIgnorables, hbbfDoNotInsertDottedCircle);
   THBBufferFlags = Set Of THBBufferFlag;

   THBBufferClusterLevel = (hbbclMonotoneGraphemes, hbbclMonotoneCharacters, hbbclCharacters, hbbclDefault = hbbclMonotoneGraphemes);

   THBBufferSerializeFlag  = (hbbsfNoClusters, hbbsfNoPositions, hbbsfNoGlyphNames, hbbsfGlyphExtents, hbbsfGlyphFlags, hbbsfNoAdvances);
   THBBufferSerializeFlags = Set Of THBBufferSerializeFlag;

   THBBufferSerializeFormat = (hbbsfText = $54455854 { TEXT } , hbbsfJson = $4A534F4E { JSON } , hbbsfInvalid = THBTag.None);

   THBBufferSerializeFormatHelper = Record Helper For THBBufferSerializeFormat
   Public
      Class Function SerializeFormatFromString(Const AStr: AnsiString): THBBufferSerializeFormat; Static; Inline;
      Function SerializeFormatToString: AnsiString; Inline;
      Class Function SerializeListFormats: TArray<AnsiString>; Static;
   End;

   THBBufferDiffFlag = (hbbdfContentTypeMismatch, hbbdfLengthMismatch, hbbdfNotdefPresent, hbbdfDottedCirclePresent, hbbdfCodepointMismatch, hbbdfClusterMismatch, hbbdfGlyphFlagsMismatch,
      hbbdfPositionMismatch);
   THBBufferDiffFlags = Set Of THBBufferDiffFlag;

   THBBufferDiffFlagsHelper = Record Helper For THBBufferDiffFlags
   Public Const
      Equal: THBBufferDiffFlags = [];
   End;

   THBBuffer = Record
   Strict Private
{$HINTS OFF}
      FValue: Pointer;
{$HINTS ON}
      // internal type
   Strict Private
   Const
      sErrorDeserializeGlyphs  = 'Error deserializing glyphs';
      sErrorDeserializeUnicode = 'Error deserializing unicode';
      sErrorPreAllocate        = 'Error preallocating buffer';
      sErrorSetLength          = 'Error setting buffer length';
      sErrorUserData           = 'Error setting buffer user data';
      sErrorShape              = 'Error while shaping';
   Strict Private
      Procedure SetContentType(Const AContentType: THBBufferContentType); Inline;
      Function GetContentType: THBBufferContentType; Inline;
      Procedure SetUnicodeFuncs(Const AUnicodeFuncs: THBUnicodeFuncs); Inline;
      Function GetUnicodeFuncs: THBUnicodeFuncs; Inline;
      Procedure SetDirection(Const ADirection: THBDirection); Inline;
      Function GetDirection: THBDirection; Inline;
      Procedure SetScript(Const AScript: THBScript); Inline;
      Function GetScript: THBScript; Inline;
      Procedure SetLanguage(Const ALanguage: THBLanguage); Inline;
      Function GetLanguage: THBLanguage; Inline;
      Procedure SetSegmentProperties(Const AProps: THBSegmentProperties); Inline;
      Function GetSegmentProperties: THBSegmentProperties; Inline;
      Procedure SetClusterLevel(Const AClusterLevel: THBBufferClusterLevel); Inline;
      Function GetClusterLevel: THBBufferClusterLevel; Inline;
      Procedure SetFlags(Const AFlags: THBBufferFlags); Inline;
      Function GetFlags: THBBufferFlags; Inline;
      Procedure SetReplacementCodepoint(Const AReplacement: THBCodepoint); Inline;
      Function GetReplacementCodepoint: THBCodepoint; Inline;
      Procedure SetInvisibleGlyph(Const AInvisible: THBCodepoint); Inline;
      Function GetInvisibleGlyph: THBCodepoint; Inline;
      Procedure SetLength(Const ALength: Cardinal); Inline;
      Function GetLength: Cardinal; Inline;
   Public Type
      THBBufferMessageFunc = Function(Const ABuffer: THBBuffer; Const AFont: THBFont; Const AMessage: PAnsiChar; Const AUserData: Pointer): THBBool; Cdecl;
   Public Const
      BufferReplacementCodepointDefault = $FFFD;
   Public
      Class Function Create: THBBuffer; Static; Inline;
      Class Function GetEmpty: THBBuffer; Static; Inline;
      Function Reference: THBBuffer; Inline;
      Procedure Destroy; Inline;
      Procedure SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: THBBool); Inline;
      Function GetUserData(Const AKey): Pointer; Inline;
      Procedure GuessSegmentProperties; Inline;
      Procedure Reset; Inline;
      Procedure ClearContents; Inline;
      Procedure PreAllocate(Const ASize: Cardinal); Inline;
      Function AllocationSuccessful: Boolean; Inline;
      Procedure Reverse; Inline;
      Procedure ReverseRange(Const AStart, AEnd: Cardinal); Inline;
      Procedure ReverseClusters; Inline;
      Procedure Add(Const ACodepoint: THBCodepoint; Const ACluster: Cardinal); Overload; Inline;
      Procedure Add(Const AText: UTF8String; Const AItemOffset: Cardinal = 0; Const AItemLength: Integer = -1); Overload; Inline;
      Procedure Add(Const AText: UnicodeString; Const AItemOffset: Cardinal = 0; Const AItemLength: Integer = -1); Overload; Inline;
      Procedure Add(Const AText: UCS4String; Const AItemOffset: Cardinal = 0; Const AItemLength: Integer = -1); Overload; Inline;
      Procedure Add(Const AText: AnsiString; Const AItemOffset: Cardinal = 0; Const AItemLength: Integer = -1); Overload; Inline;
      Procedure Add(Const AText: TArray<THBCodepoint>; Const AItemOffset: Cardinal = 0; Const AItemLength: Integer = -1); OverloaD; Inline;
      Procedure Append(Const ASource: THBBuffer; Const AStart, AEnd: Cardinal); Inline;
      Function GetGlyphInfos: TArray<THBGlyphInfo>; Inline;
      Function GetGlyphPositions: TArray<THBGlyphPosition>; Inline;
      Function HasPositions: Boolean; Inline;
      Procedure NormalizeGlyphs; Inline;
      Function SerializeGlyphs(Const AStart, AEnd: Cardinal; Const AFont: THBFont; Const AFormat: THBBufferSerializeFormat; Const AFlags: THBBufferSerializeFlags): AnsiString;
      Function SerializeUnicode(Const AStart, AEnd: Cardinal; Const AFormat: THBBufferSerializeFormat; Const AFlags: THBBufferSerializeFlags): AnsiString;
      Function Serialize(Const AStart, AEnd: Cardinal; Const AFont: THBFont; Const AFormat: THBBufferSerializeFormat; Const AFlags: THBBufferSerializeFlags): AnsiString;
      Procedure DeserializeGlyphs(Const ABuf: AnsiString; Const AFont: THBFont; Const AFormat: THBBufferSerializeFormat); Inline;
      Procedure DeserializeUnicode(Const ABuf: AnsiString; Const AFormat: THBBufferSerializeFormat); Inline;
      Function Diff(Const AReference: THBBuffer; Const ADottedcircleGlyph: THBCodepoint; Const APositionFuzz: Cardinal): THBBufferDiffFlags; Inline;
      Procedure SetMessageFunc(Const AFunc: THBBufferMessageFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Inline;
      Procedure Shape(Font: THBFont; Const AFeatures: TArray<THBFeature> = NIL); Inline;
      Procedure ShapeFull(Font: THBFont; Const AFeatures: TArray<THBFeature>; Const AShaperList: TArray<AnsiString>);
      Class Function ListShapers: TArray<AnsiString>; Static;

      Property ContentType: THBBufferContentType Read GetContentType Write SetContentType;
      Property UnicodeFuncs: THBUnicodeFuncs Read GetUnicodeFuncs Write SetUnicodeFuncs;
      Property Direction: THBDirection Read GetDirection Write SetDirection;
      Property Script: THBScript Read GetScript Write SetScript;
      Property Language: THBLanguage Read GetLanguage Write SetLanguage;
      Property SegmentProperties: THBSegmentProperties Read GetSegmentProperties Write SetSegmentProperties;
      Property ClusterLevel: THBBufferClusterLevel Read GetClusterLevel Write SetClusterLevel;
      Property Flags: THBBufferFlags Read GetFlags Write SetFlags;
      Property ReplacementCodepoint: THBCodepoint Read GetReplacementCodepoint Write SetReplacementCodepoint;
      Property InvisibleGlyph: THBCodepoint Read GetInvisibleGlyph Write SetInvisibleGlyph;
      Property Length: Cardinal Read GetLength Write SetLength;
   End;
{$ENDREGION}
{$REGION 'hb-map.h'}

   THBMap = Record
   Strict Private
{$HINTS OFF}
      FValue: Pointer;
{$HINTS ON}
      // internal type
   Strict Private
   Const
      sErrorUserData = 'Error setting map user data';
      Procedure &Set(Const AKey, AValue: THBCodepoint); Inline;
      Function Get(Const AKey: THBCodepoint): THBCodepoint; Inline;
   Public Const
      MapValueInvalid = THBCodepoint( -1);
   Public
      Class Function Create: THBMap; Static; Inline;
      Class Function GetEmpty: THBMap; Static; Inline;
      Function Reference: THBMap; Inline;
      Procedure Destroy; Inline;
      Procedure SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: Boolean); Inline;
      Function GetUserData(Const AKey): Pointer; Inline;
      Function AllocationSuccessful: Boolean; Inline;
      Procedure Clear; Inline;
      Function IsEmpty: Boolean; Inline;
      Function Count: Cardinal; Inline;
      Procedure Delete(Const AKey: THBCodepoint); Inline;
      Function Has(Const AKey: THBCodepoint): Boolean; Inline;

      Property Values[Const AKey: THBCodepoint]: THBCodepoint Read Get Write &Set; Default;
   End;
{$ENDREGION}
{$REGION 'hb-shape-plan.h'}

   THBShapePlan = Record
   Strict Private
{$HINTS OFF}
      FValue: Pointer;
{$HINTS ON}
      // internal type
   Public
      Class Function Create(Face: THBFace; Const AProps: THBSegmentProperties; Const AUserFeatures: TArray<THBFeature>; Const AShaperList: TArray<AnsiString>; Const ACoords: TArray<Integer> = NIL;
         Const ACached: Boolean = False): THBShapePlan; Static;
      Class Function GetEmpty: THBShapePlan; Static; Inline;
      Function Reference(ShapePlan: THBShapePlan): THBShapePlan; Inline;
      Procedure Destroy(ShapePlan: THBShapePlan); Inline;
      Procedure SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: Boolean); Inline;
      Function GetUserData(Const AKey): Pointer; Inline;
      Function Execute(Font: THBFont; Buffer: THBBuffer; Const AFeatures: TArray<THBFeature>): Boolean; Inline;
      Function GetShaper: AnsiString; Inline;
   End;
{$ENDREGION}

   THarfBuzzManager = Class Abstract
   Strict Private
      Class Var FMajor, FMinor, FMicro: Cardinal;
   Private
      Class Procedure Initialize; Static;
   Strict Private
   Const
      HB_VERSION_MAJOR  = 2;
      HB_VERSION_MINOR  = 9;
      HB_VERSION_MICRO  = 0;
      HB_VERSION_STRING = '2.9.0';
   Public
      Class Function VersionString: AnsiString; Static; Inline;

      Class Property MajorVersion: Cardinal Read FMajor;
      Class Property MinorVersion: Cardinal Read FMinor;
      Class Property MicroVersion: Cardinal Read FMicro;
   End;
{$REGION 'hb-common.h'}

Function hb_tag_from_string(Const AStr: PAnsiChar; Const ALen: Integer): THBTag; Cdecl; External HarfbuzzDLL;
Procedure hb_tag_to_string(Const ATag: THBTag; Buf: PAnsiChar); Cdecl; External HarfbuzzDLL;
Function hb_direction_from_string(Const AStr: PAnsiChar; Const ALen: Integer): THBDirection; Cdecl; External HarfbuzzDLL;
Function hb_direction_to_string(Const ADirection: THBDirection): PAnsiChar; Cdecl; External HarfbuzzDLL;
Function hb_language_from_string(Const AStr: PAnsiChar; Const ALen: Integer): THBLanguage; Cdecl; External HarfbuzzDLL;
Function hb_language_to_string(Const ALanguage: THBLanguage): PAnsiChar; Cdecl; External HarfbuzzDLL;
Function hb_language_get_default: THBLanguage; Cdecl; External HarfbuzzDLL;
Function hb_script_from_iso15924_tag(Const ATag: THBTag): THBScript; Cdecl; External HarfbuzzDLL;
Function hb_script_from_string(Const AStr: PAnsiChar; Const ALen: Integer): THBScript; Cdecl; External HarfbuzzDLL;
Function hb_script_to_iso15924_tag(Const AScript: THBScript): THBTag; Cdecl; External HarfbuzzDLL;
Function hb_script_get_horizontal_direction(Const AScript: THBScript): THBDirection; Cdecl; External HarfbuzzDLL;
Function hb_feature_from_string(Const AStr: PAnsiChar; Const ALen: Integer; Out OFeature: THBFeature): THBBool; Cdecl; External HarfbuzzDLL;
Procedure hb_feature_to_string([Ref] Const AFeature: THBFeature; Buf: PAnsiChar; Const ASize: Cardinal); Cdecl; External HarfbuzzDLL;
Function hb_variation_from_string(Const AStr: PAnsiChar; ALen: Integer; Out OVariation: THBVariation): THBBool; Cdecl; External HarfbuzzDLL;
Procedure hb_variation_to_string([Ref] Const AVariation: THBVariation; Buf: PAnsiChar; Const ASize: Cardinal); Cdecl; External HarfbuzzDLL;
{$ENDREGION}
{$REGION 'hb-blob.h'}
Function hb_blob_create(Const AData: PByte; Const ALength: Cardinal; Const AMode: THBMemoryMode; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc): THBBlob; Cdecl; External HarfbuzzDLL;
Function hb_blob_create_or_fail(Const AData: PByte; Const ALength: Cardinal; Const AMode: THBMemoryMode; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc): THBBlob; Cdecl;
   External HarfbuzzDLL;
Function hb_blob_create_from_file(Const AFileName: PAnsiChar): THBBlob; Cdecl; External HarfbuzzDLL;
Function hb_blob_create_from_file_or_fail(Const AFileName: PAnsiChar): THBBlob; Cdecl; External HarfbuzzDLL;
Function hb_blob_create_sub_blob(Parent: THBBlob; Const AOffset, ALength: Integer): THBBlob; Cdecl; External HarfbuzzDLL;
Function hb_blob_copy_writable_or_fail(Const ABlob: THBBlob): THBBlob; Cdecl; External HarfbuzzDLL;
Function hb_blob_get_empty: THBBlob; Cdecl; External HarfbuzzDLL;
Function hb_blob_reference(Blob: THBBlob): THBBlob; Cdecl; External HarfbuzzDLL;
Procedure hb_blob_destroy(Blob: THBBlob); Cdecl; External HarfbuzzDLL;
Function hb_blob_set_user_data(Blob: THBBlob; Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: THBBool): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_blob_get_user_data(Const ABlob: THBBlob; Const AKey): Pointer; Cdecl; External HarfbuzzDLL;
Procedure hb_blob_make_immutable(Blob: THBBlob); Cdecl; External HarfbuzzDLL;
Function hb_blob_is_immutable(Const ABlob: THBBlob): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_blob_get_length(Const ABlob: THBBlob): Cardinal; Cdecl; External HarfbuzzDLL;
Function hb_blob_get_data(Const ABlob: THBBlob; Out OLength: Cardinal): PByte; Cdecl; External HarfbuzzDLL;
Function hb_blob_get_data_writable(Blob: THBBlob; Out OLength: Cardinal): PByte; Cdecl; External HarfbuzzDLL;
{$ENDREGION}
{$REGION 'hb-unicode.h'}
Function hb_unicode_funcs_get_default: THBUnicodeFuncs; Cdecl; External HarfbuzzDLL;
Function hb_unicode_funcs_create(Parent: THBUnicodeFuncs): THBUnicodeFuncs; Cdecl; External HarfbuzzDLL;
Function hb_unicode_funcs_get_empty: THBUnicodeFuncs; Cdecl; External HarfbuzzDLL;
Function hb_unicode_funcs_reference(uFuncs: THBUnicodeFuncs): THBUnicodeFuncs; Cdecl; External HarfbuzzDLL;
Procedure hb_unicode_funcs_destroy(uFuncs: THBUnicodeFuncs); Cdecl; External HarfbuzzDLL;
Function hb_unicode_funcs_set_user_data(uFuncs: THBUnicodeFuncs; Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: THBBool): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_unicode_funcs_get_user_data(Const uFuncs: THBUnicodeFuncs; Const AKey): Pointer; Cdecl; External HarfbuzzDLL;
Procedure hb_unicode_funcs_make_immutable(uFuncs: THBUnicodeFuncs); Cdecl; External HarfbuzzDLL;
Function hb_unicode_funcs_is_immutable(Const uFuncs: THBUnicodeFuncs): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_unicode_funcs_get_parent(Const uFuncs: THBUnicodeFuncs): THBUnicodeFuncs; Cdecl; External HarfbuzzDLL;
Procedure hb_unicode_funcs_set_combining_class_func(uFuncs: THBUnicodeFuncs; Const AFunc: THBUnicodeFuncs.THBUnicodeCombiningClassFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
   Cdecl; External HarfbuzzDLL;
Procedure hb_unicode_funcs_set_general_category_func(uFuncs: THBUnicodeFuncs; Const AFunc: THBUnicodeFuncs.THBUnicodeGeneralCategoryFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
   Cdecl; External HarfbuzzDLL;
Procedure hb_unicode_funcs_set_mirroring_func(uFuncs: THBUnicodeFuncs; Const AFunc: THBUnicodeFuncs.THBUnicodeMirroringFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_unicode_funcs_set_script_func(uFuncs: THBUnicodeFuncs; Const AFunc: THBUnicodeFuncs.THBUnicodeScriptFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_unicode_funcs_set_compose_func(uFuncs: THBUnicodeFuncs; Const AFunc: THBUnicodeFuncs.THBUnicodeComposeFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_unicode_funcs_set_decompose_func(uFuncs: THBUnicodeFuncs; Const AFunc: THBUnicodeFuncs.THBUnicodeDecomposeFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Function hb_unicode_combining_class(Const uFuncs: THBUnicodeFuncs; Const AUnicode: THBCodepoint): THBUnicodeCombiningClass; Cdecl; External HarfbuzzDLL;
Function hb_unicode_general_catgegory(Const uFuncs: THBUnicodeFuncs; Const AUnicode: THBCodepoint): THBUnicodeGeneralCategory; Cdecl; External HarfbuzzDLL;
Function hb_unicode_mirroring(Const uFuncs: THBUnicodeFuncs; Const AUnicode: THBCodepoint): THBCodepoint; Cdecl; External HarfbuzzDLL;
Function hb_unicode_script(Const uFuncs: THBUnicodeFuncs; Const AUnicode: THBCodepoint): THBScript; Cdecl; External HarfbuzzDLL;
Function hb_unicode_compose(Const uFuncs: THBUnicodeFuncs; A, B: THBCodepoint; Out AB: THBCodepoint): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_unicode_decompose(Const uFuncs: THBUnicodeFuncs; AB: THBCodepoint; Out A, B: THBCodepoint): THBBool; Cdecl; External HarfbuzzDLL;
{$ENDREGION}
{$REGION 'hb-set.h'}
Function hb_set_create: THBSet; Cdecl; External HarfbuzzDLL;
Function hb_set_get_empty: THBSet; Cdecl; External HarfbuzzDLL;
Function hb_set_reference(&Set: THBSet): THBSet; Cdecl; External HarfbuzzDLL;
Procedure hb_set_destroy(&Set: THBSet); Cdecl; External HarfbuzzDLL;
Function hb_set_set_user_data(&Set: THBSet; Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: THBBool): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_set_get_user_data(Const ASet: THBSet; Const AKey): Pointer; Cdecl; External HarfbuzzDLL;
Function hb_set_allocation_successful(Const ASet: THBSet): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_set_copy(Const ASet: THBSet): THBSet; Cdecl; External HarfbuzzDLL;
Procedure hb_set_clear(&Set: THBSet); Cdecl; External HarfbuzzDLL;
Function hb_set_is_empty(Const ASet: THBSet): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_set_has(Const ASet: THBSet; Const ACodepoint: THBCodepoint): THBBool; Cdecl; External HarfbuzzDLL;
Procedure hb_set_add(&Set: THBSet; Const ACodepoint: THBCodepoint); Cdecl; External HarfbuzzDLL;
Procedure hb_set_add_range(&Set: THBSet; Const AFirst, ALast: THBCodepoint); Cdecl; External HarfbuzzDLL;
Procedure hb_set_del(&Set: THBSet; Const ACodepoint: THBCodepoint); Cdecl; External HarfbuzzDLL;
Procedure hb_set_del_range(&Set: THBSet; Const AFirst, ALast: THBCodepoint); Cdecl; External HarfbuzzDLL;
Function hb_set_is_equal(Const ASet, AOther: THBSet): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_set_is_subset(Const ASet, ALargerSet: THBSet): THBBool; Cdecl; External HarfbuzzDLL;
Procedure hb_set_set(&Set: THBSet; Const AOther: THBSet); Cdecl; External HarfbuzzDLL;
Procedure hb_set_union(&Set: THBSet; Const AOther: THBSet); Cdecl; External HarfbuzzDLL;
Procedure hb_set_intersect(&Set: THBSet; Const AOther: THBSet); Cdecl; External HarfbuzzDLL;
Procedure hb_set_subtract(&Set: THBSet; Const AOther: THBSet); Cdecl; External HarfbuzzDLL;
Procedure hb_set_symmetric_difference(&Set: THBSet; Const AOther: THBSet); Cdecl; External HarfbuzzDLL;
Function hb_set_get_population(Const ASet: THBSet): Cardinal; Cdecl; External HarfbuzzDLL;
Function hb_set_get_min(Const ASet: THBSet): THBCodepoint; Cdecl; External HarfbuzzDLL;
Function hb_set_get_max(Const ASet: THBSet): THBCodepoint; Cdecl; External HarfbuzzDLL;
Function hb_set_next(Const ASet: THBSet; Var Codepoint: THBCodepoint): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_set_previous(Const ASet: THBSet; Var Codepoint: THBCodepoint): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_set_next_range(Const ASet: THBSet; Var First, Last: THBCodepoint): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_set_previous_range(Const ASet: THBSet; Var First, Last: THBCodepoint): THBBool; Cdecl; External HarfbuzzDLL;
{$ENDREGION}
{$REGION 'hb-face.h'}
Function hb_face_count(Blob: THBBlob): Cardinal; Cdecl; External HarfbuzzDLL;
Function hb_face_create(Blob: THBBlob; Const AIndex: Cardinal): THBFace; Cdecl; External HarfbuzzDLL;
Function hb_face_create_for_tables(Const AReferenceTableFunc: THBFace.THBReferenceTableFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc): THBFace; Cdecl; External HarfbuzzDLL;
Function hb_face_get_empty: THBFace; Cdecl; External HarfbuzzDLL;
Function hb_face_reference(Face: THBFace): THBFace; Cdecl; External HarfbuzzDLL;
Procedure hb_face_destroy(Face: THBFace); Cdecl; External HarfbuzzDLL;
Function hb_face_set_user_data(Face: THBFace; Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: THBBool): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_face_get_user_data(Const AFace: THBFace; Const AKey): Pointer; Cdecl; External HarfbuzzDLL;
Procedure hb_face_make_immutable(Face: THBFace); Cdecl; External HarfbuzzDLL;
Function hb_face_is_immutable(Const AFace: THBFace): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_face_reference_table(Const AFace: THBFace; Const ATag: THBTag): THBBlob; Cdecl; External HarfbuzzDLL;
Function hb_face_reference_blob(Face: THBFace): THBBlob; Cdecl; External HarfbuzzDLL;
Procedure hb_face_set_index(Face: THBFace; Const AIndex: Cardinal); Cdecl; External HarfbuzzDLL;
Function hb_face_get_index(Const AFace: THBFace): Cardinal; Cdecl; External HarfbuzzDLL;
Procedure hb_face_set_upem(Face: THBFace; Const AUpEM: Cardinal); Cdecl; External HarfbuzzDLL;
Function hb_face_get_upem(Const Face: THBFace): Cardinal; Cdecl; External HarfbuzzDLL;
Procedure hb_face_set_glyph_count(Face: THBFace; Const AGlyphCount: Cardinal); Cdecl; External HarfbuzzDLL;
Function hb_face_get_glyph_count(Const AFace: THBFace): Cardinal; Cdecl; External HarfbuzzDLL;
Function hb_face_get_table_tags(Const AFace: THBFace; Const AStartOffset: Cardinal; Var TableCount: Cardinal; TableTags: PHBTag): Cardinal; Cdecl; External HarfbuzzDLL;
Procedure hb_face_collect_unicodes(Const AFace: THBFace; Into: THBSet); Cdecl; External HarfbuzzDLL;
Procedure hb_face_collect_variation_selectors(Const AFace: THBFace; Into: THBSet); Cdecl; External HarfbuzzDLL;
Procedure hb_face_collect_variation_unicodes(Const AFace: THBFace; Const AVariationSelector: THBCodepoint; Into: THBSet); Cdecl; External HarfbuzzDLL;
Function hb_face_builder_create: THBFace; Cdecl; External HarfbuzzDLL;
Function hb_face_builder_add_table(Face: THBFace; Const ATag: THBTag; Blob: THBBlob): THBBool; Cdecl; External HarfbuzzDLL;
{$ENDREGION}
{$REGION 'hb-font.h'}
Function hb_font_funcs_create: THBFontFuncs; Cdecl; External HarfbuzzDLL;
Function hb_font_funcs_get_empty: THBFontFuncs; Cdecl; External HarfbuzzDLL;
Function hb_font_funcs_reference(FFuncs: THBFontFuncs): THBFontFuncs; Cdecl; External HarfbuzzDLL;
Procedure hb_font_funcs_destroy(FFuncs: THBFontFuncs); Cdecl; External HarfbuzzDLL;
Function hb_font_funcs_set_user_data(FFuncs: THBFontFuncs; Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: THBBool): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_font_funcs_get_user_data(FFuncs: THBFontFuncs; Const AKey): Pointer; Cdecl; External HarfbuzzDLL;
Procedure hb_font_funcs_make_immutable(FFuncs: THBFontFuncs); Cdecl; External HarfbuzzDLL;
Function hb_font_funcs_is_immutable(FFuncs: THBFontFuncs): THBBool; Cdecl; External HarfbuzzDLL;
Procedure hb_font_funcs_set_font_h_extents_func(FFuncs: THBFontFuncs; Const AFunc: THBFontFuncs.THBFontGetFontHExtentsFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_font_funcs_set_font_v_extents_func(FFuncs: THBFontFuncs; Const AFunc: THBFontFuncs.THBFontGetFontVExtentsFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_font_funcs_set_nominal_glyph_func(FFuncs: THBFontFuncs; Const AFunc: THBFontFuncs.THBFontGetNominalGlyphFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_font_funcs_set_nominal_glyphs_func(FFuncs: THBFontFuncs; Const AFunc: THBFontFuncs.THBFontGetNominalGlyphsFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_font_funcs_set_variation_glyph_func(FFuncs: THBFontFuncs; Const AFunc: THBFontFuncs.THBFontGetVariationGlyphFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_font_funcs_set_glyph_h_advance_func(FFuncs: THBFontFuncs; Const AFunc: THBFontFuncs.THBFontGetGlyphHAdvanceFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_font_funcs_set_glyph_v_advance_func(FFuncs: THBFontFuncs; Const AFunc: THBFontFuncs.THBFontGetGlyphVAdvanceFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_font_funcs_set_glyph_h_advances_func(FFuncs: THBFontFuncs; Const AFunc: THBFontFuncs.THBFontGetGlyphHAdvancesFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_font_funcs_set_glyph_v_advances_func(FFuncs: THBFontFuncs; Const AFunc: THBFontFuncs.THBFontGetGlyphVAdvancesFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_font_funcs_set_glyph_h_origin_func(FFuncs: THBFontFuncs; Const AFunc: THBFontFuncs.THBFontGetGlyphHOriginFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_font_funcs_set_glyph_v_origin_func(FFuncs: THBFontFuncs; Const AFunc: THBFontFuncs.THBFontGetGlyphVOriginFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_font_funcs_set_glyph_h_kerning_func(FFuncs: THBFontFuncs; Const AFunc: THBFontFuncs.THBFontGetGlyphHKerningFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_font_funcs_set_glyph_extents_func(FFuncs: THBFontFuncs; Const AFunc: THBFontFuncs.THBFontGetGlyphExtentsFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_font_funcs_set_glyph_contour_point_func(FFuncs: THBFontFuncs; Const AFunc: THBFontFuncs.THBFontGetGlyphContourPointFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_font_funcs_set_glyph_name_func(FFuncs: THBFontFuncs; Const AFunc: THBFontFuncs.THBFontGetGlyphNameFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Procedure hb_font_funcs_set_glyph_from_name_func(FFuncs: THBFontFuncs; Const AFunc: THBFontFuncs.THBFontGetGlyphFromNameFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl;
   External HarfbuzzDLL;
Function hb_font_get_h_extents(Const AFont: THBFont; Out OExtents: THBFontExtents): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_font_get_v_extents(Const AFont: THBFont; Out OExtents: THBFontExtents): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_font_get_nominal_glyph(Const AFont: THBFont; Const AUnicode: THBCodepoint; Out OGlyph: THBCodepoint): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_font_get_variation_glyph(Const AFont: THBFont; Const AUnicode, AVariationSelector: THBCodepoint; Out OGlyph: THBCodepoint): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_font_get_nominal_glyphs(Const AFont: THBFont; Const ACount: Cardinal; Const AFirstUnicode: PHBCodepoint; Const AUnicodeStride: Cardinal; OFirstGlyph: PHBCodepoint;
   Const AGlyphStride: Cardinal): Cardinal; Cdecl; External HarfbuzzDLL;
Function hb_font_get_glyph_h_advance(Const AFont: THBFont; Const AGlyph: THBCodepoint): THBPosition; Cdecl; External HarfbuzzDLL;
Function hb_font_get_glyph_v_advance(Const AFont: THBFont; Const AGlyph: THBCodepoint): THBPosition; Cdecl; External HarfbuzzDLL;
Procedure hb_font_get_glyph_h_advances(Const AFont: THBFont; Const ACount: Cardinal; Const AFirstGlyph: PHBCodepoint; Const AGlyphStride: Cardinal; OFirstAdvance: PHBPosition;
   Const AAdvanceStride: Cardinal); Cdecl; External HarfbuzzDLL;
Procedure hb_font_get_glyph_v_advances(Const AFont: THBFont; Const ACount: Cardinal; Const AFirstGlyph: PHBCodepoint; Const AGlyphStride: Cardinal; OFirstAdvance: PHBPosition;
   Const AAdvanceStride: Cardinal); Cdecl; External HarfbuzzDLL;
Function hb_font_get_glyph_h_origin(Const AFont: THBFont; Const AGlyph: THBCodepoint; Out X, Y: THBPosition): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_font_get_glyph_v_origin(Const AFont: THBFont; Const AGlyph: THBCodepoint; Out X, Y: THBPosition): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_font_get_glyph_h_kerning(Const AFont: THBFont; Const ALeftGlyph, ARightGlyph: THBCodepoint): THBPosition; Cdecl; External HarfbuzzDLL;
Function hb_font_get_glyph_extents(Const AFont: THBFont; Const AGlyph: THBCodepoint; Out OExtents: THBGlyphExtents): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_font_get_glyph_contour_point(Const AFont: THBFont; Const AGlyph: THBCodepoint; Const APointIndex: Cardinal; Out X, Y: THBPosition): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_font_get_glyph_name(Const AFont: THBFont; Const AGlyph: THBCodepoint; Name: PAnsiChar; Const ASize: Cardinal): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_font_get_glyph_from_name(Const AFont: THBFont; Const AName: PAnsiChar; Const ALen: Integer; Out OGlyph: THBCodepoint): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_font_get_glyph(Const AFont: THBFont; Const AUnicode, AVariationSelector: THBCodepoint; Out OGlyph: THBCodepoint): THBBool; Cdecl; External HarfbuzzDLL;
Procedure hb_font_get_extents_for_direction(Const AFont: THBFont; Const ADirection: THBDirection; Out OExtents: THBFontExtents); Cdecl; External HarfbuzzDLL;
Procedure hb_font_get_glyph_advance_for_direction(Const AFont: THBFont; Const AGlyph: THBCodepoint; Const ADirection: THBDirection; Out X, Y: THBPosition); Cdecl; External HarfbuzzDLL;
Procedure hb_font_get_glyph_advances_for_direction(Const AFont: THBFont; Const ADirection: THBDirection; Const ACount: Cardinal; Const AFirstGlyph: PHBCodepoint; Const AGlyphStride: Cardinal;
   OFirstAdvance: PHBPosition; Const AAdvanceStride: Cardinal); Cdecl; External HarfbuzzDLL;
Procedure hb_font_get_glyph_origin_for_direction(Const AFont: THBFont; Const AGlyph: THBCodepoint; Const ADirection: THBDirection; Out X, Y: THBPosition); Cdecl; External HarfbuzzDLL;
Procedure hb_font_add_glyph_origin_for_direction(Const AFont: THBFont; Const AGlyph: THBCodepoint; Const ADirection: THBDirection; Out X, Y: THBPosition); Cdecl; External HarfbuzzDLL;
Procedure hb_font_subtract_glyph_origin_for_direction(Const AFont: THBFont; Const AGlyph: THBCodepoint; Const ADirection: THBDirection; Out X, Y: THBPosition); Cdecl; External HarfbuzzDLL;
Procedure hb_font_get_glyph_kerning_for_direction(Const AFont: THBFont; Const AFirstGlyph, ASecondGlyph: THBCodepoint; Const ADirection: THBDirection; Out X, Y: THBPosition); Cdecl;
   External HarfbuzzDLL;
Function hb_font_get_glyph_extents_for_origin(Const AFont: THBFont; Const AGlyph: THBCodepoint; Const ADirection: THBDirection; Out OExtents: THBGlyphExtents): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_font_get_glyph_contour_point_for_origin(Const AFont: THBFont; Const AGlyph: THBCodepoint; Const APointIndex: Cardinal; Const ADirection: THBDirection; Out X, Y: THBPosition): THBBool;
   Cdecl; External HarfbuzzDLL;
Procedure hb_font_glyph_to_string(Const AFont: THBFont; Const AGlyph: THBCodepoint; S: PAnsiChar; Const ASize: Cardinal); Cdecl; External HarfbuzzDLL;
Function hb_font_glyph_from_string(Const AFont: THBFont; Const AString: PAnsiChar; Const ALen: Integer; Out OGlyph: THBCodepoint): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_font_create(Const AFace: THBFace): THBFont; Cdecl; External HarfbuzzDLL;
Function hb_font_create_sub_font(Parent: THBFont): THBFont; Cdecl; External HarfbuzzDLL;
Function hb_font_get_empty: THBFont; Cdecl; External HarfbuzzDLL;
Function hb_font_reference(Font: THBFont): THBFont; Cdecl; External HarfbuzzDLL;
Procedure hb_font_destroy(Font: THBFont); Cdecl; External HarfbuzzDLL;
Function hb_font_set_user_data(Font: THBFont; Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: THBBool): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_font_get_user_data(Const AFont: THBFont; Const AKey): Pointer; Cdecl; External HarfbuzzDLL;
Procedure hb_font_make_immutable(Font: THBFont); Cdecl; External HarfbuzzDLL;
Function hb_font_is_immutable(Const AFont: THBFont): THBBool; Cdecl; External HarfbuzzDLL;
Procedure hb_font_set_parent(Font: THBFont; Const AParent: THBFont); Cdecl; External HarfbuzzDLL;
Function hb_font_get_parent(Const AFont: THBFont): THBFont; Cdecl; External HarfbuzzDLL;
Procedure hb_font_set_face(Font: THBFont; Const AFace: THBFace); Cdecl; External HarfbuzzDLL;
Function hb_font_get_face(Const AFont: THBFont): THBFace; Cdecl; External HarfbuzzDLL;
Procedure hb_font_set_funcs(Font: THBFont; Const AClass: THBFontFuncs; Const AFontData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl; External HarfbuzzDLL;
Procedure hb_font_set_funcs_data(Font: THBFont; Const AFontData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl; External HarfbuzzDLL;
Procedure hb_font_set_scale(Font: THBFont; Const AXScale, AYScale: Integer); Cdecl; External HarfbuzzDLL;
Procedure hb_font_get_scale(Const AFont: THBFont; Out OXScale, OYScale: Integer); Cdecl; External HarfbuzzDLL;
Procedure hb_font_set_ppem(Font: THBFont; Const AXPpEM, AYPpEM: Cardinal); Cdecl; External HarfbuzzDLL;
Procedure hb_font_get_ppem(Const AFont: THBFont; Out OXPpEM, OYPpEM: Cardinal); Cdecl; External HarfbuzzDLL;
Procedure hb_font_set_ptem(Font: THBFont; Const APtEM: Single); Cdecl; External HarfbuzzDLL;
Function hb_font_get_ptem(Const AFont: THBFont): Single; Cdecl; External HarfbuzzDLL;
Procedure hb_font_set_variations(Font: THBFont; Const AVariations: PHBVariation; Const AVariationsLength: Cardinal); Cdecl; External HarfbuzzDLL;
Procedure hb_font_set_var_coords_design(Font: THBFont; Const ACoords: PSingle; Const ACoordsLength: Cardinal); Cdecl; External HarfbuzzDLL;
Procedure hb_font_set_var_coords_normalized(Font: THBFont; Const ACoords2F14: PInteger; Const ACoordsLength: Cardinal); Cdecl; External HarfbuzzDLL;
Function hb_font_get_var_coords_normalized(Const AFont: THBFont; Out OLength: Cardinal): PInteger; Cdecl; External HarfbuzzDLL;
Procedure hb_font_set_var_named_instance(Font: THBFont; Const AInstanceIndex: Cardinal); Cdecl; External HarfbuzzDLL;
{$ENDREGION}
{$REGION 'hb-buffer.h'}
Function hb_segment_properties_equal([Ref] Const A, B: THBSegmentProperties): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_segment_properties_hash([Ref] Const P: THBSegmentProperties): Cardinal; Cdecl; External HarfbuzzDLL;
Function hb_buffer_create: THBBuffer; Cdecl; External HarfbuzzDLL;
Function hb_buffer_get_empty: THBBuffer; Cdecl; External HarfbuzzDLL;
Function hb_buffer_reference(Buffer: THBBuffer): THBBuffer; Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_destroy(Buffer: THBBuffer); Cdecl; External HarfbuzzDLL;
Function hb_buffer_set_user_data(Buffer: THBBuffer; Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: THBBool): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_buffer_get_user_data(Const ABuffer: THBBuffer; Const AKey): Pointer; Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_set_content_type(Buffer: THBBuffer; Const AContentType: THBBufferContentType); Cdecl; External HarfbuzzDLL;
Function hb_buffer_get_content_type(Const ABuffer: THBBuffer): THBBufferContentType; Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_set_unicode_funcs(Buffer: THBBuffer; Const AUnicodeFuncs: THBUnicodeFuncs); Cdecl; External HarfbuzzDLL;
Function hb_buffer_get_unicode_funcs(Const ABuffer: THBBuffer): THBUnicodeFuncs; Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_set_direction(Buffer: THBBuffer; Const ADirection: THBDirection); Cdecl; External HarfbuzzDLL;
Function hb_buffer_get_direction(Const ABuffer: THBBuffer): THBDirection; Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_set_script(Buffer: THBBuffer; Const AScript: THBScript); Cdecl; External HarfbuzzDLL;
Function hb_buffer_get_script(Const ABuffer: THBBuffer): THBScript; Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_set_language(Buffer: THBBuffer; Const ALanguage: THBLanguage); Cdecl; External HarfbuzzDLL;
Function hb_buffer_get_language(Const ABuffer: THBBuffer): THBLanguage; Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_set_segment_properties(Buffer: THBBuffer; [Ref] Const AProps: THBSegmentProperties); Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_get_segment_properties(Const ABuffer: THBBuffer; Out OProps: THBSegmentProperties); Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_guess_segment_properties(Buffer: THBBuffer); Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_set_flags(Buffer: THBBuffer; Const AFlags: THBBufferFlags); Cdecl; External HarfbuzzDLL;
Function hb_buffer_get_flags(Const ABuffer: THBBuffer): THBBufferFlags; Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_set_cluster_level(Buffer: THBBuffer; Const ClusterLevel: THBBufferClusterLevel); Cdecl; External HarfbuzzDLL;
Function hb_buffer_get_cluster_level(Const ABuffer: THBBuffer): THBBufferClusterLevel; Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_set_replacement_codepoint(Buffer: THBBuffer; Const AReplacement: THBCodepoint); Cdecl; External HarfbuzzDLL;
Function hb_buffer_get_replacement_codepoint(Const ABuffer: THBBuffer): THBCodepoint; Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_set_invisible_glyph(Buffer: THBBuffer; Const AInvisible: THBCodepoint); Cdecl; External HarfbuzzDLL;
Function hb_buffer_get_invisible_glyph(Const ABuffer: THBBuffer): THBCodepoint; Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_reset(Buffer: THBBuffer); Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_clear_contents(Buffer: THBBuffer); Cdecl; External HarfbuzzDLL;
Function hb_buffer_pre_allocate(Buffer: THBBuffer; Const ASize: Cardinal): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_buffer_allocation_successful(Const ABuffer: THBBuffer): THBBool; Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_reverse(Buffer: THBBuffer); Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_reverse_range(Buffer: THBBuffer; Const AStart, AEnd: Cardinal); Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_reverse_clusters(Buffer: THBBuffer); Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_add(Buffer: THBBuffer; Const ACodepoint: THBCodepoint; Const ACluster: Cardinal); Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_add_utf8(Buffer: THBBuffer; Const AText: PAnsiChar; Const ATextLength: Integer; Const AItemOffset: Cardinal; Const AItemLength: Integer); Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_add_utf16(Buffer: THBBuffer; Const AText: PWideChar; Const ATextLength: Integer; Const AItemOffset: Cardinal; Const AItemLength: Integer); Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_add_utf32(Buffer: THBBuffer; Const AText: PCardinal; Const ATextLength: Integer; Const AItemOffset: Cardinal; Const AItemLength: Integer); Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_add_latin1(Buffer: THBBuffer; Const AText: PAnsiChar; Const ATextLength: Integer; Const AItemOffset: Cardinal; Const AItemLength: Integer); Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_add_codepoints(Buffer: THBBuffer; Const AText: PHBCodepoint; Const ATextLength: Integer; Const AItemOffset: Cardinal; Const AItemLength: Integer); Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_append(Buffer: THBBuffer; Const ASource: THBBuffer; Const AStart, AEnd: Cardinal); Cdecl; External HarfbuzzDLL;
Function hb_buffer_set_length(Buffer: THBBuffer; Const ALength: Cardinal): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_buffer_get_length(Const ABuffer: THBBuffer): Cardinal; Cdecl; External HarfbuzzDLL;
Function hb_buffer_get_glyph_infos(Const ABuffer: THBBuffer; Out OLength: Cardinal): PHBGlyphInfo; Cdecl; External HarfbuzzDLL;
Function hb_buffer_get_glyph_positions(Const ABuffer: THBBuffer; Out OLength: Cardinal): PHBGlyphPosition; Cdecl; External HarfbuzzDLL;
Function hb_buffer_has_positions(Const ABuffer: THBBuffer): THBBool; Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_normalize_glyphs(Buffer: THBBuffer); Cdecl; External HarfbuzzDLL;
Function hb_buffer_serialize_format_from_string(Const AStr: PAnsiChar; Const ALen: Integer): THBBufferSerializeFormat; Cdecl; External HarfbuzzDLL;
Function hb_buffer_serialize_format_to_string(Const AFormat: THBBufferSerializeFormat): PAnsiChar; Cdecl; External HarfbuzzDLL;
Function hb_buffer_serialize_list_formats: PPAnsiChar; Cdecl; External HarfbuzzDLL;
Function hb_buffer_serialize_glyphs(Const ABuffer: THBBuffer; Const AStart, AEnd: Cardinal; Buf: PAnsiChar; Const ABufSize: Cardinal; Out OBufConsumed: Cardinal; Const AFont: THBFont;
   Const AFormat: THBBufferSerializeFormat; Const AFlags: THBBufferSerializeFlags): Cardinal; Cdecl; External HarfbuzzDLL;
Function hb_buffer_serialize_unicode(Const ABuffer: THBBuffer; Const AStart, AEnd: Cardinal; Buf: PAnsiChar; Const ABufSize: Cardinal; Out OBufConsumed: Cardinal;
   Const AFormat: THBBufferSerializeFormat; Const AFlags: THBBufferSerializeFlags): Cardinal; Cdecl; External HarfbuzzDLL;
Function hb_buffer_serialize(Const ABuffer: THBBuffer; Const AStart, AEnd: Cardinal; Buf: PAnsiChar; Const ABufSize: Cardinal; Out OBufConsumed: Cardinal; Const AFont: THBFont;
   Const AFormat: THBBufferSerializeFormat; Const AFlags: THBBufferSerializeFlags): Cardinal; Cdecl; External HarfbuzzDLL;
Function hb_buffer_deserialize_glyphs(Buffer: THBBuffer; Const ABuf: PAnsiChar; Const ABufLen: Integer; Out OEndPtr: PAnsiChar; Const AFont: THBFont; Const AFormat: THBBufferSerializeFormat): THBBool;
   Cdecl; External HarfbuzzDLL;
Function hb_buffer_deserialize_unicode(Buffer: THBBuffer; Const ABuf: PAnsiChar; Const ABufLen: Integer; Out OEndPtr: PAnsiChar; Const AFormat: THBBufferSerializeFormat): THBBool; Cdecl;
   External HarfbuzzDLL;
Function hb_buffer_diff(Const ABuffer, AReference: THBBuffer; Const ADottedcircleGlyph: THBCodepoint; Const APositionFuzz: Cardinal): THBBufferDiffFlags; Cdecl; External HarfbuzzDLL;
Procedure hb_buffer_set_message_func(Buffer: THBBuffer; Const AFunc: THBBuffer.THBBufferMessageFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc); Cdecl; External HarfbuzzDLL;
{$ENDREGION}
{$REGION 'hb-map.h'}
Function hb_map_create: THBMap; Cdecl; External HarfbuzzDLL;
Function hb_map_get_empty: THBMap; Cdecl; External HarfbuzzDLL;
Function hb_map_reference(Map: THBMap): THBMap; Cdecl; External HarfbuzzDLL;
Procedure hb_map_destroy(Map: THBMap); Cdecl; External HarfbuzzDLL;
Function hb_map_set_user_data(Map: THBMap; Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: THBBool): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_map_get_user_data(Const AMap: THBMap; Const AKey): Pointer; Cdecl; External HarfbuzzDLL;
Function hb_map_allocation_successful(Const AMap: THBMap): THBBool; Cdecl; External HarfbuzzDLL;
Procedure hb_map_clear(Map: THBMap); Cdecl; External HarfbuzzDLL;
Function hb_map_is_empty(Const AMap: THBMap): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_map_get_population(Const AMap: THBMap): Cardinal; Cdecl; External HarfbuzzDLL;
Procedure hb_map_set(Map: THBMap; Const AKey, AValue: THBCodepoint); Cdecl; External HarfbuzzDLL;
Function hb_map_get(Const AMap: THBMap; Const AKey: THBCodepoint): THBCodepoint; Cdecl; External HarfbuzzDLL;
Procedure hb_map_del(Map: THBMap; Const AKey: THBCodepoint); Cdecl; External HarfbuzzDLL;
Function hb_map_has(Const AMap: THBMap; Const AKey: THBCodepoint): THBBool; Cdecl; External HarfbuzzDLL;
{$ENDREGION}
{$REGION 'hb-shape.h'}
Procedure hb_shape(Font: THBFont; Buffer: THBBuffer; Const AFeatures: PHBFeature; Const ANumFeatures: Cardinal); Cdecl; External HarfbuzzDLL;
Function hb_shape_full(Font: THBFont; Buffer: THBBuffer; Const AFeatures: PHBFeature; Const ANumFeatures: Cardinal; Const AShaperList: PPAnsiChar): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_shape_list_shapers: PPAnsiChar; Cdecl; External HarfbuzzDLL;
{$ENDREGION}
{$REGION 'hb-shape-plan.h'}
Function hb_shape_plan_create(Face: THBFace; [Ref] Const AProps: THBSegmentProperties; Const AUserFeatures: PHBFeature; Const ANumUserFeatures: Cardinal; Const AShaperList: PPAnsiChar): THBShapePlan;
   Cdecl; External HarfbuzzDLL;
Function hb_shape_plan_create_cached(Face: THBFace; [Ref] Const AProps: THBSegmentProperties; Const AUserFeatures: PHBFeature; Const ANumUserFeatures: Cardinal; Const AShaperList: PPAnsiChar)
   : THBShapePlan; Cdecl; External HarfbuzzDLL;
Function hb_shape_plan_create2(Face: THBFace; [Ref] Const AProps: THBSegmentProperties; Const AUserFeatures: PHBFeature; Const ANumUserFeatures: Cardinal; Const ACoords: PInteger;
   Const ANumCoords: Cardinal; Const AShaperList: PPAnsiChar): THBShapePlan; Cdecl; External HarfbuzzDLL;
Function hb_shape_plan_create_cached2(Face: THBFace; [Ref] Const AProps: THBSegmentProperties; Const AUserFeatures: PHBFeature; Const ANumUserFeatures: Cardinal; Const ACoords: PInteger;
   Const ANumCoords: Cardinal; Const AShaperList: PPAnsiChar): THBShapePlan; Cdecl; External HarfbuzzDLL;
Function hb_shape_plan_get_empty: THBShapePlan; Cdecl; External HarfbuzzDLL;
Function hb_shape_plan_reference(ShapePlan: THBShapePlan): THBShapePlan; Cdecl; External HarfbuzzDLL;
Procedure hb_shape_plan_destroy(ShapePlan: THBShapePlan); Cdecl; External HarfbuzzDLL;
Function hb_shape_plan_set_user_data(ShapePlan: THBShapePlan; Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: THBBool): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_shape_plan_get_user_data(Const AShapePlan: THBShapePlan; Const AKey): Pointer; Cdecl; External HarfbuzzDLL;
Function hb_shape_plan_execute(ShapePlan: THBShapePlan; Font: THBFont; Buffer: THBBuffer; Const AFeatures: PHBFeature; Const ANumFeatures: Cardinal): THBBool; Cdecl; External HarfbuzzDLL;
Function hb_shape_plan_get_shaper(Const AShapePlan: THBShapePlan): PAnsiChar; Cdecl; External HarfbuzzDLL;
{$ENDREGION}
{$REGION 'hb-version.h'}
Procedure hb_version(Out OMajor, OMinor, OMicro: Cardinal); Cdecl; External HarfbuzzDLL;
Function HB_VERSION_STRING: PAnsiChar; Cdecl; External HarfbuzzDLL;
Function hb_version_atleast(Const AMajor, AMinor, AMicro: Cardinal): THBBool; Cdecl; External HarfbuzzDLL;
{$ENDREGION}
{$REGION 'hb-ft.h'}
Function hb_ft_face_create(Const AFTFace: TFTFace; Const ADestroy: THBDestroyFunc): THBFace; Cdecl; External HarfbuzzDLL;
Function hb_ft_face_create_cached(Const AFTFace: TFTFace): THBFace; Cdecl; External HarfbuzzDLL;
Function hb_ft_face_create_referenced(FTFace: TFTFace): THBFace; Cdecl; External HarfbuzzDLL;
Function hb_ft_font_create(Const AFTFace: TFTFace; Const ADestroy: THBDestroyFunc): THBFont; Cdecl; External HarfbuzzDLL;
Function hb_ft_font_create_referenced(FTFace: TFTFace): THBFont; Cdecl; External HarfbuzzDLL;
Function hb_ft_font_get_face(Const AFont: THBFont): TFTFace; Cdecl; External HarfbuzzDLL;
Function hb_ft_font_lock_face(Font: THBFont): TFTFace; Cdecl; External HarfbuzzDLL;
Procedure hb_ft_font_unlock_face(Font: THBFont); Cdecl; External HarfbuzzDLL;
Procedure hb_ft_font_set_load_flags(Font: THBFont; Const ALoadFlags: TFTLoadFlags); Cdecl; External HarfbuzzDLL;
Function hb_ft_font_get_load_flags(Const AFont: THBFont): TFTLoadFlags; Cdecl; External HarfbuzzDLL;
Procedure hb_ft_font_changed(Const AFont: THBFont); Cdecl; External HarfbuzzDLL;
Procedure hb_ft_font_set_funcs(Font: THBFont); Cdecl; External HarfbuzzDLL;
{$ENDREGION}

Implementation

{ THBTagHelper }

Class Function THBTagHelper.FromString(Const AStr: AnsiString): THBTag;
Begin
   Result := hb_tag_from_string(PAnsiChar(AStr), Length(AStr));
End;

Function THBTagHelper.ToString: THBTagString;
Begin
   hb_tag_to_string(Self, @Result[1]);
   SetLength(Result, {$IFNDEF VER230}AnsiStrings.{$ENDIF}StrLen(PAnsiChar(@Result[1])));
End;

{ THBDirectionHelper }

Class Function THBDirectionHelper.FromString(Const AStr: AnsiString): THBDirection;
Begin
   Result := hb_direction_from_string(PAnsiChar(AStr), Length(AStr));
End;

Function THBDirectionHelper.IsBackward: Boolean;
Begin
   Result := (Cardinal(Self) And (Not Cardinal(2))) = 5;
End;

Function THBDirectionHelper.IsForward: Boolean;
Begin
   Result := (Cardinal(Self) And (Not Cardinal(2))) = 4;
End;

Function THBDirectionHelper.IsHorizontal: Boolean;
Begin
   Result := (Cardinal(Self) And (Not Cardinal(1))) = 4;
End;

Function THBDirectionHelper.IsValid: Boolean;
Begin
   Result := (Cardinal(Self) And (Not Cardinal(3))) = 4;
End;

Function THBDirectionHelper.IsVertical: Boolean;
Begin
   Result := (Cardinal(Self) And (Not Cardinal(1))) = 6;
End;

Function THBDirectionHelper.Reverse: THBDirection;
Begin
   Result := THBDirection(Cardinal(Self) XOr 1);
End;

Function THBDirectionHelper.ToString: THBDirectionString;
Begin
   Result := hb_direction_to_string(Self);
End;

{ THBLanguage }

Class Function THBLanguage.Default: THBLanguage;
Begin
   Result := hb_language_get_default;
End;

Class Function THBLanguage.FromString(Const AStr: AnsiString): THBLanguage;
Begin
   Result := hb_language_from_string(PAnsiChar(AStr), Length(AStr));
End;

Class Operator THBLanguage.Implicit(Const AValue: AnsiString): THBLanguage;
Begin
   Result := THBLanguage.FromString(AValue);
End;

Class Operator THBLanguage.Implicit(Const AValue: THBLanguage): AnsiString;
Begin
   Result := AValue.ToString;
End;

Function THBLanguage.ToString: AnsiString;
Begin
   Result := AnsiString(hb_language_to_string(Self));
End;

{ THBScriptHelper }

Class Function THBScriptHelper.FromISO15924(Const ATag: THBTag): THBScript;
Begin
   Result := hb_script_from_iso15924_tag(ATag);
End;

Class Function THBScriptHelper.FromString(Const AStr: AnsiString): THBScript;
Begin
   Result := hb_script_from_string(PAnsiChar(AStr), Length(AStr));
End;

Function THBScriptHelper.GetHorizontalDirection: THBDirection;
Begin
   Result := hb_script_get_horizontal_direction(Self);
End;

Function THBScriptHelper.ToISO15924: THBTag;
Begin
   Result := hb_script_to_iso15924_tag(Self);
End;

{ THBFeature }

Class Function THBFeature.FromString(Const AStr: AnsiString): THBFeature;
Begin
   If Not hb_feature_from_string(PAnsiChar(AStr), Length(AStr), Result) Then
      Raise EHarfBuzz.CreateFmt(sInvalidFeatureString, [AStr]);
End;

Function THBFeature.ToString: AnsiString;
Var
   Buf: Packed Array [0 .. 127] Of AnsiChar; // doc says 128 bytes are more than enough
Begin
   hb_feature_to_string(Self, @Buf[0], 128);
   SetLength(Result, {$IFNDEF VER230}AnsiStrings.{$ENDIF}StrLen(PAnsiChar(@Buf[0])));
   Move(Buf, Result[1], Length(Result));
End;

{ THBVariation }

Class Function THBVariation.FromString(Const AStr: AnsiString): THBVariation;
Begin
   If Not hb_variation_from_string(PAnsiChar(AStr), Length(AStr), Result) Then
      Raise EHarfBuzz.CreateFmt(sInvalidVariationString, [AStr]);
End;

Function THBVariation.ToString: AnsiString;
Var
   Buf: Packed Array [0 .. 127] Of AnsiChar; // doc says 128 bytes are more than enough
Begin
   hb_variation_to_string(Self, @Buf[0], 128);
   SetLength(Result, {$IFNDEF VER230}AnsiStrings.{$ENDIF}StrLen(PAnsiChar(@Buf[0])));
   Move(Buf, Result[1], Length(Result));
End;

{ THBColor }

Constructor THBColor.Mix(Const B, G, R, A: Byte);
Begin
   Blue := B;
   Green := G;
   Red := R;
   Alpha := A;
End;

{ THBBlob }

Function THBBlob.CopyWritable: THBBlob;
Begin
   Result := hb_blob_copy_writable_or_fail(Self);
End;

Class Function THBBlob.Create(Const AData: TBytes; Const AMode: THBMemoryMode; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc; Const AFailOnError: Boolean = False): THBBlob;
Begin
   If AFailOnError Then Begin
      Result := hb_blob_create_or_fail(PByte(AData), Length(AData), AMode, AUserData, ADestroy);
      If Not Assigned(Result.FValue) Then
         Raise EHarfBuzz.Create(sCreationFailed);
   End
   Else
      Result := hb_blob_create(PByte(AData), Length(AData), AMode, AUserData, ADestroy);
End;

Class Function THBBlob.Create(Const AFileName: AnsiString; Const AFailOnError: Boolean = False): THBBlob;
Begin
   If AFailOnError Then Begin
      Result := hb_blob_create_from_file_or_fail(PAnsiChar(AFileName));
      If Not Assigned(Result.FValue) Then
         Raise EHarfBuzz.Create(sCreationFailed);
   End
   Else
      Result := hb_blob_create_from_file(PAnsiChar(AFileName));
End;

Function THBBlob.CreateSubBlob(Const AOffset, ALength: Integer): THBBlob;
Begin
   Result := hb_blob_create_sub_blob(Self, AOffset, ALength);
End;

Procedure THBBlob.Destroy;
Begin
   hb_blob_destroy(Self);
End;

Class Function THBBlob.GetEmpty: THBBlob;
Begin
   Result := hb_blob_get_empty;
End;

Function THBBlob.GetData(Out OLength: Cardinal): PByte;
Begin
   Result := hb_blob_get_data(Self, OLength);
End;

Function THBBlob.GetDataWritable(Out OLength: Cardinal): PByte;
Begin
   Result := hb_blob_get_data_writable(Self, OLength);
End;

Function THBBlob.GetFaceCount: Cardinal;
Begin
   Result := hb_face_count(Self);
End;

Function THBBlob.GetLength: Cardinal;
Begin
   Result := hb_blob_get_length(Self);
End;

Function THBBlob.GetUserData(Const AKey): Pointer;
Begin
   Result := hb_blob_get_user_data(Self, AKey);
End;

Function THBBlob.IsImmutable: Boolean;
Begin
   Result := hb_blob_is_immutable(Self);
End;

Procedure THBBlob.MakeImmutable;
Begin
   hb_blob_make_immutable(Self);
End;

Function THBBlob.Reference: THBBlob;
Begin
   Result := hb_blob_reference(Self);
End;

Procedure THBBlob.SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: Boolean);
Begin
   If Not hb_blob_set_user_data(Self, AKey, AData, ADestroy, AReplace) Then
      Raise EHarfBuzz.Create(sErrorUserData);
End;

{ THBUnicodeFuncs }

Function THBUnicodeFuncs.CombiningClass(Const AUnicode: THBCodepoint): THBUnicodeCombiningClass;
Begin
   Result := hb_unicode_combining_class(Self, AUnicode);
End;

Function THBUnicodeFuncs.Compose(Const A, B: THBCodepoint; Out AB: THBCodepoint): Boolean;
Begin
   Result := hb_unicode_compose(Self, A, B, AB);
End;

Class Function THBUnicodeFuncs.Create: THBUnicodeFuncs;
Begin
   Result := hb_unicode_funcs_create(cNIL);
End;

Class Function THBUnicodeFuncs.Create(Parent: THBUnicodeFuncs): THBUnicodeFuncs;
Begin
   Result := hb_unicode_funcs_create(Parent);
End;

Function THBUnicodeFuncs.Decompose(Const AB: THBCodepoint; Out A, B: THBCodepoint): Boolean;
Begin
   Result := hb_unicode_decompose(Self, AB, A, B);
End;

Procedure THBUnicodeFuncs.Destroy;
Begin
   hb_unicode_funcs_destroy(Self);
End;

Function THBUnicodeFuncs.GeneralCategory(Const AUnicode: THBCodepoint): THBUnicodeGeneralCategory;
Begin
   Result := hb_unicode_general_catgegory(Self, AUnicode);
End;

Class Function THBUnicodeFuncs.GetDefault: THBUnicodeFuncs;
Begin
   Result := hb_unicode_funcs_get_default;
End;

Class Function THBUnicodeFuncs.GetEmpty: THBUnicodeFuncs;
Begin
   Result := hb_unicode_funcs_get_empty;
End;

Function THBUnicodeFuncs.GetParent: THBUnicodeFuncs;
Begin
   Result := hb_unicode_funcs_get_parent(Self);
End;

Function THBUnicodeFuncs.GetUserData(Const AKey): Pointer;
Begin
   Result := hb_unicode_funcs_get_user_data(Self, AKey);
End;

Function THBUnicodeFuncs.IsImmutable: Boolean;
Begin
   Result := hb_unicode_funcs_is_immutable(Self);
End;

Procedure THBUnicodeFuncs.MakeImmutable;
Begin
   hb_unicode_funcs_make_immutable(Self);
End;

Function THBUnicodeFuncs.Mirroring(Const AUnicode: THBCodepoint): THBCodepoint;
Begin
   Result := hb_unicode_mirroring(Self, AUnicode);
End;

Function THBUnicodeFuncs.Reference: THBUnicodeFuncs;
Begin
   Result := hb_unicode_funcs_reference(Self);
End;

Function THBUnicodeFuncs.Script(Const AUnicode: THBCodepoint): THBCodepoint;
Begin
   Result := hb_unicode_mirroring(Self, AUnicode);
End;

Procedure THBUnicodeFuncs.SetCombiningClassFunc(Const AFunc: THBUnicodeCombiningClassFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_unicode_funcs_set_combining_class_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBUnicodeFuncs.SetComposeFunc(Const AFunc: THBUnicodeComposeFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_unicode_funcs_set_compose_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBUnicodeFuncs.SetDecomposeFunc(Const AFunc: THBUnicodeDecomposeFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_unicode_funcs_set_decompose_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBUnicodeFuncs.SetGeneralCategoryFunc(Const AFunc: THBUnicodeGeneralCategoryFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_unicode_funcs_set_general_category_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBUnicodeFuncs.SetMirroringFunc(Const AFunc: THBUnicodeMirroringFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_unicode_funcs_set_mirroring_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBUnicodeFuncs.SetScriptFunc(Const AFunc: THBUnicodeScriptFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_unicode_funcs_set_script_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBUnicodeFuncs.SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: Boolean);
Begin
   hb_unicode_funcs_set_user_data(Self, AKey, AData, ADestroy, AReplace);
End;

{ THBSet }

Procedure THBSet.Add(Const ACodepoint: THBCodepoint);
Begin
   hb_set_add(Self, ACodepoint);
End;

Procedure THBSet.AddRange(Const AFirst, ALast: THBCodepoint);
Begin
   hb_set_add_range(Self, AFirst, ALast);
End;

Function THBSet.AllocationSuccessful: Boolean;
Begin
   Result := hb_set_allocation_successful(Self);
End;

Procedure THBSet.Assign(Const AOther: THBSet);
Begin
   hb_set_set(Self, AOther);
End;

Procedure THBSet.Clear;
Begin
   hb_set_clear(Self);
End;

Function THBSet.Copy: THBSet;
Begin
   Result := hb_set_copy(Self);
End;

Function THBSet.Count: Cardinal;
Begin
   Result := hb_set_get_population(Self);
End;

Class Function THBSet.Create: THBSet;
Begin
   Result := hb_set_create;
End;

Procedure THBSet.Delete(Const ACodepoint: THBCodepoint);
Begin
   hb_set_del(Self, ACodepoint);
End;

Procedure THBSet.DeleteRange(Const AFirst, ALast: THBCodepoint);
Begin
   hb_set_del_range(Self, AFirst, ALast);
End;

Procedure THBSet.Destroy;
Begin
   hb_set_destroy(Self);
End;

Class Operator THBSet.Equal(Const ASet, AOther: THBSet): Boolean;
Begin
   Result := hb_set_is_equal(ASet, AOther);
End;

Class Function THBSet.GetEmpty: THBSet;
Begin
   Result := hb_set_get_empty;
End;

Function THBSet.GetNext(Const ACodepoint: THBCodepoint): THBCodepoint;
Begin
   Result := ACodepoint;
   hb_set_next(Self, Result);
End;

Function THBSet.GetPrevious(Const ACodepoint: THBCodepoint): THBCodepoint;
Begin
   Result := ACodepoint;
   hb_set_previous(Self, Result);
End;

Function THBSet.GetUserData(Const AKey): Pointer;
Begin
   Result := hb_set_get_user_data(Self, AKey);
End;

Class Operator THBSet.GreaterThanOrEqual(Const ASuperset, ASubset: THBSet): Boolean;
Begin
   Result := hb_set_is_subset(ASubset, ASuperset);
End;

Function THBSet.Has(Const ACodepoint: THBCodepoint): Boolean;
Begin
   Result := hb_set_has(Self, ACodepoint);
End;

Procedure THBSet.Intersect(Const AOther: THBSet);
Begin
   hb_set_intersect(Self, AOther);
End;

Function THBSet.IsEmpty: Boolean;
Begin
   Result := hb_set_is_empty(Self);
End;

Function THBSet.IsEqual(Const AOther: THBSet): Boolean;
Begin
   Result := hb_set_is_equal(Self, AOther);
End;

Function THBSet.IsSubset(Const ALargerSet: THBSet): Boolean;
Begin
   Result := hb_set_is_subset(Self, ALargerSet);
End;

Class Operator THBSet.LessThanOrEqual(Const ASubset, ASuperset: THBSet): Boolean;
Begin
   Result := hb_set_is_subset(ASubset, ASuperset);
End;

Function THBSet.Max: THBCodepoint;
Begin
   Result := hb_set_get_max(Self);
End;

Function THBSet.Min: THBCodepoint;
Begin
   Result := hb_set_get_min(Self);
End;

Function THBSet.Next(Var Codepoint: THBCodepoint): Boolean;
Begin
   Result := hb_set_next(Self, Codepoint);
End;

Function THBSet.NextRange(Var First, Last: THBCodepoint): Boolean;
Begin
   Result := hb_set_next_range(Self, First, Last);
End;

Function THBSet.Previous(Var Codepoint: THBCodepoint): Boolean;
Begin
   Result := hb_set_previous(Self, Codepoint);
End;

Function THBSet.PreviousRange(Var First, Last: THBCodepoint): Boolean;
Begin
   Result := hb_set_previous_range(Self, First, Last);
End;

Function THBSet.Reference: THBSet;
Begin
   Result := hb_set_reference(Self);
End;

Procedure THBSet.SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: Boolean);
Begin
   If Not hb_set_set_user_data(Self, AKey, AData, ADestroy, AReplace) Then
      Raise EHarfBuzz.Create(sErrorUserData);
End;

Procedure THBSet.Subtract(Const AOther: THBSet);
Begin
   hb_set_subtract(Self, AOther);
End;

Procedure THBSet.SymmetricDifference(Const AOther: THBSet);
Begin
   hb_set_symmetric_difference(Self, AOther);
End;

Procedure THBSet.Union(Const AOther: THBSet);
Begin
   hb_set_union(Self, AOther);
End;

{ THBFace }

Procedure THBFace.BuilderAddTable(Const ATag: THBTag; Blob: THBBlob);
Begin
   If Not hb_face_builder_add_table(Self, ATag, Blob) Then
      Raise EHarfBuzz.Create(sErrorAddBuilder);
End;

Class Function THBFace.BuilderCreate: THBFace;
Begin
   Result := hb_face_builder_create;
End;

Procedure THBFace.CollectUnicodes(Into: THBSet);
Begin
   hb_face_collect_unicodes(Self, Into);
End;

Procedure THBFace.CollectVariationSelectors(Into: THBSet);
Begin
   hb_face_collect_variation_selectors(Self, Into);
End;

Procedure THBFace.CollectVariationUnicodes(Const AVariationSelector: THBCodepoint; Into: THBSet);
Begin
   hb_face_collect_variation_unicodes(Self, AVariationSelector, Into);
End;

Class Function THBFace.CreateCached(Const AFTFace: TFTFace): THBFace;
Begin
   Result := hb_ft_face_create_cached(AFTFace);
End;

Class Function THBFace.Create(Blob: THBBlob; Const AIndex: Cardinal): THBFace;
Begin
   Result := hb_face_create(Blob, AIndex);
End;

Class Function THBFace.Create(Const AReferenceTableFunc: THBReferenceTableFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc): THBFace;
Begin
   Result := hb_face_create_for_tables(AReferenceTableFunc, AUserData, ADestroy);
End;

Class Function THBFace.Create(Const AFTFace: TFTFace; Const ADestroy: THBDestroyFunc): THBFace;
Begin
   Result := hb_ft_face_create(AFTFace, ADestroy);
End;

Class Function THBFace.CreateReferenced(FTFace: TFTFace): THBFace;
Begin
   Result := hb_ft_face_create_referenced(FTFace);
End;

Procedure THBFace.Destroy;
Begin
   hb_face_destroy(Self);
End;

Class Function THBFace.GetEmpty: THBFace;
Begin
   Result := hb_face_get_empty;
End;

Function THBFace.GetGlyphCount: Cardinal;
Begin
   Result := hb_face_get_glyph_count(Self);
End;

Function THBFace.GetIndex: Cardinal;
Begin
   Result := hb_face_get_index(Self);
End;

Function THBFace.GetTableTags: TArray<THBTag>;
Var
   TableCount: Cardinal;
Begin
   TableCount := 0;
   TableCount := hb_face_get_table_tags(Self, 0, TableCount, NIL);
   SetLength(Result, TableCount);
   hb_face_get_table_tags(Self, 0, TableCount, PHBTag(Result));
End;

Function THBFace.GetUpEM: Cardinal;
Begin
   Result := hb_face_get_upem(Self);
End;

Function THBFace.GetUserData(Const AKey): Pointer;
Begin
   Result := hb_face_get_user_data(Self, AKey);
End;

Function THBFace.IsImmutable: Boolean;
Begin
   Result := hb_face_is_immutable(Self);
End;

Procedure THBFace.MakeImmutable;
Begin
   hb_face_make_immutable(Self);
End;

Function THBFace.Reference: THBFace;
Begin
   Result := hb_face_reference(Self);
End;

Function THBFace.ReferenceTable(Const ATag: THBTag): THBBlob;
Begin
   Result := hb_face_reference_table(Self, ATag);
End;

Procedure THBFace.SetGlyphCount(Const AGlyphCount: Cardinal);
Begin
   hb_face_set_glyph_count(Self, AGlyphCount);
End;

Procedure THBFace.SetIndex(Const AIndex: Cardinal);
Begin
   hb_face_set_index(Self, AIndex);
End;

Procedure THBFace.SetUpEM(Const AUpEM: Cardinal);
Begin
   hb_face_set_upem(Self, AUpEM);
End;

Procedure THBFace.SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: Boolean);
Begin
   hb_face_set_user_data(Self, AKey, AData, ADestroy, AReplace);
End;

{ THBFont }

Procedure THBFont.AddGlyphOriginForDirection(Const AGlyph: THBCodepoint; Const ADirection: THBDirection; Out X, Y: THBPosition);
Begin
   hb_font_add_glyph_origin_for_direction(Self, AGlyph, ADirection, X, Y);
End;

Class Function THBFont.Create(Const AFTFace: TFTFace; Const ADestroy: THBDestroyFunc): THBFont;
Begin
   Result := hb_ft_font_create(AFTFace, ADestroy);
End;

Class Function THBFont.Create(Const AParent: THBFont): THBFont;
Begin
   Result := hb_font_create_sub_font(AParent);
End;

Class Function THBFont.Create(Const AFace: THBFace): THBFont;
Begin
   Result := hb_font_create(AFace);
End;

Class Function THBFont.CreateReferenced(FTFace: TFTFace): THBFont;
Begin
   Result := hb_ft_font_create_referenced(FTFace);
End;

Procedure THBFont.Destroy;
Begin
   hb_font_destroy(Self);
End;

Procedure THBFont.FTFontChanged;
Begin
   hb_ft_font_changed(Self);
End;

Procedure THBFont.FTFontSetFuncs;
Begin
   hb_ft_font_set_funcs(Self);
End;

Function THBFont.FTGetFace: TFTFace;
Begin
   Result := hb_ft_font_get_face(Self);
End;

Function THBFont.FTGetLoadFlags: TFTLoadFlags;
Begin
   Result := hb_ft_font_get_load_flags(Self);
End;

Function THBFont.FTLockFace: TFTFace;
Begin
   Result := hb_ft_font_lock_face(Self);
End;

Procedure THBFont.FTSetLoadFlags(Const ALoadFlags: TFTLoadFlags);
Begin
   hb_ft_font_set_load_flags(Self, ALoadFlags);
End;

Procedure THBFont.FTUnlockFace;
Begin
   hb_ft_font_unlock_face(Self);
End;

Class Function THBFont.GetEmpty: THBFont;
Begin
   Result := hb_font_get_empty;
End;

Procedure THBFont.GetExtentsForDirection(Const ADirection: THBDirection; Out OExtents: THBFontExtents);
Begin
   hb_font_get_extents_for_direction(Self, ADirection, OExtents);
End;

Function THBFont.GetFace: THBFace;
Begin
   Result := hb_font_get_face(Self);
End;

Function THBFont.GetGlyph(Const AUnicode, AVariationSelector: THBCodepoint; Out OGlyph: THBCodepoint): Boolean;
Begin
   Result := hb_font_get_glyph(Self, AUnicode, AVariationSelector, OGlyph);
End;

Procedure THBFont.GetGlyphAdvanceForDirection(Const AGlyph: THBCodepoint; Const ADirection: THBDirection; Out X, Y: THBPosition);
Begin
   hb_font_get_glyph_advance_for_direction(Self, AGlyph, ADirection, X, Y);
End;

Procedure THBFont.GetGlyphAdvancesForDirection(Const ADirection: THBDirection; Const ACount: Cardinal; Const AFirstGlyph: PHBCodepoint; Const AGlyphStride: Cardinal; OFirstAdvance: PHBPosition;
   Const AAdvanceStride: Cardinal);
Begin
   hb_font_get_glyph_advances_for_direction(Self, ADirection, ACount, AFirstGlyph, AGlyphStride, OFirstAdvance, AAdvanceStride);
End;

Function THBFont.GetGlyphContourPoint(Const AGlyph: THBCodepoint; Const APointIndex: Cardinal; Out X, Y: THBPosition): Boolean;
Begin
   Result := hb_font_get_glyph_contour_point(Self, AGlyph, APointIndex, X, Y);
End;

Function THBFont.GetGlyphContourPointForOrigin(Const AGlyph: THBCodepoint; Const APointIndex: Cardinal; Const ADirection: THBDirection; Out X, Y: THBPosition): Boolean;
Begin
   Result := hb_font_get_glyph_contour_point_for_origin(Self, AGlyph, APointIndex, ADirection, X, Y);
End;

Function THBFont.GetGlyphExtents(Const AGlyph: THBCodepoint; Out OExtents: THBGlyphExtents): Boolean;
Begin
   Result := hb_font_get_glyph_extents(Self, AGlyph, OExtents);
End;

Function THBFont.GetGlyphExtentsForOrigin(Const AGlyph: THBCodepoint; Const ADirection: THBDirection; Out OExtents: THBGlyphExtents): Boolean;
Begin
   Result := hb_font_get_glyph_extents_for_origin(Self, AGlyph, ADirection, OExtents);
End;

Function THBFont.GetGlyphFromName(Const AName: AnsiString; Out OGlyph: THBCodepoint): Boolean;
Begin
   Result := hb_font_get_glyph_from_name(Self, PAnsiChar(AName), Length(AName), OGlyph);
End;

Function THBFont.GetGlyphHAdvance(Const AGlyph: THBCodepoint): THBPosition;
Begin
   Result := hb_font_get_glyph_h_advance(Self, AGlyph);
End;

Procedure THBFont.GetGlyphHAdvances(Const ACount: Cardinal; Const AFirstGlyph: PHBCodepoint; Const AGlyphStride: Cardinal; OFirstAdvance: PHBPosition; Const AAdvanceStride: Cardinal);
Begin
   hb_font_get_glyph_h_advances(Self, ACount, AFirstGlyph, AGlyphStride, OFirstAdvance, AAdvanceStride);
End;

Function THBFont.GetGlyphHKerning(Const ALeftGlyph, ARightGlyph: THBCodepoint): THBPosition;
Begin
   Result := hb_font_get_glyph_h_kerning(Self, ALeftGlyph, ARightGlyph);
End;

Function THBFont.GetGlyphHOrigin(Const AGlyph: THBCodepoint; Out X, Y: THBPosition): Boolean;
Begin
   Result := hb_font_get_glyph_h_origin(Self, AGlyph, X, Y);
End;

Procedure THBFont.GetGlyphKerningForDirection(Const AFirstGlyph, ASecondGlyph: THBCodepoint; Const ADirection: THBDirection; Out X, Y: THBPosition);
Begin
   hb_font_get_glyph_kerning_for_direction(Self, AFirstGlyph, ASecondGlyph, ADirection, X, Y);
End;

Function THBFont.GetGlyphName(Const AGlyph: THBCodepoint): AnsiString;
Var
   Buf: Packed Array [0 .. 127] Of AnsiChar; // just assume 128 bytes are more than enough
Begin
   If hb_font_get_glyph_name(Self, AGlyph, @Buf[0], 128) Then
      Result := AnsiString(PAnsiChar(@Buf[0]))
   Else
      Result := '';
End;

Procedure THBFont.GetGlyphOriginForDirection(Const AGlyph: THBCodepoint; Const ADirection: THBDirection; Out X, Y: THBPosition);
Begin
   hb_font_get_glyph_origin_for_direction(Self, AGlyph, ADirection, X, Y);
End;

Function THBFont.GetGlyphVAdvance(Const AGlyph: THBCodepoint): THBPosition;
Begin
   Result := hb_font_get_glyph_v_advance(Self, AGlyph);
End;

Procedure THBFont.GetGlyphVAdvances(Const ACount: Cardinal; Const AFirstGlyph: PHBCodepoint; Const AGlyphStride: Cardinal; OFirstAdvance: PHBPosition; Const AAdvanceStride: Cardinal);
Begin
   hb_font_get_glyph_v_advances(Self, ACount, AFirstGlyph, AGlyphStride, OFirstAdvance, AAdvanceStride);
End;

Function THBFont.GetGlyphVOrigin(Const AGlyph: THBCodepoint; Out X, Y: THBPosition): Boolean;
Begin
   Result := hb_font_get_glyph_v_origin(Self, AGlyph, X, Y);
End;

Function THBFont.GetHExtents(Out OExtents: THBFontExtents): Boolean;
Begin
   Result := hb_font_get_h_extents(Self, OExtents);
End;

Function THBFont.GetNominalGlyph(Const AUnicode: THBCodepoint; Out OGlyph: THBCodepoint): Boolean;
Begin
   Result := hb_font_get_nominal_glyph(Self, AUnicode, OGlyph);
End;

Function THBFont.GetNominalGlyphs(Const ACount: Cardinal; Const AFirstUnicode: PHBCodepoint; Const AUnicodeStride: Cardinal; OFirstGlyph: PHBCodepoint; Const AGlyphStride: Cardinal): Integer;
Begin
   Result := hb_font_get_nominal_glyphs(Self, ACount, AFirstUnicode, AUnicodeStride, OFirstGlyph, AGlyphStride);
End;

Function THBFont.GetParent: THBFont;
Begin
   Result := hb_font_get_parent(Self);
End;

Function THBFont.GetPpEM: THBFontPpEM;
Begin
   Result.FParent := @Self;
End;

Function THBFont.GetPTEM: Single;
Begin
   Result := hb_font_get_ptem(Self);
End;

Function THBFont.GetScale: THBFontScale;
Begin
   Result.FParent := @Self;
End;

Function THBFont.GetUserData(Const AKey): Pointer;
Begin
   Result := hb_font_get_user_data(Self, AKey);
End;

Function THBFont.GetVarCoordsNormalized: TArray<Integer>;
Var
   Len: Cardinal;
   Buf: PInteger;
Begin
   Buf := hb_font_get_var_coords_normalized(Self, Len);
   SetLength(Result, Len);
   Move(Buf^, Result[0], Len * SizeOf(Integer));
End;

Function THBFont.GetVariationGlyph(Const AUnicode, AVariationSelector: THBCodepoint; Out OGlyph: THBCodepoint): Boolean;
Begin
   Result := hb_font_get_variation_glyph(Self, AUnicode, AVariationSelector, OGlyph);
End;

Function THBFont.GetVExtents(Out OExtents: THBFontExtents): Boolean;
Begin
   Result := hb_font_get_v_extents(Self, OExtents);
End;

Function THBFont.GlyphFromString(Const AString: AnsiString; Out OGlyph: THBCodepoint): Boolean;
Begin
   Result := hb_font_glyph_from_string(Self, PAnsiChar(AString), Length(AString), OGlyph);
End;

Function THBFont.GlyphToString(Const AGlyph: THBCodepoint): AnsiString;
Var
   Buf: Packed Array [0 .. 127] Of AnsiChar; // doc says 128 bytes are more than enough
Begin
   hb_font_glyph_to_string(Self, AGlyph, @Buf[0], 128);
   SetLength(Result, {$IFNDEF VER230}AnsiStrings.{$ENDIF}StrLen(PAnsiChar(@Buf[0])));
   Move(Buf, Result[1], Length(Result));
End;

Function THBFont.IsImmutable: Boolean;
Begin
   Result := hb_font_is_immutable(Self);
End;

Procedure THBFont.MakeImmutable;
Begin
   hb_font_make_immutable(Self);
End;

Function THBFont.Reference: THBFont;
Begin
   Result := hb_font_reference(Self);
End;

Procedure THBFont.SetFace(Const AFace: THBFace);
Begin
   hb_font_set_face(Self, AFace);
End;

Procedure THBFont.SetFuncsData(Const AFontData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_set_funcs_data(Self, AFontData, ADestroy);
End;

Procedure THBFont.SetParent(Const AParent: THBFont);
Begin
   hb_font_set_parent(Self, AParent);
End;

Procedure THBFont.SetPpEM(Const AValue: THBFontPpEM);
Var
   X, Y: Cardinal;
Begin
   hb_font_get_ppem(THBFont(AValue), X, Y);
   hb_font_set_ppem(Self, X, Y);
End;

Procedure THBFont.SetPTEM(Const APtEM: Single);
Begin
   hb_font_set_ptem(Self, APtEM);
End;

Procedure THBFont.SetScale(Const AValue: THBFontScale);
Var
   X, Y: Integer;
Begin
   hb_font_get_scale(Self, X, Y);
   hb_font_set_scale(Self, X, Y);
End;

Procedure THBFont.SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: Boolean);
Begin
   If Not hb_font_set_user_data(Self, AKey, AData, ADestroy, AReplace) Then
      Raise EHarfBuzz.Create(sErrorUserData);
End;

Procedure THBFont.SetVarCoordsDesign(Const ACoords: TArray<Single>);
Begin
   hb_font_set_var_coords_design(Self, PSingle(ACoords), Length(ACoords));
End;

Procedure THBFont.SetVarCoordsNormalized(Const ACoords2F14: TArray<Integer>);
Begin
   hb_font_set_var_coords_normalized(Self, PInteger(ACoords2F14), Length(ACoords2F14));
End;

Procedure THBFont.SetVariations(Const AVariations: TArray<THBVariation>);
Begin
   hb_font_set_variations(Self, PHBVariation(AVariations), Length(AVariations));
End;

Procedure THBFont.SetVarNamedInstance(Const AInstanceIndex: Cardinal);
Begin
   hb_font_set_var_named_instance(Self, AInstanceIndex);
End;

Procedure THBFont.SubtractGlyphOriginForDirection(Const AGlyph: THBCodepoint; Const ADirection: THBDirection; Out X, Y: THBPosition);
Begin
   hb_font_subtract_glyph_origin_for_direction(Self, AGlyph, ADirection, X, Y);
End;

{ THBFaceHelper }
Function THBFaceHelper.CreateFont: THBFont;
Begin
   Result := hb_font_create(Self);
End;

{ THBFontFuncs }

Class Function THBFontFuncs.Create: THBFontFuncs;
Begin
   Result := hb_font_funcs_create;
End;

Procedure THBFontFuncs.Destroy;
Begin
   hb_font_funcs_destroy(Self);
End;

Class Function THBFontFuncs.GetEmpty: THBFontFuncs;
Begin
   Result := hb_font_funcs_get_empty;
End;

Function THBFontFuncs.GetUserData(Const AKey): Pointer;
Begin
   Result := hb_font_funcs_get_user_data(Self, AKey);
End;

Function THBFontFuncs.IsImmutable: Boolean;
Begin
   Result := hb_font_funcs_is_immutable(Self);
End;

Procedure THBFontFuncs.MakeImmutable;
Begin
   hb_font_funcs_make_immutable(Self);
End;

Function THBFontFuncs.Reference: THBFontFuncs;
Begin
   Result := hb_font_funcs_reference(Self);
End;

Procedure THBFontFuncs.SetFontHExtentsFunc(Const AFunc: THBFontGetFontHExtentsFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_funcs_set_font_h_extents_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBFontFuncs.SetFontVExtentsFunc(Const AFunc: THBFontGetFontVExtentsFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_funcs_set_font_v_extents_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBFontFuncs.SetGlyphContourPointFunc(Const AFunc: THBFontGetGlyphContourPointFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_funcs_set_glyph_contour_point_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBFontFuncs.SetGlyphExtentsFunc(Const AFunc: THBFontGetGlyphExtentsFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_funcs_set_glyph_extents_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBFontFuncs.SetGlyphFromNameFunc(Const AFunc: THBFontGetGlyphFromNameFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_funcs_set_glyph_from_name_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBFontFuncs.SetGlyphHAdvanceFunc(Const AFunc: THBFontGetGlyphHAdvanceFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_funcs_set_glyph_h_advance_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBFontFuncs.SetGlyphHAdvancesFunc(Const AFunc: THBFontGetGlyphHAdvancesFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_funcs_set_glyph_h_advances_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBFontFuncs.SetGlyphHKerningFunc(Const AFunc: THBFontGetGlyphHKerningFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_funcs_set_glyph_h_kerning_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBFontFuncs.SetGlyphHOriginFunc(Const AFunc: THBFontGetGlyphHOriginFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_funcs_set_glyph_h_origin_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBFontFuncs.SetGlyphNameFunc(Const AFunc: THBFontGetGlyphNameFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_funcs_set_glyph_name_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBFontFuncs.SetGlyphVAdvanceFunc(Const AFunc: THBFontGetGlyphVAdvanceFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_funcs_set_glyph_v_advance_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBFontFuncs.SetGlyphVAdvancesFunc(Const AFunc: THBFontGetGlyphVAdvancesFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_funcs_set_glyph_v_advances_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBFontFuncs.SetGlyphVOriginFunc(Const AFunc: THBFontGetGlyphVOriginFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_funcs_set_glyph_v_origin_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBFontFuncs.SetNominalGlyphFunc(Const AFunc: THBFontGetNominalGlyphFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_funcs_set_nominal_glyph_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBFontFuncs.SetNorminalGlyphsFunc(Const AFunc: THBFontGetNominalGlyphsFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_funcs_set_nominal_glyphs_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBFontFuncs.SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: Boolean);
Begin
   If Not hb_font_funcs_set_user_data(Self, AKey, AData, ADestroy, AReplace) Then
      Raise EHarfBuzz.Create(sErrorUserData);
End;

Procedure THBFontFuncs.SetVariationGlyphFunc(Const AFunc: THBFontGetVariationGlyphFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_funcs_set_variation_glyph_func(Self, AFunc, AUserData, ADestroy);
End;

{ THBFont.THBFontScale }

Function THBFont.THBFontScale.GetXScale: Integer;
Var
   Dummy: Integer;
Begin
   hb_font_get_scale(THBFont(FParent), Result, Dummy);
End;

Function THBFont.THBFontScale.GetYScale: Integer;
Var
   Dummy: Integer;
Begin
   hb_font_get_scale(THBFont(FParent), Dummy, Result);
End;

Procedure THBFont.THBFontScale.SetXScale(Const AValue: Integer);
Begin
   hb_font_set_scale(THBFont(FParent), AValue, GetYScale);
End;

Procedure THBFont.THBFontScale.SetYScale(Const AValue: Integer);
Begin
   hb_font_set_scale(THBFont(FParent), GetXScale, AValue);
End;

{ THBFont.THBFontPpEM }

Function THBFont.THBFontPpEM.GetXPpEM: Cardinal;
Var
   Dummy: Cardinal;
Begin
   hb_font_get_ppem(THBFont(FParent), Result, Dummy);
End;

Function THBFont.THBFontPpEM.GetYPpEM: Cardinal;
Var
   Dummy: Cardinal;
Begin
   hb_font_get_ppem(THBFont(FParent), Dummy, Result);
End;

Procedure THBFont.THBFontPpEM.SetXPpEM(Const AValue: Cardinal);
Begin
   hb_font_set_ppem(THBFont(FParent), AValue, GetYPpEM);
End;

Procedure THBFont.THBFontPpEM.SetYPpEM(Const AValue: Cardinal);
Begin
   hb_font_set_ppem(THBFont(FParent), GetYPpEM, AValue);
End;

{ THBFontHelper }

Procedure THBFontHelper.SetFuncs(Const AClass: THBFontFuncs; Const AFontData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_font_set_funcs(Self, AClass, AFontData, ADestroy);
End;

{ THBGlyphInfo }

Function THBGlyphInfo.GetGlyphFlags: THBGlyphFlags;
Var
   RMask: THBMask Absolute Result;
Begin
   RMask := FMask And ((2 Shl Ord(High(THBGlyphFlag))) - 1);
End;

{ THBSegmentProperties }

Class Operator THBSegmentProperties.Equal(Const A, B: THBSegmentProperties): Boolean;
Begin
   Result := hb_segment_properties_equal(A, B);
End;

Function THBSegmentProperties.Hash: Cardinal;
Begin
   Result := hb_segment_properties_hash(Self);
End;

{ THBBufferSerializeFormatHelper }

Class Function THBBufferSerializeFormatHelper.SerializeFormatFromString(Const AStr: AnsiString): THBBufferSerializeFormat;
Begin
   Result := hb_buffer_serialize_format_from_string(PAnsiChar(AStr), Length(AStr));
End;

Function THBBufferSerializeFormatHelper.SerializeFormatToString: AnsiString;
Begin
   Result := AnsiString(hb_buffer_serialize_format_to_string(Self));
End;

Class Function THBBufferSerializeFormatHelper.SerializeListFormats: TArray<AnsiString>;
Var
   Buf: PPAnsiChar;
   I:   Integer;
Begin
   Buf := hb_buffer_serialize_list_formats;
   SetLength(Result, {$IFNDEF VER230}AnsiStrings.{$ENDIF}StrLen(PAnsiChar(Buf)));
   For I := 0 To High(Result) Do Begin
      Result[I] := AnsiString(Buf^);
      Inc(Buf);
   End;
End;

{ THBBuffer }

Procedure THBBuffer.Add(Const AText: UCS4String; Const AItemOffset: Cardinal; Const AItemLength: Integer);
Begin
   hb_buffer_add_utf32(Self, PCardinal(AText), System.Length(AText), AItemOffset, AItemLength);
End;

Procedure THBBuffer.Add(Const AText: AnsiString; Const AItemOffset: Cardinal; Const AItemLength: Integer);
Begin
   hb_buffer_add_latin1(Self, PAnsiChar(AText), System.Length(AText), AItemOffset, AItemLength);
End;

Procedure THBBuffer.Add(Const AText: UnicodeString; Const AItemOffset: Cardinal; Const AItemLength: Integer);
Begin
   hb_buffer_add_utf16(Self, PWideChar(AText), System.Length(AText), AItemOffset, AItemLength);
End;

Procedure THBBuffer.Add(Const ACodepoint: THBCodepoint; Const ACluster: Cardinal);
Begin
   hb_buffer_add(Self, ACodepoint, ACluster);
End;

Procedure THBBuffer.Add(Const AText: UTF8String; Const AItemOffset: Cardinal; Const AItemLength: Integer);
Begin
   hb_buffer_add_utf8(Self, PAnsiChar(AText), System.Length(AText), AItemOffset, AItemLength);
End;

Procedure THBBuffer.Add(Const AText: TArray<THBCodepoint>; Const AItemOffset: Cardinal; Const AItemLength: Integer);
Begin
   hb_buffer_add_codepoints(Self, PHBCodepoint(AText), System.Length(AText), AItemOffset, AItemLength);
End;

Function THBBuffer.AllocationSuccessful: Boolean;
Begin
   Result := hb_buffer_allocation_successful(Self);
End;

Procedure THBBuffer.Append(Const ASource: THBBuffer; Const AStart, AEnd: Cardinal);
Begin
   hb_buffer_append(Self, ASource, AStart, AEnd);
End;

Procedure THBBuffer.ClearContents;
Begin
   hb_buffer_clear_contents(Self);
End;

Class Function THBBuffer.Create: THBBuffer;
Begin
   Result := hb_buffer_create;
End;

Procedure THBBuffer.DeserializeGlyphs(Const ABuf: AnsiString; Const AFont: THBFont; Const AFormat: THBBufferSerializeFormat);
Var
   Dummy: PAnsiChar;
Begin
   If Not hb_buffer_deserialize_glyphs(Self, PAnsiChar(ABuf), System.Length(ABuf), Dummy, AFont, AFormat) Then
      Raise EHarfBuzz.Create(sErrorDeserializeGlyphs);
End;

Procedure THBBuffer.DeserializeUnicode(Const ABuf: AnsiString; Const AFormat: THBBufferSerializeFormat);
Var
   Dummy: PAnsiChar;
Begin
   If Not hb_buffer_deserialize_unicode(Self, PAnsiChar(ABuf), System.Length(ABuf), Dummy, AFormat) Then
      Raise EHarfBuzz.Create(sErrorDeserializeUnicode);
End;

Procedure THBBuffer.Destroy;
Begin
   hb_buffer_destroy(Self);
End;

Function THBBuffer.Diff(Const AReference: THBBuffer; Const ADottedcircleGlyph: THBCodepoint; Const APositionFuzz: Cardinal): THBBufferDiffFlags;
Begin
   Result := hb_buffer_diff(Self, AReference, ADottedcircleGlyph, APositionFuzz);
End;

Function THBBuffer.GetClusterLevel: THBBufferClusterLevel;
Begin
   Result := hb_buffer_get_cluster_level(Self);
End;

Function THBBuffer.GetContentType: THBBufferContentType;
Begin
   Result := hb_buffer_get_content_type(Self);
End;

Function THBBuffer.GetDirection: THBDirection;
Begin
   Result := hb_buffer_get_direction(Self);
End;

Class Function THBBuffer.GetEmpty: THBBuffer;
Begin
   Result := hb_buffer_get_empty;
End;

Function THBBuffer.GetFlags: THBBufferFlags;
Begin
   Result := hb_buffer_get_flags(Self);
End;

Function THBBuffer.GetGlyphInfos: TArray<THBGlyphInfo>;
Var
   Buf: PHBGlyphInfo;
   Len: Cardinal;
Begin
   Buf := hb_buffer_get_glyph_infos(Self, Len);
   System.SetLength(Result, Len);
   Move(Buf^, Result[0], Len * SizeOf(THBGlyphInfo));
End;

Function THBBuffer.GetGlyphPositions: TArray<THBGlyphPosition>;
Var
   Buf: PHBGlyphPosition;
   Len: Cardinal;
Begin
   Buf := hb_buffer_get_glyph_positions(Self, Len);
   System.SetLength(Result, Len);
   Move(Buf^, Result[0], Len * SizeOf(THBGlyphPosition));
End;

Function THBBuffer.GetInvisibleGlyph: THBCodepoint;
Begin
   Result := hb_buffer_get_invisible_glyph(Self);
End;

Function THBBuffer.GetLanguage: THBLanguage;
Begin
   Result := hb_buffer_get_language(Self);
End;

Function THBBuffer.GetLength: Cardinal;
Begin
   Result := hb_buffer_get_length(Self);
End;

Function THBBuffer.GetReplacementCodepoint: THBCodepoint;
Begin
   Result := hb_buffer_get_replacement_codepoint(Self);
End;

Function THBBuffer.GetScript: THBScript;
Begin
   Result := hb_buffer_get_script(Self);
End;

Function THBBuffer.GetSegmentProperties: THBSegmentProperties;
Begin
   hb_buffer_get_segment_properties(Self, Result);
End;

Function THBBuffer.GetUnicodeFuncs: THBUnicodeFuncs;
Begin
   Result := hb_buffer_get_unicode_funcs(Self);
End;

Function THBBuffer.GetUserData(Const AKey): Pointer;
Begin
   Result := hb_buffer_get_user_data(Self, AKey);
End;

Procedure THBBuffer.GuessSegmentProperties;
Begin
   hb_buffer_guess_segment_properties(Self);
End;

Function THBBuffer.HasPositions: Boolean;
Begin
   Result := hb_buffer_has_positions(Self);
End;

Class Function THBBuffer.ListShapers: TArray<AnsiString>;
Var
   Buf: PPAnsiChar;
   I:   Integer;
Begin
   Buf := hb_shape_list_shapers;
   System.SetLength(Result, {$IFNDEF VER230}AnsiStrings.{$ENDIF}StrLen(PAnsiChar(Buf)));
   For I := 0 To High(Result) Do Begin
      Result[I] := AnsiString(Buf^);
      Inc(Buf);
   End;
End;

Procedure THBBuffer.NormalizeGlyphs;
Begin
   hb_buffer_normalize_glyphs(Self);
End;

Procedure THBBuffer.PreAllocate(Const ASize: Cardinal);
Begin
   If Not hb_buffer_pre_allocate(Self, ASize) Then
      Raise EHarfBuzz.Create(sErrorPreAllocate);
End;

Function THBBuffer.Reference: THBBuffer;
Begin
   Result := hb_buffer_reference(Self);
End;

Procedure THBBuffer.Reset;
Begin
   hb_buffer_reset(Self);
End;

Procedure THBBuffer.Reverse;
Begin
   hb_buffer_reverse(Self);
End;

Procedure THBBuffer.ReverseClusters;
Begin
   hb_buffer_reverse_clusters(Self);
End;

Procedure THBBuffer.ReverseRange(Const AStart, AEnd: Cardinal);
Begin
   hb_buffer_reverse_range(Self, AStart, AEnd);
End;

Function THBBuffer.Serialize(Const AStart, AEnd: Cardinal; Const AFont: THBFont; Const AFormat: THBBufferSerializeFormat; Const AFlags: THBBufferSerializeFlags): AnsiString;
Var
   Buf:             Packed Array [0 .. 127] Of AnsiChar;
   Consumed, Start: Cardinal;
Begin
   Result := '';
   Start := AStart;
   While Start < AEnd Do Begin
      Inc(Start, hb_buffer_serialize(Self, Start, AEnd, @Buf[0], 128, Consumed, AFont, AFormat, AFlags));
      Result := Result + Buf; // Buf will always be null-terminated
   End;
End;

Function THBBuffer.SerializeGlyphs(Const AStart, AEnd: Cardinal; Const AFont: THBFont; Const AFormat: THBBufferSerializeFormat; Const AFlags: THBBufferSerializeFlags): AnsiString;
Var
   Buf:             Packed Array [0 .. 127] Of AnsiChar;
   Consumed, Start: Cardinal;
Begin
   Result := '';
   Start := AStart;
   While Start < AEnd Do Begin
      Inc(Start, hb_buffer_serialize_glyphs(Self, Start, AEnd, @Buf[0], 128, Consumed, AFont, AFormat, AFlags));
      Result := Result + Buf; // Buf will always be null-terminated
   End;
End;

Function THBBuffer.SerializeUnicode(Const AStart, AEnd: Cardinal; Const AFormat: THBBufferSerializeFormat; Const AFlags: THBBufferSerializeFlags): AnsiString;
Var
   Buf:             Packed Array [0 .. 127] Of AnsiChar;
   Consumed, Start: Cardinal;
Begin
   Result := '';
   Start := AStart;
   While Start < AEnd Do Begin
      Inc(Start, hb_buffer_serialize_unicode(Self, Start, AEnd, @Buf[0], 128, Consumed, AFormat, AFlags));
      Result := Result + Buf; // Buf will always be null-terminated
   End;
End;

Procedure THBBuffer.SetClusterLevel(Const AClusterLevel: THBBufferClusterLevel);
Begin
   hb_buffer_set_cluster_level(Self, AClusterLevel);
End;

Procedure THBBuffer.SetContentType(Const AContentType: THBBufferContentType);
Begin
   hb_buffer_set_content_type(Self, AContentType);
End;

Procedure THBBuffer.SetDirection(Const ADirection: THBDirection);
Begin
   hb_buffer_set_direction(Self, ADirection);
End;

Procedure THBBuffer.SetFlags(Const AFlags: THBBufferFlags);
Begin
   hb_buffer_set_flags(Self, AFlags);
End;

Procedure THBBuffer.SetInvisibleGlyph(Const AInvisible: THBCodepoint);
Begin
   hb_buffer_set_invisible_glyph(Self, AInvisible);
End;

Procedure THBBuffer.SetLanguage(Const ALanguage: THBLanguage);
Begin
   hb_buffer_set_language(Self, ALanguage);
End;

Procedure THBBuffer.SetLength(Const ALength: Cardinal);
Begin
   If Not hb_buffer_set_length(Self, ALength) Then
      Raise EHarfBuzz.Create(sErrorSetLength);
End;

Procedure THBBuffer.SetMessageFunc(Const AFunc: THBBufferMessageFunc; Const AUserData: Pointer; Const ADestroy: THBDestroyFunc);
Begin
   hb_buffer_set_message_func(Self, AFunc, AUserData, ADestroy);
End;

Procedure THBBuffer.SetReplacementCodepoint(Const AReplacement: THBCodepoint);
Begin
   hb_buffer_set_replacement_codepoint(Self, AReplacement);
End;

Procedure THBBuffer.SetScript(Const AScript: THBScript);
Begin
   hb_buffer_set_script(Self, AScript);
End;

Procedure THBBuffer.SetSegmentProperties(Const AProps: THBSegmentProperties);
Begin
   hb_buffer_set_segment_properties(Self, AProps);
End;

Procedure THBBuffer.SetUnicodeFuncs(Const AUnicodeFuncs: THBUnicodeFuncs);
Begin
   hb_buffer_set_unicode_funcs(Self, AUnicodeFuncs);
End;

Procedure THBBuffer.SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: THBBool);
Begin
   If Not hb_buffer_set_user_data(Self, AKey, AData, ADestroy, AReplace) Then
      Raise EHarfBuzz.Create(sErrorUserData);
End;

Procedure THBBuffer.Shape(Font: THBFont; Const AFeatures: TArray<THBFeature>);
Begin
   hb_shape(Font, Self, PHBFeature(AFeatures), System.Length(AFeatures));
End;

Procedure THBBuffer.ShapeFull(Font: THBFont; Const AFeatures: TArray<THBFeature>; Const AShaperList: TArray<AnsiString>);
Var
   ShaperList: TArray<Pointer>;
Begin
   If Assigned(AShaperList) Then Begin
      // We can in principle directly use the AShaperList array, but it needs to be
      // zero-terminated
      System.SetLength(ShaperList, System.Length(AShaperList) + 1);
      Move(AShaperList[0], ShaperList[0], System.Length(AShaperList) * SizeOf(Pointer));
      ShaperList[High(ShaperList)] := NIL;
      If hb_shape_full(Font, Self, PHBFeature(AFeatures), System.Length(AFeatures), PPAnsiChar(ShaperList)) Then
         Exit;
   End Else If hb_shape_full(Font, Self, PHBFeature(AFeatures), System.Length(AFeatures), NIL) Then
      Exit;
   Raise EHarfBuzz.Create(sErrorShape);
End;

{ THBMap }

Function THBMap.AllocationSuccessful: Boolean;
Begin
   Result := hb_map_allocation_successful(Self);
End;

Procedure THBMap.Clear;
Begin
   hb_map_clear(Self);
End;

Function THBMap.Count: Cardinal;
Begin
   Result := hb_map_get_population(Self);
End;

Class Function THBMap.Create: THBMap;
Begin
   Result := hb_map_create;
End;

Procedure THBMap.Delete(Const AKey: THBCodepoint);
Begin
   hb_map_del(Self, AKey);
End;

Procedure THBMap.Destroy;
Begin
   hb_map_destroy(Self);
End;

Function THBMap.Get(Const AKey: THBCodepoint): THBCodepoint;
Begin
   Result := hb_map_get(Self, AKey);
End;

Function THBMap.GetUserData(Const AKey): Pointer;
Begin
   Result := hb_map_get_user_data(Self, AKey);
End;

Class Function THBMap.GetEmpty: THBMap;
Begin
   Result := hb_map_get_empty;
End;

Function THBMap.Has(Const AKey: THBCodepoint): Boolean;
Begin
   Result := hb_map_has(Self, AKey);
End;

Function THBMap.IsEmpty: Boolean;
Begin
   Result := hb_map_is_empty(Self);
End;

Function THBMap.Reference: THBMap;
Begin
   Result := hb_map_reference(Self);
End;

Procedure THBMap.&Set(Const AKey, AValue: THBCodepoint);
Begin
   hb_map_set(Self, AKey, AValue);
End;

Procedure THBMap.SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: Boolean);
Begin
   If Not hb_map_set_user_data(Self, AKey, AData, ADestroy, AReplace) Then
      Raise EHarfBuzz.Create(sErrorUserData);
End;

{ THBShapePlan }

Class Function THBShapePlan.Create(Face: THBFace; Const AProps: THBSegmentProperties; Const AUserFeatures: TArray<THBFeature>; Const AShaperList: TArray<AnsiString>; Const ACoords: TArray<Integer>;
   Const ACached: Boolean): THBShapePlan;
Var
   ShaperList: TArray<Pointer>;
Begin
   If Assigned(AShaperList) Then Begin
      // We can in principle directly use the AShaperList array, but it needs to be
      // zero-terminated
      SetLength(ShaperList, Length(AShaperList) + 1);
      Move(AShaperList[0], ShaperList[0], Length(AShaperList) * SizeOf(Pointer));
      ShaperList[High(ShaperList)] := NIL;
   End
   Else
      ShaperList := NIL;
   If Assigned(ACoords) Then
      If ACached Then
         Result := hb_shape_plan_create_cached2(Face, AProps, PHBFeature(AUserFeatures), Length(AUserFeatures), PInteger(ACoords), Length(ACoords), PPAnsiChar(ShaperList))
      Else
         Result := hb_shape_plan_create2(Face, AProps, PHBFeature(AUserFeatures), Length(AUserFeatures), PInteger(ACoords), Length(ACoords), PPAnsiChar(ShaperList))
   Else If ACached Then
      Result := hb_shape_plan_create_cached(Face, AProps, PHBFeature(AUserFeatures), Length(AUserFeatures), PPAnsiChar(ShaperList))
   Else
      Result := hb_shape_plan_create(Face, AProps, PHBFeature(AUserFeatures), Length(AUserFeatures), PPAnsiChar(ShaperList));
End;

Procedure THBShapePlan.Destroy(ShapePlan: THBShapePlan);
Begin
   hb_shape_plan_destroy(Self);
End;

Function THBShapePlan.Execute(Font: THBFont; Buffer: THBBuffer; Const AFeatures: TArray<THBFeature>): Boolean;
Begin
   Result := hb_shape_plan_execute(Self, Font, Buffer, PHBFeature(AFeatures), Length(AFeatures));
End;

Class Function THBShapePlan.GetEmpty: THBShapePlan;
Begin
   Result := hb_shape_plan_get_empty;
End;

Function THBShapePlan.GetShaper: AnsiString;
Begin
   Result := AnsiString(hb_shape_plan_get_empty);
End;

Function THBShapePlan.GetUserData(Const AKey): Pointer;
Begin
   Result := hb_shape_plan_get_user_data(Self, AKey);
End;

Function THBShapePlan.Reference(ShapePlan: THBShapePlan): THBShapePlan;
Begin
   Result := hb_shape_plan_reference(Self);
End;

Procedure THBShapePlan.SetUserData(Const AKey; Const AData: Pointer; Const ADestroy: THBDestroyFunc; Const AReplace: Boolean);
Begin
   If Not hb_shape_plan_set_user_data(Self, AKey, AData, ADestroy, AReplace) Then
      Raise EHarfBuzz.Create('Error settings shape plan user data');
End;

{ THarfBuzzManager }

Class Procedure THarfBuzzManager.Initialize;
Begin
   If Not hb_version_atleast(HB_VERSION_MAJOR, HB_VERSION_MINOR, HB_VERSION_MICRO) Then
      Raise EHarfBuzz.CreateFmt('HarfBuzz version expected to be at least %s, got %s', [HB_VERSION_STRING, VersionString]);
   hb_version(FMajor, FMinor, FMicro);
End;

Class Function THarfBuzzManager.VersionString: AnsiString;
Begin
   Result := AnsiString(HB_VERSION_STRING);
End;

Initialization

THarfBuzzManager.Initialize;

End.
