# TextShaping4Delphi
This contains Delphi headers for FreeType and harfbuzz.
All headers require at least version XE3. They should be compatible with FreePascal, just be sure to replace `[Ref] Const` by `Constref` in all source files. They should be compatible with both x86_32 and x86_64.

## FreeType
The header translation is based on version 2.9.1. It includes the header files `ftsystem.h`, `fterrors.h`, `ftcolor.h`, `ftbitmap.h`, `ftimage.h`, `fttypes.h`, `ftlcdfil.h`, `freetype.h`, `ftmodapi.h`, and `ftobj.h`.

## HarzBuzz
The header translation is based on version 2.8.0. It includes the header files `hb-common.h`, `hb-blob.h`, `hb-unicode.h`, `hb-set.h`, `hb-face.h`, `hb-font.h`, `hb-buffer.h`, `hb-map.h`, `hb-shape-plan.h`, `hb-version.h`, and `hb-ft.h`.

## Interface
The translations often use native Delphi features (e.g., sets instead of bitmasks) where possible in order to give a natural feel for the Delphi developer. All types (including the most important pointer types) are implemented as records, so that we do not get any overhead. The functional C interface is of course available, but a much more natural approach is to use the advanced record capabilities - basically treat your records as if they were classes. The overhead for this can be zero if the compiler inlines properly, and it is negligible even under the not-so-optimal inlining performance of the compiler.

## Example
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
End;
```

## Misc
Please report bugs or if other headers are required. Perhaps in the future, we can use the new managed records feature in 10.4 (which has already been in FPC for a while) so that we can spare the try..finally constructs.