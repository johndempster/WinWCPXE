unit Data;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Spin, ExtCtrls, Grids;

type
  TDataFrm = class(TForm)
    sgTable: TStringGrid;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataFrm: TDataFrm;

implementation

{$R *.DFM}

end.
