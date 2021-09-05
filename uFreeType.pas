// Translation of the FreeType interface into Delphi Language/Object Pascal
// Based on version 2.11.0
// This header file is Copyright (C) 2021 by Benjamin Desef
// You may use it under the same conditions as FreeType itself, i.e., you may choose to
// either apply the FreeType License or the GNU General Public License version 2.
// The original FreeType copyright header is
// Copyright (C) 1996-2021 by
// David Turner, Robert Wilhelm, and Werner Lemberg.

{$Z1}
Unit uFreeType;

Interface

{$IFDEF FPC}
{$MODE Delphi}
{$MESSAGE FATAL 'Replace every instance of "[Ref] Const" in this file by "Constref", then disable this error.'}
{$ENDIF}

Uses SysUtils{$IFNDEF VER230}, AnsiStrings{$ENDIF};

Const
   FreeTypeDLL = 'freetype.dll';

Type
   EFreeType = Class(Exception)
   End;

{$REGION 'fttypes.h'}
   // Basic Data Types

   TFTTag     = Type Cardinal;
   TFTF2Dot14 = Type SmallInt;
   TFTF26Dot6 = Type LongInt;
   TFTFixed   = Type LongInt;

   TFTError = Integer;

   TFTErrorHelper = Record Helper For TFTError
   Public
      Function Base: Byte; Inline;
      Function Module: Word; Inline;
      Function Equals(Const AError: TFTError): Boolean; Inline;
      Function Inequals(Const AError: TFTError): Boolean; Inline;
   End;

   TFTUnitVector = Record
      X, Y: TFTF2Dot14;
   End;

   PFTMatrix = ^TFTMatrix;

   TFTMatrix = Record
      XX, XY, YX, YY: TFTFixed;
   End;

   TFTData = Record
      Pointer: PByte;
      Length: Integer;
   End;

   TFTGeneric = Record
      Data: Pointer;
      Finalizer: Procedure(AObject: Pointer); Cdecl;
   End;

   // List management
   PFTListNode = ^TFTListNode;

   TFTListNode = Record
      Prev, Next: PFTListNode;
      Data: Pointer;
   End;

   PFTList = ^TFTList;

   TFTList = Record
      Head, Tail: PFTListNode;

      Function IsEmpty: Boolean; Inline;
   End;
{$ENDREGION}
{$REGION 'ftsystem.h'}
   // System interface. How FreeType manages memory and i/o

   // Memory management
   PFTMemory = ^TFTMemory;

   TFTMemory = Record
      User: Pointer;
      AllocFunc: Function([Ref] Const AMemory: TFTMemory; Const ASize: LongInt): Pointer; Cdecl;
      FreeFunc: Procedure([Ref] Const AMemory: TFTMemory; Const ABlock: Pointer); Cdecl;
      ReallocFunc: Function([Ref] Const AMemory: TFTMemory; Const ACurSize, ANewSize: LongInt; Const ABlock: Pointer): Pointer; Cdecl;

      Function Alloc(Const ASize: LongInt): Pointer; Inline;
      Procedure Free(Const ABlock: Pointer); Inline;
      Function Realloc(Const ACurSize, ANewSize: LongInt; Const ABlock: Pointer): Pointer; Inline;
   End;

   // I/O management
   PFTStream = ^TFTStream;

   TFTStream = Record
   Strict Private
   Type
      TFTStreamDesc = Record
         Case Boolean Of
            False:
               (Value: LongInt);
            True:
               (Pointer: Pointer);
      End;
   Public
      Base:      PByte;
      Size, Pos: LongWord;
   Strict Private
      FDescriptor: TFTStreamDesc;
   Public
      Property DescriptorInt:     LongInt Read FDescriptor.Value Write FDescriptor.Value;
      Property DescriptorPointer: Pointer Read FDescriptor.Pointer Write FDescriptor.Pointer;
   Public
      Pathname:  PAnsiChar;
      ReadFunc:  Function(Var Stream: TFTStream; Const AOffset: LongWord; Var ABuffer; Const ACount: LongWord): LongWord; Cdecl;
      CloseFunc: Procedure(Var Stream: TFTStream); Cdecl;
   Strict Private
{$HINTS OFF}
      Memory:        PFTMemory; // internal, do not use
      Cursor, Limit: PByte;
{$HINTS ON}
   Public
      Function Read(Const AOffset: LongWord; Var ABuffer; Const ACount: LongWord): LongWord; Inline;
      Procedure Close; Inline;
   End;
{$ENDREGION}
{$REGION 'ftcolor.h'}
   // Glyph Color Management

   PFTColor = ^TFTColor;

   TFTColor = Record
   Public
      Blue, Green, Red, Alpha: Byte;
      Constructor Mix(Const ABlue, AGreen, ARed, AAlpha: Byte);
   End;

   TFTPaletteFlag  = (ftPaletteForLightBackground, ftPaletteForDarkBackground);
   TFTPaletteFlags = Set Of ftPaletteForLightBackground .. TFTPaletteFlag($F);

   TFTPaletteData = Record
      NumPalettes: Word;
      PaletteNameIds: Word;
      PaletteFlags: ^TFTPaletteFlags;
      NumPaletteEntries: Word;
      PaletteEntryNameIds: PWord;
   End;

   // Layer management
   TFTLayerIterator = Record
      NumLayers, Layer: Cardinal;
      P: PByte;
   End;
{$ENDREGION}
{$REGION 'ftimage.h'}

   // Basic types
   TFTPos = Type LongInt;

   PFTVector = ^TFTVector;

   TFTVector = Record
      X, Y: TFTPos;
   End;

   TFTBBox = Record
      XMin, YMin, XMax, YMax: TFTPos;
   End;

   TFTPixelMode = (ftpmNone, ftpmMono, ftpmGray, ftpmGray2, ftpmGray4, ftpmLcd, ftpmLcdV, ftpmBgra);

   PFTBitmap = ^TFTBitmap;

   TFTBitmap = Record
   Public
      Rows, Width: Cardinal;
      Pitch:       Integer;
      Buffer:      PByte;
      NumGrays:    Word;
      PixelMode:   TFTPixelMode;
   Strict Private
{$HINTS OFF}
      FPaletteMode: Byte;
      FPalette:     Pointer;
{$HINTS ON}
      Function GetScanLine(Const ALine: Cardinal): PByte; Inline;
   Public
      Procedure Init; Inline;
      Procedure Copy(Var Target: TFTBitmap); Inline;
      Procedure Embolden(Const AXStrength, AYStrength: TFTPos); Inline;
      Procedure Convert(Var Target: TFTBitmap; Const Alignment: Integer); Inline;
      Procedure Blend(Const ASourceOffset: TFTVector; Var Target: TFTBitmap; Var TargetOffset: TFTVector; Const AColor: TFTColor); Inline;
      Procedure Done; Inline;

      Property ScanLine[Const ALine: Cardinal]: PByte Read GetScanLine;
   End;

   TFTOutlineFlag  = (ftofOwner, ftofEvenOddFill, ftofReverseFill, ftofIgnoreDropouts, ftofSmartDropouts, ftofIncludeStubs, ftofOverlap, ftofHighPrecision = 8, ftofSinglePass);
   TFTOutlineFlags = Set Of ftofOwner .. TFTOutlineFlag($1F);

   TFTCurveTag  = (ftctOn, ftctCubic, ftctHasScanmode, ftctTouchX, ftctTouchY);
   TFTCurveTags = Set Of ftctOn .. ftctTouchY;

   // bits 5-7 should contain the drop-out mode according to the OpenType specification (SCANMODE).
   // Probably this should be SCANTYPE?
   TFTCurveTagsHelper = Record Helper For TFTCurveTags
   Public Type
      TFTDropoutRules = Set Of 1 .. 6;
   Public
      Function GetDropoutMode: TFTDropoutRules;
   End;

Const
   ftctTouchBoth = [ftctTouchX, ftctTouchY];

