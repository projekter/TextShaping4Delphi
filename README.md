# TextShaping4Delphi
This contains partial Delphi headers for FreeType, harfbuzz, and ICU.
All headers require at least version XE3. They may be compatible with FreePascal, just be sure to replace `[Ref] Const` by `Constref` in all source files. They should be compatible with both x86_32 and x86_64.

## FreeType
The header translation is based on version 2.11.0. It includes the header files `ftsystem.h`, `fterrors.h`, `ftcolor.h`, `ftbitmap.h`, `ftimage.h`, `fttypes.h`, `ftlcdfil.h`, `freetype.h`, `ftmodapi.h`, and `ftobj.h`.

## HarzBuzz
The header translation is based on version 2.9.0. It includes the header files `hb-common.h`, `hb-blob.h`, `hb-unicode.h`, `hb-set.h`, `hb-face.h`, `hb-font.h`, `hb-buffer.h`, `hb-map.h`, `hb-shape-plan.h`, `hb-version.h`, and `hb-ft.h`.

## ICU
The header translation is based on version 69.1. It includes the header files `utypes.h`, `uvernum.h`, `uversion.h`, `umachine.h`, `uenum.h`, `uloc.h`, `stringoptions.h`, `ucpmap.h`, `uchar.h`, `utext.h`, `parseerr.h`, and `ubrk.h`. Note that ICU can be compiled with a weird "feature" (and the precompiled binaries available from the GitHub Releases of ICU are!) that appends a suffix which contains the version number to each function; therefore, the DLLs cannot easily be swapped without changing the corresponding string (or introducing dynamic binding that tries to determine this string).

## Interface
The translations often use native Delphi features (e.g., sets instead of bitmasks) where possible in order to give a natural feel for the Delphi developer. All types (including the most important pointer types) are implemented as records, so that we do not get any overhead. The functional C interface is of course available, but a much more natural approach is to use the advanced record capabilities - basically treat your records as if they were classes. The overhead for this can be zero if the compiler inlines properly, and it is negligible even under the not-so-optimal inlining performance of the compiler.

## Contributing
In all cases, the translated headers comprise only a small subset of the features of the libraries. I may expand it when I need it, but feel free to create pull requests that cover another feature set. It should provide both the function headers and types, using as much of Delphi's natural features and convenience functions in the records.

Only an even smaller subset of all the functions is tested. Please report any bugs!

## Example (text shaping)
This is oriented at the [simple shaping example](https://harfbuzz.github.io/a-simple-shaping-example.html) and the [harfbuzz tutorial](https://github.com/harfbuzz/harfbuzz-tutorial/blob/master/hello-harfbuzz-freetype.c).
```Delphi
Uses
   uFreeType, uHarfBuzz;
Var
   Face:      TFTFace;
   Font:      THBFont;
   Buf:       THBBuffer;
   GlyphInfo: TArray<THBGlyphInfo>;
   GlyphPos:  TArray<THBGlyphPosition>;
   I:         Integer;
   CursorX, CursorY: Double;
Const
   FontSize = 36;
Begin
   Face := TFTFace.Create({ font file goes here }, 0);
   Try
      Face.SetCharSize(FontSize *64, FontSize *64, 0, 0);
      Font := THBFace.CreateReferenced(Face);
      Try
         Font.FTFontSetFuncs;
         Buf := THBBuffer.Create;
         Try
            Buf.Add('Sample text');
            // variant 1
            Buf.Direction := hbdLTR;
            Buf.Script := hbsLatin;
            Buf.Language := 'en';
            // variant 2
            Buf.GuessSegmentProperties;

            Buf.Shape(Font);

            GlyphInfo := Buf.GetGlyphInfos;
            GlyphPos := Buf.GetGlyphPositions;

            For I := 0 To High(GlyphInfo) Do Begin
               Face.LoadGlyph(GlyphInfo[I].Codepoint, [ftlfRender]);
               // Draw should draw the bitmap #1 at x position #2 and y position #3.
               Draw(Face.Glyph.Bitmap,
                  Round(CursorX + GlyphPos[I].XOffset / 64 + Face.Glyph.BitmapLeft),
                  Round(CursorY - GlyphPos[I].YOffset / 64 - Face.Glyph.BitmapTop));
               CursorX := CursorX + GlyphPos[I].XAdvance / 64;
               CursorY := CursorY - GlyphPos[I].YAdvance / 64;
            End;
         Finally
            Buf.Destroy;
         End;
      Finally
         Font.Destroy;
      End;
   Finally
      Face.Destroy;
   End;
End.
```

## Example (text breaking)
This is oriented at the [text breaking example](https://github.com/unicode-org/icu/blob/main/icu4c/source/samples/break/ubreak.c).
```Delphi
Uses uICU;

Procedure PrintEachForward(ABoundary: TICUBreakIterator; Const AStr: String);
Var
   Start, &End: Integer;
Begin
   Start := ABoundary.First;
   &End := ABoundary.Next;
   While &End <> TICUBreakIterator.cBrkDone Do Begin
      WriteLn(Copy(AStr, Start +1, &End - Start));
      Start := &End;
      &End := ABoundary.Next;
   End;
End;

Procedure PrintEachBackward(ABoundary: TICUBreakIterator; Const AStr: String);
Var
   Start, &End: Integer;
Begin
   &End := ABoundary.Last;
   Start := ABoundary.Previous;
   While &End <> TICUBreakIterator.cBrkDone Do Begin
      WriteLn(Copy(AStr, Start +1, &End - Start));
      &End := Start;
      Start := ABoundary.Previous;
   end;
End;

Const cStringToExamine = '{ put your string here }';   
Var
   BI: TICUBreakIterator;
Begin
   WriteLn('Sentence Boundaries');
   BI := TICUBreakIterator.Create(icubitSentence, TICULocale.locUS, Blindtext);
   Try
      WriteLn('Forward');
      PrintEachForward(BI, cStringToExamine);
      WriteLn('Backward');
      PrintEachBackward(BI, cStringToExamine);
   Finally
      BI.Free;
   End;

   WriteLn('Word Boundaries');
   BI := TICUBreakIterator.Create(icubitWord, TICULocale.locUS, Blindtext);
   Try
      WriteLn('Forward');
      PrintEachForward(BI, cStringToExamine);
      WriteLn('Backward');
      PrintEachBackward(BI, cStringToExamine);
   Finally
      BI.Free;
   End;
End.
```