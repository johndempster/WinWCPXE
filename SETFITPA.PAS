unit Setfitpa;
{ ===========================================================
  WinEDR (c) J. Dempster, University of Strathclyde 1998-2001
  Let users set curve fitting parameters
  ===========================================================
  19/4/99 ... Now used TValidatedEdit
  24/6/01 ... Equation parameters now displayed with super/subscripts
              using RichEdit controls
  17/12/02 ... Now performs initial parameter guesses
               and has manual guess option to retain previous settings           }

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, maths, ValEdit, ComCtrls, ValidatedEdit ;

type
  TSetFitParsFrm = class(TForm)
    ParametersGrp: TGroupBox;
    ckFixed0: TCheckBox;
    Label2: TLabel;
    ckFixed1: TCheckBox;
    ckFixed2: TCheckBox;
    ckFixed3: TCheckBox;
    ckFixed4: TCheckBox;
    ckFixed5: TCheckBox;
    ckFixed6: TCheckBox;
    ckFixed7: TCheckBox;
    bOK: TButton;
    bCancel: TButton;
    Label1: TLabel;
    edPar0: TValidatedEdit;
    edPar1: TValidatedEdit;
    edPar2: TValidatedEdit;
    edPar3: TValidatedEdit;
    edPar4: TValidatedEdit;
    edPar5: TValidatedEdit;
    edPar6: TValidatedEdit;
    edPar7: TValidatedEdit;
    erPar0: TRichEdit;
    erPar1: TRichEdit;
    erpar2: TRichEdit;
    erpar3: TRichEdit;
    erpar4: TRichEdit;
    erpar5: TRichEdit;
    erpar6: TRichEdit;
    erpar7: TRichEdit;
    erpar8: TRichEdit;
    edpar8: TValidatedEdit;
    ckfixed8: TCheckBox;
    erpar9: TRichEdit;
    edpar9: TValidatedEdit;
    ckfixed9: TCheckBox;
    GroupBox1: TGroupBox;
    rbAutomaticGuess: TRadioButton;
    rbManual: TRadioButton;
    bInitialise: TButton;
    procedure FormShow(Sender: TObject);
    procedure bOKClick(Sender: TObject);
    procedure bCancelClick(Sender: TObject);
    procedure bInitialiseClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetParameterLine( var erPar : TRichEdit ;
                                var ed : TValidatedEdit ;
                                var ck : TCheckBox ;
                                ParNum : LongInt ) ;
    procedure GetParameterLine( const ed : TValidatedEdit ;
                                const ck : TCheckBox ;
                                ParNum : LongInt ) ;

  public
    { Public declarations }
    Equation : TEquation ;
    MathFunc : TMathFunc ;
    XUnits : string[8] ;
    YUnits : string[8] ;
    XYData : PXYData ;
    NumPoints : Integer ;

  end;

var
  SetFitParsFrm: TSetFitParsFrm;

implementation


{$R *.DFM}

procedure TSetFitParsFrm.FormShow(Sender: TObject);
{ ---------------------------------------
  Initialisation when dialog form is shown
  ---------------------------------------}
begin

        SetParameterLine( erPar0, edPar0,  ckFixed0, 0 ) ;
        SetParameterLine( erPar1, edPar1,  ckFixed1, 1) ;
        SetParameterLine( erPar2, edPar2,  ckFixed2, 2 ) ;
        SetParameterLine( erPar3, edPar3,  ckFixed3, 3 ) ;
        SetParameterLine( erPar4, edPar4,  ckFixed4, 4 ) ;
        SetParameterLine( erPar5, edPar5,  ckFixed5, 5 ) ;
        SetParameterLine( erPar6, edPar6,  ckFixed6, 6 ) ;
        SetParameterLine( erPar7, edPar7,  ckFixed7, 7 ) ;
        SetParameterLine( erPar8, edPar8,  ckFixed8, 8 ) ;
        SetParameterLine( erPar9, edPar9,  ckFixed9, 9 ) ;
        end;


procedure TSetFitParsFrm.SetParameterLine(
          var erPar : TRichEdit ;
          var ed : TValidatedEdit ;
          var ck : TCheckBox ;
          ParNum : Integer
          ) ;
{ -------------------------------------------
  Create parameter line on form from Equation
  -------------------------------------------}
var
   List : TStringList ;