Type
   TFTOutline = Record
   Strict Private
      FNContours, FNPoints: SmallInt;
      FPoints:              PFTVector;
      FTags:                ^TFTCurveTags;
      FContourEndPoints:    PSmallInt;
   Strict Private
      Function GetPoints: TArray<TFTVector>; Inline;
      Function GetTags: TArray<TFTCurveTags>; Inline;
      Function GetContours: TArray<SmallInt>; Inline;
   Public
      Property Points:   TArray<TFTVector> Read GetPoints;
      Property Tags:     TArray<TFTCurveTags> Read GetTags;
      Property Contours: TArray<SmallInt> Read GetContours;
   Public Const
      cOutlineContoursMax = High(SmallInt);
      cOutlinePointsMax   = High(SmallInt);
   Public
      Flags: TFTOutlineFlags;
   End;

   TFTOutlineFuncs = Record
      MoveTo: Function([Ref] Const ATo: TFTVector; Const AUser: Pointer): Integer; Cdecl;
      LineTo: Function([Ref] Const ATo: TFTVector; Const AUser: Pointer): Integer; Cdecl;
      ConicTo: Function([Ref] Const AControl, ATo: TFTVector; Const AUser: Pointer): Integer; Cdecl;
      CubicTo: Function([Ref] Const AControl1, AControl2, ATo: TFTVector; Const AUser: Pointer): Integer; Cdecl;
      Shift: Integer;
      Delta: TFTPos;
   End;

   TFTGlyphFormat = (ftgfNone = $00000000, ftgfComposite = $636F6D70 { comp } , ftgfBitmap = $62697473 { bits } , ftgfOutline = $6F75746C { outl } , ftgfPlotter = $706C6F74 { plot } );

   // Raster definitions
   TFTSpan = Record
      X: SmallInt;
      Len: Word;
      Coverage: Byte;
   End;

   TFTRasterFlag  = (ftrfAA, ftrfDirect, ftrfClip, ftrfSDF);
   TFTRasterFlags = Set Of ftrfAA .. TFTRasterFlag($1F);

   TFTRasterParams = Record
   Public
      Target: PFTBitmap;
      Source: Pointer;
      Flags:  TFTRasterFlags;
   Strict Private
{$HINTS OFF}
      FGraySpans, FBlackSpans: Procedure(Const AY, ACount: Integer; [Ref] Const ASpans: TFTSpan; Const AUser: Pointer); Cdecl;
      FBitTest:                Function(Const AY, AX: Integer; Const AUser: Pointer): Integer; Cdecl;
      FBitSet:                 Procedure(Const AY, AX: Integer; Const AUser: Pointer); Cdecl;
{$HINTS ON}
   Public
      User:    Pointer;
      ClipBox: TFTBBox;
   End;

   TFTRaster = Record
      // internal type
   End;

   TFTRasterFuncs = Record
   Public
      GlyphFormat:   TFTGlyphFormat;
      RasterNew:     Function([Ref] Const AMemory: TFTMemory; Out ORaster: TFTRaster): Integer; Cdecl;
      RasterReset:   Procedure(Const ARaster: TFTRaster; Const APoolBase: PByte; Const APoolSize: LongWord); Cdecl;
      RasterSetMode: Function(Const ARaster: TFTRaster; Const AMode: LongWord; Const AArgs: Pointer): Integer; Cdecl;
      RasterRender:  Function(Const ARaster: TFTRaster; [Ref] Const AParams: TFTRasterParams): Integer; Cdecl;
      RasterDone:    Procedure(Const ARaster: TFTRaster); Cdecl;
   End;
{$ENDREGION}
{$REGION 'ftcolor.h experimental interface'}

   // experimental interface
   TFTPaintFormat = (ftpfColrLayers = 1, ftpfSolid = 2, ftpfLinearGradient = 4, ftptRadialGradient = 6, ftptSweepGradient = 8, ftpfGlyph = 10, ftpfColrGlyph = 11, ftpfTransform = 12,
      ftpfTranslate = 14, ftpfScale = 16, ftpfRotate = 24, ftpfSkew = 28, ftpfComposite = 32, ftpfFormatMax = 33, ftpfUnsupported = 255);

   TFTColorStopIterator = Record
      NumColorStops, CurrentColorStop: Cardinal;
      P: PByte;
   End;

   TFTColorIndex = Record
      PaletteIndex: Word;
      Alpha: TFTF2Dot14;
   End;

   TFTColorStop = Record
      StopOffset: TFTF2Dot14;
      Color: TFTColorIndex;
   End;

   TFTPaintExtend = (ftpePad, ftpeRepeat, ftpeReflect);

   TFTColorLine = Record
      Extend: TFTPaintExtend;
      ColorStopIterator: TFTColorStopIterator;
   End;

   TFTAffine23 = Record
      XX, XY, dX, YX, YY, dY: TFTFixed;
   End;

   TFTCompositeMode = (ftcmClear, ftcmSrc, ftcmDest, ftcmSrcOver, ftcmDestOver, ftcmSrcIn, ftcmDestIn, ftcmSrcOut, ftcmDestOut, ftcmSrcAtop, ftcmDestAtop, ftcmXor, ftcmScreen, ftcmOverlay, ftcmDarken,
      ftcmLighten, ftcmColorDodge, ftcmColorBurn, ftcmHardLight, ftcmSoftLight, ftcmDifference, ftcmExclusion, ftcmMultiply, ftcmHSLHue, ftcmHSLSaturation, ftcmHSLColor, ftcmHSLLuminosity, ftcmMAX);

   TFTOpaquePaint = Record
      P: PByte;
      InsertRootTransform: ByteBool;
   End;

   TFTPaintColrLayers = Record
      LayerIterator: TFTLayerIterator;
   End;

   TFTPaintSolid = Record
      Color: TFTColorIndex;
   End;

   TFTPaintLinearGradient = Record
      ColorLine: TFTColorLine;
      P0, P1, P2: TFTVector;
   End;

   TFTPaintRadialGradient = Record
      ColorLine: TFTColorLine;
      C0: TFTVector;
      R0: Word;
      C1: TFTVector;
      R1: Word;
   End;

   TFTPaintSweepGradient = Record
      ColorLine: TFTColorLine;
      Center: TFTVector;
      StartAngle, EndAngle: TFTFixed;
   End;

   TFTPaintGlyph = Record
      Paint: TFTOpaquePaint;
      GlyphID: Cardinal;
   End;

   TFTPaintColrGlyph = Record
      GlyphID: Cardinal;
   End;

   TFTPaintTransform = Record
      Paint: TFTOpaquePaint;
      Affine: TFTAffine23;
   End;

   TFTPaintTranslate = Record
      Paint: TFTOpaquePaint;
      dX, dY: TFTFixed;
   End;

   TFTPaintScale = Record
      Paint: TFTOpaquePaint;
      ScaleX, ScaleY, CenterX, CenterY: TFTFixed;
   End;

   TFTPaintRotate = Record
      Paint: TFTOpaquePaint;
      Angle, CenterX, CenterY: TFTFixed;
   End;

   TFTPaintSkew = Record
      Paint: TFTOpaquePaint;
      XSkewAngle, YSkewAngle, CenterX, CenterY: TFTFixed;
   End;

   TFTPaintComposite = Record
      SourcePaint: TFTOpaquePaint;
      CompositeMode: TFTCompositeMode;
      BackdropPaint: TFTOpaquePaint;
   End;

   TFTColrPaint = Record
      Format: TFTPaintFormat;
      Case Byte Of
         0:
            (ColrLayers: TFTPaintColrLayers);
         1:
            (Glyph: TFTPaintGlyph);
         2:
            (Solid: TFTPaintSolid);
         3:
            (LinearGradient: TFTPaintLinearGradient);
         4:
            (RadialGradient: TFTPaintRadialGradient);
         5:
            (SweepGradient: TFTPaintSweepGradient);
         6:
            (Transform: TFTPaintTransform);
         7:
            (Translate: TFTPaintTranslate);
         8:
            (Scale: TFTPaintScale);
         9:
            (Rotate: TFTPaintRotate);
         10:
            (Skew: TFTPaintSkew);
         11:
            (Composite: TFTPaintComposite);
         12:
            (ColrGlyph: TFTPaintColrGlyph);
   End;

   TFTColorRootTransform = (ftrtIncludeRootTransform, ftrtNoRootTransform, ftrtRootTransformMax);
{$ENDREGION}
{$REGION 'ftlcdfil.h'}
   // Subpixel Rendering

   TFTLcdFilter = (ftlcdfNone = 0, ftlcdfDefault = 1, ftlcdfLight = 2, ftlcdfLegacy1 = 3, ftlcdfLegacy = 16);

   TFTLCDFiveTapFilter = Array [0 .. 4] Of Byte;

   TFTLCDThreeVecs = Array [0 .. 2] Of TFTVector;
{$ENDREGION}
{$REGION 'freetype.h'}

   // Base interface
   TFTGlyphMetrics = Record
      Width, Height: TFTPos;
      HorzBearingX, HorzBearingY, HorzAdvance: TFTPos;
      VertBearingX, VertBearingY, VertAdvance: TFTPos;
   End;

   PFTBitmapSize = ^TFTBitmapSize;

   TFTBitmapSize = Record
      Height, Width: SmallInt;
      Size, XPpEM, YPpEM: TFTPos;
   End;

   // Object classes
   TFTLibrary = Record
   Strict Private
{$HINTS OFF}
      FValue: Pointer;
{$HINTS ON}
      // internal type
   End;

   TFTModule = Record
   Strict Private
{$HINTS OFF}
      FValue: Pointer;
{$HINTS ON}
      // internal type
   End;

   TFTDriver = Record
   Strict Private
{$HINTS OFF}
      FValue: Pointer;
{$HINTS ON}
      // internal type
   End;

   TFTRenderer = Record
   Strict Private
{$HINTS OFF}
      FValue: Pointer;
{$HINTS ON}
      // internal type
   End;

   PFTSize = ^TFTSize;

   PFTGlyphSlot = ^TFTGlyphSlot;

   PFTCharMap = ^TFTCharMap;

   TFTEncoding = (fteNone = $00000000, fteMsSymbol = $73796D62 { symb } , fteUnicode = $756E6963 { unic } , fteSjis = $736A6973 { sjis } , ftePrc = $67622020 { gb } , fteBig5 = $62696735 { big5 } ,
      fteWansung = $77616E73 { wans } , fteJohab = $6A6F6861 { joha } ,
      // for backward compatibility
      fteGb2312 = ftePrc, fteMsSjis = fteSjis, fteMsGb2312 = ftePrc, fteMsBig5 = fteBig5, fteMsWansung = fteWansung, fteMsJohab = fteJohab, fteAdobeStandard = $41444F42 { ADOB } ,
      fteAdobeExpert = $41444245 { ADBE } , fteAdobeCustom = $41444243 { ADBC } , fteAdobeLatin1 = $6C617431 { lat1 } , fteOldLatin2 = $6C617432 { lat2 } , fteAppleRoman = $61726D6E { armn }
      );

   TFTCharMap = Record
   Strict Private
{$HINTS OFF}
      FFace: Pointer;
{$HINTS ON}
   Public
      Encoding:               TFTEncoding;
      PlatformID, EncodingID: Word;
      Function GetCharMapIndex: Integer; Inline;
   End;

   // Base object classes
   TFTFaceFlag = (ftffScalable, ftffFixedSizes, ftffFixedWidth, ftffSFNT, ftffHorizontal, ftffVertical, ftffKerning, ftffFastGlyphs, ftffMultipleMasters, ftffGlyphNames, ftffExternalStream,
      ftffHinter, ftffCIDKeyed, ftffTricky, ftffColor, ftffVariation);
   TFTFaceFlags = Set Of ftffScalable .. TFTFaceFlag(8 * SizeOf(LongInt) - 1);

   TFTStyleFlag  = (ftsfItalic, ftsfBold);
   TFTStyleFlags = ftsfItalic .. TFTStyleFlag(8 * SizeOf(LongInt) - 1);

   TFTStyleFlagsHelper = Record Helper For TFTStyleFlags
   Public
      Function CountNamedInstances: Cardinal; Inline;
   End;

   TFTSizeRequestType = (ftsrtNominal, ftsrtRealDim, ftsrtBBox, ftsrtCell, ftsrtScales);

   TFTSizeRequest = Record
      &Type: TFTSizeRequestType;
      Width, Height: LongInt;
      HorzResolution, VertResolution: Cardinal;
   End;

   TFTLoadFlag = (ftlfNoScale, ftlfNoHinting, ftlfRender, ftlfNoBitmap, ftlfVerticalLayout, ftlfForceAutohint, ftlfCropBitmap, ftlfPedantic, ftlfAdvanceOnly, ftlfIgnoreGlobalAdvanceWidth,
      ftlfNoRecurse, ftlfIgnoreTransform, ftlfMonochrome, ftlfLinearDesign, ftlfSbitsOnly, ftlfNoAutohint, ftlfTargetLight, ftlfTargetMono, ftlfTargetLCD, ftlfTargetLCDV, ftlfColor,
      ftlfComputeMetrics, ftlfBitmapMetricsOnly);
   TFTLoadFlags = Set Of ftlfNoScale .. TFTLoadFlag($1F);

   TFTRenderMode = (ftrmNormal, ftrmLight, ftrmMono, ftrmLcd, ftrmLcdV, ftrmSDF);

   TFTLoadFlagsHelper = Record Helper For TFTLoadFlags
   Strict Private
      Function GetTargetMode: TFTRenderMode; Inline;
      Procedure SetTargetMode(Const AMode: TFTRenderMode); Inline;
   Public
      Property TargetMode: TFTRenderMode Read GetTargetMode Write SetTargetMode;
   End;

