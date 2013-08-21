unit Setvar;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Global ;

type
  TSetVarFrm = class(TForm)
    cbVariable: TComboBox;
    cbChannel: TComboBox;
    bOK: TButton;
    procedure bOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  SetVarFrm: TSetVarFrm;

implementation

{$R *.DFM}


procedure TSetVarFrm.bOKClick(Sender: TObject);
begin
     SetVarFrm.Hide ;
     end;

end.
