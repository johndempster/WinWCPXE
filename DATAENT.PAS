unit Dataent;
{ --------------------------------------------
  Graph - Data Entry form (c) J. Dempster 1997
  --------------------------------------------}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Spin, ExtCtrls, Grids, global ;

type
  TDataFrm = class(TForm)
    sgTable: TStringGrid;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    EdTitle: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure EdTitleChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sgTableKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    MyGraph : Integer ;
  end;

var
  DataFrm: TDataFrm;

implementation

uses MDIMain ;

{$R *.DFM}
const
     XCol = 0 ;
     YCol = 1 ;
     SDCol = 2 ;

procedure TDataFrm.FormCreate(Sender: TObject);
begin
     Caption := format('Graph #%d',[LastGraphChanged] ) ;
     MyGraph := LastGraphChanged ;

     Width := sgTable.Left + sgTable.Width + 20 ;
     sgTable.Cells[XCol,0] := 'X ' ;
     sgTable.Cells[YCol,0] := 'Y ' ;
     sgTable.Cells[SDCol,0] := 'St. Dev. ' ;

     Main.SetMenus ;

     end;

procedure TDataFrm.EdTitleChange(Sender: TObject);
begin
     Graph[MyGraph].Title := edTitle.text ;
     Plot.Changed := True ;
     end;

procedure TDataFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Action := caFree ;
     end;

procedure TDataFrm.sgTableKeyPress(Sender: TObject; var Key: Char);
begin
     Plot.Changed := True ;
     end;

end.