{$Z4}

   TFTKerningMode = (ftkDefault, ftkUnfitted, ftkUnscaled);
{$Z1}

   TFTFSType = Record
   Public Type
      TFTFSTypeEmbedding = (ftfseInstallableEmbedding = $0, ftfseRestrictedLicenseEmbedding = $2, ftfsePreviewAndPrintEmbedding = $4, ftfseEditableEmbedding = $8);
      TFTFSTypeFlag      = (ftfsfNoSubsetting, ftfsfBitmapEmbeddingOnly);
      TFTFSTypeFlags     = Set Of TFTFSTypeFlag;
   Strict Private
      FValue: Word;
      Function GetEmbedding: TFTFSTypeEmbedding; Inline;
      Function GetFlags: TFTFSTypeFlags; Inline;
   Public
      Property Embedding: TFTFSTypeEmbedding Read GetEmbedding;
      Property Flags:     TFTFSTypeFlags Read GetFlags;
   End;

   TFTFace = Record
   Strict Private
   Type
      TFTFaceRec = Record
         NumFaces, FaceIndex: LongInt;
         FaceFlags: TFTFaceFlags;
         StyleFlags: TFTStyleFlags;
         NumGlyphs: LongInt;
         FamilyName, StyleName: PAnsiChar;
         NumFixedSizes: Integer;
         AvailableSizes: PFTBitmapSize;
         NumCharMaps: Integer;
         CharMaps: PFTCharMap;
         Generic: TFTGeneric;
         // properties for scalable outlines
         BBox: TFTBBox;
         UnitsPerEM: Word;
         Ascender, Descender, Height: SmallInt;
         MaxAdvanceWidth, MaxAdvanceHeight: SmallInt;
         UnderlinePosition, UnderlineThickness: SmallInt;
         Glyph: PFTGlyphSlot;
         Size: PFTSize;
         CharMap: PFTCharMap;
         FDriver: TFTDriver;
         FMemory: PFTMemory;
         FStream: PFTStream;
         FSizesList: TFTList;
         FAutohint: TFTGeneric;
         FExtensions, FInternal: Pointer;
      End;
   Strict Private
      FValue: ^TFTFaceRec;
      Function GetNumFaces_: LongInt; Inline;
      Function GetFaceIndex: LongInt; Inline;
      Function GetFaceFlags: TFTFaceFlags; Inline;
      Function GetStyleFlags_: TFTStyleFlags; Inline;
      Function GetNumGlyphs: LongInt; Inline;
      Function GetFamilyName: AnsiString; Inline;
      Function GetStyleName: AnsiString; Inline;
      Function GetAvailableSizes: TArray<TFTBitmapSize>;
      Function GetCharMaps: TArray<TFTCharMap>; Inline;
      Function GetGeneric: TFTGeneric; Inline;
      Procedure SetGeneric(Const AValue: TFTGeneric); Inline;
      Function GetBBox: TFTBBox; Inline;
      Function GetUnitsPerEM: Word; Inline;
      Function GetAscender: SmallInt; Inline;
      Function GetDescender: SmallInt; Inline;
      Function GetHeight: SmallInt; Inline;
      Function GetMaxAdvanceWidth: SmallInt; Inline;
      Function GetMaxAdvanceHeight: SmallInt; Inline;
      Function GetUnderlinePosition: SmallInt; Inline;
      Function GetUnderlineThickness: SmallInt; Inline;
      Function GetGlyph: PFTGlyphSlot; Inline;
      Function GetSize: PFTSize; Inline;
      Function GetCharMap: PFTCharMap; Inline;
      Function GetDriverName: AnsiString; Inline;
   Public Type
      TColorGlyphLayerItem = Record
         GlyphIndex, ColorIndex: Cardinal;
      End;

      TFTCharVariantDefault = (ftcvdStandardCMap = 1, ftcsdVariationSelectorCMap = 0, ftcsdNoVariation = Integer( -1));

      PPaletteArray = ^TPaletteArray;
      TPaletteArray = Packed Array [0 .. 0] Of TFTColor;
   Public
      Function IsNamedInstance: Boolean; Inline;

      Class Function Create(Const AFile: AnsiString; Const AFaceIndex: Word; Const ANamedInstanceIndex: Word = 0): TFTFace; Overload; Static;
      Class Function Create(Const AData: Pointer; Const ASize: Cardinal; Const AFaceIndex: Word; Const ANamedInstanceIndex: Word = 0): TFTFace; Overload; Static;
      Procedure Destroy;

      Class Function GetNumFaces(Const AFile: AnsiString): Integer; Overload; Static;
      Class Function GetNumFaces(Const AData: Pointer; Const ASize: Cardinal): Integer; Overload; Static;
      Class Function GetStyleFlags(Const AFile: AnsiString; Const AFaceIndex: Word): TFTStyleFlags; Overload; Static;
      Class Function GetStyleFlags(Const AData: Pointer; Const ASize: Cardinal; Const AFaceIndex: Word): TFTStyleFlags; Overload; Static;

      Procedure SelectSize(Const AStrikeIndex: Integer); Inline;
      Procedure RequestSize(Const ARequest: TFTSizeRequest); Overload; Inline;
      Procedure RequestSize(Const AType: TFTSizeRequestType; Const AWidth, AHeight: LongInt; Const AHorzResolution, AVertResolution: Cardinal); Overload;
      Procedure SetCharSize(Const ACharWidth, ACharHeight: TFTF26Dot6; Const AHorzResolution, AVertResolution: Cardinal); Inline;
      Procedure SetPixelSize(Const APixelWidth, APixelHeight: Cardinal); Inline;

      Procedure LoadGlyph(Const AGlyphIndex: Cardinal; Const ALoadFlags: TFTLoadFlags = []); Inline;
      Procedure LoadChar(Const ACharCode: LongWord; Const ALoadFlags: TFTLoadFlags = []); Inline;

      Procedure ClearTransform; Inline;
      Procedure SetTransform(Const AMatrix: TFTMatrix); Overload; Inline;
      Procedure SetTransform(Const ADelta: TFTVector); Overload; Inline;
      Procedure SetTransform(Const AMatrix: TFTMatrix; Const ADelta: TFTVector); Overload; Inline;
      Procedure GetTransform(Out OMatrix: TFTMatrix); Overload; Inline;
      Procedure GetTransform(Out ODelta: TFTVector); Overload; Inline;
      Procedure GetTransform(Out OMatrix: TFTMatrix; Out ODelta: TFTVector); Overload; Inline;

      Function GetKerning(Const ALeftGlyph, ARightGlyph: Cardinal; Const AKernMode: TFTKerningMode): TFTVector; Inline;
      Function GetTrackKerning(Const APointSize: TFTFixed; Const ADegree: Integer): TFTFixed; Inline;

      Function GetGlyphName(Const AGlyphIndex: Cardinal): AnsiString;
      Function GetPostscriptName: AnsiString; Inline;

      Procedure SelectCharMap(Const AEncoding: TFTEncoding); Inline;
      Procedure SetCharMap(Var CharMap: TFTCharMap); Inline;

      Function GetCharIndex(Const ACharCode: LongWord): Cardinal; Inline;
      Function GetFirstChar(Out OGlyphIndex: Cardinal): LongWord; Inline;
      Function GetNextChar(Const ACharCode: LongWord; Out OGlyphIndex: Cardinal): LongWord; Inline;

      Procedure Properties(Const AStemDarkening: ByteBool); Overload; Inline;
      Procedure Properties(Const ALCDFilterWeights: TFTLCDFiveTapFilter); Overload; Inline;
      Procedure Properties(Const ARandomSeed: Integer); Overload; Inline;
      Procedure Properties(Const AStemDarkening: ByteBool; Const ALCDFilterWeights: TFTLCDFiveTapFilter); Overload;
      Procedure Properties(Const AStemDarkening: ByteBool; Const ARandomSeed: Integer); Overload;
      Procedure Properties(Const ALCDFilterWeights: TFTLCDFiveTapFilter; Const ARandomSeed: Integer); Overload;
      Procedure Properties(Const AStemDarkening: ByteBool; Const ALCDFilterWeights: TFTLCDFiveTapFilter; Const ARandomSeed: Integer); Overload;

      Function GetNameIndex(Const GlyphName: AnsiString): Cardinal; Inline;
      Function GetColorGlyphLayers(Const ABaseGlyph: Cardinal): TArray<TColorGlyphLayerItem>;
      Function GetFSTypeFlags: TFTFSType; Inline;

      Function GetCharVariantIndex(Const ACharCode, AVariantSelector: LongWord): Cardinal; Inline;
      Function GetCharVariantIsDefault(Const ACharCode, AVariantSelector: LongWord): TFTCharVariantDefault; Inline;
      Function GetVariantSelectors: TArray<Cardinal>;
      Function GetVariantsOfChar(Const ACharCode: LongWord): TArray<Cardinal>;
      Function GetCharsOfVariant(Const AVariantSelector: LongWord): TArray<Cardinal>;

      Function GetPalette: TFTPaletteData; Inline;
      Function SelectPalette(Const APaletteIndex: Word): PPaletteArray; Inline;
      Procedure SetForegroundColor(Const AForegroundColor: TFTColor); Inline;

      Function GetColorGlyphPaint(Const ABaseGlyph: Cardinal; Const ARootTransform: TFTColorRootTransform): TFTOpaquePaint; Inline;
      Function GetPaintLayers: TArray<TFTOpaquePaint>;
      Function GetColorLineStops: TArray<TFTColorStop>;
      Function GetPaint(Const AOpaquePaint: TFTOpaquePaint): TFTColrPaint; Inline;

      Property NumFaces: LongInt Read GetNumFaces_;
      Property FaceIndex: LongInt Read GetFaceIndex;
      Property FaceFlags: TFTFaceFlags Read GetFaceFlags;
      Property StyleFlags: TFTStyleFlags Read GetStyleFlags_;
      Property NumGlyphs: LongInt Read GetNumGlyphs;
      Property FamilyName: AnsiString Read GetFamilyName;
      Property StyleName: AnsiString Read GetStyleName;
      Property AvailableSizes: TArray<TFTBitmapSize> Read GetAvailableSizes;
      Property CharMaps: TArray<TFTCharMap> Read GetCharMaps;
      Property Generic: TFTGeneric Read GetGeneric Write SetGeneric;
      Property BBox: TFTBBox Read GetBBox;
      Property UnitsPerEM: Word Read GetUnitsPerEM;
      Property Ascender: SmallInt Read GetAscender;
      Property Descender: SmallInt Read GetDescender;
      Property Height: SmallInt Read GetHeight;
      Property MaxAdvanceWidth: SmallInt Read GetMaxAdvanceWidth;
      Property MaxAdvanceHeight: SmallInt Read GetMaxAdvanceHeight;
      Property UnderlinePosition: SmallInt Read GetUnderlinePosition;
      Property UnderlineThickness: SmallInt Read GetUnderlineThickness;
      Property Glyph: PFTGlyphSlot Read GetGlyph;
      Property Size: PFTSize Read GetSize;
      Property CharMap: PFTCharMap Read GetCharMap;
      Property DriverName: AnsiString Read GetDriverName;
   End;

   TFTSizeMetrics = Record
      XPpEM, YPpEM: Word;
      XScale, YScale: TFTFixed;
      Ascender, Descender, Height, MaxAdvance: TFTPos;
   End;

   TFTSize = Record
   Public
      Face:    TFTFace;
      Generic: TFTGeneric;
      Metrics: TFTSizeMetrics;
   Strict Private
{$HINTS OFF}
      FInternal: Pointer;
{$HINTS ON}
   End;

   TFTSubGlyphFlag  = (ftsgfArgsAreWords, ftsgfArgsAreXyValues, ftsgfRoundXyToGrid, ftsgfScale, ftsgfXyScale = 6, ftsgf2x2, ftsgfUseMyMetrics = 9);
   TFTSubGlyphFlags = Set Of ftsgfArgsAreWords .. TFTSubGlyphFlag($1F);

   TFTGlyphSlot = Record
   Public
      &Library:                             TFTLibrary;
      Face:                                 TFTFace;
      Next:                                 PFTGlyphSlot;
      GlyphIndex:                           Cardinal;
      Generic:                              TFTGeneric;
      Metrics:                              TFTGlyphMetrics;
      LinearHorzAdvance, LinearVertAdvance: TFTFixed;
      Advance:                              TFTVector;
      Format:                               TFTGlyphFormat;
      Bitmap:                               TFTBitmap;
      BitmapLeft, BitmapTop:                Integer;
      Outline:                              TFTOutline;
      NumSubGlyphs:                         Cardinal;
   Strict Private {$HINTS OFF}
      FSubGlyphs, FControlData: Pointer;
      FControlLen:              Integer; {$HINTS ON}
   Public
      LsbDelta, RsbDelta: TFTPos;
   Strict Private {$HINTS OFF}
      FOther, FInternal: Pointer;
{$HINTS ON}
   Public
      Procedure RenderGlyph(Const ARenderMode: TFTRenderMode); Inline;
      Procedure SubGlyphInfo(Const SubIndex: Cardinal; Out OIndex: Integer; Out OFlags: TFTSubGlyphFlags; Out OArg1, OArg2: Integer; Out OTransform: TFTMatrix); Inline;
      Procedure OwnBitmap; Inline;
   End;

   // Functions
   TFTOpenFlag  = (ftofMemory, ftofStream, ftofPathname, ftofDriver, ftofParams);
   TFTOpenFlags = ftofMemory .. TFTOpenFlag($1F);

   TFTParameterTag = (ftptIgnoreTypographicFamily = $69677066 { igpf } , ftptIgnoreTypographicSubfamily = $69677073 { igps } , ftptIncremental = $696E6372 { incr } ,
      ftptLCDFilterWeights = $6C636466 { lcdf } , ftptRandomSeed = $73656564 { seed } , ftptStemDarkening = $6461726B { dark } , ftptUnpatentedHinting = $756E7061 { unpa } );

   PFTParameter = ^TFTParameter;

   TFTParameter = Record
      Tag: TFTParameterTag;
      Data: Pointer;
   End;

   TFTOpenArgs = Record
      Flags: TFTOpenFlags;
      MemoryBase: PByte;
      MemorySize: LongInt;
      Pathname: PAnsiChar;
      Stream: PFTStream;
      Driver: TFTModule;
      NumParams: Integer;
      Params: PFTParameter;
   End;
{$ENDREGION}
{$REGION 'ftmodapi.h'}

   // Module Management
   TFTModuleFlag  = (ftmfFontDriver, ftmfRenderer, ftmfHinter, ftmfStyler, ftmfDriverScalable = 8, ftmfDriverNoOutlines, ftmfDriverHasHinter, ftmfDriverHintsLightly);
   TFTModuleFlags = Set Of ftmfFontDriver .. TFTModuleFlag(8 * SizeOf(LongWord) - 1);

   PFTModuleInterface = Pointer;

   TFTModuleClass = Record
      ModuleFlags: TFTModuleFlags;
      ModuleSize: LongInt;
      ModuleName: PAnsiChar;
      ModuleVersion, ModuleRequires: TFTFixed;
      ModuleInterface: PFTModuleInterface;
      ModuleInit: Function(Module: TFTModule): TFTError; Cdecl;
      ModuleDone: Procedure(Module: TFTModule); Cdecl;
      GetInterface: Function(Const Module: TFTModule; Const Name: PAnsiChar): PFTModuleInterface; Cdecl;
   End;

   TFTDebugHookFunc = Function(Const AArg: Pointer): TFTError; Cdecl;

