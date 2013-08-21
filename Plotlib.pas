unit Plotlib;
{ ----------------------------------------------
  Graph plotting library
  V1.0 30/9/96
  V1.1 12/11/98 DrawAxes improved
  V2.0 16/1/99 Plot now implemented as an object
  ----------------------------------------------}


interface
uses
    ExtCtrls,Shared, WinTypes, WinProcs, Classes, SysUtils, Graphics,
    Forms, Printers, maths, stdctrls, global, controls ;

  {    Controls,
  Dialogs, }
const

     DataLimit = 4000 ;
type
    TMarkerStyle = ( SquareMarker, CircleMarker, TriangleMarker ) ;
    TMarkerType = ( mkOpen, mkSolid, mkNone ) ;
    TLineType = ( ltNone, ltLinear, ltFittedCurve ) ;
    { Axis description record }
    TAxis = record
      Lo : Single ;
      Hi : Single ;
      Lo1 : Single ;
      Hi1 : Single ;
      Tic : Single ;
      Min : Single ;
      Max : single ;
      PosMin : Single ;
      Position : LongInt ;
      Scale : single ;
      Log : Boolean ;
      Lab : string ;
      LabelAtTop : Boolean ;
      StartOfTickLabels : LongInt ;
      AutoRange : Boolean ;
      end ;

  THistCursorPos = record
           Enabled : Boolean ;
           Selected : Boolean ;
           xPix : Integer ;
           xVal : single ;
           index : Integer ;
           Lab : TLabel ;
           Color : TColor ;
           end ;


    TLegendPosition = ( LegendAtTop, LegendAtBottom, LegendAtRight, NoLegend ) ;

    { Graph data storage record }
    TxyBuf = class(TObject)
         NumPoints : Integer ;
         x : array[0..DataLimit] of Single ;
         y : array[0..DataLimit] of Single ;
         ErrBar : Array[0..DataLimit] of single ;
         Signif : Array[0..DataLimit] of Integer ;
         ErrorBars : Boolean ;
         DrawMarker : boolean ;
         DrawLineFlag : boolean ;
         LineColor : TColor ;
         LineType : TLineType ;
         LineStyle : TPenStyle ;
         LineThickness : Integer ;
         MarkerType : TMarkerType ;
         MarkerStyle : TMarkerStyle ;
         MarkerSize : LongInt ;
         MarkerSolid : Boolean ;
         MarkerColor : TColor ;
         Title : string ;
         Number : Integer ;
         Equation : TEquation ;
         end ;

    { Plot description record }
    TPlot = class(TObject)
      private
         procedure SetAllFontNames(
                   Name : string
                   ) ;
         procedure SetAllFontSizes(
                   Size : Integer
                   ) ;
      published
         property AllFontNames : string write SetAllFontNames ;
         property AllFontSizes : Integer write SetAllFontSizes ;
      public
      Changed : Boolean ;
      Histogram : Boolean ;
      Left : LongInt ;
      Right : LongInt ;
      Top : LongInt ;
      Bottom : LongInt ;
      LeftMargin : single ;
      RightMargin : single ;
      TopMargin : single ;
      BottomMargin : single ;
      XAxis : TAxis ;
      YAxis : TAxis ;
      Title : string ;
      FontName : string ;
      FontSize : LongInt ;
      NumGraphs : LongInt ;
      BinBorders : Boolean ;
      BinFillStyle : TBrushStyle ;
      BinFillColor : TColor ;
      LineThickness : LongInt ;
      MarkerSize : LongInt ;
     { BitmapWidth : LongInt ;
      BitmapHeight : LongInt ;}
      LegendFontName : string ;
      LegendFontSize : LongInt ;
      LabelFontName : string ;
      LabelFontSize : LongInt ;
      LegendPosition : TLegendPosition ;
      Cursors : Array[0..2] of THistCursorPos ;
      CursorActive : Boolean ;

      procedure DrawAxes(
                Canvas : TCanvas ;
                xy : TObject
                ) ;


      procedure CheckAxis(
                var Axis : TAxis
                ) ;

      procedure DefineAxis(
                var Axis : TAxis ;
                AxisType : char ;
                PlotObj : TObject
                ) ;

      procedure DrawLine(
                Canvas : TCanvas ;
                xy : TXYBuf ) ;

      procedure DrawMarkers(
                Canvas : TCanvas ;
                xy : TxyBuf ) ;

      Procedure DrawMarkerShape(
                Canvas : TCanvas ;
                xPix,yPix : LongInt ;
                xy : TxyBuf ) ;
      procedure DrawFunction(
                Canvas : TCanvas ;
                xy : TxyBuf
                ) ;
      procedure DrawErrorBars(
                Canvas : TCanvas ;
                xy : TxyBuf
                ) ;
      procedure DrawHistogram(
                Canvas : TCanvas ;
                Hist : THistogram
                ) ;

      function XToScreenCoord(
               x : single           { Position on X axis (IN) }
               ) : Integer ;        { Returns pixel coord within display area }

      function ScreenToXCoord(
               xPix : Integer               { Position on display (IN) (pixel coords) }
               ) : single  ;             { Return position on X axis }

      procedure MoveVerticalCursor(
                PB : TPaintBox ;             { Paintbox to be drawn on }
                Index : Integer ;            { Cursor to be moved }
                XPix : Integer ) ;           { New position for cursor
                                              (in paintbox coordinates }
      procedure DrawVerticalCursor(
                PB : TPaintBox ;           { Paintbox to be drawn on }
                Index : Integer ;          { Cursor to be used }
                X : single ) ;                { New X position of cursor
                                              (in Plot X axis coords) }

      procedure InitialiseCursor(
                Index : Integer ;
                Color : TColor ;
                Lab : TLabel
                ) ;
      function ActiveCursorNum : Integer ;

      procedure MoveActiveCursor(
          pb : TPaintBox ;
          XCursorPos : Integer
          ) ;

      procedure MoveCursorToNearestHistogramBin(
          pb : TPaintBox ;
          Index : Integer ;
          Histogram : THistogram
          ) ;

      procedure CopyFrom(
          Source : TPlot
          ) ;

      end ;






    { Axis tick list object }
    TTickList = class(TObject)
              public
              NumTicks : Integer ;
              Mantissa : Array[0..400] of string ;
              Exponent : Array[0..400] of string ;
              Value : Array[0..400] of single ;
              MaxWidth : Integer ;
              MaxHeight : Integer ;

              procedure CreateList(
                        Const Canvas : TCanvas ;
                        Var Axis : TAxis
                        ) ;
              procedure AddTick(
                        var Axis : TAxis ;   { Plot axis to which tick belongs }
                        TickValue : single ;  { Tick value }
                        Labelled : Boolean    { True = labelled tick }
                        ) ;
              procedure DrawTicks(
                        const Canvas : TCanvas ;
                        var Plot : TPlot ;
                        AxisPosition : Integer ;
                        AxisType : string
                        ) ;
              procedure CalculateWidth(
                       const Canvas : TCanvas    { Drawing surface }
                       ) ;
              procedure CalculateHeight(
                       const Canvas : TCanvas    { Drawing surface }
                       ) ;
              function TidyNumber(
                       const RawNumber : string
                       ) : string ;
              end ;


procedure TextOutRotated(
          CV : TCanvas ;
          xPix,yPix : LongInt ;
          Text : String ;
          Angle : Integer
          ) ;

procedure HorizontalBar(
          Canvas : TCanvas ;
          const PrChan : TChannel ;
          ShowLabels : boolean ;
          BarValue : single ;
          dt : single ;
          TScale : single  ;
          const BarUnits : string
          ) ;

procedure VerticalBar(
          Canvas : TCanvas ;
          const PrChan : TChannel ;
          ShowLabels : boolean ;
          BarValue : single ;
          const BarUnits : string
          ) ;

procedure DrawHorizontalCursor(
          Canvas : TCanvas ;
          Const Chan : TChannel ;
          Level : Integer ;
          CursorColour : TColor ) ;


function PrinterPointsToPixels(
         PointSize : Integer
         ) : Integer ;
function PrinterCmToPixels(
         const Axis : string ;
         cm : single
         ) : Integer ;

procedure EraseDisplay(
          Canvas : TCanvas
          ) ;

implementation


{ ------------------
  Erase display area
  ------------------}
procedure EraseDisplay(
          Canvas : TCanvas
          ) ;
begin
     Canvas.brush.color := clWhite ;
     Canvas.fillrect(Canvas.ClipRect);
     end ;

{ --------------------------
  Draw a set of X and Y axes
  --------------------------}
procedure TPlot.DrawAxes(
          Canvas : TCanvas ; {canvas on which the axes are to be drawn.}
          xy : TObject       { Data to be plotted }
          ) ;
var
   xPix,yPix : LongInt ;
   Temp : Single ;
   XTickList : TTickList ;
   YTickList : TTickList ;

begin

     { Plot title }
     Canvas.Font.Name := Self.LabelFontName ;
     Canvas.Font.Size := Self.LabelFontSize ;
     if Self.Title <> '' then begin
        xPix := (Self.Left + Self.Right - Canvas.TextWidth(Self.Title)) div 2 ;
        Canvas.TextOut( xPix, Self.Top, Self.Title ) ;
        Self.Top := Self.Top + Canvas.TextHeight(Self.Title) ;
        end ;

     { X Axis label }
     Canvas.Font.Name := Self.LabelFontName ;
     Canvas.Font.Size := Self.LabelFontSize ;
     Self.Bottom := Self.Bottom - 2*Canvas.TextHeight(Self.xAxis.Lab) ;
     xPix := ( Self.Left + Self.Right - Canvas.TextWidth(Self.XAxis.Lab) ) div 2 ;
     Canvas.TextOut( xPix, Self.Bottom, Self.XAxis.Lab ) ;

     { Y Axis label (if at left of axis) }
     if not Self.yAxis.LabelAtTop then begin
        Canvas.Font.Name := Self.LabelFontName ;
        Canvas.Font.Size := Self.LabelFontSize ;
        { Plot label along Y axis, rotated 90 degrees }
        yPix := ((Self.Bottom - Self.Top) div 2) + Self.Top
                + Canvas.TextWidth( Self.YAxis.Lab ) div 2 ;
        TextOutRotated( Canvas, Self.Left, yPix, Self.YAxis.Lab, 90 ) ;
        Self.Left := Self.Left + (3*Canvas.TextHeight(Self.YAxis.Lab)) div 2 ;
        end
     else begin
        Self.Top := Self.Top + Canvas.TextHeight(Self.YAxis.Lab) ;
        end ;

     { Find appropriate axis ranges if required }
     if Self.XAxis.AutoRange then Self.DefineAxis( Self.XAxis, 'X', xy ) ;
     if Self.YAxis.AutoRange then Self.DefineAxis( Self.YAxis, 'Y', xy ) ;

     { Ensure that axes ranges are valid }
     CheckAxis( Self.XAxis ) ;
     CheckAxis( Self.YAxis ) ;

     Canvas.Font.Name := Self.FontName ;
     Canvas.Font.Size := Self.FontSize ;

     { Create Y axis tick list }
     YTickList := TTickList.Create ;
     YTickList.CreateList( Canvas, Self.yAxis ) ;
     { Shift left margin to leave space for Y axis tick values }
     Self.Left := Self.Left + YTickList.MaxWidth + Canvas.TextWidth('X') ;

     { Create X axis tick list }
     XTickList := TTickList.Create ;
     XTickList.CreateList( Canvas, Self.xAxis ) ;
     { Shift bottom margin to leave space for X axis tick values }
     Self.Bottom := Self.Bottom - XTickList.MaxHeight - Canvas.TextHeight('X') ;

     Self.right := Self.Right - XTickList.MaxWidth ;

     { Set thickness of line to be used to draw axes }
     Canvas.Pen.Width := MaxInt([Self.LineThickness,1]) ;

     { Draw X axis }
     If Self.yAxis.log Then Temp := Self.YAxis.Lo1
                       Else Temp := MinFlt([MaxFlt([Self.YAxis.Lo1,0.]),Self.YAxis.Hi1]) ;

     Self.XAxis.Position := -Trunc((Temp - Self.YAxis.Lo1)*Self.YAxis.Scale )
                            + Self.Bottom ;
     Canvas.polyline( [ Point( Self.Left, Self.XAxis.Position ),
                        Point( Self.Right,Self.XAxis.Position ) ] ) ;

     { Draw Y axis }
     Canvas.Font.Name := Self.FontName ;

     If Self.xAxis.log Then Temp := Self.XAxis.Lo1
                       Else Temp := MinFlt([MaxFlt([Self.XAxis.Lo1,0.]),Self.XAxis.Hi1]);
     Self.YAxis.Position := trunc( (Temp - Self.XAxis.Lo1)*Self.XAxis.Scale )
                            + Self.Left ;
     Canvas.polyline( [point(Self.YAxis.Position, Self.Top),
                       point(Self.YAxis.Position, Self.Bottom)]) ;

     { Draw calibration ticks on X and Y Axes }
     XTickList.DrawTicks(Canvas, Self, Self.XAxis.Position, 'X') ;
     YTickList.DrawTicks(Canvas, Self, Self.YAxis.Position, 'Y') ;

     { Plot Y axis title (if at top of axis) }
     if Self.yAxis.LabelAtTop then begin
        Canvas.Font.Name := Self.LabelFontName ;
        Canvas.Font.Size := Self.LabelFontSize ;
        Canvas.TextOut( Self.YAxis.Position,
                        Self.Top - Canvas.TextHeight(Self.yAxis.Lab),
                        Self.yAxis.Lab ) ;
        end ;

     XTickList.Free ;
     YTickList.Free ;
     End ;


{ ----------------------------------
  Ensure plot axis has a valid range
  ----------------------------------}
procedure TPlot.CheckAxis(
          var Axis : TAxis
          ) ;
begin

     Axis.Lo1 := Axis.Lo ;
     Axis.Hi1 := Axis.Hi ;
     If Axis.log Then begin
        If Axis.Hi1 <= 0. Then Axis.Hi1 := 1. ;
        If Axis.Lo1 <= 0. Then Axis.Lo1 := Axis.Hi1 * 0.01 ;
        Axis.Hi1 := log10(Axis.Hi1) ;
        Axis.Lo1 := log10(Axis.Lo1) ;
        end ;

     { Ensure that axes have non-zero ranges and tics }
     If Axis.Hi1 = Axis.Lo1 Then Axis.Hi1 := Axis.Lo1 + 1. ;
     if Axis.Tic <= 0.0 then Axis.tic := (Axis.Hi1 - Axis.Lo1) / 5.0 ;

     end ;


{ ----------------------------------------------------
  Create TickList object using settings from plot axis
  ----------------------------------------------------}
procedure TTickList.CreateList(
          Const Canvas : TCanvas ;
          Var Axis : TAxis
          ) ;
var
   x,xEnd,xNeg,xSmallTick : single ;
   i : Integer ;
begin

     NumTicks := 0 ;

     If Axis.log Then begin

        { ** Logarithmic tics ** }

        { Set starting point at first power of 10 below minimum }
        if Axis.Lo1 > 0.0 then x := Int(Axis.Lo1)
                          else x := Int(Axis.Lo1) - 1.0 ;

        While x <= Axis.Hi1 do begin
              { Add labelled tick }
              if x >= Axis.Lo1 then AddTick(Axis,AntiLog10(x),True ) ;
              { Add unlabelled ticks }
              xSmallTick := AntiLog10(x) ;
              for i := 2 to 9 do if ((xSmallTick*i) <= Axis.Hi)
                  and ((xSmallTick*i) >= Axis.Lo) then begin
                  AddTick(Axis,xSmallTick*i,False ) ;
                  end ;
              x := x + 1. ;
              end ;
        end

     Else begin

        { ** Linear ticks on x axis ** }
        { Note. If axis include zero make ticks always start from there }
        if ( Axis.Lo1*Axis.Hi1 <= 0. ) then begin
             x := 0. ;
             xEnd := MaxFlt( [Abs(Axis.Lo1),Abs(Axis.Hi1)] ) ;
             end
        else begin
             x := Axis.Lo1 ;
             xEnd := Axis.Hi1 ;
             end ;
        While x <= xEnd do begin
             if x <= Axis.Hi1 then AddTick(Axis,x,True ) ;
             xNeg := -x ;
             if xNeg >= Axis.Lo1 then AddTick(Axis,xNeg,True ) ;
             x := x + Axis.tic ;
             end ;
        end ;
     { Calculate width of widest tick }
     CalculateWidth( Canvas ) ;
     { Calculate height of highest tick }
     CalculateHeight( Canvas ) ;
     end ;


{ ------------------------------------
  Return maximum width of tick strings
  ------------------------------------}
procedure TTickList.CalculateWidth(
         const Canvas : TCanvas    { Drawing surface }
         )  ;
var
   i, Width : Integer ;
begin


     MaxWidth := 0 ;
     for i := 0 to NumTicks-1 do begin
         Width := Canvas.TextWidth(Mantissa[i]) + Canvas.TextWidth(Exponent[i]) ;
         if Width > MaxWidth then MaxWidth := Width ;
         end ;
    end ;


{ -------------------------------------
  Return maximum height of tick strings
  -------------------------------------}
procedure TTickList.CalculateHeight(
         const Canvas : TCanvas    { Drawing surface }
         ) ;
var
   i,Height : integer ;
begin

     MaxHeight := 0 ;
     for i := 0 to NumTicks-1 do begin
         Height := Canvas.TextHeight(Mantissa[i]) ;
         if (Exponent[i] <> '') then
            Height := Height + (Canvas.TextHeight(Exponent[i]) div 2) ;
         if Height > MaxHeight then MaxHeight := Height ;
         end ;
     end ;


{ ----------------------------------------------------------------
  Draw ticks contained in TickList object on selected axis of plot
  ----------------------------------------------------------------}
procedure TTickList.DrawTicks(
          const Canvas : TCanvas ;   { Drawing surface }
          var Plot : TPlot ;         { Plot axes descriptor record }
          AxisPosition : Integer ;   { Position of axis (pixels) }
          AxisType : string ) ;      { Type of axis 'X' or 'Y' }
var
   TickSize,i,xPixLabel,yPixLabel,xPix,yPix : Integer ;
begin

     { Calculate Axes data-->pixel scaling factors }
     Plot.XAxis.Scale := Abs(Plot.Right - Plot.Left) /
                         Abs(Plot.XAxis.Hi1 - Plot.XAxis.Lo1) ;
     Plot.YAxis.Scale := Abs(Plot.Bottom - Plot.Top) /
                         Abs(Plot.YAxis.Hi1 - Plot.YAxis.Lo1) ;

     for i := 0 to NumTicks-1 do begin
        { Plot tick line and value }

        If AxisType = 'X' Then begin
           { X axis tick }
           TickSize := Canvas.TextHeight('X') div 2 ;
           yPix := AxisPosition ;
           if Plot.xAxis.Log then begin
              xPix := Plot.Left + Trunc((Log10(Value[i])
                                  - Plot.xAxis.Lo1)*Plot.xAxis.Scale) ;
              end
           else begin
              xPix := Plot.Left + Trunc((Value[i]
                                  - Plot.xAxis.Lo)*Plot.xAxis.Scale) ;
              end ;

           Canvas.polyline( [ Point(xPix,yPix), Point(xPix,yPix+TickSize)]) ;
           yPixLabel := yPix + TickSize + Self.MaxHeight
                        - Canvas.TextHeight(Mantissa[i]) ;
           xPixLabel := xPix - (Canvas.TextWidth(Mantissa[i]) div 2) ;
           end
        else begin
           {Y axis tick }
           TickSize := Canvas.TextWidth('X') ;
           xPix := AxisPosition ;
           if Plot.yAxis.Log then begin
              yPix := Plot.Bottom - Trunc((Log10(Value[i])
                                    - Plot.yAxis.Lo1)*Plot.yAxis.Scale) ;
              end
           else begin
              yPix := Plot.Bottom - Trunc((Value[i]
                                  - Plot.yAxis.Lo)*Plot.yAxis.Scale) ;

              end ;
           Canvas.polyline( [ Point(xPix,yPix), Point(xPix-TickSize,yPix)]) ;
           { Calculate starting position of label }
           xPixLabel := xPix - TickSize
                        - Canvas.TextWidth(Mantissa[i]
                                           + Exponent[i] + ' ') ;
           yPixLabel := yPix - (Canvas.TextHeight(Mantissa[i]) div 2);
           end ;

        if Mantissa[i] <> '' then begin
           Canvas.TextOut( xPixLabel, yPixLabel, Mantissa[i] ) ;
           if Exponent[i] <> '' then Canvas.TextOut(
                                xPixLabel + Canvas.TextWidth(Mantissa[i]),
                                yPixLabel - ((TickSize) div 2), Exponent[i] ) ;
           end ;

        end ;

     end ;


{ -----------------------------
  Add a tick string to TickList
  -----------------------------}
procedure TTickList.AddTick(
          var Axis : TAxis ;           { Plot axis to which tick belongs }
          TickValue : single ;         { Tick value }
          Labelled : Boolean           { True = labelled tick }
          ) ;
var
   i : Integer ;
   TickString : string ;
   PowerOfTen : Boolean ;
begin

    { Get tick value. If this is a logarithmic axis set PowerofTen% = TRUE
    to force the tick to be displayed as a power of ten irrespective of
    its magnitude }

    If Axis.log Then PowerofTen := True
                else PowerofTen := False ;

    Value[NumTicks] := TickValue ;

    if Labelled then begin
       { ** Turn tick value into string ** }
       If TickValue = 0.0 Then begin
          { Zero value }
          Mantissa[NumTicks] := '0' ;
          Exponent[NumTicks] := '' ;
          PowerofTen := False ;
          end
       Else If (Abs(TickValue) <= 999. )
          And  (Abs(TickValue) >= 0.01 )
          And  (PowerofTen = False) Then begin
          { Print values }
          Mantissa[NumTicks] := TidyNumber(Format('%8.3g',[TickValue])) ;
          PowerofTen := False ;
          Exponent[NumTicks] := '' ;
          end
       Else begin
          { Create tick as scientic notation (e.g. 2.E+003 )
            and separate out its mantissa and exponent, i.e.
                  3
            2 x 10 (Note this mode is always used if axis is logarithmic) }

          TickString := Format('%12.1e', [TickValue] ) ;
          i := Pos('E',TickString) ;
          If i > 0 Then begin
             { Extract mantissa part of number }
             Mantissa[NumTicks] := Copy( TickString, 1, i-1 ) ;
             Mantissa[NumTicks] := TidyNumber(Mantissa[NumTicks] ) + 'x10' ;
             If Mantissa[NumTicks] = '1.0x10' Then Mantissa[NumTicks] := '10' ;
             { Get sign of exponent }
             i := i + 1 ;
             Exponent[NumTicks] := Copy(TickString, i, Length(TickString)-i+1 ) ;
             Exponent[NumTicks] := IntToStr( ExtractInt( Exponent[NumTicks] ) );
             PowerofTen := True ;
             end ;
          end ;
       end
    else begin
         { ** Unlabelled ticks }
         Mantissa[NumTicks] := '' ;
         Exponent[NumTicks] := '' ;
         end ;

    Inc(NumTicks) ;

    end ;

{ -------------------------------------------------------
  Find a suitable min/max range and ticks for a plot axis
  -------------------------------------------------------}
procedure TPlot.DefineAxis(
          var Axis : TAxis ;         { Axis description record (OUT) }
          AxisType : char ;          { Type of axis 'X' or 'Y' (IN) }
          PlotObj : TObject          { Data to be plotted      (IN) }
          ) ;
var
   R,Max,Min,MinPositive,Sign,Range,Start,Step : Single ;
   g,i : LongInt ;
   xy : TxyBuf ;
   Hist : THistogram ;
begin

     if PlotObj is TxyBuf then begin
        { Object is an X/Y graph }
        xy := TxyBuf(PlotObj) ;
        { Find max./min. range of data }
        Min := MaxSingle ;
        Max := -MaxSingle ;
        MinPositive := MaxSingle ;
        for g := 0 to Self.NumGraphs-1 do begin
            For i := 0 To xy.NumPoints-1 do begin
                If AxisType = 'X' Then R := xy.x[i]
                                  Else R := xy.y[i] ;
                If R <= Min Then Min := R ;
                If R >= Max Then Max := R ;
                If (R > 0) And (R <= MinPositive) Then MinPositive := R ;
                end ;
            end ;
        end
     else if PlotObj is THistogram then begin
        { Plot object is a histogram }
        Hist := THistogram(PlotObj) ;
        if AxisType = 'X' then begin
           Min := Hist.Bins[0].Lo ;
           Max := Hist.Bins[Hist.NumBins-1].Hi ;
           end
        else begin
           Max := 0.0 ;
           for i := 0 to Hist.NumBins-1 do
               if Hist.Bins[i].y > Max then Max := Hist.Bins[i].y ;
           Min := 0.0 ;
           end ;
        end ;

    Axis.Hi := Max ;
    Axis.Lo := Min ;

    { Adjust axis range if Min and Max are same value }
    if Abs(Axis.Hi - Axis.Lo) <= 1E-37 then begin
       if Axis.Hi < 0. then begin
          Axis.Lo := Axis.Lo*2. ;
          Axis.Hi := 0. ;
          end
       else begin
            Axis.Hi := Axis.Hi * 2. ;
            if Axis.Hi = 0. then Axis.Hi := Axis.Hi + 1. ;
            Axis.Lo := 0. ;
            end ;
       end ;

    If Axis.Log = False Then begin  {* Linear axis *}

        { Set upper limit of axis }

        If Abs(Axis.Hi) <= 1E-37 Then
           { If Upper limit is (or is close to zero) set to zero }
           Axis.Hi := 0.
        Else begin
            { Otherwise ... }
            If Axis.Hi < 0. Then begin
               { Make positive for processing }
               Axis.Hi := -Axis.Hi ;
               Sign := -1. ;
               end
            else Sign := 1. ;

            Start := AntiLog10(Int(log10(axis.Hi))) ;
            if Start > Axis.Hi then Start := Start * 0.1 ;
            Step := 1. ;
            While (Step*Start) < Axis.Hi do Step := Step + 1. ;
            Axis.Hi := Start*Step ;
            end ;

        { Set lower limit of axis }

        If Abs(Axis.Lo) <= 1E-37 Then
           { If lower limit is (or is close to zero) set to zero }
           Axis.Lo := 0.
        else begin
                  { Otherwise ... }
            If Axis.Lo < 0. Then begin
               { Make positive for processing }
               Axis.Lo := -Axis.Lo ;
               Sign := -1. ;
               end
            else Sign := 1. ;

            Start := AntiLog10(Int(log10(axis.Lo))) ;
            if Start > Axis.Lo then Start := Start * 0.1 ;
            Step := 1. ;
            While (Step*Start) <= Axis.Lo do Step := Step + 1. ;
            if Sign > 0. then Step := Step - 1. ;
            Axis.Lo := Start*Step*Sign ;
            end ;

        { Use zero as one of the limits, if the range of data points
          is not to narrow. }

        If (Axis.Hi > 0. ) And (Axis.Lo > 0. ) And
           ( Abs( (Axis.Hi - Axis.Lo)/Axis.Hi ) > 0.1 ) Then Axis.Lo := 0.
        Else If (Axis.Hi < 0. ) And (Axis.Lo < 0. ) And
           ( Abs( (Axis.Lo - Axis.Hi)/Axis.Lo ) > 0.1 ) Then Axis.Hi := 0. ;


        { Choose a tick interval ( 1, 2, 2.5, 5 ) }

        Range := Abs(Axis.Hi - Axis.Lo) ;
        Axis.tic := antilog10( Int(log10( Range/5. )) - 1. ) ;
        if Range/Axis.tic > 6. then Axis.tic := Axis.tic*2. ;
        if Range/Axis.tic > 6. then Axis.tic := Axis.tic*2.5 ;
        if Range/Axis.tic > 6. then Axis.tic := Axis.tic*2. ;
        if Range/Axis.tic > 6. then Axis.tic := Axis.tic*2. ;
        if Range/Axis.tic > 6. then Axis.tic := Axis.tic*2.5 ;
        end
    Else begin  { * Logarithmic axis * }

        {Set upper limit }
        if Log10(Max) >= 0.0 then Axis.Hi := AntiLog10(int(log10(Max)))
                             else Axis.Hi := AntiLog10(int(log10(Max))-1.0) ;
        i := 1 ;
        while (Axis.Hi*i <= Max) and (i<10) do Inc(i) ;
        Axis.Hi := Axis.Hi*i ;

        { Set lower limit (note that minimum *positive* value
          is used since log. axes cannot deal with negative numbers) }

        if Log10(MinPositive) >= 0.0 then Axis.Lo := AntiLog10(int(log10(MinPositive))+1.0)
                                     else Axis.Lo := AntiLog10(int(log10(MinPositive))) ;
        i := 10 ;
        while (Axis.Lo*i*0.1 >= MinPositive) and (i>1) do Dec(i) ;
        Axis.Lo := Axis.Lo*i*0.1 ;
        Axis.tic := 10. ;
        end ;

    end ;


{ ----------------------
  Draw a line on a graph
  ----------------------}
 procedure TPlot.DrawLine(
                Canvas : TCanvas ;
                xy : TXYBuf
                ) ;
var
   xPix,yPix,i : LongInt ;
   x,y : single ;
   BadPoint, LineBreak : Boolean ;
   SavePen : TPen ;
begin
     { Save pen settings }

     SavePen := TPen.Create ;
     with SavePen do begin
          Style := Canvas.Pen.Style ;
          Width := Canvas.Pen.Width ;
          Color := Canvas.Pen.Color ;
          end ;

     { Set pen to settings for this line }
     with Canvas.Pen do begin
          Style := xy.LineStyle ;
          Width := xy.LineThickness ;
          Color := xy.LineColor ;
          end ;

     LineBreak := True ;
     for i := 0 to xy.NumPoints-1 do begin

          BadPoint := False ;

         { If X is a log axis ... convert x point to log }
         x := xy.x[i] ;
         if Self.xAxis.log then begin
            if x > 0. then x:= log10(x)
                      else BadPoint := True ;
            end ;

         { If X coord is outside the axis range ... don't plot it }
         if (x < Self.xAxis.Lo1 ) or (x > Self.xAxis.hi1) then BadPoint := True ;

         { If Y is a log axis ... convert y point to log }
         y := xy.y[i] ;
         if Self.yAxis.log then begin
            if y > 0. then y:= log10(y)
                      else BadPoint := True ;
            end ;

         { If Y coord is outside the axis range ... don't plot it }
         if (y < Self.yAxis.Lo1 ) or (y > Self.yAxis.hi1) then BadPoint := True ;

         if not BadPoint then begin
            { Plot line segment }
            xPix :=  Trunc( (x - Self.xAxis.Lo1)*Self.xAxis.Scale )
                    + Self.Left ;
            yPix := -Trunc( (y - Self.yAxis.Lo1)*Self.yAxis.Scale )
                    + Self.Bottom ;
            { Note. If LineBreak set .... don't draw line but move
              to next point }
            if LineBreak then Canvas.MoveTo( xPix, yPix )
                         else Canvas.LineTo( xPix, yPix ) ;
            LineBreak := False ;
            end
         else LineBreak := True ;
         end ;

     {Restore pen settings }
     with SavePen do begin
          Canvas.Pen.Style := Style ;
          Canvas.Pen.Width := Width ;
          Canvas.Pen.Color := Color ;
          end ;
     SavePen.Free ;

     end ;


{ --------------------------------------------
  Draw a series of error bars on a graph
  ------------------------------------------- }
procedure TPlot.DrawErrorBars(
          Canvas : TCanvas ;     { Canvas on which line is to be drawn (OUT) }
          xy : TxyBuf            { Contains the data points to be plotted (IN) }
          ) ;
var
   xPix,yPixTop,yPixBottom,i,n,HalfSize : LongInt ;
   x,y,ErrBar : single ;
   BadPoint : Boolean ;
   Asterisks : string ;
begin

     HalfSize := xy.MarkerSize div 2 ;

     for i := 0 to xy.NumPoints-1 do begin

          BadPoint := False ;

         { If X is a log axis ... convert x point to log }
         x := xy.x[i] ;
         if Self.xAxis.log then begin
            if x > 0. then x:= log10(x)
                      else BadPoint := True ;
            end ;

         { If X coord is outside the axis range ... don't plot it }
         if (x < Self.xAxis.Lo1 ) or (x > Self.xAxis.hi1) then BadPoint := True ;

         { If Y is a log axis ... convert y point to log }
         y := xy.y[i] ;
         ErrBar := xy.ErrBar[i] ;
         if Self.yAxis.log then begin
            if y > 0. then begin
               y:= log10(y) ;
               if ErrBar > 0. then ErrBar := log10(ErrBar)
                              else ErrBar := 0. ;
               end
            else BadPoint := True ;
            end ;

         { If Y coord is outside the axis range
           or the error bar is zero ... don't plot it }
         if (y < Self.yAxis.Lo1 ) or (y > Self.yAxis.hi1)
            or ( ErrBar = 0. ) then BadPoint := True ;

         if not BadPoint then begin

            { Find top and bottom of error bar }
            xPix :=  Trunc( (x - Self.xAxis.Lo1)*Self.xAxis.Scale )
                    + Self.Left ;
            yPixTop := -Trunc(
                       ( (y + ErrBar) - Self.yAxis.Lo1)*Self.yAxis.Scale )
                         + Self.Bottom  ;
            yPixBottom := -Trunc(
                           ( (y - ErrBar) - Self.yAxis.Lo1)*Self.yAxis.Scale )
                               + Self.Bottom ;

            { Vertical error bar }
            Canvas.MoveTo( xPix, MinInt([yPixBottom,Self.Bottom]) ) ;
            Canvas.LineTo( xPix, MaxInt([yPixTop,Self.Top]) ) ;

            { Bottom tic of error bar }
            if yPixBottom <= Self.Bottom then begin
               Canvas.MoveTo( xPix - HalfSize, yPixBottom ) ;
               Canvas.LineTo( xPix + HalfSize, yPixBottom ) ;
               end ;
            { Top tic of error bar }
            if yPixTop >= Self.Top then begin
               Canvas.MoveTo( xPix - HalfSize, yPixTop ) ;
               Canvas.LineTo( xPix + HalfSize, yPixTop ) ;
               end ;

            if xy.Signif[i] > 0 then begin
               Asterisks := '' ;
               for n := 1 to xy.Signif[i] do Asterisks := Asterisks + '*';
               yPixTop := yPixTop - Canvas.TextHeight('*') ;
               Canvas.TextOut( xPix, yPixTop, Asterisks ) ;
               end ;


            end ;
         end ;
     end ;


{ -----------------------------------
  Draw a series of markers on a graph
  -----------------------------------}
procedure TPlot.DrawMarkers(
          Canvas : TCanvas ; { Canvas on which line is to be drawn (OUT) }
          xy : TxyBuf        { Contains the data points to be plotted (IN) }
          ) ;
var
   xPix,yPix,i : LongInt ;
   x,y : single ;
   BadPoint : Boolean ;
   SavePen : TPen ;
   OldBrush : TBrush ;
begin

     { Save pen settings }
     SavePen := TPen.Create ;
     with SavePen do begin
          Style := Canvas.Pen.Style ;
          Width := Canvas.Pen.Width ;
          Color := Canvas.Pen.Color ;
          end ;

     { Set pen to settings for border around marker }
     with Canvas.Pen do begin
          Style := psSolid ;
          Width := xy.LineThickness ;
          Color := xy.MarkerColor ;
          end ;

     { Save brush settings }
     OldBrush := TBrush.Create ;
     OldBrush.Style := Canvas.brush.Style ;
     OldBrush.Color := Canvas.brush.Color ;

     for i := 0 to xy.NumPoints-1 do begin

          BadPoint := False ;

         { If X is a log axis ... convert x point to log }
         x := xy.x[i] ;
         if Self.xAxis.log then begin
            if x > 0. then x:= log10(x)
                      else BadPoint := True ;
            end ;

         { If X coord is outside the axis range ... don't plot it }
         if (x < Self.xAxis.Lo1 ) or (x > Self.xAxis.hi1) then BadPoint := True ;

         { If Y is a log axis ... convert y point to log }
         y := xy.y[i] ;
         if Self.yAxis.log then begin
            if y > 0. then y:= log10(y)
                      else BadPoint := True ;
            end ;

         { If Y coord is outside the axis range ... don't plot it }
         if (y < Self.yAxis.Lo1 ) or (y > Self.yAxis.hi1) then BadPoint := True ;

         if not BadPoint then begin
            { Plot marker }
            xPix :=  Trunc( (x - Self.xAxis.Lo1)*Self.xAxis.Scale )
                    + Self.Left ;
            yPix := -Trunc( (y - Self.yAxis.Lo1)*Self.yAxis.Scale )
                    + Self.Bottom ;
            Self.DrawMarkerShape( Canvas, xPix, yPix, xy ) ;
            end ;
         end ;

     { Restore pen settings }
     with SavePen do begin
          Canvas.Pen.Style := Style ;
          Canvas.Pen.Width := Width ;
          Canvas.Pen.Color := Color ;
          end ;
     SavePen.Free ;

     { Restore brush settings }
     Canvas.brush.Style := OldBrush.Style ;
     Canvas.brush.Color := OldBrush.Color  ;
     OldBrush.Free ;

     end ;


procedure TPlot.DrawMarkerShape(
          Canvas : TCanvas ;
          xPix,yPix : LongInt ;
          xy : TxyBuf
          ) ;
var
   HalfSize : LongInt ;
begin

     {Marker Size }
     HalfSize := xy.MarkerSize div 2 ;

     { Marker colour }
     Canvas.brush.color := xy.MarkerColor ;

     { Marker solid or empty }
     if xy.MarkerType = mkSolid then Canvas.brush.style := bsSolid
                                else Canvas.brush.style := bsClear ;

     { Draw Marker }
     case xy.MarkerStyle of
          SquareMarker :
                Canvas.rectangle( xPix - HalfSize, yPix - HalfSize,
                                     xPix + HalfSize, yPix + HalfSize ) ;
          CircleMarker :
                Canvas.Ellipse( xPix - HalfSize, yPix - HalfSize,
                                   xPix + HalfSize, yPix + HalfSize ) ;
          TriangleMarker :
                Canvas.Polygon( [Point(xPix - HalfSize,yPix + HalfSize),
                                 Point(xPix + HalfSize,yPix + HalfSize),
                                 Point(xPix ,yPix - HalfSize)] )  ;
          end ;
     end ;


{ ----------------------------
  Draw a mathematical function
  ----------------------------}
procedure TPlot.DrawFunction(
          Canvas : TCanvas ;  { Canvas on which line is to be drawn }
          xy : TxyBuf         { Contains the X values and equation to be plotted }
          ) ;
var
   i : LongInt ;
   x,xMin,xMax,dx : single ;
   Func : TXYBuf ;
   MathFunc : TMathFunc ;
   OK : Boolean ;
begin
     { Create function data object }
     Func := TXYBuf.Create ;
     { Create mathematical function objection }
     MathFunc := TMathFunc.Create ;

     try
        MathFunc.Setup( xy.Equation.EqnType, ' ', ' ' ) ;

        Func.DrawLineFlag := True ;
        Func.LineColor := xy.LineColor ;
        Func.LineType := xy.LineType ;
        Func.LineStyle := xy.LineStyle ;
        Func.LineThickness := xy.LineThickness ;

        xMin := Self.xAxis.Lo ;
        xMax := Self.xAxis.Hi ;

        { Create series of points at which function curve is to be plotted }

        Func.NumPoints := 100 ;
        if Self.xAxis.log then begin
           { Logarithmic X axis (log. spaced points) }
           i := 0 ;
           while (xMin <= 0. ) and (i < (xy.NumPoints-1)) do begin
              xMin := xy.x[i] ;
              inc(i) ;
              end ;
           i := xy.NumPoints-1 ;
           while (xMax <= 0. ) and ( i >=0 ) do begin
              xMax := xy.x[i] ;
              Dec(i) ;
              end ;

           if (xMin > 0. ) and (xMax > 0. ) then begin
              xMin := log10(xMin) ;
              xMax := log10(xMax) ;
              x := xMin ;
              dx := (xMax - xMin) / Func.NumPoints ;
              for i := 0 to Func.NumPoints-1 do begin
                  Func.x[i] := AntiLog10(x) ;
                  x := x + dx ;
                  end ;
              OK := True ;
              end
           else OK := False ;
           end
        else begin
           { -- Linear axis points (equal spacing) }
           if (xMin <> xMax) then begin
              x := xMin ;
              dx := (xMax - xMin) / Func.NumPoints ;
              for i := 0 to Func.NumPoints-1 do begin
                  Func.x[i] := x ;
                  x := x + dx ;
                  end ;
              Ok := True ;
              end
           else OK := False ;
           end ;

        if OK then begin
           { Create function curve }
           for i := 0 to Func.NumPoints-1 do
               Func.y[i] := MathFunc.Value(Func.x[i]) ;

           Self.DrawLine( Canvas, Func ) ;
           end ;

     finally
        Func.Free ;
        MathFunc.Free ;
        end ;
     end ;

{ ------------------
  Plot a histogram
  ------------------}
procedure TPlot.DrawHistogram(
          Canvas : TCanvas ;     { Canvas on which line is to be drawn (OUT)}
          Hist : THistogram      { Histogram data object to be plotted (IN) }
          ) ;
var
   xPixLo,xPixHi,yPix,i : LongInt ;
   BinLo,BinHi,BinY : Single ;
   OffYAxis,FirstBin : Boolean ;
   OldBrush : TBrush ;
begin
     OldBrush := Canvas.brush ;
     Canvas.brush.color := Self.BinFillColor ;
     Canvas.brush.Style := Self.BinFillStyle ;

     FirstBin := True ;
     for i := 0 to Hist.NumBins-1 do begin

         BinLo := Hist.Bins[i].Lo  ;
         BinHi := Hist.Bins[i].Hi  ;

         if (BinLo >= Self.xAxis.Lo) and (BinHi <= Self.xAxis.Hi) then begin

            { Convert X's to logs if log. X axis }
            if Self.xAxis.Log then begin
               BinLo := log10( BinLo ) ;
               BinHi := log10( BinHi ) ;
               end ;

            { Keep bin Y value to limits of plot, but determine
              whether it has gone off scale }

            OffYAxis := False ;
            BinY := Hist.Bins[i].y ;
            if BinY < Self.yAxis.Lo then begin
               BinY := Self.yAxis.Lo ;
               OffYAxis := True ;
               end ;
            if BinY > Self.yAxis.Hi then begin
               BinY := Self.yAxis.Hi ;
               OffYAxis := True ;
               end ;

            if Self.yAxis.Log then BinY := log10(BinY) ;

            { Convert to window coordinates }

            xPixLo := Trunc( (BinLo - Self.xAxis.Lo1)*Self.xAxis.Scale )
                      + Self.Left ;
            xPixHi := Trunc( (BinHi - Self.xAxis.Lo1)*Self.xAxis.Scale )
                       + Self.Left ;
            yPix := -Trunc( (BinY - Self.yAxis.Lo1)*Self.yAxis.Scale )
                       + Self.Bottom ;

            {if Canvas.Brush.Style <> bsClear then}

               Canvas.FillRect( Rect( xPixLo, yPix, xPixHi, Self.Bottom) ) ;

            { Draw left edge of histogram box }

            if FirstBin then begin
                 Canvas.MoveTo( xPixLo,Self.Bottom ) ;
                 FirstBin := False ;
                 end ;

            Canvas.lineto( xPixLo,yPix ) ;

            { Draw top of histogram box (but not if bin is off scale) }
            if OffYAxis then Canvas.MoveTo( xPixHi,yPix )
                        else Canvas.LineTo( xPixHi,yPix ) ;

            { Plot right hand edge of bin if all edges of bin are to
              be displayed }
            if Self.BinBorders then Canvas.lineto( xPixHi,Self.Bottom ) ;

            end ;
         end ;

     { Make sure right hand edge of last bin is drawn }
     if (BinHi <= Self.xAxis.Hi1) then Canvas.LineTo( xPixHi,Self.Bottom ) ;

     Canvas.brush := OldBrush ;

     end ;


function TTickList.TidyNumber(
         const RawNumber : string
         ) : string ;
var
   i0,i1 : LongInt ;
begin
     i0 := 1 ;
     while (RawNumber[i0] = ' ') and (i0 < length(RawNumber)) do
           i0 := i0 + 1 ;
     i1 := length(RawNumber) ;
     while (RawNumber[i1] = ' ') and (i1 > 1) do i1 := i1 - 1 ;
     if i1 >= i0 then TidyNumber := Copy( RawNumber, i0, i1-i0+1 )
                 else TidyNumber := '?' ;
     end ;


{ -------------------------------------------------------------------------
  Draw a horizontal calibration bar of size <BarValue> in units <BarUnits>
  for channel <PrChan> on canvas <Canvas>. <dt> is sampling intervals (secs),
  <TScale> is time scaling (from internal units (always secs) to BarUnits)
  If <ShowLabels> is false don't label bar
  -------------------------------------------------------------------------}
procedure HorizontalBar(
          Canvas : TCanvas ;         { Canvas to plot on (OUT) }
          const PrChan : TChannel ;  { Channel descriptor (IN) }
          ShowLabels : boolean ;     { Display text if TRUE (IN) }
          BarValue : single  ;       { Size of calibration bar (IN) }
          dt : single  ;             { Sampling interval (secs) (IN) }
          TScale : single  ;         { Time units scaling factor (IN) }
          const BarUnits : string    { Bar units (IN) }
          ) ;
var
   Tick,LineHeight : Integer ;
   StartPoint,EndPoint : TPoint ;
begin
     Tick := Canvas.TextHeight( 'X' ) div 2 ;
     LineHeight := (Canvas.TextHeight('X')*12) div 10 ;

     if BarValue > 0. then begin

        StartPoint := Point( PrChan.Left,PrChan.Bottom + LineHeight) ;
        EndPoint :=   Point( StartPoint.x + Trunc( BarValue*PrChan.xScale/dt ) ,
                             StartPoint.y ) ;

        Canvas.Polyline( [StartPoint,EndPoint] ) ;
        { Ticks at end of bar }
        Canvas.Polyline( [Point(StartPoint.x,StartPoint.y+Tick),
                          Point(StartPoint.x,StartPoint.y-Tick) ]);
        Canvas.Polyline( [Point(EndPoint.x,EndPoint.y+Tick),
                          Point(EndPoint.x,EndPoint.y-Tick) ]);

        { Value of calibration bar (Note s-->ms) }
        if Settings.ShowLabels then
           Canvas.TextOut( StartPoint.X, StartPoint.Y + Canvas.TextHeight('X'),
                           format( '%.1f %s',[BarValue*TScale,BarUnits ] ) ) ;
        end ;
     end ;


{ --------------------------------------------------------------------------
  Draw a vertical calibration bar of size <BarValues> in units <BarUnits>
  for the signal channel defined by <PrChan> on to <Canvas>. If <showlabels>
  is false do not print labels.
  --------------------------------------------------------------------------}
procedure VerticalBar(
          Canvas : TCanvas ;         { Canvas to plot on (OUT) }
          const PrChan : TChannel ;  { Channel descriptor (IN) }
          ShowLabels : boolean ;     { Display text if TRUE (IN) }
          BarValue : single ;        { Size of calibration bar (IN) }
          const BarUnits : string    { Bar units (IN) }
          ) ;
var
   Tick : Integer ;
   BarText : string ;
   StartPoint,EndPoint : TPoint ;
begin
     Tick := Canvas.TextWidth( 'X' ) div 2 ;
     if BarValue > 0. then begin

        BarText := format('%.1f %s', [BarValue,BarUnits]) ;
        StartPoint := Point(PrChan.Left - Canvas.textwidth('XXXXX') - 1,
                            PrChan.Bottom) ;
        EndPoint := Point( StartPoint.x, StartPoint.y -
                           Trunc( BarValue*PrChan.yScale/PrChan.ADCScale ) ) ;
        Canvas.Polyline( [StartPoint,EndPoint] ) ;

        { Draw ticks at end of bar }
        Canvas.Polyline( [Point(StartPoint.x-Tick,StartPoint.y),
                                Point(StartPoint.x+Tick,StartPoint.y) ]);
        Canvas.Polyline( [Point(EndPoint.x+Tick,EndPoint.y),
                                Point(EndPoint.x-Tick,EndPoint.y) ]);
        if Settings.ShowLabels then begin
           { Print bar label }
           Canvas.TextOut( StartPoint.X -
                           Canvas.TextWidth(BarText) div 2,
                           StartPoint.Y + Canvas.TextHeight(BarText), BarText ) ;
           end ;
        end ;
     end ;


{ ----------------------------------------------------
  Draw horizontal cursor at ADC level 'Level'
  in display area defined by  record data channel 'Chan'
  ----------------------------------------------------}
procedure DrawHorizontalCursor(
          Canvas : TCanvas ;      { Canvas to plot cursor on (OUT) }
          Const Chan : TChannel ; { Signal channel descriptor (IN) }
          Level : Integer ;       { Cursor level (IN) }
          CursorColour : TColor ) { Colour of cursor (IN) };
var
   yPix,xPix,TicSize : Integer ;
   OldColor : TColor ;
   OldStyle : TPenStyle ;
   OldMode : TPenMode ;
begin
     with canvas do begin
          OldColor := pen.color ;
          OldStyle := pen.Style ;
          OldMode := pen.mode ;
          pen.mode := pmXor ;
          pen.color := CursorColour ;
          end ;

     yPix := Trunc( Chan.Bottom - (Level - Chan.yMin)*Chan.yScale ) ;
     Canvas.polyline([Point(Chan.Left,yPix),Point(Chan.Right,yPix)]);

     with Canvas do begin
          pen.style := OldStyle ;
          pen.color := OldColor ;
          pen.mode := OldMode ;
          end ;

    end ;


procedure TextOutRotated(
          CV : TCanvas ;
          xPix,yPix : LongInt ;
          Text : String ;
          Angle : Integer ) ;
var
   LogFont : TLogFont ;
begin
     GetObject( CV.Font.Handle, SizeOf(TLogFont), @LogFont ) ;
     LogFont.lfEscapement := Angle*10 ;
     CV.Font.Handle := CreateFontIndirect(LogFont) ;
     CV.TextOut( xPix, yPix, Text ) ;
     LogFont.lfEscapement := 0 ;
     CV.Font.Handle := CreateFontIndirect(LogFont) ;
     end ;


function PrinterPointsToPixels(
         PointSize : Integer
         ) : Integer ;
var
   PixelsPerInch : single ;
begin

     { Get height and width of page (in mm) and calculate
       the size of a pixel (in cm) }
     PixelsPerInch := GetDeviceCaps( printer.handle, LOGPIXELSX ) ;
     PrinterPointsToPixels := Trunc( (PointSize*PixelsPerInch) / 72. ) ;
     end ;


function PrinterCmToPixels(
         const Axis : string;
         cm : single
         ) : Integer ;
{ -------------------------------------------
  Convert from cm (on printer page) to pixels
  -------------------------------------------}
var
   PixelWidth,PixelHeight : single ;
begin
     { Get height and width of page (in mm) and calculate
       the size of a pixel (in cm) }
     if UpperCase(Axis) = 'H' then begin
        { Printer pixel width (mm) }
        PixelWidth := GetDeviceCaps( printer.handle, HORZSIZE ) ;
        Result := Trunc( ( 10. * cm * printer.pagewidth) / PixelWidth );
        end
     else begin
        { Printer pixel height (mm) }
        PixelHeight := GetDeviceCaps( printer.handle, VERTSIZE ) ;
        Result := Trunc( ( printer.pageheight * 10. * cm )/ PixelHeight ) ;
        end ;
     end ;


{ -----------------------------------------------------
  Return screen coordinate of X value along PLOT X axis
  -----------------------------------------------------}
function TPlot.XToScreenCoord(
         x : single           { Position on X axis (IN) }
         ) : Integer ;        { Returns pixel coord within display area }
var
   OK : Boolean ;
begin
     OK := True ;
     { If X is a log axis ... convert x point to log }
     if Self.xAxis.log then begin
        if x > 0.0 then x:= log10(x)
                   else OK := False ;
        end ;

     if OK then begin
        if (x < Self.xAxis.Lo1 ) then Result := Self.Left
        else if (x > Self.xAxis.hi1) then Result := Self.Right
        else Result :=  Trunc( (x - Self.xAxis.Lo1)*Self.xAxis.Scale )
                        + Self.Left ;
        end
     else Result := Self.Left ;
     end ;


{ --------------------------------------------
  Calculate X axis value from screen coord.
  --------------------------------------------}
function TPlot.ScreenToXCoord(
         xPix : Integer               { Position on display (IN) (pixel coords) }
         ) : single  ;             { Return position on X axis }
var
   OK : Boolean ;
   xPix1 : Integer ;
   x : single ;
begin
     OK := True ;

     xPix1 := xPix ;

     if xPix1 < Self.Left then begin
        xPix1 := Self.Left ;
        OK := False ;
        end ;

     if xPix1 > Self.Right then begin
        xPix1 := Self.Right ;
        OK := False ;
        end ;

     x := ((xPix1 - Self.Left)/Self.xAxis.Scale) + Self.xAxis.Lo1 ;
     if Self.xAxis.log then x := antilog10(x) ;
     Result := x ;
     end ;


{ -----------------------------------------------
  Initialise colour and attached label for cursor
  -----------------------------------------------}
procedure TPlot.InitialiseCursor(
          Index : Integer ;
          Color : TColor ;
          Lab : TLabel
          ) ;
begin
     Cursors[Index].Enabled := True ;
     Cursors[Index].Lab := Lab ;
     Cursors[Index].Color := Color ;
     end ;


{ --------------------
  Move vertical cursor
  --------------------}
procedure TPlot.MoveVerticalCursor(
          PB : TPaintBox ;                { Paint box to be drawn on }
          Index : Integer ;
          XPix : Integer ) ;              { New position for cursor
                                            (in paintbox coordinates }
begin
     Self.DrawVerticalCursor( PB, Index, Self.Cursors[Index].xVal ) ;
     Self.Cursors[Index].XVal := Self.ScreenToXCoord( XPix ) ;
     Self.DrawVerticalCursor( PB, Index, Self.Cursors[Index].xVal ) ;
     end ;


{ -----------------------------
  Draw/remove a vertical cursor
  -----------------------------}
procedure TPlot.DrawVerticalCursor(
          PB : TPaintBox ;              { Canvas to be drawn on }
          Index : Integer ;
          X : single ) ;                { New X position of cursor
                                         (in Plot X axis coords) }
var
   OldColor : TColor ;
   OldStyle : TPenStyle ;
   OldMode : TPenMode ;
begin
    if Cursors[Index].Enabled then begin
       with PB.Canvas do begin
          OldColor := pen.color ;
          OldStyle := pen.Style ;
          OldMode := pen.mode ;
          pen.mode := pmXor ;
          pen.color := Self.Cursors[Index].Color ;
          end ;

       Cursors[Index].xPix := Self.XToScreenCoord( X ) ;
       PB.Canvas.polyline([Point(Cursors[Index].xPix,Self.Top),
                         Point(Cursors[Index].xPix,Self.Bottom)] ) ;

       if (Cursors[Index].xPix >= Self.Left)
          and (Cursors[Index].xPix <= Self.Right) then begin
          Cursors[Index].Lab.Left := pb.Left + Cursors[Index].xPix
                                   - (Cursors[Index].Lab.Width div 2);

          Cursors[Index].Lab.visible := True ;
          end
       else Cursors[Index].Lab.visible := False ;

       with PB.Canvas do begin
          pen.style := OldStyle ;
          pen.color := OldColor ;
          pen.mode := OldMode ;
          end ;
       end ;
     end ;


{ -----------------------------------------
  Get the index number of the active cursor
  -----------------------------------------}
function TPlot.ActiveCursorNum : Integer ;
var
   SelectedCursor,i : Integer ;
begin
     SelectedCursor := -1 ;
     for i := 0 to High(Cursors) do
         if Cursors[i].Enabled and Cursors[i].Selected then begin
         SelectedCursor := i ;
         end ;
     Result := SelectedCursor ;
     end ;

{ ----------------------------------------------------------------
  Move the active cursor to a new position under the mouse pointer
  ----------------------------------------------------------------}
procedure TPlot.MoveActiveCursor(
          pb : TPaintBox ;
          XCursorPos : Integer
          ) ;
Const
     Margin = 4 ;
var
   i : Integer ;
   CursorSelected : Boolean ;
begin

     if Self.CursorActive then begin

        { Move the currently activated cursor to a new position }

        for i := 0 to High(Cursors) do
            if Cursors[i].Enabled and Cursors[i].Selected then begin
            Self.MoveVerticalCursor( pb, i, XCursorPos ) ;
            end ;

        end

     else begin

        { If no cursors are currently active ....
          Determine whether the mouse is over a cursor and indicate
          this by changing the mouse pointer
          }
        CursorSelected := False ;
        for i := 0 to High(Cursors) do if Cursors[i].Enabled then begin
           Cursors[i].Selected := False ;
           if Abs(XCursorPos - Cursors[i].xPix) < Margin then begin
              Cursors[i].Selected := True ;
              pb.Cursor := crSizeWE ;
              CursorSelected := True ;
              end ;
           end ;
        if not CursorSelected then pb.Cursor := crDefault ;

        end ;
     end ;


procedure TPlot.MoveCursorToNearestHistogramBin(
          pb : TPaintBox ;
          Index : Integer ;
          Histogram : THistogram
          ) ;
{ -------------------------------------
  Move cursor to nearest histogram bins
  -------------------------------------}
var
   iBin : Integer ;
   MinDiff,xVal : single ;
begin
    if Cursors[Index].Enabled then begin
       { Find bin with mid-point closest to cursor position }
       MinDiff := MaxSingle ;
       for iBin := 0 to Histogram.MaxBin do begin
         if Abs(Cursors[Index].xVal - Histogram.Bins[iBin].Mid) < MinDiff then begin
            MinDiff := Abs(Cursors[Index].xVal - Histogram.Bins[iBin].Mid) ;
            xVal := Histogram.Bins[iBin].Mid ;
            Cursors[Index].Index := iBin ;
            end ;
         end ;
       { Find new screen coord for cursor }
       Self.MoveVerticalCursor(pb,Index,Self.XToScreenCoord(xVal)) ;
       end ;
    end ;

{ ----------------------------------
  Copy data from another Plot object
  ----------------------------------}
procedure TPlot.CopyFrom(
          Source : TPlot
          ) ;
begin
      Changed := Source.Changed ;
      Histogram := Source.Histogram ;
      Left := Source.Left ;
      Right := Source.Right ;
      Top := Source.Top ;
      Bottom := Source.Bottom ;
      LeftMargin := Source.LeftMargin ;
      RightMargin := Source.RightMargin ;
      TopMargin := Source.TopMargin ;
      BottomMargin := Source.BottomMargin ;
      XAxis := Source.XAxis ;
      YAxis := Source.YAxis ;
      Title := Source.Title ;
      FontName := Source.FontName ;
      FontSize := Source.FontSize ;
      NumGraphs := Source.NumGraphs ;
      BinBorders := Source.BinBorders ;
      BinFillStyle := Source.BinFillStyle ;
      BinFillColor := Source.BinFillColor ;
      LineThickness := Source.LineThickness ;
      MarkerSize := Source.MarkerSize ;

      LegendFontName := Source.LegendFontName ;
      LegendFontSize := Source.LegendFontSize ;
      LabelFontName := Source.LabelFontName ;
      LabelFontSize := Source.LabelFontSize ;
      LegendPosition := Source.LegendPosition ;
      Cursors := Source.Cursors ;
      CursorActive := Source.CursorActive ;
      end ;


procedure TPlot.SetAllFontNames(
          Name : string
          ) ;
begin
     FontName := Name ;
     LegendFontName := Name ;
     LabelFontName := Name ;
     end ;

procedure TPlot.SetAllFontSizes(
          Size : Integer
          ) ;
begin
     FontSize := Size ;
     LegendFontSize := Size ;
     LabelFontSize := Size ;
     end ;


end.