begin

     if ParNum < MathFunc.NumParameters then begin
        List := TStringList.Create ;
        List.Add( MathFunc.ParNames[ParNum] ) ;
        MathFunc.CopyResultsToRichEdit( List , erPar ) ;
        if Pos( 'ms', MathFunc.ParUnits[ParNum] ) > 0 then ed.Scale := 1.
                                                      else ed.Scale := 1. ;

        if rbAutomaticGuess.Checked and
           (not MathFunc.FixedParameters[ParNum]) then
           ed.Value := MathFunc.InitialGuess(XYData^,NumPoints,ParNum)
        else ed.Value := MathFunc.Parameters[ParNum]  ;

        ed.Units := MathFunc.ParUnits[ParNum] ;
        ed.enabled := True ;
        ck.Enabled := True ;
        if MathFunc.FixedParameters[ParNum] then ck.Checked := True
                                            else ck.Checked := False ;
        erPar.Visible := True ;
        List.Free ;
        end
     else begin
        erPar.visible := False ;
        ed.text := '' ;
        ed.enabled := False ;
        ck.enabled := False ;
        ck.checked := False ;
        end ;
     end ;



procedure TSetFitParsFrm.GetParameterLine(
          const ed : TValidatedEdit ;
          const ck : TCheckBox ;
          ParNum : LongInt
          ) ;
{ -----------------------------------------------
  Read parameter line on form and update Equation
  -----------------------------------------------}
begin
     if ed.enabled then  begin
        MathFunc.Parameters[ParNum] := ed.Value ;
        MathFunc.FixedParameters[ParNum] := ck.Checked
        end ;
     end ;


procedure TSetFitParsFrm.bOKClick(Sender: TObject);
//
// OK button clicked
// -----------------
begin

     // Transfer equation parameters from form to MathFunc

     GetParameterLine( edPar0, ckFixed0, 0 ) ;
     GetParameterLine( edPar1, ckFixed1, 1 ) ;
     GetParameterLine( edPar2, ckFixed2, 2 ) ;
     GetParameterLine( edPar3, ckFixed3, 3 ) ;
     GetParameterLine( edPar4, ckFixed4, 4 ) ;
     GetParameterLine( edPar5, ckFixed5, 5 ) ;
     GetParameterLine( edPar6, ckFixed6, 6 ) ;
     GetParameterLine( edPar7, ckFixed7, 7 ) ;
     GetParameterLine( edPar8, ckFixed8, 8 ) ;
     GetParameterLine( edPar9, ckFixed9, 9 ) ;

     // Indicate that parameters have been set
     Equation.ParametersSet := True ;

     // Exit
     hide ;
     end;


procedure TSetFitParsFrm.bCancelClick(Sender: TObject);
begin
     hide ;
     end;


procedure TSetFitParsFrm.bInitialiseClick(Sender: TObject);
// -----------------------------------------
// Create a set of initial parameter guesses
// -----------------------------------------
var
     i : Integer ;
begin

     // Get parameter data from form
     GetParameterLine( edPar0, ckFixed0, 0 ) ;
     GetParameterLine( edPar1, ckFixed1, 1 ) ;
     GetParameterLine( edPar2, ckFixed2, 2 ) ;
     GetParameterLine( edPar3, ckFixed3, 3 ) ;
     GetParameterLine( edPar4, ckFixed4, 4 ) ;
     GetParameterLine( edPar5, ckFixed5, 5 ) ;
     GetParameterLine( edPar6, ckFixed6, 6 ) ;
     GetParameterLine( edPar7, ckFixed7, 7 ) ;
     GetParameterLine( edPar8, ckFixed8, 8 ) ;
     GetParameterLine( edPar9, ckFixed9, 9 ) ;

     // Determine best initial guesses
     for i := 0 to MathFunc.NumParameters-1 do
         if not MathFunc.FixedParameters[i] then begin
            MathFunc.Parameters[i] := MathFunc.InitialGuess(XYData^,NumPoints,i) ;
            end ;

     // Update form with new values
     SetParameterLine( erPar0, edPar0,  ckFixed0, 0 ) ;
     SetParameterLine( erPar1, edPar1,  ckFixed1, 1) ;
     SetParameterLine( erPar2, edPar2,  ckFixed2, 2 ) ;
     SetParameterLine( erPar3, edPar3,  ckFixed3, 3 ) ;
     SetParameterLine( erPar4, edPar4,  ckFixed4, 4 ) ;
     SetParameterLine( erPar5, edPar5,  ckFixed5, 5 ) ;
     SetParameterLine( erPar6, edPar6,  ckFixed6, 6 ) ;
     SetParameterLine( erPar7, edPar7,  ckFixed7, 7 ) ;
     SetParameterLine( erPar8, edPar8,  ckFixed8, 8 ) ;
     SetParameterLine( erPar9, edPar9,  ckFixed9, 9 ) ;

     end;

end.