{$Z4}
   TFTDebugHook = (ftdhTrueType);
{$Z1}
   TFTTrueTypeEngineType = (fttteNone, fttteUnpatented, ftttePatented);
{$ENDREGION}

   TFTManager = Class Abstract
   Strict Private
      Class Var FLibrary:               TFTLibrary;
      Class Var FMajor, FMinor, FPatch: Integer;

      Class Function MemAlloc([Ref] Const AMemory: TFTMemory; Const ASize: Integer): Pointer; Static; Cdecl;
      Class Procedure MemFree([Ref] Const AMemory: TFTMemory; Const ABlock: Pointer); Static; Cdecl;
      Class Function MemRealloc([Ref] Const AMemory: TFTMemory; Const ACurSize, ANewSize: Integer; Const ABlock: Pointer): Pointer; Static; Cdecl;

   Const
      sError          = 'The error %d occured in a FreeType call: %s.';
      FREETYPE_MAJOR  = 2;
      FREETYPE_MINOR  = 11;
      FREETYPE_PATCH  = 0;
      cMem: TFTMemory = (User: NIL; AllocFunc: TFTManager.MemAlloc; FreeFunc: TFTManager.MemFree; ReallocFunc: TFTManager.MemRealloc);
   Private
      Class Procedure Initialize; Static;
      Class Procedure Finalize; Static;
   Public
      Class Procedure Error(Const AErrorCode: TFTError); Static; // Inline;
      Class Property &Library: TFTLibrary Read FLibrary;

      Class Property MajorVersion: Integer Read FMajor;
      Class Property MinorVersion: Integer Read FMinor;
      Class Property PatchVersion: Integer Read FPatch;
   End;

{$REGION 'fterrors.h'}

