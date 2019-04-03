object Main: TMain
  Left = 664
  Top = 328
  Caption = ';'
  ClientHeight = 586
  ClientWidth = 869
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 566
    Width = 869
    Height = 20
    Panels = <
      item
        Width = 400
      end
      item
        Width = 50
      end>
  end
  object MainMenu: TMainMenu
    Left = 16
    Top = 8
    object File1: TMenuItem
      Caption = '&File'
      RadioItem = True
      OnClick = File1Click
      object mnNew: TMenuItem
        Caption = '&New Data File..'
        OnClick = mnNewClick
      end
      object mnOpen: TMenuItem
        Caption = '&Open Data File..'
        OnClick = mnOpenClick
      end
      object mnFileProps: TMenuItem
        Caption = 'P&roperties'
        OnClick = mnFilePropsClick
      end
      object mnClose: TMenuItem
        Caption = 'Close'
        OnClick = mnCloseClick
      end
      object mnPrint: TMenuItem
        Caption = '&Print..'
        Enabled = False
        OnClick = mnPrintClick
      end
      object mnPrintSetup: TMenuItem
        Caption = 'Print Setup'
        OnClick = mnPrintSetupClick
      end
      object mnImport: TMenuItem
        Caption = '&Import..'
        OnClick = mnImportClick
      end
      object mnExport: TMenuItem
        Caption = '&Export..'
        OnClick = mnExportClick
      end
      object mnInterleave: TMenuItem
        Caption = 'I&nterleave Records..'
        OnClick = mnInterleaveClick
      end
      object mnAppend: TMenuItem
        Caption = '&Append Data File..'
        OnClick = mnAppendClick
      end
      object InspectLogFile: TMenuItem
        Caption = 'Inspect Log File'
        OnClick = InspectLogFileClick
      end
      object mnExit: TMenuItem
        Caption = 'E&xit'
        OnClick = mnExitClick
      end
      object mnRecentFileSeparator: TMenuItem
        Caption = '-'
      end
      object mnRecentFile0: TMenuItem
        OnClick = mnRecentFile0Click
      end
      object mnRecentFile1: TMenuItem
        Tag = 1
        OnClick = mnRecentFile0Click
      end
      object mnRecentFile2: TMenuItem
        Tag = 2
        OnClick = mnRecentFile0Click
      end
      object mnRecentFile3: TMenuItem
        Tag = 3
        OnClick = mnRecentFile0Click
      end
    end
    object Edit: TMenuItem
      Caption = '&Edit'
      OnClick = EditClick
      object mnCopyData: TMenuItem
        Caption = 'Copy &Data'
        Enabled = False
        OnClick = mnCopyDataClick
      end
      object mnCopyImage: TMenuItem
        Caption = 'Copy &image'
        Enabled = False
        OnClick = mnCopyImageClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object CopyRecord: TMenuItem
        Caption = 'C&opy record'
        OnClick = CopyRecordClick
      end
      object InsertRecord: TMenuItem
        Caption = 'I&nsert record'
        OnClick = InsertRecordClick
      end
      object DeleteRecord: TMenuItem
        Caption = '&Delete record'
        OnClick = DeleteRecordClick
      end
      object AppendRecord: TMenuItem
        Caption = '&Append record'
        OnClick = AppendRecordClick
      end
      object DeleteRejected: TMenuItem
        Caption = 'Delete &rejected'
        OnClick = DeleteRejectedClick
      end
    end
    object View: TMenuItem
      Caption = '&View'
      OnClick = ViewClick
      object mnZoomOutAll: TMenuItem
        Caption = 'Zoom Out (&All channels)'
        OnClick = mnZoomOutAllClick
      end
      object mnStoreTraces: TMenuItem
        Caption = '&Superimpose traces'
        OnClick = mnStoreTracesClick
      end
      object mnDisplayGrid: TMenuItem
        Caption = 'Display &grid'
        OnClick = mnDisplayGridClick
      end
      object mnShowAllChannels: TMenuItem
        Caption = 'S&how all channels'
        OnClick = mnShowAllChannelsClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnShowRaw: TMenuItem
        Caption = '&Raw records'
        Checked = True
        OnClick = mnShowRawClick
      end
      object mnShowAveraged: TMenuItem
        Caption = '&Averaged records'
        OnClick = mnShowAveragedClick
      end
      object mnShowLeakSubtracted: TMenuItem
        Caption = '&Leak subtracted records'
        OnClick = mnShowLeakSubtractedClick
      end
      object mnShowDrivingFunction: TMenuItem
        Caption = '&Driving functions'
        OnClick = mnShowDrivingFunctionClick
      end
    end
    object Record1: TMenuItem
      Caption = '&Record'
      object mnRecordToDisk: TMenuItem
        Caption = '&Record to disk'
        OnClick = mnRecordToDiskClick
      end
      object mnSealTest: TMenuItem
        Caption = '&Pipette seal test / Signal monitor'
        OnClick = mnSealTestClick
      end
    end
    object Setup: TMenuItem
      Caption = '&Setup'
      OnClick = SetupClick
      object mnLaboratorInterface: TMenuItem
        Caption = '&Laboratory Interface'
        OnClick = mnLaboratorInterfaceClick
      end
      object Recording1: TMenuItem
        Caption = '&Input Channels && Amplifiers'
        OnClick = Recording1Click
      end
      object WaveformGenerator: TMenuItem
        Caption = '&Stimulus/recording Protocol Editor'
        OnClick = WaveformGeneratorClick
      end
      object mnCED1902: TMenuItem
        Caption = '&CED 1902 amplifier'
        OnClick = mnCED1902Click
      end
      object mnDClamp: TMenuItem
        Caption = 'DCLAMP - D&ynamic Clamp'
        OnClick = mnDClampClick
      end
      object mnVP500: TMenuItem
        Caption = '&VP500 Patch Clamp'
        OnClick = mnVP500Click
      end
      object mnTriton: TMenuItem
        Caption = '&Tecella Patch Clamp'
        OnClick = mnTritonClick
      end
      object mnEPC9Panel: TMenuItem
        Caption = 'EPC-&9/10 Patch Clamp'
        OnClick = mnEPC9PanelClick
      end
      object mnResetMulticlamp: TMenuItem
        Caption = 'Reset &Multiclamp 700A/B Link'
        Hint = 'Reset communication link with Multiclamp 700A/B'
        OnClick = mnResetMulticlampClick
      end
      object mnDefaultSettings: TMenuItem
        Caption = '&Default output settings'
        OnClick = mnDefaultSettingsClick
      end
    end
    object Analysis: TMenuItem
      Caption = '&Analysis'
      object WaveformMeasurements: TMenuItem
        Caption = '&Waveform measurement'
        OnClick = WaveformMeasurementsClick
      end
      object SignalAverager: TMenuItem
        Caption = '&Signal averaging'
        OnClick = SignalAveragerClick
      end
      object LeakCurrentSubtraction: TMenuItem
        Caption = '&Leak current subtraction'
        OnClick = LeakCurrentSubtractionClick
      end
      object CurveFitting: TMenuItem
        Caption = '&Curve fitting'
        OnClick = CurveFittingClick
      end
      object mnPwrSpec: TMenuItem
        Caption = 'Non-stationary &variance'
        OnClick = mnPwrSpecClick
      end
      object mnQuantalContent: TMenuItem
        Caption = '&Quantal content'
        OnClick = mnQuantalContentClick
      end
      object mnDrivingFunction: TMenuItem
        Caption = '&Driving function'
        OnClick = mnDrivingFunctionClick
      end
      object EditRecord: TMenuItem
        Caption = 'Signal &editor'
        OnClick = EditRecordClick
      end
    end
    object Simulations1: TMenuItem
      Caption = 'S&imulations'
      object Synapse: TMenuItem
        Caption = '&Nerve-evoked EPSCs'
        OnClick = SynapseClick
      end
      object HHSimulation: TMenuItem
        Caption = '&Voltage-activated currents'
        OnClick = HHSimulationClick
      end
      object mnSimMEPSC: TMenuItem
        Caption = '&Miniature EPSCs'
        OnClick = mnSimMEPSCClick
      end
    end
    object Windows: TMenuItem
      Caption = '&Windows'
      object mnDummy: TMenuItem
        Visible = False
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object Contents: TMenuItem
        Caption = '&Contents'
        OnClick = ContentsClick
      end
      object mnShowHints: TMenuItem
        Caption = '&Show Hints'
        Checked = True
        OnClick = mnShowHintsClick
      end
      object About: TMenuItem
        Caption = '&About ...'
        OnClick = AboutClick
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'Whole Cell (WCP)|*.wcp'
    Left = 56
    Top = 8
  end
  object SaveDialog: TSaveDialog
    Filter = 'Whole Cell (WCP|*.wcp'
    Left = 96
    Top = 8
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 128
    Top = 8
  end
  object ImportFile: TADCDataFile
    NumChannelsPerScan = 2
    NumBytesPerSample = 2
    NumScansPerRecord = 512
    FloatingPointSamples = False
    MaxADCValue = 2047
    MinADCValue = -2048
    RecordNum = 0
    ScanInterval = 1.000000000000000000
    NumFileHeaderBytes = 0
    WCPNumZeroAvg = 0
    WCPRecordAccepted = False
    ABFAcquisitionMode = ftGapFree
    EDREventDetectorChannel = 0
    EDREventDetectorRecordSize = 0
    EDRVarianceRecordSize = 0
    EDRVarianceRecordOverlap = 0
    EDRBackedUp = False
    ASCIISeparator = #9
    ASCIITimeDataInCol0 = False
    ASCIITimeUnits = 's'
    ASCIITitleLines = 2
    ASCIIFixedRecordSize = False
    Left = 160
    Top = 8
  end
  object SESLabIO: TSESLabIO
    ADCNumSamples = 1
    DACInvertTriggerLevel = False
    DACRepeatWaveform = False
    DigitalStimulusEnabled = False
    DigitalStimulusStart = 0
    TritonUserConfig = 0
    TritonDACStreamingEnabled = False
    TritonICLAMPOn = False
    Left = 200
    Top = 8
  end
end
