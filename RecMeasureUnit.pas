unit RecMeasureUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XMultiYPlot;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    XMultiYPlot1: TXMultiYPlot;
    cbPlotVar: TComboBox;
    bAddPlot: TButton;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