Function FT_Error_String(Const AErrorCode: TFTError): PAnsiChar; Cdecl; External FreeTypeDLL;
{$ENDREGION}
{$REGION 'ftlcdfil.h'}
Function FT_Library_SetLcdFilter(&Library: TFTLibrary; Const AFilter: TFTLcdFilter): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Library_SetLcdFilterWeights(&Library: TFTLibrary; [Ref] Const AWeights: TFTLCDFiveTapFilter): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Library_SetLcdGeometry(&Library: TFTLibrary; [Ref] Const ASub: TFTLCDThreeVecs): TFTError; Cdecl; External FreeTypeDLL;
{$ENDREGION}
{$REGION 'freetype.h'}
Function FT_Init_FreeType(Out OLibrary: TFTLibrary): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Done_FreeType(&Library: TFTLibrary): TFTError; Cdecl; External FreeTypeDLL;
Function FT_New_Face(Const ALibrary: TFTLibrary; Const AFilePathName: PAnsiChar; Const AFaceIndex: LongInt; Out AFace: TFTFace): TFTError; Cdecl; External FreeTypeDLL;
Function FT_New_Memory_Face(Const ALibrary: TFTLibrary; Const AFileBase: PByte; Const AFileSize, AFaceIndex: LongInt; Out OFace: TFTFace): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Open_Face(Const ALibrary: TFTLibrary; [Ref] Const AArgs: TFTOpenArgs; Const FaceIndex: LongInt; Out OFace: TFTFace): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Attach_File(Face: TFTFace; Const AFilePathName: PAnsiChar): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Attach_Stream(Face: TFTFace; [Ref] Const AParameters: TFTOpenArgs): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Reference_Face(Face: TFTFace): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Done_Face(Face: TFTFace): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Select_Size(Face: TFTFace; Const AStrikeIndex: Integer): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Request_Size(Face: TFTFace; [Ref] Const AReq: TFTSizeRequest): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Set_Char_Size(Face: TFTFace; Const ACharWidth, ACharHeight: TFTF26Dot6; Const AHorzResolution, AVertResolution: Cardinal): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Set_Pixel_Sizes(Face: TFTFace; Const APixelWidth, APixelHeight: Cardinal): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Load_Glyph(Face: TFTFace; Const AGlyphIndex: Cardinal; Const ALoadFlags: TFTLoadFlags): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Load_Char(Face: TFTFace; Const ACharCode: LongWord; Const ALoadFlags: TFTLoadFlags): TFTError; Cdecl; External FreeTypeDLL;
Procedure FT_Set_Transform(Face: TFTFace; Const AMatrix: PFTMatrix; Const ADelta: PFTVector); Cdecl; External FreeTypeDLL;
Procedure FT_Get_Transform(Const AFace: TFTFace; OMatrix: PFTMatrix; ODelta: PFTVector); Cdecl; External FreeTypeDLL;
Function FT_Render_Glyph(Var Slot: TFTGlyphSlot; Const RenderMode: TFTRenderMode): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Get_Kerning(Const AFace: TFTFace; Const ALeftGlyph, ARightGlyph: Cardinal; Const AKernMode: TFTKerningMode; Out OKerning: TFTVector): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Get_Track_Kerning(Const AFace: TFTFace; Const APointSize: TFTFixed; Const ADegree: Integer; Out OKerning: TFTFixed): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Get_Glyph_Name(Const AFace: TFTFace; Const AGlyphIndex: Cardinal; Const ABuffer: Pointer; Const ABufferMax: Cardinal): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Get_Postscript_Name(Const AFace: TFTFace): PAnsiChar; Cdecl; External FreeTypeDLL;
Function FT_Select_Charmap(Face: TFTFace; Const AEncoding: TFTEncoding): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Set_Charmap(Face: TFTFace; Var CharMap: TFTCharMap): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Get_Charmap_Index([Ref] Const ACharmap: TFTCharMap): Integer; Cdecl; External FreeTypeDLL;
Function FT_Get_Char_Index(Const AFace: TFTFace; Const ACharCode: LongWord): Cardinal; Cdecl; External FreeTypeDLL;
Function FT_Get_First_Char(Const AFace: TFTFace; Out OGlyphIndex: Cardinal): LongWord; Cdecl; External FreeTypeDLL;
Function FT_Get_Next_Char(Const AFace: TFTFace; Const ACharCode: LongWord; Out OGlyphIndex: Cardinal): LongWord; Cdecl; External FreeTypeDLL;
Function FT_Face_Properties(Face: TFTFace; Const ANumProperties: Cardinal; Const AProperties: PFTParameter): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Get_Name_Index(Const AFace: TFTFace; Const AGlyphName: PAnsiChar): Cardinal; Cdecl; External FreeTypeDLL;
Function FT_Get_SubGlyph_Info([Ref] Const AGlyph: TFTGlyphSlot; Const ASubIndex: Cardinal; Out OIndex: Integer; Out OFlags: TFTSubGlyphFlags; Out OArg1, OArg2: Integer; Out OTransform: TFTMatrix)
   : TFTError; Cdecl; External FreeTypeDLL;
Function FT_Get_FSType_Flags(Const AFace: TFTFace): TFTFSType; Cdecl; External FreeTypeDLL;
Function FT_Face_GetCharVariantIndex(Const AFace: TFTFace; Const ACharCode, AVariantSelector: LongWord): Cardinal; Cdecl; External FreeTypeDLL;
Function FT_Face_GetCharVariantIsDefault(Const AFace: TFTFace; Const ACharCode, AVariantSelector: LongWord): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Face_GetVariantSelectors(Const AFace: TFTFace): PCardinal; Cdecl; External FreeTypeDLL;
Function FT_Face_GetVariantsOfChar(Const AFace: TFTFace; Const ACharCode: LongWord): PCardinal; Cdecl; External FreeTypeDLL;
Function FT_Face_GetCharsOfVariant(Const AFace: TFTFace; Const VariantSelector: LongWord): PCardinal; Cdecl; External FreeTypeDLL;
// Computations
Function FT_MulDiv(Const AMultiplier1, AMultiplier2, ADivisor: LongInt): LongInt; Cdecl; External FreeTypeDLL;
Function FT_MulFix(Const AMultiplier: LongInt; Const AMultiplierF16Dot16: TFTFixed): LongInt; Cdecl; External FreeTypeDLL; // (A*B)/$10000
Function FT_DivFix(Const ANumerator: LongInt; Const ADenominatorF16Dot16: TFTFixed): LongInt; Cdecl; External FreeTypeDLL; // (A*$10000)/B
Function FT_RoundFix(Const A: TFTFixed): TFTFixed; Cdecl; External FreeTypeDLL;
Function FT_CeilFix(Const A: TFTFixed): TFTFixed; Cdecl; External FreeTypeDLL;
Function FT_FloorFix(Const A: TFTFixed): TFTFixed; Cdecl; External FreeTypeDLL;
Procedure FT_Vector_Transform(Var Vector: TFTVector; [Ref] Const AMatrix: TFTMatrix); Cdecl; External FreeTypeDLL;
// FreeType Version
Procedure FT_Library_Version(Const ALibrary: TFTLibrary; Out OMajor, OMinor, OPatch: Integer); Cdecl; External FreeTypeDLL;
{$ENDREGION}
{$REGION 'ftcolor.h'}
Function FT_Palette_Data_Get(Const AFace: TFTFace; Out OPalette: TFTPaletteData): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Palette_Select(Const AFace: TFTFace; Const APaletteIndex: Word; Out OPalette: PFTColor): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Palette_Set_Foreground_Color(Const AFace: TFTFace; Const AForegroundColor: TFTColor): TFTError; Cdecl; External FreeTypeDLL;
// Layer management
Function FT_Get_Color_Glyph_Layer(Const AFace: TFTFace; Const ABaseGlyph: Cardinal; Out OGlyphIndex, OColorIndex: Cardinal; Var Iterator: TFTLayerIterator): ByteBool; Cdecl; External FreeTypeDLL;
// experimental interface
Function FT_Get_Color_Glyph_Paint(Const AFace: TFTFace; Const ABaseGlyph: Cardinal; Const ARootTransform: TFTColorRootTransform; Out OPaint: TFTOpaquePaint): ByteBool; Cdecl; External FreeTypeDLL;
Function FT_Get_Paint_Layers(Const AFace: TFTFace; Var Iterator: TFTLayerIterator; Out OPaint: TFTOpaquePaint): ByteBool; Cdecl; External FreeTypeDLL;
Function FT_Get_Colorline_Stops(Const AFace: TFTFace; Out OColorStop: TFTColorStop; Var Iterator: TFTColorStopIterator): ByteBool; Cdecl; External FreeTypeDLL;
Function FT_Get_Paint(Const AFace: TFTFace; Const AOpaquePaint: TFTOpaquePaint; Out OPaint: TFTColrPaint): ByteBool; Cdecl; External FreeTypeDLL;
{$ENDREGION}
{$REGION 'ftbitmap.h'}
Procedure FT_Bitmap_Init(Var Bitmap: TFTBitmap); Cdecl; External FreeTypeDLL;
Function FT_Bitmap_Copy(Const ALibrary: TFTLibrary; [Ref] Const ASource: TFTBitmap; Var Target: TFTBitmap): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Bitmap_Embolden(Const ALibrary: TFTLibrary; Var Bitmap: TFTBitmap; Const AXStrength, AYStrength: TFTPos): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Bitmap_Convert(Const ALibrary: TFTLibrary; [Ref] Const ASource: TFTBitmap; Var Target: TFTBitmap; Const Alignment: Integer): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Bitmap_Blend(Const ALibrary: TFTLibrary; [Ref] Const ASource: TFTBitmap; Const ASourceOffset: TFTVector; Var Target: TFTBitmap; Var TargetOffset: TFTVector; Const AColor: TFTColor)
   : TFTError; Cdecl; External FreeTypeDLL;
