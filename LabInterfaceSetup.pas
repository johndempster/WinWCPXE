unit LabInterfaceSetup;
// -------------------------------------
// Laboratory Interface Setup Dialog Box
// -------------------------------------
// 15.06.11 New form for laboratory interface setup only
//          (previously handled in setupdlg form)
// 20.09.11 A/D voltage range index now acquired from and written back to Settings.ADCVoltageRangeIndex
//          (Fixes bug in V4.3.4 where range was reset to +/-10V when seal test opened)
// 30.09.11 A/D voltage range setting is now preserved when device # is changed
// 14.10.11 Device list now only contains list of available devices
// 17.01.11 Hourglass now indicates when interface is being changed
//          Interface information box now updated when A/D input mode changed
// 20.08.13 Unnecessary update of Main.SESLABIO.ADCInputMode when OK button pressed removed
//          to remove delay caused by resetting of NIDAQmx devices.
// 05.11.15 HekaEPC9USB interface added
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, math, seslabio ;

type
  TLabInterfaceSetupFrm = class(TForm)
    cbLabInterface: TComboBox;
    NIPanel: TPanel;
    Label3: TLabel;
    Label13: TLabel;
    cbADCInputMode: TComboBox;
    cbDeviceNumber: TComboBox;
    Panel1: TPanel;
    edModel: TEdit;
    Label5: TLabel;
    cbADCVoltageRange: TComboBox;
    bOK: TButton;
    bCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbLabInterfaceChange(Sender: TObject);
    procedure cbDeviceNumberChange(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure cbADCInputModeChange(Sender: TObject);
  private
    { Private declarations }
    procedure FillOptionsLists ;
  public
    { Public declarations }
  end;

var
  LabInterfaceSetupFrm: TLabInterfaceSetupFrm;

implementation

uses MDIForm, AmpModule;

{$R *.dfm}

procedure TLabInterfaceSetupFrm.FormShow(Sender: TObject);
// --------------------------------------
// Initialisations when form is displayed
// --------------------------------------
begin
     ClientWidth := cbLabInterface.Left + cbLabInterface.Width + 5 ;
     ClientHeight := bOK.Top + bOK.Height + 5 ;
     
     { Stop laboratory interface activity }
     if Main.SESLabIO.ADCActive then Main.SESLabIO.ADCStop ;
     if Main.SESLabIO.DACActive then Main.SESLabIO.DACStop ;

     FillOptionsLists ;

     end;

procedure TLabInterfaceSetupFrm.bOKClick(Sender: TObject);
begin

    Screen.Cursor := crHourGlass ;

    // A/D channel input mode
    //Main.SESLABIO.ADCInputMode := cbADCInputMode.ItemIndex ;

    Main.SESLabIO.ADCVoltageRangeIndex := cbADCVoltageRange.ItemIndex ;

    Screen.Cursor := crDefault ;
    Close ;

    end;


procedure TLabInterfaceSetupFrm.FillOptionsLists ;
// -----------------------------------
// Re-open lab. interface after change
// -----------------------------------
var
   i,iKeep : Integer ;
begin

     // Interface types
     Main.SESLABIO.GetLabInterfaceTypes( cbLabInterface.Items ) ;
     cbLabInterface.ItemIndex := cbLabInterface.Items.IndexofObject(TObject(Main.SESLABIO.LabInterfaceType)) ;

     // A/D channel input mode
     Main.SESLABIO.GetADCInputModes( cbADCInputMode.Items ) ;
     cbADCInputMode.ItemIndex := Min(Main.SESLABIO.ADCInputMode,cbADCInputMode.Items.Count-1) ;

     // Device list
     Main.SESLABIO.GetDeviceList( cbDeviceNumber.Items ) ;
     cbDeviceNumber.ItemIndex := Min(Main.SESLABIO.DeviceNumber-1,cbADCInputMode.Items.Count-1) ;

     if cbADCInputMode.Items.Count > 1 then NIPanel.Visible := True
                                       else NIPanel.Visible := False ;

     if NIPanel.Visible then Panel1.top := NIPanel.Top + NIPanel.Height + 5
                        else Panel1.top := NIPanel.Top ;
     //ClientWidth := Panel1.Left + Panel1.Width ;
     ClientHeight := Panel1.Top + Panel1.Height + 2 ;

     iKeep := Main.SESLabIO.ADCVoltageRangeIndex ;
     cbADCVoltageRange.clear ;
     for i := 0 to Main.SESLabIO.ADCNumVoltageRanges-1 do begin
         Main.SESLabIO.ADCVoltageRangeIndex := i ;
         cbADCVoltageRange.items.add(
           format(' +/-%.3g V ',[Main.SESLabIO.ADCVoltageRange] )) ;
         end ;
     Main.SESLabIO.ADCVoltageRangeIndex := iKeep ;
     cbADCVoltageRange.ItemIndex := Main.SESLabIO.ADCVoltageRangeIndex ;

    // Initialise channel display settings to minimum magnification
    Main.mnZoomOutAll.Click ;

     // If using VP500 as interface, amplifier must also be VP500
     case Main.SESLabIO.LabInterfaceType of
          vp500 : begin
            Amplifier.AmplifierType[0] := amVP500 ;
            Amplifier.AmplifierType[1] := amNone ;
            Amplifier.AmplifierType[2] := amNone ;
            Amplifier.AmplifierType[3] := amNone ;
            end ;
          Triton : begin
            Amplifier.AmplifierType[0] := amTriton ;
            Amplifier.AmplifierType[1] := amNone ;
            Amplifier.AmplifierType[2] := amNone ;
            Amplifier.AmplifierType[3] := amNone ;
            end;
          HekaEPC9,HekaEPC10,HekaEPC10USB,HekaEPC9USB :begin
            Amplifier.AmplifierType[0] := amHekaEPC9 ;
            Amplifier.AmplifierType[1] := amNone ;
            Amplifier.AmplifierType[2] := amNone ;
            Amplifier.AmplifierType[3] := amNone ;
            end;
          HekaEPC10Plus : begin
            Amplifier.AmplifierType[0] := amHekaEPC9 ;
            Amplifier.AmplifierType[1] := amHekaEPC9 ;
            Amplifier.AmplifierType[2] := amNone ;
            Amplifier.AmplifierType[3] := amNone ;
            end ;
          else begin
            if Amplifier.AmplifierType[0] = amTriton then Amplifier.AmplifierType[0] := amNone ;
            if Amplifier.AmplifierType[0] = amVP500 then Amplifier.AmplifierType[0] := amNone ;
            if Amplifier.AmplifierType[0] = amHekaEPC9 then Amplifier.AmplifierType[0] := amNone ;
            if Amplifier.AmplifierType[1] = amHekaEPC9 then Amplifier.AmplifierType[1] := amNone ;
          end;
        end ;

     edModel.Text := Main.SESLabIO.LabInterfaceModel ;

     end;


procedure TLabInterfaceSetupFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree ;
    end;

procedure TLabInterfaceSetupFrm.cbLabInterfaceChange(Sender: TObject);
// ----------------------
// Lab. interface changed
// ----------------------
begin
     Screen.Cursor := crHourGlass ;
     Main.SESLabIO.LabInterfaceType := Integer(cbLabInterface.Items.Objects[cbLabInterface.ItemIndex]);
     FillOptionsLists ;
     Screen.Cursor := crDefault ;
     end;


procedure TLabInterfaceSetupFrm.cbDeviceNumberChange(Sender: TObject);
// ----------------------
// Device # changed
// ----------------------
begin
     Screen.Cursor := crHourGlass ;
     Main.SESLabIO.DeviceNumber := cbDeviceNumber.ItemIndex + 1 ;
     FillOptionsLists ;
     Screen.Cursor := crDefault ;
     end;

procedure TLabInterfaceSetupFrm.bCancelClick(Sender: TObject);
begin
     Close ;
     end;

procedure TLabInterfaceSetupFrm.cbADCInputModeChange(Sender: TObject);
// ----------------------
// A/D input mode changed
// ----------------------
begin
     Screen.Cursor := crHourGlass ;
     Main.SESLABIO.ADCInputMode := cbADCInputMode.ItemIndex ;
     FillOptionsLists ;
     Screen.Cursor := crDefault ;
     end;

end.
