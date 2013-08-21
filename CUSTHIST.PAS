unit Custhist;
{ ----------------------------------
  WinWCP - Customise histogram plot
  ---------------------------------}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Spin, Global, Shared, ExtCtrls ;

type
  TCustHistFrm = class(TForm)
    XAxisGrp: TGroupBox;
    lbXMin: TLabel;
    lbxMax: TLabel;
    Label1: TLabel;
    edXlo: TEdit;
    edXHi: TEdit;
    edXTic: TEdit;
    cbXAxisType: TComboBox;
    YAxisGrp: TGroupBox;
    lbYMin: TLabel;
    lbYMax: TLabel;
    Label4: TLabel;
    edYLo: TEdit;
    edYHi: TEdit;
    EdYTic: TEdit;
    cbYAxisType: TComboBox;
    FontGrp: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    cbFontName: TComboBox;
    TraceGrp: TGroupBox;
    ckBorders: TCheckBox;
    bOK: TButton;
    bCancel: TButton;
    LabelsGrp: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    EdXLab: TEdit;
    edYLab: TEdit;
    edTitle: TEdit;
    cbFillStyle: TComboBox;
    ColorBox: TShape;
    Label8: TLabel;
    ColorDialog: TColorDialog;
    Label9: TLabel;
    EdFontSize: TEdit;
    EdLineThickness: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure ColorBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EdFontSizeKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    SetPlot : TPlot ;
  end;

var
  CustHistFrm: TCustHistFrm;

implementation

{$R *.DFM}

uses maths ;

procedure TCustHistFrm.FormActivate(Sender: TObject);
{ ---------------------
  Initialise form
  ----------------}
begin

     edxLo.text :=  format( ' %8.3g', [SetPlot.XAxis.Lo] );
     edxHi.text :=  format( ' %8.3g', [SetPlot.XAxis.Hi] );
     edxTic.text := format( ' %8.3g', [SetPlot.XAxis.Tic] );
     if SetPlot.XAxis.log then cbXAxisType.itemindex := 1
                          else cbXAxisType.itemindex := 0 ;
     edyLo.text :=  format( ' %8.3g', [SetPlot.yAxis.Lo] );
     edyHi.text :=  format( ' %8.3g', [SetPlot.yAxis.Hi] );
     edyTic.text := format( ' %8.3g', [SetPlot.yAxis.Tic] );
     if SetPlot.YAxis.log then cbYAxisType.itemindex := 1
                          else cbYAxisType.itemindex := 0 ;

     EdXLab.text := SetPlot.XAxis.lab ;
     EdYLab.text := SetPlot.YAxis.lab ;
     EdTitle.text := SetPlot.title ;

     cbFontName.clear ;
     cbFontName.sorted := True ;
     cbFontName.items := screen.fonts ;
     cbFontName.ItemIndex := cbFontname.items.indexof( Settings.Plot.FontName ) ;
     if cbFontName.ItemIndex < 0 then cbFontName.ItemIndex := 1 ;
     edFontSize.text := format(' %d pts',[Settings.Plot.FontSize]) ;
     edLineThickness.text := format(' %d pts',[Settings.Plot.LineThickness]) ;

     ckBorders.checked := SetPlot.BinBorders ;

     { Bin fill style and colour }
     if SetPlot.BinFillStyle = bsSolid then cbFillStyle.ItemIndex := 1
     else if SetPlot.BinFillStyle = bsBDiagonal then cbFillStyle.ItemIndex := 2
     else cbFillStyle.ItemIndex := 0 ;
     ColorBox.brush.color := SetPlot.BinFillColor ;
     end;


procedure TCustHistFrm.bOKClick(Sender: TObject);
begin

     { Update CustHist's local Plot record }

     SetPlot.XAxis.Lo := ExtractFloat( edXlo.text, SetPlot.XAxis.Lo ) ;
     SetPlot.XAxis.Hi := ExtractFloat( edXHi.text, SetPlot.XAxis.Hi ) ;
     SetPlot.XAxis.Tic := ExtractFloat( edXTic.text, SetPlot.XAxis.Tic ) ;
     if cbXAxisType.itemIndex = 0 then SetPlot.XAxis.log := false
                                  else SetPlot.XAxis.log := True ;
     SetPlot.YAxis.Lo := ExtractFloat( edYlo.text, SetPlot.YAxis.Lo ) ;
     SetPlot.YAxis.Hi := ExtractFloat( edYHi.text, SetPlot.YAxis.Hi ) ;
     SetPlot.YAxis.Tic := ExtractFloat( edYTic.text, SetPlot.YAxis.Tic ) ;
     if cbYAxisType.itemIndex = 0 then SetPlot.YAxis.log := false
                                  else SetPlot.YAxis.log := True ;
     SetPlot.XAxis.Lab := edXLab.text ;
     SetPlot.YAxis.Lab := edYLab.text ;
     SetPlot.Title := edTitle.text ;

     Settings.Plot.FontSize := ExtractInt(edFontSize.text) ;
     Settings.Plot.FontName := cbFontName.text ;
     Settings.Plot.LineThickness := ExtractInt(edLineThickness.text) ;

     SetPlot.BinBorders := ckBorders.checked ;
     { Bin fill style and colour }
     if cbFillStyle.ItemIndex = 1 then SetPlot.BinFillStyle := bsSolid
     else if cbFillStyle.ItemIndex = 2 then SetPlot.BinFillStyle := bsBDiagonal
     else SetPlot.BinFillStyle := bsClear ;
     SetPlot.BinFillColor := ColorBox.brush.color ;


     CustHistFrm.Hide ;
     end;

procedure TCustHistFrm.ColorBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     if ColorDialog.Execute then ColorBox.brush.color := ColorDialog.color ;
     end;

procedure TCustHistFrm.EdFontSizeKeyPress(Sender: TObject; var Key: Char);
{ ----------------
  Check point size
  ----------------}
begin
     if key = chr(13) then TEdit(Sender).text := format( ' %d pts',
                           [IntLimitTo(ExtractInt(TEdit(Sender).text),1,64)] ) ;
     end;

end.