Function FT_GlyphSlot_Own_Bitmap(Var Slot: TFTGlyphSlot): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Bitmap_Done(Const ALibrary: TFTLibrary; Var Bitmap: TFTBitmap): TFTError; Cdecl; External FreeTypeDLL;
{$ENDREGION}
{$REGION 'ftmodapi.h'}
Function FT_Add_Module(&Library: TFTLibrary; [Ref] Const AClass: TFTModuleClass): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Get_Module(&Library: TFTLibrary; Const AModuleName: PAnsiChar): TFTModule; Cdecl; External FreeTypeDLL;
Function FT_Remove_Module(&Library: TFTLibrary; Module: TFTModule): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Property_Set(&Library: TFTLibrary; Const AModuleName, APropertyName: PAnsiChar; Const AValue): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Property_Get(Const ALibrary: TFTLibrary; Const AModuleName, APropertyName: PAnsiChar; Var Value): TFTError; Cdecl; External FreeTypeDLL;
Procedure FT_Set_Default_Properties(&Library: TFTLibrary); Cdecl; External FreeTypeDLL;
Function FT_Reference_Library(&Library: TFTLibrary): TFTError; Cdecl; External FreeTypeDLL;
Function FT_New_Library([Ref] Const AMemory: TFTMemory; Out OLibrary: TFTLibrary): TFTError; Cdecl; External FreeTypeDLL;
Function FT_Done_Library(&Library: TFTLibrary): TFTError; Cdecl; External FreeTypeDLL;
Procedure FT_Set_Debug_Hook(&Library: TFTLibrary; Const AHookIndex: TFTDebugHook; Const ADebugHook: TFTDebugHookFunc); Cdecl; External FreeTypeDLL;
Procedure FT_Add_Default_Modules(&Library: TFTLibrary); Cdecl; External FreeTypeDLL;
// The TrueType Engine
Function FT_Get_TrueType_Engine_Type(Const ALibrary: TFTLibrary): TFTTrueTypeEngineType; Cdecl; External FreeTypeDLL;
{$ENDREGION}

Implementation

{ TFTMemory }

Function TFTMemory.Alloc(Const ASize: LongInt): Pointer;
Begin
   Result := AllocFunc(Self, ASize);
End;

Procedure TFTMemory.Free(Const ABlock: Pointer);
Begin
   FreeFunc(Self, ABlock);
End;

Function TFTMemory.Realloc(Const ACurSize, ANewSize: LongInt; Const ABlock: Pointer): Pointer;
Begin
   Result := ReallocFunc(Self, ACurSize, ANewSize, ABlock);
End;

{ TFTStream }

Function TFTStream.Read(Const AOffset: LongWord; Var ABuffer; Const ACount: LongWord): LongWord;
Begin
   Result := ReadFunc(Self, AOffset, ABuffer, ACount);
End;

Procedure TFTStream.Close;
Begin
   CloseFunc(Self);
End;

{ TFTColor }

Constructor TFTColor.Mix(Const ABlue, AGreen, ARed, AAlpha: Byte);
Begin
   Blue := ABlue;
   Green := AGreen;
   Red := ARed;
   Alpha := AAlpha;
End;

{ TFTBitmap }

Procedure TFTBitmap.Blend(Const ASourceOffset: TFTVector; Var Target: TFTBitmap; Var TargetOffset: TFTVector; Const AColor: TFTColor);
Begin
   TFTManager.Error(FT_Bitmap_Blend(TFTManager.&Library, Self, ASourceOffset, Target, TargetOffset, AColor));
End;

Procedure TFTBitmap.Convert(Var Target: TFTBitmap; Const Alignment: Integer);
Begin
   TFTManager.Error(FT_Bitmap_Convert(TFTManager.&Library, Self, Target, Alignment));
End;

Procedure TFTBitmap.Copy(Var Target: TFTBitmap);
Begin
   TFTManager.Error(FT_Bitmap_Copy(TFTManager.&Library, Self, Target));
End;

Procedure TFTBitmap.Done;
Begin
   TFTManager.Error(FT_Bitmap_Done(TFTManager.&Library, Self));
End;

Procedure TFTBitmap.Embolden(Const AXStrength, AYStrength: TFTPos);
Begin
   TFTManager.Error(FT_Bitmap_Embolden(TFTManager.&Library, Self, AXStrength, AYStrength));
End;

Function TFTBitmap.GetScanLine(Const ALine: Cardinal): PByte;
Begin
   Result := PByte(NativeInt(Buffer) + NativeInt(ALine) * Pitch);
End;

Procedure TFTBitmap.Init;
Begin
   FT_Bitmap_Init(Self);
End;

{ TFTCurveTagsHelper }

Function TFTCurveTagsHelper.GetDropoutMode: TFTDropoutRules;
Begin
   // https://docs.microsoft.com/en-us/typography/opentype/spec/tt_instructions#scantype
   Case PByte(@Self)^ Shr 5 Of
      0:
         Result := [1, 2, 3];
      1:
         Result := [1, 2, 4];
      2, 3, 6, 7:
         Result := [1, 2];
      4:
         Result := [1, 2, 5];
      5:
         Result := [1, 2, 6];
   End;
End;

{ TFTOutline }

Function TFTOutline.GetContours: TArray<SmallInt>;
Begin
   SetLength(Result, FNContours);
   Move(FContourEndPoints^, Result[0], FNContours * SizeOf(SmallInt));
End;

Function TFTOutline.GetPoints: TArray<TFTVector>;
Begin
   SetLength(Result, FNPoints);
   Move(FPoints^, Result[0], FNPoints * SizeOf(TFTVector));
End;

Function TFTOutline.GetTags: TArray<TFTCurveTags>;
Begin
   SetLength(Result, FNPoints);
{$IF SizeOf(TFTCurveTags) <> 1}
{$MESSAGE FATAL 'Unexpected set size (should be byte)'}
{$IFEND}
   Move(FTags^, Result[0], FNPoints);
End;

{ TFTErrorHelper }

Function TFTErrorHelper.Base: Byte;
Begin
   Result := Byte(Self And $FF);
End;

Function TFTErrorHelper.Equals(Const AError: TFTError): Boolean;
Begin
   Result := Base = AError.Base;
End;

Function TFTErrorHelper.Inequals(Const AError: TFTError): Boolean;
Begin
   Result := Base <> AError.Base;
End;

Function TFTErrorHelper.Module: Word;
Begin
   Result := Word(Self And $FF00);
End;

{ TFTList }

Function TFTList.IsEmpty: Boolean;
Begin
   Result := Not Assigned(Head);
End;

{ TFTGlyphSlot }

Procedure TFTGlyphSlot.OwnBitmap;
Begin
   TFTManager.Error(FT_GlyphSlot_Own_Bitmap(Self));
End;

Procedure TFTGlyphSlot.RenderGlyph(Const ARenderMode: TFTRenderMode);
Begin
   TFTManager.Error(FT_Render_Glyph(Self, ARenderMode));
End;

Procedure TFTGlyphSlot.SubGlyphInfo(Const SubIndex: Cardinal; Out OIndex: Integer; Out OFlags: TFTSubGlyphFlags; Out OArg1, OArg2: Integer; Out OTransform: TFTMatrix);
Begin
   TFTManager.Error(FT_Get_SubGlyph_Info(Self, SubIndex, OIndex, OFlags, OArg1, OArg2, OTransform));
End;

{ TFTCharmap }

Function TFTCharMap.GetCharMapIndex: Integer;
Begin
   Result := FT_Get_Charmap_Index(Self);
   If Result = -1 Then
      Raise EFreeType.Create('Error while getting charmap index');
End;

{ TFTStyleFlagsHelper }

Function TFTStyleFlagsHelper.CountNamedInstances: Cardinal;
Begin
   Result := (Cardinal(Pointer(@Self)^) Shr 16) And $7FFF;
End;

{ TFTLoadFlagsHelper }

Function TFTLoadFlagsHelper.GetTargetMode: TFTRenderMode;
Begin
   Result := TFTRenderMode((PCardinal(@Self)^ Shr 16) And 15);
End;

Procedure TFTLoadFlagsHelper.SetTargetMode(Const AMode: TFTRenderMode);
Begin
   Self := Self - [ftlfTargetLight, ftlfTargetMono, ftlfTargetLCD, ftlfTargetLCDV];
   If AMode <> ftrmNormal Then
      Include(Self, TFTLoadFlag(Cardinal(AMode) + 16));
End;

{ TFTFSType }

Function TFTFSType.GetEmbedding: TFTFSTypeEmbedding;
Begin
   Result := TFTFSTypeEmbedding(FValue And $F);
End;

Function TFTFSType.GetFlags: TFTFSTypeFlags;
Begin
   PWord(@Result)^ := FValue Shr 8;
End;

{ TFTFace }

Class Function TFTFace.Create(Const AFile: AnsiString; Const AFaceIndex, ANamedInstanceIndex: Word): TFTFace;
Begin
   TFTManager.Error(FT_New_Face(TFTManager.&Library, PAnsiChar(AFile), AFaceIndex Or (ANamedInstanceIndex Shl 16), Result));
End;

Class Function TFTFace.Create(Const AData: Pointer; Const ASize: Cardinal; Const AFaceIndex: Word; Const ANamedInstanceIndex: Word): TFTFace;
Begin
   TFTManager.Error(FT_New_Memory_Face(TFTManager.&Library, AData, ASize, AFaceIndex Or (ANamedInstanceIndex Shl 16), Result));
End;

Procedure TFTFace.ClearTransform;
Begin
   FT_Set_Transform(Self, NIL, NIL);
End;

Procedure TFTFace.Destroy;
Begin
   FT_Done_Face(Self);
End;

Function TFTFace.GetAscender: SmallInt;
Begin
   Result := FValue^.Ascender;
End;

Function TFTFace.GetAvailableSizes: TArray<TFTBitmapSize>;
Begin
   SetLength(Result, FValue^.NumFixedSizes);
   Move(FValue^.AvailableSizes^, Result[0], SizeOf(Result[0]) * Length(Result));
End;

Function TFTFace.GetBBox: TFTBBox;
Begin
   Result := FValue^.BBox;
End;

Function TFTFace.GetCharIndex(Const ACharCode: LongWord): Cardinal;
Begin
   Result := FT_Get_Char_Index(Self, ACharCode);
End;

Function TFTFace.GetCharMap: PFTCharMap;
Begin
   Result := FValue^.CharMap;
