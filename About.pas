unit About;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls ;

type
  TAboutDlg = class(TForm)
    Panel1: TPanel;
    ProductName: TLabel;
    Copyright: TLabel;
    Label1: TLabel;
    bOK: TButton;
    GroupBox1: TGroupBox;
    edSupplier: TEdit;
    EdModel: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutDlg: TAboutDlg;

implementation

{$R *.DFM}

uses MDIform, WCPFIleUnit;

procedure TAboutDlg.FormActivate(Sender: TObject);
begin
     edSupplier.text := Main.SESLabIO.LabInterfaceName ;
     edModel.text := Main.SESLabIO.LabInterfaceModel ;
     ProductName.caption := 'Whole Cell Analysis Program '
                            + WCPFile.ProgVersion ;
     end;


procedure TAboutDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Action := caFree ;
     end;

end.

