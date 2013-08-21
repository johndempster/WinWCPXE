unit Filter;
{ --------------------------------------------------------------
  Define filtering criteria for setting record status and type
  --------------------------------------------------------------
  28/11/00
  11/01/01 Updated, can now set record type as well as status
  6/3/01   Variable,channel and record type now preserved when form is closed
  25/2/02 ... Record type matching criteria added to record selection filter
  }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ValEdit,global, ValidatedEdit ;

type
  TFilterFrm = class(TForm)
    GroupBox3: TGroupBox;
    rbAllRecords: TRadioButton;
    GroupBox4: TGroupBox;
    rbVariable: TRadioButton;
    cbVariables: TComboBox;
    bApply: TButton;
    bCancel: TButton;
    cbChannels: TComboBox;
    lbChannels: TLabel;
    GroupBox5: TGroupBox;
    GroupBox2: TGroupBox;
    rbAccepted: TRadioButton;
    rbRejected: TRadioButton;
    ckSetRecordStatus: TCheckBox;
    GroupBox1: TGroupBox;
    cbRecordType: TComboBox;
    ckSetRecordType: TCheckBox;
    cbMatchType: TComboBox;
    Label3: TLabel;
    GroupBox6: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edUpperLimit: TValidatedEdit;
    edLowerLimit: TValidatedEdit;
    procedure FormShow(Sender: TObject);
    procedure bApplyClick(Sender: TObject);
    procedure rbAllRecordsClick(Sender: TObject);
    procedure rbVariableClick(Sender: TObject);
    procedure ckSetRecordStatusClick(Sender: TObject);
    procedure ckSetRecordTypeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    LastVariableIndex : Integer ;
    LastChannelIndex : Integer ;
    LastRecordType : Integer ;
    LastMatchType : Integer ;
  public
    { Public declarations }
    Channel : Integer ;            // Channel to which filter is applied (OUT)
    Variable : Integer ;           // Variable to which filter is applied (OUT)
    VarName : string ;             // Name of selected variable
    SetRecordStatus : Boolean ;    // Change record status when match occurs (OUT)
    Status : string ;           // Change status to this after match (OUT)
    SetRecordType : Boolean ;      // Change record type when match occurs (OUT)
    RecType : string ;          // Change Record type to this after match (IN)
    VarNames : TStringList ;       // Variable name (IN)
    LowerLimit : single ;          // Lower match criteria (OUT)
    UpperLimit : single ;          // Upper match criteria (OUT)
    AllRecords : Boolean ;         // Apply changes to all records (OUT)
    MatchType : string ;           // Type of record selected for match (OUT)
    ShowChannels : Boolean ;
  end;

var
  FilterFrm: TFilterFrm;

implementation

{$R *.DFM}

procedure TFilterFrm.FormCreate(Sender: TObject);
//
// Initialisations when form is created
//
begin
     LastVariableIndex := -1 ;
     LastChannelIndex := -1 ;
     LastRecordType := -1 ;
     end;

procedure TFilterFrm.FormShow(Sender: TObject);
//
// Initialisations when form is displayed
//
begin
     { Get record type list }
     cbRecordType.items := RecordTypes ;
     cbRecordType.items.delete(0)  ; {Delete first entry 'ALL'}
     if LastRecordType < 0 then LastRecordType := 0 ;
     cbRecordType.itemIndex := LastRecordType ;

     // Selected record type (in matching criteria)
     cbMatchType.Items := RecordTypes ;
     if LastMatchType < 0 then LastMatchType := 0 ;
     cbMatchType.ItemIndex := LastMatchType ;

     { Get names of available variables }
     cbVariables.items := VarNames  ;
     if LastVariableIndex < 0  then LastVariableIndex := 0 ;
     cbVariables.ItemIndex := LastVariableIndex ;

     { Ensure option controls are disabled if their check box is clear }
     if not ckSetRecordType.Checked then cbRecordType.Enabled := False ;
     if not ckSetRecordStatus.Checked then begin
        rbAccepted.Enabled := False ;
        rbRejected.Enabled := False ;
        end ;

     { Make channels combo invisible if only one channel }
     if ShowChannels then begin
        cbChannels.Visible := True ;
        lbChannels.Visible := True ;
        cbChannels.items := ChannelNames  ;
        If LastChannelIndex < 0 then LastChannelIndex := 0 ;
        cbChannels.ItemIndex := LastChannelIndex ;
        end
     else begin
        cbChannels.Visible := False ;
        lbChannels.Visible := False ;
        end ;
     end;


procedure TFilterFrm.bApplyClick(Sender: TObject);
{ ---------------------------------------------------
  Updated filter criteria and result public variables
  --------------------------------------------------- }
begin

     Variable := Integer(TObject(cbVariables.Items.Objects[cbVariables.ItemIndex])) ;
     VarName := cbVariables.Text ;
     Channel := cbChannels.ItemIndex ;

     SetRecordStatus := ckSetRecordStatus.Checked ;
     if rbAccepted.Checked then Status := 'ACCEPTED'
                           else Status := 'REJECTED' ;

     SetRecordType := ckSetRecordType.Checked ;
     RecType := cbRecordType.text ;

     // Record type to be selected for matching
     MatchType :=cbMatchType.text ;

     LowerLimit := edLowerLimit.Value ;
     UpperLimit := edUpperLimit.Value ;
     AllRecords := rbAllRecords.Checked ;
     end;


procedure TFilterFrm.rbAllRecordsClick(Sender: TObject);
begin
     rbVariable.Checked := False ;
     end;

procedure TFilterFrm.rbVariableClick(Sender: TObject);
begin
     rbAllRecords.Checked := False ;
     end;

procedure TFilterFrm.ckSetRecordStatusClick(Sender: TObject);
begin
     if ckSetRecordStatus.Checked then begin
        rbAccepted.Enabled := True ;
        rbRejected.Enabled := True ;
        end
     else begin
        rbAccepted.Enabled := False ;
        rbRejected.Enabled := False ;
        end ;
     end;


procedure TFilterFrm.ckSetRecordTypeClick(Sender: TObject);
begin
     if ckSetRecordType.Checked then begin
        cbRecordType.Enabled := True ;
        end
     else begin
        cbRecordType.Enabled := False ;
        end ;
     end;



procedure TFilterFrm.FormClose(Sender: TObject; var Action: TCloseAction);
//
// Save settings when form is closed
//
begin
     LastVariableIndex := cbVariables.ItemIndex ;
     LastChannelIndex := cbChannels.ItemIndex ;
     LastRecordType := cbRecordType.ItemIndex ;
     LastMatchType := cbMatchType.ItemIndex ;
     end;

Initialization

end.