End;

Function TFTFace.GetCharMaps: TArray<TFTCharMap>;
Begin
   SetLength(Result, FValue^.NumCharMaps);
   Move(FValue^.CharMaps^, Result[0], SizeOf(Result[0]) * Length(Result));
End;

Function TFTFace.GetCharsOfVariant(Const AVariantSelector: LongWord): TArray<Cardinal>;
Var
   V, W: PCardinal;
Begin
   V := PCardinal(FT_Face_GetCharsOfVariant(Self, AVariantSelector));
   If Not Assigned(V) Then
      Exit(NIL);
   W := V;
   While W^ <> 0 Do
      Inc(W);
   SetLength(Result, NativeUInt(W) - NativeUInt(V));
   Move(V^, Result[0], Length(Result) * SizeOf(Cardinal));
End;

Function TFTFace.GetCharVariantIndex(Const ACharCode, AVariantSelector: LongWord): Cardinal;
Begin
   Result := FT_Face_GetCharVariantIndex(Self, ACharCode, AVariantSelector);
End;

Function TFTFace.GetCharVariantIsDefault(Const ACharCode, AVariantSelector: LongWord): TFTCharVariantDefault;
Begin
   Result := TFTCharVariantDefault(FT_Face_GetCharVariantIsDefault(Self, ACharCode, AVariantSelector));
End;

Function TFTFace.GetColorGlyphLayers(Const ABaseGlyph: Cardinal): TArray<TColorGlyphLayerItem>;
Var
   Iterator: TFTLayerIterator;
   Item:     TColorGlyphLayerItem;
   I:        Integer;
Begin
   Iterator.P := NIL;
   If FT_Get_Color_Glyph_Layer(Self, ABaseGlyph, Item.GlyphIndex, Item.ColorIndex, Iterator) Then Begin
      SetLength(Result, Iterator.NumLayers);
      Move(Item, Result[0], SizeOf(Item));
      For I := 1 To High(Result) Do
         If Not FT_Get_Color_Glyph_Layer(Self, ABaseGlyph, Result[I].GlyphIndex, Result[I].ColorIndex, Iterator) Then
            Raise EFreeType.Create('Error while getting glyph layers');
   End;
End;

Function TFTFace.GetColorGlyphPaint(Const ABaseGlyph: Cardinal; Const ARootTransform: TFTColorRootTransform): TFTOpaquePaint;
Begin
   If Not FT_Get_Color_Glyph_Paint(Self, ABaseGlyph, ARootTransform, Result) Then
      Raise EFreeType.Create('No color glyph found, or the root paint could not be retrieved');
End;

Function TFTFace.GetColorLineStops: TArray<TFTColorStop>;
Var
   Iterator: TFTColorStopIterator;
   Item:     TFTColorStop;
   I:        Integer;
Begin
   Iterator.P := NIL;
   If FT_Get_Colorline_Stops(Self, Item, Iterator) Then Begin
      SetLength(Result, Iterator.NumColorStops);
      Move(Item, Result[0], SizeOf(Item));
      For I := 1 To High(Result) Do
         If Not FT_Get_Colorline_Stops(Self, Result[I], Iterator) Then
            Raise EFreeType.Create('Error while getting colorline stops');
   End;
End;

Function TFTFace.GetDescender: SmallInt;
Begin
   Result := FValue^.Descender;
End;

Function TFTFace.GetDriverName: AnsiString;
Type
   PFTModuleClass  = ^TFTModuleClass;
   PPFTModuleClass = ^PFTModuleClass;
Begin
   Result := PPFTModuleClass(FValue^.FDriver)^.ModuleName;
End;

Function TFTFace.GetFaceFlags: TFTFaceFlags;
Begin
   Result := FValue^.FaceFlags;
End;

Function TFTFace.GetFaceIndex: LongInt;
Begin
   Result := FValue^.FaceIndex;
End;

Function TFTFace.GetFamilyName: AnsiString;
Begin
   Result := AnsiString(FValue^.FamilyName);
End;

Function TFTFace.GetFirstChar(Out OGlyphIndex: Cardinal): LongWord;
Begin
   Result := FT_Get_First_Char(Self, OGlyphIndex);
End;

Function TFTFace.GetFSTypeFlags: TFTFSType;
Begin
   Result := FT_Get_FSType_Flags(Self);
End;

Function TFTFace.GetGeneric: TFTGeneric;
Begin
   Result := FValue^.Generic;
End;

Function TFTFace.GetGlyph: PFTGlyphSlot;
Begin
   Result := FValue^.Glyph;
End;

Function TFTFace.GetGlyphName(Const AGlyphIndex: Cardinal): AnsiString;
Begin
   SetLength(Result, 255);
   TFTManager.Error(FT_Get_Glyph_Name(Self, AGlyphIndex, @Result[1], 255));
   SetLength(Result, {$IFNDEF VER230}AnsiStrings.{$ENDIF}StrLen(PAnsiChar(@Result[1])));
End;

Function TFTFace.GetHeight: SmallInt;
Begin
   Result := FValue^.Height;
End;

Function TFTFace.GetKerning(Const ALeftGlyph, ARightGlyph: Cardinal; Const AKernMode: TFTKerningMode): TFTVector;
Begin
   TFTManager.Error(FT_Get_Kerning(Self, ALeftGlyph, ARightGlyph, AKernMode, Result));
End;

Function TFTFace.GetMaxAdvanceHeight: SmallInt;
Begin
   Result := FValue^.MaxAdvanceHeight;
End;

Function TFTFace.GetMaxAdvanceWidth: SmallInt;
Begin
   Result := FValue^.MaxAdvanceWidth;
End;

Function TFTFace.GetNameIndex(Const GlyphName: AnsiString): Cardinal;
Begin
   Result := FT_Get_Name_Index(Self, PAnsiChar(GlyphName));
End;

Function TFTFace.GetNextChar(Const ACharCode: LongWord; Out OGlyphIndex: Cardinal): LongWord;
Begin
   Result := FT_Get_Next_Char(Self, ACharCode, OGlyphIndex);
End;

Function TFTFace.GetNumFaces_: LongInt;
Begin
   Result := FValue^.NumFaces;
End;

Class Function TFTFace.GetNumFaces(Const AFile: AnsiString): Integer;
Var
   Face: TFTFace;
Begin
   TFTManager.Error(FT_New_Face(TFTManager.&Library, PAnsiChar(AFile), -1, Face));
   Result := Face.NumFaces;
   TFTManager.Error(FT_Done_Face(Face));
End;

Class Function TFTFace.GetNumFaces(Const AData: Pointer; Const ASize: Cardinal): Integer;
Var
   Face: TFTFace;
Begin
   TFTManager.Error(FT_New_Memory_Face(TFTManager.&Library, AData, ASize, -1, Face));
   Result := Face.NumFaces;
   TFTManager.Error(FT_Done_Face(Face));
End;

Function TFTFace.GetNumGlyphs: LongInt;
Begin
   Result := FValue^.NumGlyphs;
End;

Function TFTFace.GetPaint(Const AOpaquePaint: TFTOpaquePaint): TFTColrPaint;
Begin
   If Not FT_Get_Paint(Self, AOpaquePaint, Result) Then
      Raise EFreeType.Create('Error while getting details for a paint');
End;

Function TFTFace.GetPaintLayers: TArray<TFTOpaquePaint>;
Var
   Iterator: TFTLayerIterator;
   Item:     TFTOpaquePaint;
   I:        Integer;
Begin
   Iterator.P := NIL;
   If FT_Get_Paint_Layers(Self, Iterator, Item) Then Begin
      SetLength(Result, Iterator.NumLayers);
      Move(Item, Result[0], SizeOf(Item));
      For I := 1 To High(Result) Do
         If Not FT_Get_Paint_Layers(Self, Iterator, Result[I]) Then
            Raise EFreeType.Create('Error while getting paint layers');
   End;
End;

Function TFTFace.GetPalette: TFTPaletteData;
Begin
   TFTManager.Error(FT_Palette_Data_Get(Self, Result));
End;

Function TFTFace.GetPostscriptName: AnsiString;
Begin
   Result := AnsiString(FT_Get_Postscript_Name(Self));
End;

Class Function TFTFace.GetStyleFlags(Const AFile: AnsiString; Const AFaceIndex: Word): TFTStyleFlags;
Var
   Face: TFTFace;
Begin
   TFTManager.Error(FT_New_Face(TFTManager.&Library, PAnsiChar(AFile), -(AFaceIndex + 1), Face));
   Result := Face.StyleFlags;
   TFTManager.Error(FT_Done_Face(Face));
End;

Function TFTFace.GetSize: PFTSize;
Begin
   Result := FValue^.Size;
End;

Class Function TFTFace.GetStyleFlags(Const AData: Pointer; Const ASize: Cardinal; Const AFaceIndex: Word): TFTStyleFlags;
Var
   Face: TFTFace;
Begin
   TFTManager.Error(FT_New_Memory_Face(TFTManager.&Library, AData, ASize, -(AFaceIndex + 1), Face));
   Result := Face.StyleFlags;
   TFTManager.Error(FT_Done_Face(Face));
End;

Function TFTFace.GetStyleFlags_: TFTStyleFlags;
Begin
   Result := FValue^.StyleFlags;
End;

Function TFTFace.GetStyleName: AnsiString;
Begin
   Result := AnsiString(FValue^.StyleName);
End;

Function TFTFace.GetTrackKerning(Const APointSize: TFTFixed; Const ADegree: Integer): TFTFixed;
Begin
   TFTManager.Error(FT_Get_Track_Kerning(Self, APointSize, ADegree, Result));
End;

Procedure TFTFace.GetTransform(Out OMatrix: TFTMatrix);
Begin
   FT_Get_Transform(Self, @OMatrix, NIL);
End;

Procedure TFTFace.GetTransform(Out ODelta: TFTVector);
Begin
   FT_Get_Transform(Self, NIL, @ODelta);
End;

Procedure TFTFace.GetTransform(Out OMatrix: TFTMatrix; Out ODelta: TFTVector);
Begin
   FT_Get_Transform(Self, @OMatrix, @ODelta);
End;

Function TFTFace.GetUnderlinePosition: SmallInt;
Begin
   Result := FValue^.UnderlinePosition;
End;

Function TFTFace.GetUnderlineThickness: SmallInt;
Begin
   Result := FValue^.UnderlineThickness;
End;

Function TFTFace.GetUnitsPerEM: Word;
Begin
   Result := FValue^.UnitsPerEM;
End;

Function TFTFace.GetVariantSelectors: TArray<Cardinal>;
Var
   V, W: PCardinal;
Begin
   V := PCardinal(FT_Face_GetVariantSelectors(Self));
   If Not Assigned(V) Then
      Exit(NIL);
   W := V;
   While W^ <> 0 Do
      Inc(W);
   SetLength(Result, NativeUInt(W) - NativeUInt(V));
   Move(V^, Result[0], Length(Result) * SizeOf(Cardinal));
End;

Function TFTFace.GetVariantsOfChar(Const ACharCode: LongWord): TArray<Cardinal>;
Var
   V, W: PCardinal;
Begin
   V := PCardinal(FT_Face_GetVariantsOfChar(Self, ACharCode));
   If Not Assigned(V) Then
      Exit(NIL);
   W := V;
   While W^ <> 0 Do
      Inc(W);
   SetLength(Result, NativeUInt(W) - NativeUInt(V));
   Move(V^, Result[0], Length(Result) * SizeOf(Cardinal));
End;

Function TFTFace.IsNamedInstance: Boolean;
Begin
   Result := (FaceIndex And $7FFF0000) <> 0;
End;

Procedure TFTFace.LoadChar(Const ACharCode: LongWord; Const ALoadFlags: TFTLoadFlags);
Begin
   TFTManager.Error(FT_Load_Char(Self, ACharCode, ALoadFlags));
End;

Procedure TFTFace.LoadGlyph(Const AGlyphIndex: Cardinal; Const ALoadFlags: TFTLoadFlags);
Begin
   TFTManager.Error(FT_Load_Glyph(Self, AGlyphIndex, ALoadFlags));
End;

Procedure TFTFace.Properties(Const AStemDarkening: ByteBool);
Var
   Props: TFTParameter;
Begin
   Props.Tag := ftptStemDarkening;
   Props.Data := @AStemDarkening;
   TFTManager.Error(FT_Face_Properties(Self, 1, @Props));
End;

Procedure TFTFace.Properties(Const ALCDFilterWeights: TFTLCDFiveTapFilter);
Var
   Props: TFTParameter;
Begin
   Props.Tag := ftptLCDFilterWeights;
   Props.Data := @ALCDFilterWeights;
   TFTManager.Error(FT_Face_Properties(Self, 1, @Props));
End;

Procedure TFTFace.Properties(Const ARandomSeed: Integer);
Var
   Props: TFTParameter;
Begin
   Props.Tag := ftptRandomSeed;
   Props.Data := @ARandomSeed;
   TFTManager.Error(FT_Face_Properties(Self, 1, @Props));
End;

Procedure TFTFace.Properties(Const AStemDarkening: ByteBool; Const ALCDFilterWeights: TFTLCDFiveTapFilter);
Var
   Props: Array [0 .. 1] Of TFTParameter;
Begin
   Props[0].Tag := ftptStemDarkening;
   Props[0].Data := @AStemDarkening;
   Props[1].Tag := ftptLCDFilterWeights;
   Props[1].Data := @ALCDFilterWeights;
   TFTManager.Error(FT_Face_Properties(Self, 2, @Props));
End;

Procedure TFTFace.Properties(Const AStemDarkening: ByteBool; Const ARandomSeed: Integer);
Var
   Props: Array [0 .. 1] Of TFTParameter;
Begin
   Props[0].Tag := ftptStemDarkening;
   Props[0].Data := @AStemDarkening;
   Props[1].Tag := ftptRandomSeed;
   Props[1].Data := @ARandomSeed;
   TFTManager.Error(FT_Face_Properties(Self, 2, @Props));
End;

Procedure TFTFace.Properties(Const ALCDFilterWeights: TFTLCDFiveTapFilter; Const ARandomSeed: Integer);
Var
   Props: Array [0 .. 1] Of TFTParameter;
Begin
   Props[0].Tag := ftptLCDFilterWeights;
   Props[0].Data := @ALCDFilterWeights;
   Props[1].Tag := ftptRandomSeed;
   Props[1].Data := @ARandomSeed;
   TFTManager.Error(FT_Face_Properties(Self, 2, @Props));
End;

Procedure TFTFace.Properties(Const AStemDarkening: ByteBool; Const ALCDFilterWeights: TFTLCDFiveTapFilter; Const ARandomSeed: Integer);
Var
   Props: Array [0 .. 2] Of TFTParameter;
Begin
   Props[0].Tag := ftptStemDarkening;
   Props[0].Data := @AStemDarkening;
   Props[1].Tag := ftptLCDFilterWeights;
   Props[1].Data := @ALCDFilterWeights;
   Props[2].Tag := ftptRandomSeed;
   Props[2].Data := @ARandomSeed;
   TFTManager.Error(FT_Face_Properties(Self, 3, @Props));
End;

Procedure TFTFace.RequestSize(Const ARequest: TFTSizeRequest);
Begin
   TFTManager.Error(FT_Request_Size(Self, ARequest));
End;

Procedure TFTFace.RequestSize(Const AType: TFTSizeRequestType; Const AWidth, AHeight: LongInt; Const AHorzResolution, AVertResolution: Cardinal);
Var
   Req: TFTSizeRequest;
Begin
   Req.&Type := AType;
   Req.Width := AWidth;
   Req.Height := AHeight;
   Req.HorzResolution := AHorzResolution;
   Req.VertResolution := AVertResolution;
   TFTManager.Error(FT_Request_Size(Self, Req));
End;

Procedure TFTFace.SelectCharMap(Const AEncoding: TFTEncoding);
Begin
   TFTManager.Error(FT_Select_Charmap(Self, AEncoding));
End;

Function TFTFace.SelectPalette(Const APaletteIndex: Word): PPaletteArray;
Begin
   TFTManager.Error(FT_Palette_Select(Self, APaletteIndex, PFTColor(Result)));
End;

Procedure TFTFace.SelectSize(Const AStrikeIndex: Integer);
Begin
   TFTManager.Error(FT_Select_Size(Self, AStrikeIndex));
End;

Procedure TFTFace.SetCharMap(Var CharMap: TFTCharMap);
Begin
   TFTManager.Error(FT_Set_Charmap(Self, CharMap));
End;

Procedure TFTFace.SetCharSize(Const ACharWidth, ACharHeight: TFTF26Dot6; Const AHorzResolution, AVertResolution: Cardinal);
Begin
   TFTManager.Error(FT_Set_Char_Size(Self, ACharWidth, ACharHeight, AHorzResolution, AVertResolution));
End;

Procedure TFTFace.SetForegroundColor(Const AForegroundColor: TFTColor);
Begin
   TFTManager.Error(FT_Palette_Set_Foreground_Color(Self, AForegroundColor));
End;

Procedure TFTFace.SetGeneric(Const AValue: TFTGeneric);
Begin
   FValue^.Generic := AValue;
End;

Procedure TFTFace.SetPixelSize(Const APixelWidth, APixelHeight: Cardinal);
Begin
   TFTManager.Error(FT_Set_Pixel_Sizes(Self, APixelWidth, APixelHeight));
End;

Procedure TFTFace.SetTransform(Const AMatrix: TFTMatrix);
Begin
   FT_Set_Transform(Self, @AMatrix, NIL);
End;

Procedure TFTFace.SetTransform(Const ADelta: TFTVector);
Begin
   FT_Set_Transform(Self, NIL, @ADelta);
End;

Procedure TFTFace.SetTransform(Const AMatrix: TFTMatrix; Const ADelta: TFTVector);
Begin
   FT_Set_Transform(Self, @AMatrix, @ADelta);
End;

{ TFTManager }

Class Procedure TFTManager.Error(Const AErrorCode: TFTError);
Begin
   If AErrorCode <> 0 Then
      Raise EFreeType.CreateFmt(sError, [AErrorCode, AnsiString(FT_Error_String(AErrorCode))]);
End;

Class Procedure TFTManager.Finalize;
Begin
   FT_Done_Library(FLibrary);
   // FT_Done_FreeType(FLibrary^);
End;

Class Procedure TFTManager.Initialize;
Begin
   Error(FT_New_Library(cMem, FLibrary));
   FT_Add_Default_Modules(FLibrary);
   FT_Set_Default_Properties(FLibrary);
   // FT_Init_FreeType(FLibrary);
   FT_Library_Version(FLibrary, FMajor, FMinor, FPatch);
   Assert((MajorVersion = FREETYPE_MAJOR) And (MinorVersion = FREETYPE_MINOR) And (PatchVersion = FREETYPE_PATCH), 'Unknown FreeType version');
End;

Class Function TFTManager.MemAlloc([Ref] Const AMemory: TFTMemory; Const ASize: Integer): Pointer;
Begin
   Result := GetMemory(ASize);
End;

Class Procedure TFTManager.MemFree([Ref] Const AMemory: TFTMemory; Const ABlock: Pointer);
Begin
   FreeMemory(ABlock);
End;

Class Function TFTManager.MemRealloc([Ref] Const AMemory: TFTMemory; Const ACurSize, ANewSize: Integer; Const ABlock: Pointer): Pointer;
Begin
   Result := ReallocMemory(ABlock, ANewSize);
End;

Initialization

TFTManager.Initialize;

Finalization

TFTManager.Finalize;

End.
