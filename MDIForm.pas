unit MDIForm;
// USERS OF THIS SOFTWARE MAY MODIFY IT FOR PERSONAL PURPOSES ASSOCIATED
// WITH ACADEMIC RESEARCH. ITS SALE OR INCORPORATION INTO COMMERCIALLY
// DISTRIBUTED PRODUCTS IN WHOLE OR IN PART IS FORBIDDEN WITHOUT THE
// THE EXPRESS PERMISSION OF THE AUTHOR OR THE UNIVERSITY OF STRATHCLYDE

{ =======================================================================
  WinWCP Master MDI form (c) John Dempster, 1996-2001 All Rights Reserved
  V1.3 20/3/97 CED 1401 support added (tested on micro1401)
  V1.3b 3/4/97 About box now reads Interface type on start-up
               pCLAMP multi-channel files now imported with correct dt
               -10412 error now fixed for N.I. boards
  V1.4 23/4/97 Support for CED 1902 added
  V1.5 20/5/97 Support for Digidata 1200 added
  4/6/97 ... Caption now correctly updated when New file created
  V1.5a 9/6/97 ...Append menu option added
  V1.6 10/6/97 ... Export to Axon ABF file added
  V1.6a 12/6/97 ... LEAK records now included in subtracted file when
                    in FILE MODE leak subtraction mode.
                    COPY DATA Buffer overflow GPI (REPLAY.PAS) fixed
  V1.6b 16/6/97 ... Cursor readings in View Records can be saved to log file
  V1.6c 25/6/97 ... Seal test now has 3 pulse options
        27/6/97 ... Seal Test AUTOSCALE and DISPLAYSCALE now in INI file
  V1.6d 27/6/97 ... Seal test baseline now fixed when AutoScale is unchecked
  V1.6e 8/7/97 ... Seal Test scaling now takes amplifier gain into account
  V1.6f 16/7/97 ... Default Outputs Dialog now indicates whether it is
                    active or not.
                    Seal Test always autoscaled, first time after program
                    started
  V1.7 25/8/97 ... Import from CED data files added (Convert.pas)
  V1.7a 31/8/97 ... Key shortcuts now available for setting record type
        1/9/97 ... Append now updates number of records correctly
  V1.7b 8/9/97 ... Event detector pre-trigger % now variable
                   Delete rejected records now works
                   Ctrl-R now toggles rejected record check box
  V1.7c 10/9/97 ... Active record in View records module (replay.pas)
                    now only displayed once.
                    Number of variables in X-Y displays now increased
                    to 6000 (measure.pas, curvefit.pas)
                    Histograms now stored in clipboard as Bin.Mid,Y pairs
  V1.7d 1/12/97 ... Event detection now works with standard 1401 (rec.pas)
                    CED error message text now returned (CED1401.pas)
  V1.8 14/12/97 ... Waveform generation now accurate to 0.1 ms
                    Averaging function limited of 16000 points
                    Copy Data GPF fixed by reducing size of text buffer to
                    30000
                    10-90% rise time now based upon 10%-90% (peak-baseline)
                    rather than 10%-90% peak+ - peak-
  V1.8a 6/1/97 ...  INI file can now be disabled with /NI command line
                    parameter. This allows program to be run from read-only
                    directory on a file server. Log file also disabled in
                    these circumstance.
  V1.8b 20/1/98 ... Seal Test now has free run option which allows monitoring
                    of input channels without voltage pulse generation/triggering
  V1.8c 24/2/98 ... EPC curve fitting function now works
  V1.9 3/2/98 ... Export to ASCII, Integer and floating point now added
  V1.9a 5/3/98 ... DMA channels can now be disabled for N.I. boards (update)
                   Digidata I/O port can now be changed by users (bug fix)
  V1.9b 23/3/98 ... Curve fitting no longer crashes when fitting very large
                    records.
                    Large error pulse steps between seal test sweeps
                    with Digidata 1200 fixed.
                    (Bug in VDS_ProgramDMACHannel in VDS.PAS).
  V2.0 2/4/98 ...   Time interval over which rate of rise is calculated
                    can now be set by user. (measure.pas)
                    Cursor readout now shows both absolute and C1-C0 values
                    (replay.pas)
                    LabPC.pas corrected to prevent NIDAQ error messages
                    during voltage pulses
                    Numbers of data points in user-defined waveforms now
                    reduced automatically to fit available buffer space.
                    Recording intervals also adjusted if too long
  V2.0a 14/4/98 ... Bug in WavRun.pas which caused NIDAQ error -10411 when
                    voltage pulse >7secs long were produced now fixed.
  V2.0b 5/5/98 ... Size of array increased in SaveInitializationFile and
                    LoadInitializationFile to avoids Array Full error when
                    6 channels are used.
  V2.1 6/2/98 ... SealTest module modified to fix intermittent 0V glitches
                    between test pulses with Digidata 1200
                    Delete Records & Delete Rejected option fixed to
                    prevent Divide by Zero errors when further records
                    are acquired.
                    Test pulse width can now be set within range 0.1 ms - 1000ms
                    System no longer crashes on File/Exit when
                    Seal Test or Recording in progress
  V2.2 12/4/99 ... RecEdit can now change ADCVoltageRange settings for record
                   Residual SD added to list of variables in Curvfit.pas
  V2.3 31/5/99 ... Updated to support ABF V1.5 (Clampex V7)
  V2.3a 25/6/99 ... ADCVoltageRange = 0.0 trapped and corrected
          Problem arises when WinWCP files are analysed by WCP for DOS
  -----------
  V3.0 11/7/99 ... 32 bit version
       23/7/99 ... V8.0 WCP data file now has 1024 byte analysis block
       4/9/99 ... Display grid added
       10/9/99 ... Curvfit.pas Zero baseline now correctly added to fitted lines
  22/10/99 ... Replay.pas updated
  26/10/99 ... ScopeDisplay.pas changed
               .AddHorizontalCursor now has UseAsZeroLevel flag
  30/10/99 ... NewFile method added to MDI child forms
  V3.0b 9/12/99
  V3.0.2 16/12/99
  V3.0.3 21/12/99 ... NIDAQ -10403 error with PCI-1200 now fixed (labpc.pas)
  V3.0.4 24/1/2000 ... NIDAQ -10403 error with Lab-PC1200/AI now fixed (labpc.pas)
                   ... SimHH.pas Inactivation kinetics fixed
                   ... Conversions from V2.X to V3.X WCP format now reported in log
  V3.0.5 25/1/2000 ... Axon import and export bugs fixed (convert.pas)
                       Non-linear summation fixed in Quantal Analysis module (qanal.pas)
  V3.0.6 22/2/2000 ... Copy Image improved
  V3.0.7 12/3/2000 ... Rate of rise mode now has quadratic fitting options (measure.pas)
  21/3/00 Maths.pas GetEquation Now returns ParFixed state correctly
  V3.0.8a ?????
  8/8/00  Bug in MINV fixed which was returning incorrect parameter SDs
  12/9
  23/11/00 ... Default command voltage and digital output settings now
               updated as soon as program starts
  V3.0.9 28/11/00
  V3.1.0 4/1/01
         Four new record types added TYP1,TYP2,TYP3,TYP4
         Records designated as FAIL now always return zero peak measurements
  V3.1.1 19/1/01 (SEALTEST) Error in calculation of current pulse corrected
  V3.1.2 22/1/01 Decaying exponential functions added to curve fitting
  31/1/01 Non-stationary variance calculation corrected. Now correctly
          applies peak scaling to variance-mean plot. (PWRSPEC)
  19/02/01 Axopatch gain telegraphs now read
  V3.1.3 6/3/01 FilterFrm now preserves variable, channel and record type
         7/3/2001 -10697 error with E-Series boards when dt>3 ms fixed
         12/3/2001 Axoutils32.dll now loaded from c:\axon\libs (not \windows\system)
                   (WinWCP now compatible with AxoScope)
  V3.1.4 26/4/2001 Support for CED Power-1401 added
                   Gaussian curves can now be fitted to histograms in measure.pas
                   Exponential functions can be fitted to X/Y graphs in measure.pas
                   Warning now given when trying to open READ-ONLY files.
  V3.1.5 ??        Artefact removal added to Signal Editor
  V3.1.6 17/7/01 ... Signal difference between Readout-t0 cursors added
                     Greek symbols now used for Tau in fit results
                     Copy Data how handles large records correctly
                     and copies reliably
  V3.1.7         Measure.pas (Baseline variable now derived from record-baseline average
              and now visible in results box)
              Now compilable under Delphi V5
              14/8/01 .... Elapsed timer added to Seal Test
                           SealTest window now resizable
                           FP error when maximised now fixed
  V3.1.8 3/9/01 .... Fixed/From record zero level settings now saved in initialisation file
                     "From record" zero level averaging area now indicated by pair of tics
  V3.1.9 1/10/01 .. Error which prevented selection of No Lab Interface (16 bit) option
                     now fixed (SESLabIO)
  V3.1.10 1/11/01 ... Display now zoomed out correctly when number
                       of samples in record changes (replay.pas)
                       DD1320.pas changed to get circular buffer
                       function to work correctly with Digidata 1320
                       Multiple ASCII record files now imported correctly
  23/11/01 Functions in Wavrun.pas moved to proper data module
           Wrap-round when DAC value exceeds upper limit
           of DAC binary range fixed (FillDACBuf)
  4/12/01 ... MaxTBuf (in global.pas) increased to 32767 to avoid problems
              with averaging large records
              Save Cursor now saves data to log file in tab formatted table (replay.pas)
              Recorded signals can now be superimposed during recording
  6/12/01 ... Peak amplitude can now be calculated from average of
              points before or after peak signal (measure.pas)
              Hang-up problem with 16 bit boards fixed (NI_GetLabInterfaceInfo)
  V3.2.1 20/12/01 ... 12 bit D/A outputs of 16 bit PCI-6035E now supported correctly
                      All modules now use Main.WriteOuputPorts to set default D/A digital values

  V3.2.2 16/1/01  ... Non-stationary variance now derives average scaling factor
                      from signal amplitude at same point as peak of average
                      rather than individual peak (i.e. now same as Silver et al, 1993)
         27/01/02 ... MaxPointsPerLine of XYPlotDisplay components now adjusted to correct size.
                      (pwrspec.pas)

  V3.2.2 13/2/02 .... Intermittent floating point errors with Windows 2000 fixed
                      Resistance and other readouts only updated if they have
                      valid data now (sealtest.pas)

  V3.2.3 25/2/02 .... Record type matching criteria added to record selection filter (measure.pas)
                      Sub-ranges of records can now exported in tab-text format correctly.
                      Status-bar added to bottom of MDI form

          26/2/02 ... Rise time limits can now be set by user
                      Progress is reported in main status bar
          19/3/02 ... Leak current subtraction can now preserve absolute zero level
                      (used primarily when subtracting record in Fixed scaling mode)
          22/3/02 ... Curve Fit now handles largest records (32678 samples)
                      ITC-16/18 support added
  V3.2.4 12/4/02  ... c:\axon\pclamp8 and c:\axon\axoscope8 folders now
                      searched for Axdd123x.dll (dd1320.pas)
  V3.2.5 ??       ... Traces now correctly match channel names
                      in Leak subtraction and Edit Record displays
          28/4/02 ... Sub-range of samples within record can now be output in
                      tab-text and binary export formats (export.pas)
          15/5/02 ... Sub-ranges of records can now be exported to ABF files (export.pas)
          15/5/02 ... Importing progress now reported in main status bar
          21.5.02 ... Support for -AI variants of N.I. cards which lack D/A converters added (natinst.pas)
          22.5.02 ... ASCII text file now closed after importing ended (import.pas)
          29.5.02 ... Settings now saved to WCP file header when OK selected (setup.pas)
  V3.2.6  15.7.02 ... Digital outputs now supported on E-series National Instruments boards
                      Stimulus Editor - RecordInterval now automatically updated to ensure that it is
                                        5% (or 300ms) greater than RecordDuration
          19.7.02 ... Time shift of digital pulses after first sweep in a series
                      with CED 1401 interfaces fixed (by ensuring that last point
                      output to sync. channel is always Trigger Off) (StimModule.pas)

          23.7.02 ... DAC update interval limited to 50 ms
                      to avoid -10411 error with Lab-PC boards (23.7.02)
  V3.2.7  23.10.02 ... Support for CED Micro-1401 Mk2 added
                       Compiled under Delphi V7
          26.11.02 ... Support for 10V A/D input range of National Instruments
                       boards added, some corrected to A/D ranges for various boards
  V3.2.8  30.01.03 ... Support for ITC-16 & ITC-18 using old driver added
          10.02.03 ... Problem which caused DIV 0 error when using PCLAMP V9
                       version of AXDD132X.DLL fixed
                       (Copies of older AXDD132X.DLL and AXOUTILS32.DLL now
                        loaded from WinWCP program folder)
          11.02.03 ... WCP data files can now be opened by double clicking
                       when a suitable file type is created
          12.02.03 ... Boltzmann function fitting added to measure.pas
                       T.50% changed to T.x% (user selectable) (measure.pas)
  V3.2.9  8.04.03 .... Support for CED 1401s modified to have 10V A/D or D/As added
          16.4.03 .... Support for PCI-6014E added
          27.04.03 ... Single 5Vx1ms sync pulse now produced on DAC 1
                       by National Instruments E-Series boards.
  V3.3.0  23/5/3 ..... CED 1902 gain now reported immediately when changed
  V3.3.1  24/6/3 ..... No. of horizontal/vertical display grid lines can be changed
                       Support for WPC-100 amplifier added
  V.3.3.2 21/7/3 ..... Exception when importing ABF files fixed
                       ABF file episodes now extended to end of record
                       with last samples when number of samples in episode
                       is not a multiple of 256.
  V3.3.3  25/8/3 ..... Both \1401 and \1401\utils folders checked for 1401 command
                       (ampmodule.pas) CED 1902 queried after each command sent
//                     (fixes failure to set AC coupling with 29xx s/n 1902s)
  V3.3.4  8/9/3 ...... Lo limits now different for current, voltage and cell parameters
  V3.3.6  18/9/3 ..... Seal Test/Record To Disk/Default Settings no longer open
                       when a lab. interface is not available.
                       Failure of Digidata 132X interfaces to open immediately
                       after being switched on fixed
  V3.3.7  15/11/3 ...  Curve fitting now works correctly for record
                       with more than 16000 points
  V3.3.8  21.1/4       About now shows A/D & D/A resolution for NI cards
                       Support for DaqCard 6024E added
  V3.3.9  4/2/3        (Measure.pas) Peak - last point exceeding x% level in
                       Peak-90% decay range is designateded as decay duration.
                       This biases the decay time to longer intervals in the presence of noise. (Problem noticed by
                       Delia Beleli. V3.3.9 now gives same T.50% result as V2.3.7)
                       Bug which may have caused incorrection amplifier gain
                       telegraph readings with National Instruments boards fixed (seslabio.pas)
                       Stimulus protocols can now be externally triggered
                       Signal Editor now allows record A/D input voltage range to be edited
  V3.4.0 4/3/3         Axon ABF file scaling factors now exported correctly when WCPchannels
                       channels have different A/D voltage ranges (ConvertWCPToAxon)
  V3.4.1 10.03.04      FLoating point errors now trapped in sealtest.pas
  V3.4.2 18.03.04      Import now uses ADCDataFile component
  V3.4.3 30.03.04      User-defined stimulus waveforms can now contain negative voltages
                       File/New now increments file name
  V3.4.4 14.04.04      File name incrementing now works
  V3.4.5 09.05.04      Subtraction of ionic leak current only option added
  V3.4.6 11.06.04      VP500 current clamp mode now works
                       VP500 max. sampling rate increased to 50 kHz
                       Stimulus waveform glitch at end of some record sizes fixed
                       VP500 Command not allows errors fixed
  V3.4.7 27.07.04      Active High/Low options now added to External Trigger
  V3.4.9 02.08.04      Trace now remains displayed between sweeps
         09.08.04      Support for Multiclamp 700A and 700B added
  V3.5.0 10.08.04 Biologic RK400 gain readout fixed
  V3.5.1 01.10.04 External trigger mode now working with ITC-18
                  Seal Test window cell parameters can be saved to log file
                  Bug in seal test where holding potential/pulse was set
                  initially to Pulse #1 when #2/#3 required
                  Out of Memory error when windows made too small fixed
  V3.5.2 12.12.04 No. samples/buffer increased to 131072
                  Two DAC voltage waveform channels available within stimulus protocol
                  Support for two patch clamps added
  V3.5.3 13.02.05 AMS-2400 patch clamp gain telegraph fixed
  V3.5.4 14.02.05 Support for NPI Turbo Tec 10C added
  V3.5.5 25.04.05 Support for National Instruments M Series cards added
  V3.5.6 19.05.05 x% value of T.(x%) variable decay time measurement now retained in file
                  Only selected channels now displayed in waveform measurements window
                  Abort button now works in Waveform Measurements module
  V3.5.7          Display magnification settings now retained between data files
  V3.5.8 19.07.05 Pointer fault when blank Next Protocol in Stimulus Editor fixed
                  User-defined waveforms with comma decimal separator can now be used
                  Support for NPI SEC 05LX single electrode voltage clamp added
                  Pointer error when importing large ASCII text files fixed
  V3.5.9 29.07.05 A/D input mode (different, NRSE) can now be set for NI cards
                  NPI SEC 05LX single electrode voltage clamp corrected
  V3.6.2 06.09.05 CED 1902 gain now read correctly
                  EPSC simulation module updated
                  (record duration and display amplitude can now be user-defined)
  V3.6.3          Illegal Pointer error when stimulus waveform exceeds DAC buffer fixed
                  Hot keys for channel zoom in/out added
                  Cursor labels now internal to signal display windows
  V3.6.4 11.12.05 Automation interface added
  V3.6.7 12.04.06 Digidata 1200 now supported on Windows 2000/XP
                  Support for Dagan 3900A & PCONE added
                  Problem with opening zero level dialog box fixed
  V3.6.8 23.04.06 Access violation when fitting curves to non-stationary variance plot fixed
  V3.6.9 23.05.06 Waveform measurement and curve fitting plots can now have > 4096 points
  V3.7.0 25.07.06 Recording channel settings now stored separately from file channel settings
                  File Properties editing dialog box added
                  Axopatch 200 Voltage/current clamp mode telegraph now supported
                  Support for Warner 501A and 505B patch clamps added
  V3.7.1 12.08.06 Record duration + 300ms limit for stimulus protocol removed
                  Displayed trace maintained on screen until next one is available
                  Digidata 1200 now working again under Windows 9X (with old WinRT driver)
                  Axopatch 200 current/voltage clamp channel switching now supported
                  using mode telegraph
  V3.7.2 19.08.06 Storage mode working again
                  Interval between linked protocols now set equal to Record interval
                  of second protocol.
  V3.7.3 03.09.06 Support for Cairn Optopatch current clamp mode telegraph added
  V3.7.4 12.09.09 Lab-PC now uses 100 kHz timebase
  V3.7.5 17.09.06 Record display now zoomed out when program started
                  CED voltage pulse now work correctly when more than 32000 samples in waveform
  V3.7.6 26.09.06 Exception when program started for first fixed
                  Zoom In/Out works with Recording and Replay windows
  V3.7.7 19.10.06 File/Export now exports average and leak-subtracted files as well as raw
                  View menu channel display On/Off selection now works again
  V3.7.8 03.12.06 Waveform measurements now work correctly when signal amplitude
                  exceeds 32767.
                  Averaging of leak current when ILeak only subtraction in use
              now works correctly leading to lower noise / more accuration subtraction
              ILeak mode button only now disabled in Group leak subtraction mode
  V3.7.9 07.12.06 Non-stationary variance now works correctly with 16 bit signals
                  with amplitudes greater than 32767. Error which limited number of
                  points in variance-mean plot to number of records fixed.
  V3.8.0 08.12.06 Non-stationary variance display now use MaxADCValue from
                  loaded WCP file (not laboratory interface
  V3.8.1 18.12.06 Export to IGOR Binary Wave (IBW) files now works.
  V3.8.2 04.02.07 Channels imported from WCP files now scaled correctly
                  CFS file channel with zero points now ignored.
  V3.8.3 07.04.07 SealTest amplifier gain setting now stored and updated corrected
                  when Amplifier = None or Manual
                  Intermittent incorrect sample at end of sweep when usingf ITC16/18 fixed
                  No longer returns errors with boards which don't support 8 bits of digital I/O
  V3.8.4 13.04.07 ITC16/18 now updated correctly
  V3.8.5 05.06.07 Now imports from Heka ASCII data files
                  First lines in ASCII text files can now be ignored
                  Additional functions added to winwcp.AUTO COM interface
                  Bug in digital pulse outputs with E series NI boards now fixed

  V3.8.6 1.08.07 Display magnification facility now easier to use
                 can also be controlled using button on display
  V3.8.7 22.08.07 On-line analysis window added
                  Copy & Print menu items now enabled/disabled by Edit/File menus.
  V3.8.8 04.09.07
  V3.8.9 05.09.07 WCP files with spaces in name now opened correctly in WinWCP when
                  double-clicked. Files can now be exported to folders containing
                  dots in name.
  V3.9.0 20.11.07 Changes in delay and duration of repeated stimulus pulses
                  after the first one with NIDAQ-MX supported cards fixed.
  V3.9.1 28.11.07 .. Stimulus program selected when recording started now restored at stop of recording
                     Stimulus program name now included in status bar
  V3.9.2 14.12.07 Data files containing more than 131000 points now be loaded correctly
  V3.9.3 27.01.08 Sampling interval now exported correctly when a sub-series of records
                  with the same interval exported from a file containing records with
                  different sampling intervals. Warning message displayed when
                  records with different intervals exported (exportunit.pas)
  V3.9.4 11.02.08 Bug in event detection trigger which produced incorrect
                  sampling intervals and samples per record fixed.
                  Lab-PC interfaces now use interrupt-driven data transfer
                  to avoide spike glitches in recording display.
  V3.9.5 11.03.08 Support for CED Power1401 Mk2 added
                  Repeating of digital pulses with 1401s fixed
                  Amplifier support for Axoclamp 2 and Dagan TEV200A added
  V3.9.6 28.04.08 Channel scale factors now correct when importing from
                  Axon ABF V1.8 files
  V3.9.7 03.06.08 Amplifiers now independently controlled (ampmodule.pas)
                  Support added for Triton patch clamp
                  Seal Test and recording window now switch correctly
  V3.9.7 14.07.08 Signal display windows improved.
                  Y axis ticks now now 1,2, or 5 step units
                  Individual channels can hidden. Y axis size of each channel can
                  be adjusted.
                  Seal test now uses last used pulse setting when window re-opened

  V3.9.8 05.08.08 Support for Digidata 1440 added
  V3.9.9 19.08.08 Error which caused incorrect A/D sampling interval being reported
                  (possibly introduced WinWCP V3.9.6-8) with NIDAQ-MX
                  when sampling intervals shorter than board limits selected fixed.
  V4.0.0 20.08.08 Min. sampling/update interval for 6221/6229 boards now 1E-6s.
  V4.0.1 04.09.08 Triton 8 channel patch clamp now fully supported and working
                  Get Cursors button added to Waveform measurement and curve fitting windows
  V4.0.2 05.09.08 Channel Y axis resizing no longer evoked by unintentional mouse up
                  on first display of trace. Vertical cursors no longer displayed
                  when outside selected display area
  V4.0.3 12.09.08 CED 1401 (+/-10V) interface option added
                  NPI Turbo-Tec03X gain scaling now correct
  V4.0.4 6.09.08 Leak waveform now re-created in leak mode to avoid different
                   leak pulse duration
                 "Out of memory" error when exporting files fixed
  V4.0.5 26.09.08 Now works with Digidata 1440 ... "No Devices found"
                  error fixed (by using old version of axdd400.dll)
  V4.0.6 12.11.08 Rise time and decay time precision increased by interpolating
              between samples to find exact time of threshold transition.
              T.X% decay can now be 100%
              Histograms with zero bin width now prevented
  V4.0.8 11.02.09 .. Stimulus protocol folder can now be set by user.
                     Log file can no longer be edited from within WinWCP
                     Add Note line added.
                     Marker option added to recording window
                     Changes to ident line and markers logged
  V4.0.9 16.04.09 .. Error in
  V4.1.0 14.05.09 .. On-line analysis updated. Now has 5 & 7 point smoothed rate of rise
                     and slope measurements. Plots can be linked to specific stimulus
                     protocols.
                     No. of points in user-defined waveforms for stimulus protocols now limited only
                     by size of DAC output buffer of interface card.
  V4.1.1 29.07.09 .. Support for Tecella Triton+ added, library update to V0.111
  V4.1.2 03.09.09 .. CFS files can now be exported
                     CFS files with 4 byte int, 4 & 8 byte real can be read
  V4.1.3 08.12.09 .. Non-stationary variance analysis updated
                     Average scale to peak now works better when realignment in use
                     NS variance settings now retained in WCP file
                     Background variance can now be calculated from pre-signal baseline
  V4.1.4 01.02.10 .. Axoclamp 2 current gain now correct. Support for
                     HS1 HS10 HS0.1 headstages added
                     ChannelLimit changed to WCPChannelLimit to distinguish
                     from ChannelLimit in maths.pas
  V4.1.5 08.03.10 .. WCPChannelLimit changed to WCPMaxChannels-1
  V4.1.6 24.05.10 .. Now supports 16 analog input channels
                     Slope rate of rise added to waveform measurements
                     Double exponential decay EPC added to curve fitting module
                     Supports Tecella Triton plus
                     Improvements to results and summary tables in
                     waveform measurements and curve fitting  modules. Tables
                     can be saved to text files.
                     On-line plot measurements can be copied to clipboard
                     and stored in log file as table.
                     WCP data file format changed to V9.0, Variable size header
                     and record analysis blocks, support for up to 128 analog channels
  V4.1.7 01.06.10 .. Tecella Triton voltage trace now aligned with current traces
  V4.1.8 21.06.10 .. Settings for simulation modules now saved in INI file
                     Waveform measurements Lock Channels option now saved in INI file
                     and no longer resets cursor positions to default when changed
                     Bug where record analysis block size was set incorrectly fixed.
  V4.1.9 22.07.10 .. Time of record acquisition (RH.Time) now set when record is saved
                     to provide consistent time for all trigger modes. Fixes bug with
                     external trigger mode where first record had T=0 and 2nd record
                     record had incorrectly long time.
                     Spurious -10V pulse on DAC0 between stimulus pulses with
                     Digidata 1440A interface fixed (dd1440.pas
  V4.2.0 26.08.01 .. Support for Tecella PICO added (but still has bugs)
                     FP divide error with empty stimulus protocols fixed.
  V4.2.1 08.09.10 .. Triton_Zap function added
  V4.2.2 10.09.10 .. Support for Heka EPC-800 added
  V4.2.3 10.12.10 .. Program now automatically requests elevation to admin
                     privileges when run under Windows Vista or 7.
  V4.2.4 04.01.11 .. Support for PICO
  V4.2.5 07.02.11 .. Now correctly detects NI board min/max sampling intervals
                     when running NIDAQmx V8+
  V4.2.6 09.02.11 .. Additional set of analysis area cursors (3-4) added to
                     on-line analysis module so measurements can be taken from
                     two different regions of recording sweep.
  V4.2.7 09.02.11 ... BUG FIX. Correct D/A voltage range now reported by .DACVoltageRange property
                     (No longer reports A/D voltage range)
  V4.2.8 02.03.11 ... Support for USB 6008/9 added
                      National Instruments cards now traps errors when
                      no hardware is available for device number or
                      A/D input mode is not supported
  V4.2.9 15.04.11 ... Inversion of digital O/P states with Power 1401 Mk2 fixed??
  V4.3.0 10.05.11 ... AM Systems 2400 Current/voltage clamp mode telegraph now supported
  V4.3.1 20.05.11 ... Tecella PICO: No. of samples in recording sweep can now be set 256-32768
                      Voltage ramps suppported in voltage-clamp (+/-255mV) mode
  V4.3.3 12.07.11 ... New stimulus protocol editor, amplifiers module,
                      Laboratory Interface setup now separate from amplifiers
                      Recording settings now set in Recording window
         20.07.11 ... Protocol execution list added to recording window
  V4.3.4 22.08.11 ... File/New Data File .. Folder now set to My Documents
                    if existing data folder does not exist.
                    Signal displays: Time axis now has calibration ticks
                    Channel tick boxes no longer drop off screen
                    Signal channels can now be remapped to different
                    analog inputs (National Instruments interfaces)
  V4.3.5 22.09.11 ... Stack overflow error when switching from Channels to Amplifiers page
                      in Input CHannels & Amplifiers fixed
                      EPC 800 gain and mode telegraph updated and now working correctly
                      Seal test now uses correct A/D voltage range when program started
  V4.3.6 30.09.11 ... Laboratory Interface Setup: A/D voltage range setting is now
                      preserved when device # is changed. Model name is now updated
                      correctly when device number is changed
  V4.3.7 18.10.11 ... Correct D/A voltage range now determined for PCIe 6229
                      Default command voltage scale factor for OptoPatch now 100 mV/V
  V4.3.8 02.11.11 ... Full range of stimulus types, digital outputs and utility DAC output
                      now supported on Pico.
  V4.3.9 07.11.11 ... Memory violation when setting Digidata 1320 interface fixed
                      (seslabio.pas, dd1320.pas)
  V4.4.0 15.11.11 ... Data points for fitted lines now copied to clip board by Edit/Copy Data
                      (scopedisplay.pas)
                      No. of samples / record can now be entered in simulation windows
  V4.4.1 18.11.11 ... Digidata 1320 increased to 1048576 samples
                      Signal display now in correct place in recording window
  V4.4.2 19.12.11 ... ITC-16/18 buffer size increased to 4194304
  V4.4.3 23.12.11 ... Coinitialise/Codeinitialize code added to LoadProtocolFromXML/SaveProtocolToXML
                      in stimModule.pas and in TritonUnit.pas.
                      DAC streaming can now be disabled for Tecella PICO
  V4.4.4 16.01.12 ... Instrutech old drivers buffer size increased to 4194304
  V4.4.5 16.01.12 ... All modules with XML settings files:
                      GetElementFloat() in XML settings files now handles both ',' and '.' decimal separators
                      stimmodule.pas: Leak subtraction option now correctly divides AO0 waveform.
                      sealtest.pas: Duration of stimulus pulse now determined from ChIm in Iclamp mode and ChVm in Vclamp mode
// V4.4.6 18.01.12 Triton_MemoryToDACAndDigitalOutStream: DAC stimulus stream values divided by 10
//                 in current clamp mode to keep signal scaling correct I(Not sure why this is
//                 necessary
// V4.4.7 24.01.12 .. Sealtest: Pulse amplitudes in seal test now located correctly when holding potential non-zero
//                    Fixes bug introduced 16.01.12
// V4.4.8 06.03.12 .. .WCP data files now opened in share deny right
//                     allowing other programs read only sharing
//                    SealTestfrm: Output channels for test pulse now selected by check box and pulse can be
//                    applied to additional channels by ticking boxes.
// V4.4.9 02.04.12 .. Tecella Pico: C slow A-D components can now be enabled/disabled
//                    in automatic capacity compensation
// V4.5.0 16.04.12 .. Default data and vprot folders now automatically created inside
//                    winwcp folder if not already present.
//                    Applying stimulus with more output channels than available no
//                    longer corrupts stimulus waveforms (rec.pas)
//                    Access violation when switching between Amplifiers & Input Channels page
//                    in Input Channels & Amplifiers fixed.
//                    No. of displayed input channels can now be set in seal test
//                    Vhold, Vtest, Thold, Tstep can now be set for Pico auto compensation
// V4.5.1 11.06.12 .. Stimulus Editor: Recording parameters table now filled correctly
//                    when no default protocol exists. Opened and Saved protocols now selected
//                    as default protocol if none already defined .
//                    CED 1401s now support A/D and D/A buffer sizes up to 8 Msamples.
// V4.5.2 26.06.12 .. CED 1401: use1432.dll now loaded from c:\winwcp to ensure a version
                       compatible with WinWCP (with stdcalls) is used (ced1401.pas)
   V4.5.3 31.08.12 .. Fixed zero level option added to all signal display windows
                      "Incl. stim protocol in file name" option added. Creates new file every time Record is started
                      or a protocol changes and appends protocol name and sequence number to data file name.
                       New files forced by changes in recording settings are now indicated .XX.wcp sequence number
                      rather than appended pluses.
                      Empty record no longer written to file when recording sweeps are aborted by pressing Stop button
   V4.5.4 18/.09.12 .. Default command voltage scaling factor of EPC-800 now set to 0.1 (rather than 0.02)
                       Micro 1401 Mk3 now specifically identified.
  V4.5.5 27/11/12 .... CED Micro 1401 now correctly identified and A/D host buffer reduced to 32768
  V4.5.6 15/01/13 .... LeakSub.pas Display cursor update loop which occurred when more than 2 channels in data file fixed.
                       fileio.pas GetRecordHeaderOnly() Record type now checked and set to TEST if entry not a valid record type
  V4.5.7 28/01/13 .... "A/D input mode not supported by this device" error fixed for PCI-615X cards by
                       using DAQmx_Val_PseudoDiff mode only for PCI-611X cards
  V4.5.8 22/02/13 .... Digidata 1440 support updated. Max. record size increased to 8 MSample.
                       Corrupted WCP data file record analysis blocks now restored with default value (fileio.pas)
  V4.5.9 16/04/13 .... CED 1401 support: sampling interval now rounded to nearest clock tick value rather
                       than truncated to nearest lower value.
  V4.6.0 17/04/13 .... CED 1401 support: A/D and D/A now timed using faster hardware clock, allowing more precisely set
                       A/D and D/A sampling intervals
  V4.6.1 19/04/13 .... CED1401.pas ClockPeriod set to 2.5E-7 if it is found to be 0.0
  V4.6.2 07/06/13 .... No. of points averaged for From Record zero level can now be adjusted in Zero Level form.
  V4.6.3 26/08/13 ... Recording window can now be opened without an open data file.
                       RecEdit.pas: All files now backed up. Undo button now works consistently, undoing all changes
                       Various problems with X and Y shifts fixed
                       Creation time in data files now contains milliseconds
                       'winwcp.ini' and .log files now stored in Windows
                       <common documents folder>\WinWCP\ rather than program folder
                       SetCurrentDir() now used to ensure file dialog boxes open in current protocol directory
                       CheckNewDataFileNeeded() now permits 1E-4 difference in channel gains without requiring
                       a new file to be opened to allow for loss of precision when data written/read from fiel header
  V4.6.4 27.08.13 ... Recording start time now stored in WCP header and time of record acquisition display in replay.pas
  V4.6.5 27.08.13 ... Amplifiers: Dagan CA1B now reads gain telegraph correctly
  V4.6.6 20.09.13 ... Support for Heka amplifiers and Instrutech interfaces added
                      Bugs in Power 1401 support fixed. 2.5X error in A/D sampling rate fixed
                      ToHost transfers now in 64Kb blocks fixing sample scrambling for high speed/large records
                      Waveform updates now faster
  V4.6.7 23.09.13 ... Recording start time now encoded in en-GB format by GBDateToStr & GBStrToDate
  V4.6.8 25.09.13 ... .log files now created in settings folder.
  V4.6.9 05.12.13 ... Now works with CED1401-plus again (DAC transfer buffers adjusted to fit at least
                      3 in DAC buffer in 1401
                      A/D input channels can now be mapped to different physical inputs
                      for CED 1401s, Digidatas 1320 and 1440 and ITC-16 and ITC-18
                      2 Multiclamp 700 B now supported.
                      Loading/Saving of amplifier/channel settings now works correctly
   V4.7.0 06.12.13    .HoldingVoltage ActiveX command ow scaled by amplifier command voltage scale factor (autounit.pas)
   V4.7.1 17.12.13    Addition Multiclamp messages reported to log file
   V4.7.2 19.12.13    Addition Multiclamp messages reported to log file (may now recognise 2 amplifiers)
   V4.7.3 09.01.13    New version of Heka EPCDLL.DLL (support USB devices)
   V4.7.4 24.03.14    Heka EPC9/10 RS % compensation now works
                      Cslow and RS compensation turned off during auto Cfast to avoid access violations
   V4.7.5 14.04.14    FPU exceptions disabled in Tecella support to allow Triton-Plus to work
                      Padding at end of stimulus pulses reduced from 1s to 100ms to speed up repeat rate
   V4.7.6 15.05.14    Amplifier # now appended to channel name if more than one amplifier in use
   V4.7.7 25.06.14    Free run and external trigger modes now work with Heka devices
   V4.7.8 27.06.14    ITC-18 Now works correctly with sampling buffers > 50000 samples
                      Analog output buffer no longer corrupted
   V4.7.9 30.06.14    ITC-18 More bugs fixed.
   V4.8.0 23.07.14    Ampmodule.pas updated. V1.1 message received report format corrected.  No longer produces error.
   V4.8.2 15.08.14    Settings.VProtDirectory now initialised correctly with '\' at end. Protocols list now detected again
                      Support for USB-6000-6005 added
                      Gap-free ABF files now loaded as a single record
   V4.8.3 15.09.14    ABF V2.X files now imported (using abffio.dll)
                      PCI-6281 and other 18 bit interfaces now supported.
   V4.8.4 18.09.14    Current scaling factor for Axoclamp 2 current command channel now recognised currently
                      Current and Voltage command channels can now be updated by user.
   V4.8.5 15.10.14    ITC-18 ADCActive no longer set TRUE by adctomemory() in tmWaveGen mode
                      Prevents time jitter and access violations with voltage step protocols.
                      Rec.pas Stimulus protocol status now updated during sweep and shows time till next stimulus
   V4.8.6             File/Import. Blank lines in files no longer stop importing
                      Digidata 1320 D/A timing error fixed.
   V4.8.7 05.12.14    ABF2 import now works correctly (update to adcdatafile.pas)
          15.12.14    EditProtocolUnit.pas Changes to element parameters no longer lost
                      when a new element dropped on waveform palette
   V4.8.8 11.02.15    Tecella: Now tested and works correctly with Triton+
                      Export: No. of exportable channels increased to 32.
   V4.8.9 12.03.15    Invalid date error now avoided when loaded WCP data files created on systems
                      using yyyy-mm-dd date format now fixed.
   V4.9.0 20.03.15    WinWCP program version now stored in WCP header
                      Date format in WCP header now fixed at yyyy/mm/dd (does not use LOCAL settings)
          24.03.15    Dynamic clamp control panel added
                      Prefix can be added to default file name and date removed (setting in Default Output settings)
   V4.9.1 10.04.15    Recording to disk no longer defaults to From Record zero level (Rec.pas)
                      Sampling interval of ABF file imports now read correctly (ADCDataFile.pas)
// V4.9.2 22.04.15    Multiclamp 700A/B channels now correctly assigned to analog inputs when two Multiclamp 700A/Bs
//                    in use Amp #1 (lower s.n) Ch.1 1.Primary->AI0,Secondary->AI1, Ch.2 1.Primary->AI2,Secondary->AI3
//                    Amp #2 (higher s.n) Ch.1 1.Primary->AI4,Secondary->AI5, Ch.2 1.Primary->AI6,Secondary->AI7
                      CED1902u.pas: CED 1902 DC Offset now works.
   V4.9.3 05.05.15    Multiclamp 700A/B Now correctly allocates Channel 1 of second Multiclamp 700A/B as Amplifier #3
   V4.9.4 03.06.15    InputChannelSetup.pas: Users updates to channel current units now applied to both
                      VCLAMP and ICLAMP mode settings if patch clamp does not have mode switched primary/secondary channels.
   V4.9.5 08.06.15    Multiple files can now be selected for export and channels can now be selected for export formats
   V4.9.6 16.06.15    Heka EPC9: Voltage & current ADC channels can be remapped
                      Stimulus Protocols & free run record duration: No. of samples/channel is now altered when sampling interval changed
                      to maintain fixed duration and vice versa
   V4.9.7 18.06.15    DCLAMP: Negative steps of activation V1/2 now work
   V4.9.8 10.07.15    Support for Digidata 1550 and 1550A added
                      Scope displays now use min/max envelope filter to greatly improve
                      display performance for sweeps with large numbers of samples/record
   V4.9.9 13.07.15    ExportUnit: Long file names no longer corrupted in file name list by
                      being split accross line.
   V5.0.0 13.07.15    Axdd1440.dll updated to V2.0.2.1 to work under 64 bit Windows.
                      DD1550.DLL compiled with MT rather than MT DLL run-time library
                      to allow it to load under 64 bit windows.
   V5.0.1 13.07.15    Digidata 1550: 64/32 bit version of wdapi1140.dll created when O/S detected
   V5.0.2 27.07.15    Digidata 1440: ADC offset calibration subtracted from inputs
   V5.0.3 28.07.15    Stimulus protocols: Analog & digital pulse trains with frequency incrementing added
   V5.0.4 04.08.15    Records now plotted correctly again on printer and on clipboard (fixes bug introduces in V4.9.8).
                      Superimposition of traces now possible in waveform measurement window.
   V5.0.5 10.08.15    Records with large numbers of points now correctly plotted using YMin-YMax compression
                      (rather than just Ymin) (scopedisplay.pas).
   V5.0.6 12.08.15    dd1440.pas 64/32 bit version of wdapi1140.dll created when O/S detected
                      Now correctly loads dd1440.dll
   V5.0.7 14.08.16    export.pas: Export of average, leak subtracted and driving function now works again
                      rec.pas: Large spurious values appearing in first samples of leak subtracted records fixed
   V5.0.8 21.08.15    dd1400,dd1550,dd1550A.pas: DLL files now acquired from PCLAMP or AXOCLAMP folders and copied
                      to settings folder C:\Users\Public\Documents\SESLABIO
                      Units of voltage channel of OptoPatch amplifier now correct.
                      Record: Display no longer erased when changing between linked protocols as
                      as no. channels/samples does not change.
   V5.0.9 02.10.15    DCLAMP updated: time constant and steady-state activation v1/2s can be incremented
                      individually. Incrementing after protocol added.
                      Zap button added to seal test.
   V5.1.0 14.10.15    Axoclamp 900A code updated (still untested with actual patch clamp)
                      scopedisplay: Data exported to clipboard now min/max compressed to less than 20000 points.
                      CurveFit: Residual plot now kept within min-max ADCValue limits to avoid numerical roll-over of data points
   V5.1.1 18.11.15    Record: Add Marker Add button removed. Marker text added automatically
                      QuantFrm: Now opens top/left
                      USB-6002/3 P1.0->PFI0+PFI1 now used as trigger line for A/D and D/A start synchronisation
                      Heka EPC9-USB lab. interface option. Current gain scale factor can be corrected
                      using 'HekaGCF.txt' correction factor file.
                      Heka EPC9/10 Now correctly maps gain list to gain excluding skipped index numbers.
                      RecEdit.pas: Repeated display updated problem when multiple channels in file fixed
                      Replay.pas and others: T???Cursors.Base remove since redundant
  =======================================================================}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, Global, FileIo, Shared, Replay,
  Measure, Average, PrintRec, Rec, CurvFit, SimSyn,SimHH, SealTest,
  LeakSub, About, RecEdit,Log, QAnal, DrvFun, defset,
  SESLabIO, ced1902u, ComCtrls, ADCDataFile, strutils, math, StdCtrls,FileCtrl,
  UITypes, Vcl.HtmlHelpViewer, shlobj, ioutils ;

type
  TMain = class(TForm)
    StatusBar: TStatusBar;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    mnNew: TMenuItem;
    mnOpen: TMenuItem;
    mnClose: TMenuItem;
    mnPrint: TMenuItem;
    mnPrintSetup: TMenuItem;
    mnImport: TMenuItem;
    mnExport: TMenuItem;
    mnInterleave: TMenuItem;
    mnAppend: TMenuItem;
    InspectLogFile: TMenuItem;
    mnExit: TMenuItem;
    mnRecentFileSeparator: TMenuItem;
    mnRecentFile0: TMenuItem;
    mnRecentFile1: TMenuItem;
    mnRecentFile2: TMenuItem;
    mnRecentFile3: TMenuItem;
    Edit: TMenuItem;
    mnCopyData: TMenuItem;
    mnCopyImage: TMenuItem;
    N1: TMenuItem;
    CopyRecord: TMenuItem;
    InsertRecord: TMenuItem;
    DeleteRecord: TMenuItem;
    AppendRecord: TMenuItem;
    DeleteRejected: TMenuItem;
    View: TMenuItem;
    mnZoomOutAll: TMenuItem;
    mnStoreTraces: TMenuItem;
    mnDisplayGrid: TMenuItem;
    N2: TMenuItem;
    mnShowRaw: TMenuItem;
    mnShowAveraged: TMenuItem;
    mnShowLeakSubtracted: TMenuItem;
    mnShowDrivingFunction: TMenuItem;
    Record1: TMenuItem;
    mnRecordToDisk: TMenuItem;
    mnSealTest: TMenuItem;
    Setup: TMenuItem;
    Recording1: TMenuItem;
    WaveformGenerator: TMenuItem;
    mnCED1902: TMenuItem;
    mnVP500: TMenuItem;
    mnDefaultSettings: TMenuItem;
    Analysis: TMenuItem;
    WaveformMeasurements: TMenuItem;
    SignalAverager: TMenuItem;
    LeakCurrentSubtraction: TMenuItem;
    CurveFitting: TMenuItem;
    mnPwrSpec: TMenuItem;
    mnQuantalContent: TMenuItem;
    mnDrivingFunction: TMenuItem;
    EditRecord: TMenuItem;
    Simulations1: TMenuItem;
    Synapse: TMenuItem;
    HHSimulation: TMenuItem;
    mnSimMEPSC: TMenuItem;
    Windows: TMenuItem;
    mnDummy: TMenuItem;
    Help1: TMenuItem;
    Contents: TMenuItem;
    mnShowHints: TMenuItem;
    About: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    ImportFile: TADCDataFile;
    mnFileProps: TMenuItem;
    mnTriton: TMenuItem;
    mnShowAllChannels: TMenuItem;
    mnLaboratorInterface: TMenuItem;
    SESLabIO: TSESLabIO;
    mnEPC9Panel: TMenuItem;
    mnResetMulticlamp: TMenuItem;
    mnDClamp: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure mnOpenClick(Sender: TObject);
    procedure mnExitClick(Sender: TObject);
    procedure Recording1Click(Sender: TObject);
    procedure mnNewClick(Sender: TObject);
    procedure mnCloseClick(Sender: TObject);
    procedure mnPrintSetupClick(Sender: TObject);
    procedure mnImportClick(Sender: TObject);
    procedure mnExportClick(Sender: TObject);
    procedure mnInterleaveClick(Sender: TObject);
    procedure mnAppendClick(Sender: TObject);
    procedure mnPrintClick(Sender: TObject);
    procedure InspectLogFileClick(Sender: TObject);
    procedure mnCopyDataClick(Sender: TObject);
    procedure mnCopyImageClick(Sender: TObject);
    procedure CopyRecordClick(Sender: TObject);
    procedure InsertRecordClick(Sender: TObject);
    procedure DeleteRecordClick(Sender: TObject);
    procedure AppendRecordClick(Sender: TObject);
    procedure DeleteRejectedClick(Sender: TObject);
    procedure mnZoomOutAllClick(Sender: TObject);
    procedure mnStoreTracesClick(Sender: TObject);
    procedure mnDisplayGridClick(Sender: TObject);
    procedure mnShowRawClick(Sender: TObject);
    procedure mnShowAveragedClick(Sender: TObject);
    procedure mnShowLeakSubtractedClick(Sender: TObject);
    procedure mnShowDrivingFunctionClick(Sender: TObject);
    procedure WaveformMeasurementsClick(Sender: TObject);
    procedure SignalAveragerClick(Sender: TObject);
    procedure LeakCurrentSubtractionClick(Sender: TObject);
    procedure CurveFittingClick(Sender: TObject);
    procedure mnPwrSpecClick(Sender: TObject);
    procedure mnQuantalContentClick(Sender: TObject);
    procedure mnDrivingFunctionClick(Sender: TObject);
    procedure EditRecordClick(Sender: TObject);
    procedure mnRecordToDiskClick(Sender: TObject);
    procedure mnSealTestClick(Sender: TObject);
    procedure WaveformGeneratorClick(Sender: TObject);
    procedure mnCED1902Click(Sender: TObject);
    procedure mnVP500Click(Sender: TObject);
    procedure mnDefaultSettingsClick(Sender: TObject);
    procedure SynapseClick(Sender: TObject);
    procedure HHSimulationClick(Sender: TObject);
    procedure mnSimMEPSCClick(Sender: TObject);
    procedure AboutClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ContentsClick(Sender: TObject);
    procedure mnShowHintsClick(Sender: TObject);
    procedure mnRecentFile0Click(Sender: TObject);
    procedure mnShow0Click(Sender: TObject);
    procedure mnZoomInCh0Click(Sender: TObject);
    procedure mnZoomOutCh0Click(Sender: TObject);
    procedure ViewClick(Sender: TObject);
    procedure mnFilePropsClick(Sender: TObject);
    procedure EditClick(Sender: TObject);
    procedure File1Click(Sender: TObject);
    procedure mnTritonClick(Sender: TObject);
    procedure SetupClick(Sender: TObject);
    procedure mnShowAllChannelsClick(Sender: TObject);
    procedure mnLaboratorInterfaceClick(Sender: TObject);
    procedure mnEPC9PanelClick(Sender: TObject);
    procedure mnResetMulticlampClick(Sender: TObject);
    procedure mnDClampClick(Sender: TObject);
  private

    procedure UpdateFileHeaderBlocks ;


    procedure SetRecentFileItem( MenuItem : TMenuItem ; FileName : string ) ;
    function ImportFromDataFile : Boolean ;

    procedure DefaultHandler( Var Message ) ; override ;

    procedure UpdateDisplays ;


  public
    { Public declarations }
    SettingsDirectory : String ;  // Settings folder
    SettingsFileName : String ;   // Settings file name
    LogFileName : string ;        // Activity log file name

   // Cell parameters
   RSeal : Single ; // Seal Resistance (Ohms)
   Gm : Single ;    // Cell membrane conductance (S)
   Ga : Single ;    // Pipette access conductance (S)
   Cm : Single ;    // Cell capacity (F)
   Vm : Single ;    // Cell membrane voltage (V)
   Im : Single ;    // Cell membrane current (A)

   procedure LoadDataFiles( FileName : string ) ;
   procedure NewFileUpdate ;
   function CreateIndexedFileName( FileName : String ) : String ;
    procedure SetMenus ;
    procedure CloseFormsAndDataFile ;
    procedure CloseAllDataFiles ;
    function CreateNewDataFile(
             FileName : String
             ) : Boolean ;
    function OpenAssociateFile( var FileHeader : TFileHeader ;
                                const FileName : string ;
                                const FileExtension : string ) : boolean ;

    procedure ShowChannel( Chan : Integer ; MenuItem : TMenuItem ) ;
    procedure UpdateMDIWindows ;
    function UpdateCaption( var FH : TFileHeader ; Title : string ) : string ;
    procedure UpdateChannelScalingFactors(var RH : TRecHeader ) ;
    function FormExists( FormName : String ) : Boolean ;
    procedure UpdateRecentFilesList ;

    function GetSpecialFolder(const ASpecialFolderID: Integer): string;
    function DateToStr( DateTime : TDateTime ) : String ;
    function StrToDate( DateTime : String ) : TDateTime ;

    end;

var
  Main: TMain;

implementation

{$R *.dfm}

uses Pwrspec, SimMEPSC, AmpModule, maths , VP500Panel,
  ImportASCIIUnit, ImportRawUnit , exportUnit, Convert , FilePropsUnit,
  RecPlotUnit, TritonPanelUnit , EditProtocolUnit, LabInterfaceSetup,
  InputChannelSetup, EPC9PanelUnit , DCLAMPUnit;

var
   WCPClipboardFileName : string ;

procedure TMain.DefaultHandler( Var Message ) ;
// ---------------
// Message handler
// ---------------
begin
    Inherited DefaultHandler(Message) ;
    end ;

procedure TMain.FormShow(Sender: TObject);
{ ---------------------------------------------------------------
  Initialize global program settings and load last data file used
  ---------------------------------------------------------------}
var
   ch,i : Integer ;
   FileName : String ;
begin

      Top := 20 ;
      Left := 20 ;
      Width := Screen.Width - Left - 20 ;
      Height := Screen.Height - Top - 50 ;

      ProgVersion := 'V5.1.1';
      Caption := 'WinWCP : Strathclyde Electrophysiology Software ' + ProgVersion ;

      { Get directory which contains WinWCP program }
      Settings.ProgDirectory := ExtractFilePath(ParamStr(0)) ;

     // Create settings directory
     SettingsDirectory := GetSpecialFolder(CSIDL_COMMON_DOCUMENTS) + '\WinWCP\';
     if not SysUtils.DirectoryExists(SettingsDirectory) then begin
        if SysUtils.ForceDirectories(SettingsDirectory) then
           WriteToLogFile( 'Settings folder ' + SettingsDirectory + ' created.')
        else WriteToLogFile( 'Unable to create settings folder' + SettingsDirectory) ;
        end ;
     SettingsFileName := SettingsDirectory + 'winwcp.ini' ;

     { Open log file (contains log of program activity) }
     OpenLogFile ;
     WriteToLogFile( 'WinWCP Started' ) ;

     // Stimulus protocols folder
     Settings.VProtDirectory := GetSpecialFolder(CSIDL_COMMON_DOCUMENTS) + '\WinWCP\Vprot\';
      if not SysUtils.DirectoryExists(Settings.VProtDirectory) then begin
         if SysUtils.ForceDirectories(Settings.VProtDirectory) then
            WriteToLogFile( 'Protocols folder ' + Settings.VProtDirectory + ' created.')
         else WriteToLogFile( 'Unable to create protocols folder' + Settings.VProtDirectory) ;
         end ;

      // Create default data directory (in My Documents)
      Settings.DataDirectory := GetSpecialFolder(CSIDL_PERSONAL) + '\WinWCP Data\';
      if not SysUtils.DirectoryExists(Settings.DataDirectory) then begin
         if SysUtils.ForceDirectories(Settings.DataDirectory) then
            WriteToLogFile( 'Data folder ' + Settings.DataDirectory + ' created.')
         else WriteToLogFile( 'Unable to create data folder' + Settings.DataDirectory) ;
         end ;

      Application.HelpFile := Settings.ProgDirectory + 'WinWCP.chm';

      { Create clipboard file name for Copy/Insert of records }
      WCPClipboardFileName := TPath.GetTempPath + 'WCPClipboardFile.tmp' ;
      { Delete any existing clipboard files }
      if FileExists(WCPClipboardFileName) then DeleteFile (PChar(WCPClipboardFileName)) ;

      { Create default set of record types }
      RecordTypes := TStringList.Create ;
      RecordTypes.Add( 'ALL' ) ;
      RecordTypes.Add( 'EVOK' ) ;
      RecordTypes.Add( 'MINI' ) ;
      RecordTypes.Add( 'FAIL' ) ;
      RecordTypes.Add( 'TEST' ) ;
      RecordTypes.Add( 'LEAK' ) ;
      RecordTypes.Add( 'TYP1' ) ;
      RecordTypes.Add( 'TYP2' ) ;
      RecordTypes.Add( 'TYP3' ) ;
      RecordTypes.Add( 'TYP4' ) ;

      { Create channel names list }
      ChannelNames := TStringList.Create ;

     { Default values for channels }

     { Minimum/maximum of binary A/D and D/A data samples }
     RawFH.MinADCValue := -2048 ;
     RawFH.MaxADCValue := 2047 ;
     MinDACValue := -2048 ;
     MaxDACVAlue := 2047 ;

     RawFH.CreationTime := '' ;
     RawFH.NumChannels := 1 ;
     RawFH.NumSamples := 512 ;
     RawFH.NumAnalysisBytesPerRecord := 512 ;
     RawFH.NumDataBytesPerRecord := RawFH.NumSamples*RawFH.NumChannels*2 ;
     RawFH.NumBytesPerRecord := RawFH.NumDataBytesPerRecord
                                + RawFH.NumAnalysisBytesPerRecord ;
     RawFH.NumBytesInHeader := MaxBytesInFileHeader ;
     RawFH.ADCVoltageRange := 5. ;
     RawFH.NumZeroAvg := 20  ;
     RawFH.dt := 0.001 ;
     RawFH.Version := 8.0 ;
     RawFH.ProgVersion := ProgVersion ;
     RawFH.NumPointsAveragedAtPeak := 1 ;

     for ch := 0 to WCPMaxChannels-1 do begin
         Channel[ch].TimeZero := 1. ;
         Channel[ch].ADCScale := 1. ;
         Channel[ch].CursorIndex := 128 ;
         Channel[ch].ZeroIndex := 0 ;
         Channel[ch].Cursor0 := 0 ;
         Channel[ch].Cursor1 := RawFH.NumSamples div 2 ;
         { Zero levels fixed at hardware zero }
         Channel[ch].ADCZero := 0 ;
         Channel[ch].ADCZeroAt := -1 ;
         Channel[ch].ADCCalibrationFactor := 0.001 ;
         Channel[ch].ADCAmplifierGain := 1. ;
         Channel[ch].ADCUnits := 'mV' ;
         Channel[ch].ADCName := format('Ch.%d',[ch]);
         Channel[ch].color:= clBlue ;
         Channel[ch].xMin := 0. ;
         Channel[ch].xMax := RawfH.NumSamples-1 ;
         Channel[ch].yMin := RawfH.MinADCValue ;
         Channel[ch].yMax := RawfH.MaxADCValue ;
         Channel[ch].InUse := True ;
         end ;

     { Initialise to no laboratory interface }
     Settings.LaboratoryInterface := 0 ;
     Settings.DeviceNumber := 1 ;

     Settings.NumChannels := 1 ;
     Settings.NumSamples := 4096 ;
     Settings.RecordDuration := 1.0 ;

     Settings.RecordingMode := 0 ;
     Settings.EventDetector.Channel := 0 ;
     Settings.EventDetector.Threshold := 0.1 ;
     Settings.EventDetector.PreTrigger := 0.1 ;
     Settings.ExternalTriggerActiveHigh := False ;

     Settings.AutoErase := True ;
     Settings.DisplayGrid := True ;
     Settings.ResetDisplayMagnification := True ;

     mnDisplayGrid.Checked := Settings.DisplayGrid ;

     Settings.Colors.Cursors := clBlue ;
     Settings.Colors.Grid := clAqua ;
     Settings.FixedZeroLevels := False ;

     Settings.NumRecordsRequired := 1 ;
     Settings.CutOffFrequency := 0. ;
     { Minimum interval for updating D/A converters when
       generating command voltage waveforms }
     Settings.MinDACInterval := 0.0001 ;

     Settings.TUnits := 'ms' ;
     Settings.TScale := SecsToMs ;
     Settings.TUnScale := MsToSecs ;

     { Name of command voltage protocol file in current use }
     Settings.VProgramFileName := '' ;
     Settings.VProgramFileName := '' ;

     { Divide factor that the patch/voltage clamp applies to its
       command voltage input. The D/A output voltage is thus scaled up
       by this factor }

     Settings.DACInvertTriggerLevel := False ;
     Settings.DigitalPort.Value := 0 ;
     Settings.UpdateOutputs := True ;

     { Default settings for seal test pulse }
     Settings.SealTest.Use := 1 ;
     Settings.SealTest.PulseHeight1 := 0.01 ;
     Settings.SealTest.HoldingVoltage1 := 0. ;
     Settings.SealTest.PulseHeight2 := 0.01 ;
     Settings.SealTest.HoldingVoltage2 := 0. ;
     Settings.SealTest.PulseHeight3 := 0.0 ;
     Settings.SealTest.HoldingVoltage3 := 0. ;

     Settings.SealTest.PulseWidth:= 0.03 ;
     Settings.SealTest.CurrentChannel := 0 ;
     Settings.SealTest.VoltageChannel := 1 ;
     Settings.SealTest.AutoScale := True ;
     Settings.SealTest.DisplayScale := 1 ;
     Settings.SealTest.SmoothingFactor := 1.0 ;

     Settings.SealTest.ZapAmplitude := 0.2 ;
     Settings.SealTest.ZapDuration := 0.1 ;
     
     { Set flag indicating this is the first sweep, to force an autoscale }
     Settings.SealTest.FirstSweep := True ;

     Settings.Plot.TopMargin := 25.0 ;
     Settings.Plot.LeftMargin := 25.0 ;
     Settings.Plot.BottomMargin := 5.0 ;
     Settings.Plot.RightMargin := 25.0;
     Settings.Plot.FontName := 'Arial' ;
     Settings.Plot.FontSize := 12 ;
     Settings.Plot.LineThickness := 2 ;
     Settings.Plot.MarkerSize := 5 ;
     Settings.Plot.ShowLines := True ;
     Settings.Plot.ShowMarkers := True ;
     Settings.Plot.MetafileWidth := 600 ;
     Settings.Plot.MetafileHeight := 600 ;

     { Bitmap size for images copied to clipboard }
     Settings.BitmapWidth := 600 ;
     Settings.BitmapHeight := 500 ;

     // Voltage clamp simulation  settings
     Settings.VClampSim.NumSteps := 16 ;
     Settings.VClampSim.GMax :=20E-9 ;
     Settings.VClampSim.GLeak := 1E-9 ;
     Settings.VClampSim.GSeries := 200E-9 ;
     Settings.VClampSim.Cm := 30E-12 ;
     Settings.VClampSim.VRev := -100E-3 ;
     Settings.VClampSim.VHold := -90E-3 ;
     Settings.VClampSim.VStep := 10E-3 ;

     { Activation gate (m) parameters }
     Settings.VClampSim.m.VHalf := -1E-3 ;
     Settings.VClampSim.m.VSlope := -11E-3 ;
     Settings.VClampSim.m.TauMin := 1.5E-3 ;
     Settings.VClampSim.m.TauMax := 3.5E-3 ;
     Settings.VClampSim.m.TauVHalf := 0.0 ;
     Settings.VClampSim.m.TauVslope := 30E-3 ;
     Settings.VClampSim.m.P := 1 ;

     { Inactivation gate (h) parameters }
     Settings.VClampSim.UseInactivation := false ;

     Settings.VClampSim.h.VHalf := -45E-3 ;
     Settings.VClampSim.h.VSlope := 11.5E-3 ;
     Settings.VClampSim.h.TauMin := 14E-3 ;
     Settings.VClampSim.h.TauMax := 482.6E-3 ;
     Settings.VClampSim.h.TauVHalf := -52.5E-3 ;
     Settings.VClampSim.h.TauVslope := 15E-3 ;
     Settings.VClampSim.h.P := 1. ;

     // Synaptic current simulation settings
     Settings.SynapseSim.NumRecords := 100 ;
     Settings.SynapseSim.RecordDuration := 1E-1 ;
     Settings.SynapseSim.TauRise := 2E-4 ;
     Settings.SynapseSim.Tau1 := 1E-2 ;
     Settings.SynapseSim.Latency := 0.0 ;
     Settings.SynapseSim.Tau2 := 5E-2 ;
     Settings.SynapseSim.A2Fraction := 0.1 ;
     Settings.SynapseSim.QuantumAmplitude := 1.0 ;
     Settings.SynapseSim.QuantumStDev := 0.0 ;
     Settings.SynapseSim.n := 1.0 ;
     Settings.SynapseSim.p := 1.0 ;
     Settings.SynapseSim.NoiseRMS := 0.1 ;
     Settings.SynapseSim.DisplayRange := 10.0 ;
     Settings.SynapseSim.VRest := -90.0 ;
     Settings.SynapseSim.DoubleExponentialDecay := False ;

     // MEPSC simulation parameters
     Settings.MEPSCSim.NumRecords := 100 ;
     Settings.MEPSCSim.RecordDuration := 0.1 ;
     Settings.MEPSCSim.UnitCurrent := 1.0 ;
     Settings.MEPSCSim.TransmitterDecayTime := 100E-6 ;

     Settings.MEPSCSim.BindingRate :=  2E5 ;
     Settings.MEPSCSim.OpenRate := 1E4 ;
     Settings.MEPSCSim.CloseRate :=  1E3 ;
     Settings.MEPSCSim.UnbindRate :=  1E3 ;
     Settings.MEPSCSim.BlockRate := 0.0 ;
     Settings.MEPSCSim.UnBlockRate := 0.0 ;

     Settings.MEPSCSim.NoiseRMS := 0. ;
     Settings.MEPSCSim.LPFilter := 1000.0 ;
     Settings.MEPSCSim.LPFilterInUse := False ;
     Settings.MEPSCSim.Drift := 0.0 ;

     { Time taken to write one sector to hard disk }
     { Zero forces a write test to be made within wavgen module }
     //Settings.SectorWriteTime := 0. ;

     Settings.ProtocolListFileName := '' ;

     Settings.FileNameIncludeDate := True ;  // Include date in auto-created file names
     Settings.FileNamePrefix := '' ;          // Add prefix to name

     { Settings for record hard copy plots }
     Settings.TimeBarValue := -1. ;
     for ch := 0 to WCPMaxChannels-1 do Settings.BarValue[ch] := -1. ;
     Settings.ShowLabels := True ;
     Settings.ShowZeroLevels := True ;

     Settings.DifferentiationMode := 0 ;
     Settings.LockChannelCursors := True ;

     Settings.WavGenNoDisplay := False ; {Display waveform check box settings
                                          for Waveform Generator }

     // On-line analysis cursor positions
     Settings.OpenNewFileOnRecord := False ;
     Settings.RecCursor0 := -1 ;
     Settings.RecCursor1 := -1 ;
     Settings.RecCursor2 := -1 ;
     Settings.RecCursor3 := -1 ;
     Settings.RecCursor4 := -1 ;

     { Set the file names and handles for all header blocks to null }
     RawFH.FileHandle := -1 ;
     RawFH.FileName := '' ;
     AvgFH.FileHandle := -1 ;
     AvgFH.FileName := '' ;
     LeakFH.FileHandle := -1 ;
     LeakFH.FileName := '' ;
     DrvFH.FileHandle := -1 ;
     DrvFH.FileName := '' ;
     RawFH.RecordingStartTime := '' ;

     RSeal := 1E9 ;
     Ga := 1E-8 ;
     Gm := 1E-9 ;
     Cm := 3E-11 ;
     Vm := 0.0 ;
     Im := 0.0 ;

     mnShowAveraged.visible := false ;
     mnShowLeakSubtracted.visible := false ;
     mnShowRaw.visible := False ;

     SetMenus ;

     { Load initialization file to get name of last data file used }

     if not Settings.NoINIFile then LoadInitializationFile( SettingsFileName ) ;

     mnDisplayGrid.Checked := Settings.DisplayGrid ;
     mnStoreTraces.Checked := not Settings.AutoErase ;

     for ch := 0 to RawFH.NumChannels-1 do begin
         Channel[ch].xMin := 0. ;
         Channel[ch].xMax := RawfH.NumSamples-1 ;
         Channel[ch].Cursor1 := RawFH.NumSamples div 2 ;
         end ;

     { Enable Windows menu to show active MDI windows }
     WindowMenu := Windows ;

     RawfH.MinADCValue := SESLabIO.ADCMinValue ;
     RawFH.MaxADCValue := SESLabIO.ADCMaxValue ;

     { Add names of recently accessed data files to Files menu }
     mnRecentFileSeparator.Visible := False ;
     SetRecentFileItem( mnRecentFile0, Settings.RecentFiles[0] ) ;
     SetRecentFileItem( mnRecentFile1, Settings.RecentFiles[1] ) ;
     SetRecentFileItem( mnRecentFile2, Settings.RecentFiles[2] ) ;
     SetRecentFileItem( mnRecentFile3, Settings.RecentFiles[3] ) ;

     { Open a data file if one has been supplied in parameter string }
     FileName :=  '' ;
     for i := 1 to ParamCount do begin
         if i > 1 then FileName := FileName + ' ' ;
         FileName := FileName + ParamStr(i) ;
         end ;

     // Initialise channel display settings to minimum magnification
     for ch := 0 to WCPMaxChannels-1 do begin
         Channel[ch].Cursor0 := 0 ;
         Channel[ch].Cursor1 := RawFH.NumSamples div 2 ;
         Channel[ch].xMin := 0. ;
         Channel[ch].xMax := RawfH.NumSamples-1 ;
         Channel[ch].yMin := SESLabIO.ADCMinValue ;
         Channel[ch].yMax := SESLabIO.ADCMaxValue ;
//         RecChannel[ch].xMin := 0. ;
//         RecChannel[ch].xMax := Settings.NumSamples-1 ;
//         RecChannel[ch].yMin := SESLabIO.ADCMinValue ;
//         RecChannel[ch].yMax := SESLabIO.ADCMaxValue ;
         end ;

     if ANSIContainsText( ExtractFileExt(FileName),'.wcp') then begin
        if FileExists(FileName) then begin
           if (FileGetAttr(FileName) AND faReadOnly) = 0 then LoadDataFiles(FileName)
           else ShowMessage( FileName + ' is READ-ONLY. Unable to open!') ;

           end ;
        end ;

     end;


procedure TMain.SetRecentFileItem(
          MenuItem : TMenuItem ;    { Menu item to be updated }
          FileName : string         { Name of data file to be added }
          ) ;
{ ------------------------------------------------------
  Add the name of a recently used data file to File menu
  ------------------------------------------------------ }
begin
     if FileName <> '' then begin
        mnRecentFileSeparator.Visible := True ;
        MenuItem.Caption := FileName ;
        MenuItem.Visible := True ;
        end
     Else MenuItem.Visible := False ;
     end ;


procedure TMain.mnOpenClick(Sender: TObject);
//{ -Menu item --------------------
//  Open an existing .wcp data file
//  -------------------------------}
begin

     OpenDialog.options := [ofPathMustExist] ;
     OpenDialog.DefaultExt := 'WCP' ;
     if Settings.DataDirectory <> '' then
        SetCurrentDir(Settings.DataDirectory) ;
        OpenDialog.InitialDir := Settings.DataDirectory ;
     OpenDialog.Filter := ' WCP Files (*.WCP)|*.WCP';
     OpenDialog.Title := 'Open File ' ;

     if OpenDialog.execute then begin
        // Load selected file
        if (FileGetAttr(OpenDialog.FileName) AND faReadOnly) = 0 then begin
            LoadDataFiles( OpenDialog.FileName ) ;
            // Update list of recently used files
            UpdateRecentFilesList ;
            WriteToLogFile( 'Data file: ' + OpenDialog.FileName + ' open.' ) ;
            end
         else ShowMessage( OpenDialog.FileName + ' is READ-ONLY. Unable to open!') ;
         end ;

     end;


procedure TMain.LoadDataFiles( FileName : string ) ;
{ -------------------------------------------------
  Load .WCP and any associated .AVG,.SUB data files
  -------------------------------------------------}
var
   ch : Integer ;
begin

     { Close existing data file(s) }
     CloseAllDataFiles ;

     { Open original 'raw' data file }
     if not OpenAssociateFile(RawFH,FileName,'.wcp') then Exit ;

     // Select raw for display
     FH := RawFH ;

     Main.Caption := 'WinWCP : ' + RawFH.FileName ;
     { Save data directory }
     Settings.DataDirectory := ExtractFilePath( RawFH.FileName ) ;

     { Open averages file (if one exists)}
     OpenAssociateFile(AvgFH,FileName,'.avg') ;

     {Open a leak subtracted file (if one exists) }
     OpenAssociateFile(LeakFH,FileName,'.sub') ;

     { Open a driving function file (if one exists) }
     OpenAssociateFile(DrvFH,FileName,'.dfn') ;

     { Make sure all channels are visible }
     for ch := 0 to RawFH.NumChannels-1 do Channel[ch].InUse := True ;

     { Open view form if one doesn't exist }
//     if (RawfH.NumRecords > 0) and not FormExists('ReplayFrm') then
//        ReplayFrm := TReplayFrm.Create(Self) ;

     { Inform all open forms that data file(s) have changed }
     NewFileUpdate ;

     { Set display magnification to minimum }
     if fH.NumRecords > 0 then begin
        //if OldNumSamples <> RawFH.NumSamples then mnZoomOut.Click ;
        mnShowRaw.Click ;
        end ;

     SetMenus ;

     end ;


procedure TMain.ShowChannel(
          Chan : Integer ;
          MenuItem : TMenuItem
          ) ;
{ --------------------------------------
  Make Channel item in View menu visible
  -------------------------------------- }
begin
     if Chan < RawFH.NumChannels then begin
        MenuItem.Visible := True ;
        MenuItem.Checked := Channel[Chan].InUse ;
        MenuItem.Caption := format(' Ch.%d %s',[Chan,Channel[Chan].ADCName]) ;
        end
     else  MenuItem.Visible := False ;
     end ;


function TMain.OpenAssociateFile(
         var FileHeader : TFileHeader ;  { File header of this file }
         const FileName : string ;       { Name of data file }
         const FileExtension : string    { Extension to be added }
         ) : boolean ;                   { =True if file opened succcessfully }
{ -------------------------------------
  Open an associated file (if it exists)
  -------------------------------------}
var
   OK : Boolean ;
begin

     Result := False ;

     { Close existing file }
     FileCloseSafe( FileHeader.FileHandle ) ;

     { Check that file exists }
     FileHeader.FileName := ChangeFileExt( FileName, FileExtension ) ;
     if not FileExists( FileHeader.FileName ) then Exit ;

     { Open file }
     FileHeader.FileHandle := FileOpen( FileHeader.FileName, fmOpenReadWrite or fmShareDenyWrite) ;
     if FileHeader.FileHandle < 0 then Exit ;

     { Load the data file details }
     GetHeader( FileHeader ) ;

     { If it is an old file format convert it to new format }

     if (FileHeader.NumAnalysisBytesPerRecord < 1024 ) or
        (FileHeader.NumBytesInHeader < 1024) then begin
        // Convert pre WCP V6.2 to V9 format
        FileCloseSafe( FileHeader.FileHandle ) ;
        OK :=ConvertWCPPreV62toV9(FileHeader.FileName) ;
        if OK then begin
           FileHeader.FileHandle := FileOpen(FileHeader.FileName,fmOpenReadWrite or fmShareDenyWrite) ;
           GetHeader( FileHeader ) ;
           end
        else Exit ;
        end
     else if FileHeader.Version < 9.0 then begin
        // Convert WCP V6.2 - V8 to V9 format
        FileCloseSafe( FileHeader.FileHandle ) ;
        OK := ConvertWCPV8toV9(FileHeader.FileName) ;
        if OK then begin
           FileHeader.FileHandle := FileOpen(FileHeader.FileName,fmOpenReadWrite or fmShareDenyWrite) ;
           GetHeader( FileHeader ) ;
           end
        else Exit ;
        end ;

     Result := True ;

     end ;


procedure TMain.mnEPC9PanelClick(Sender: TObject);
// -------------------------------
//  Display EPC9/10 control window
// ------------------------------- }
begin

     if FormExists( 'EPC9PanelFrm' ) then begin
        // Make form visible, active and on top
        if EPC9PanelFrm.WindowState = wsMinimized then EPC9PanelFrm.WindowState := wsNormal ;
        EPC9PanelFrm.BringToFront ;
        EPC9PanelFrm.SetFocus ;
        end
     else begin
        EPC9PanelFrm := TEPC9PanelFrm.Create(Self) ;
        EPC9PanelFrm.Top := 10 ;
        EPC9PanelFrm.Left := Width - EPC9PanelFrm.Width - 50 ;
        end ;

     end;

procedure TMain.mnExitClick(Sender: TObject);
{ --------------------------------
  Save state and terminate program
  -------------------------------- }
begin
     close ;
     end;


procedure TMain.Recording1Click(Sender: TObject);
{ - Menu Item -------------------------------
  Record parameters set-up dialog (setup.pas)
  -------------------------------------------}
begin
     if FormExists( 'SetUpDlg' ) then begin
        // Make form visible, active and on top
        if InputChannelSetupFrm.WindowState = wsMinimized then InputChannelSetupFrm.WindowState := wsNormal ;
        InputChannelSetupFrm.BringToFront ;
        InputChannelSetupFrm.SetFocus ;
        end
     else begin
        InputChannelSetupFrm := TInputChannelSetupFrm.Create(Self) ;
        InputChannelSetupFrm.Top := 10 ;
        InputChannelSetupFrm.Left := 10 ;
        end ;

     end;


procedure TMain.WaveformMeasurementsClick(Sender: TObject);
{ - Menu Item ------------------------------------
  Create waveform measurements module (measure.pas)
  ------------------------------------------------}
begin
     if FormExists( 'MeasureFrm' ) then begin
        // Make form visible, active and on top
        if MeasureFrm.WindowState = wsMinimized then MeasureFrm.WindowState := wsNormal ;
        MeasureFrm.BringToFront ;
        MeasureFrm.SetFocus ;
        end
     else begin
        MeasureFrm := TMeasureFrm.Create(Self) ;
        end ;
     end;


procedure TMain.CurveFittingClick(Sender: TObject);
{ - Menu Item -------------------------------
  Run waveform curve fitting module (fit.pas)
  -------------------------------------------}
begin

     if FormExists( 'FitFrm' ) then begin
        // Make form visible, active and on top
        if FitFrm.WindowState = wsMinimized then FitFrm.WindowState := wsNormal ;
        FitFrm.BringToFront ;
        FitFrm.SetFocus ;
        end
     else begin
        FitFrm := TFitFrm.Create(Self) ;
        end ;

     end;


procedure TMain.SignalAveragerClick(Sender: TObject);
{ - Menu Item ----------------------------
  Run signal averager module (average.pas)
  ----------------------------------------}
begin

     if FormExists( 'AvgFrm' ) then begin
        // Make form visible, active and on top
        if AvgFrm.WindowState = wsMinimized then AvgFrm.WindowState := wsNormal ;
        AvgFrm.BringToFront ;
        AvgFrm.SetFocus ;
        end
     else begin
        AvgFrm := TAvgFrm.Create(Self) ;
        AvgFrm.Top := 25 ;
        AvgFrm.Left := 25 ;
        end ;

     end;


procedure TMain.mnShowRawClick(Sender: TObject);
{ - Menu Item -------------------------
  Select original data file for viewing
  -------------------------------------}
begin

     if RawFH.NumRecords <= 0 then Exit ;
     
     fH := RawFH ;
     GetHeader(fH) ;

     mnShowRaw.checked := True ;
     mnShowAveraged.checked :=  False ;
     mnShowDrivingFunction.checked := False ;
     mnShowLeakSubtracted.checked := False ;
     mnDrivingFunction.enabled := true ;

     { Update child windows }
     UpdateMDIWindows ;

     if FormExists( 'ReplayFrm' ) then begin
        // Make form visible, active and on top
        if ReplayFrm.WindowState = wsMinimized then ReplayFrm.WindowState := wsNormal ;
        ReplayFrm.BringToFront ;
        ReplayFrm.SetFocus ;
        end
     else begin
        ReplayFrm := TReplayFrm.Create(Self) ;
        end ;

     end;


procedure TMain.mnShowAveragedClick(Sender: TObject);
{ - Menu Item ---------------------------
  Select averages record file for viewing
  ----------------------------------------}
begin
     fH := AvgFH ;
     GetHeader( fH) ;
     mnShowAveraged.checked := True ;
     mnShowRaw.checked :=  False ;
     mnShowDrivingFunction.checked := False ;
     mnShowLeakSubtracted.checked := False ;
     mnDrivingFunction.enabled := true ;

     { Update child windows }
     UpdateMDIWindows ;

     if FormExists( 'ReplayFrm' ) then begin
        // Make form visible, active and on top
        if ReplayFrm.WindowState = wsMinimized then ReplayFrm.WindowState := wsNormal ;
        ReplayFrm.BringToFront ;
        ReplayFrm.SetFocus ;
        end
     else begin
        ReplayFrm := TReplayFrm.Create(Self) ;
        ReplayFrm.Top := 10 ;
        ReplayFrm.Left := 10 ;
        ReplayFrm.Width := Max( ClientWidth - RecordFrm.Left - 50, 50) ;
        end ;

     end;


procedure TMain.mnShowLeakSubtractedClick(Sender: TObject);
{ - Menu Item -----------------------------------
  Select leak subtracted record file for viewing
  ----------------------------------------------}
begin
     fH := LeakFH ;
     GetHeader( fH) ;
     mnShowAveraged.checked := False ;
     mnShowRaw.checked :=  False ;
     mnShowDrivingFunction.checked := False ;
     mnShowLeakSubtracted.checked := True ;
     mnDrivingFunction.enabled := true ;

     { Update child windows }
     UpdateMDIWindows ;

     if FormExists( 'ReplayFrm' ) then begin
        // Make form visible, active and on top
        if ReplayFrm.WindowState = wsMinimized then ReplayFrm.WindowState := wsNormal ;
        ReplayFrm.BringToFront ;
        ReplayFrm.SetFocus ;
        end
     else begin
        ReplayFrm := TReplayFrm.Create(Self) ;
        ReplayFrm.Top := 10 ;
        ReplayFrm.Left := 10 ;
        ReplayFrm.Width := Max( ClientWidth - RecordFrm.Left - 50, 50) ;
        end ;

     end;


procedure TMain.mnShowDrivingFunctionClick(Sender: TObject);
{ - Menu Item -----------------------------------
  Select driving function records file for viewing
  ----------------------------------------------}
begin
     fH := DrvFH ;
     GetHeader( fH ) ;
     mnShowAveraged.checked := False ;
     mnShowRaw.checked :=  False ;
     mnShowLeakSubtracted.checked := False ;
     mnShowDrivingFunction.checked := True ;
     mnDrivingFunction.enabled := false ;

     { Update child windows }
     UpdateMDIWindows ;

     if FormExists( 'ReplayFrm' ) then begin
        // Make form visible, active and on top
        if ReplayFrm.WindowState = wsMinimized then ReplayFrm.WindowState := wsNormal ;
        ReplayFrm.BringToFront ;
        ReplayFrm.SetFocus ;
        end
     else begin
        ReplayFrm := TReplayFrm.Create(Self) ;
        ReplayFrm.Top := 10 ;
        ReplayFrm.Left := 10 ;
        ReplayFrm.Width := Max( ClientWidth - RecordFrm.Left - 50, 50) ;
        end ;

     end;


procedure TMain.mnCloseClick(Sender: TObject);
{ -------------------------
  Close all forms and files
  -------------------------}
var
   i : Integer ;
begin
     { Close all child windows }
     for i := 0 to Main.MDIChildCount-1 do begin
         if Main.MDICHildren[i].Name <> 'DCLAMPFrm' then Main.MDICHildren[i].Close ;
         end;

     Application.ProcessMessages ;

     { Make View menu options invisible }
     mnShowAveraged.visible := false ;
     mnShowLeakSubtracted.visible := false ;
     mnShowRaw.visible := False ;

     { Close files }
     CloseAllDataFiles ;

     Caption := 'WinWCP : Strathclyde Electrophysiology Software ' + ProgVersion ;
     
     end ;


procedure TMain.mnPrintClick(Sender: TObject);
{ - Menu Item ----------------------------------------------------
  Print the record or graph displayed in the currently active form
  ----------------------------------------------------------------}
begin
    if ActiveMDIChild.Name = 'ReplayFrm' then TReplayFrm(ActiveMDIChild).Print
    else if ActiveMDIChild.Name = 'MeasureFrm' then TMeasureFrm(ActiveMDIChild).Print
    else if ActiveMDIChild.Name = 'FitFrm' then TFitFrm(ActiveMDIChild).Print
    else if ActiveMDIChild.Name = 'RecPlotFrm' then RecPlotFrm.Print
    else if ActiveMDIChild.Name = 'PwrSpecFrm' then TPwrSpecFrm(ActiveMDIChild).PrintDisplay ;

    end;


procedure TMain.mnPrintSetupClick(Sender: TObject);
{ - Menu Item ------------------
  Standard printer setup dialog
  ------------------------------}
begin
     PrinterSetupDialog1.Execute ;
     end;


procedure TMain.mnRecordToDiskClick(Sender: TObject);
{ - Menu Item ------------
  Display recording window
  ------------------------}
begin

     // Exit if no interface available
     if (not SESLabIO.LabInterfaceAvailable) or
        (SESLabIO.LabInterfaceType = NoInterface12) or
        (SESLabIO.LabInterfaceType = NoInterface16) then begin
         StatusBar.SimpleText := 'No laboratory interface: Record To Disk not available!' ;
         Exit ;
         end ;

     if FormExists( 'RecordFrm' ) then begin
        // Make form visible, active and on top
        if RecordFrm.WindowState = wsMinimized then RecordFrm.WindowState := wsNormal ;
        RecordFrm.BringToFront ;
        RecordFrm.SetFocus ;
        end
     else begin
        RecordFrm := TRecordFrm.Create(Self) ;
        RecordFrm.Top := 10 ;
        RecordFrm.Left := 10 ;
        RecordFrm.Width := Max( ClientWidth - RecordFrm.Left - 50, 50) ;
        end ;

     end;


procedure TMain.mnResetMulticlampClick(Sender: TObject);
// -------------------------------------------
// Reset communications with Multiclamp 700A/B
// -------------------------------------------
begin
    Amplifier.ResetMultiClamp700 ;
    end;

procedure TMain.mnNewClick(Sender: TObject);
{ - Menu Item --------
  Create new data file
  --------------------}
begin

     { Present user with standard Save File dialog box }
     SaveDialog.options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist] ;
     SaveDialog.DefaultExt := 'WCP' ;
     SaveDialog.FileName := CreateIndexedFileName( RawFH.FileName ) ;
     SaveDialog.Filter := ' WCP Files (*.WCP)|*.WCP' ;
     SaveDialog.Title := 'New Data File' ;
     if Settings.DataDirectory <> '' then begin
        SaveDialog.InitialDir := Settings.DataDirectory ;
        SetCurrentDir(Settings.DataDirectory) ;
        end;

     if SaveDialog.execute then begin
        CreateNewDataFile( SaveDialog.FileName ) ;
        // Update list of recently used files
        UpdateRecentFilesList ;
        end ;

     end ;


procedure TMain.WaveformGeneratorClick(Sender: TObject);
{ - Menu Item -------------------------------
  Edit a voltage-clamp command pulse waveform
  -------------------------------------------}
begin
     if FormExists( 'EditProtocolFrm' ) then begin
        // Make form visible, active and on top
        if EditProtocolFrm.WindowState = wsMinimized then EditProtocolFrm.WindowState := wsNormal ;
        EditProtocolFrm.BringToFront ;
        EditProtocolFrm.SetFocus ;
        end
     else begin
        EditProtocolFrm := TEditProtocolFrm.Create(Self) ;
        EditProtocolFrm.Top := 10 ;
        EditProtocolFrm.Left := 10 ;
        end ;

     end;


procedure TMain.SetMenus ;
{ ---------------------------
  Activate usable menu items
  --------------------------}
begin
     View.Enabled := False ;
     Analysis.Enabled := False ;
     mnPrint.Enabled := False ;
     Edit.Enabled := True ;
     Setup.Enabled := True ;
     Record1.Enabled := True ;
     mnClose.Enabled := False ;
     mnFileProps.Enabled := False ;
     mnExport.Enabled := False ;
     Simulations1.Enabled := True ;
//     mnRecordToDisk.Enabled := False ;

     { Disable copy/insert record functions }
     CopyRecord.Enabled := False ;
     InsertRecord.Enabled := False ;
     AppendRecord.Enabled := False ;
     DeleteRecord.Enabled := False ;
     DeleteRejected.Enabled := False ;

     { Enable setup, recording and simulation ... if a data file is open }
     if RawFH.FileHandle >= 0 then begin
           { Allow these functions when a data file is open }
//           mnRecordToDisk.Enabled := True ;
           mnClose.Enabled := True ;
           mnFileProps.Enabled :=  True ;
           Simulations1.Enabled := True ;
           View.Enabled := True ;
           mnShowRaw.Visible := False ;

           { Enable these functions when a data record is in the clipboard }
            if FileExists(WCPClipboardFileName) then begin
               InsertRecord.Enabled := True ;
               AppendRecord.Enabled := True ;
               end ;

           { Enable these functions when file contains data records }
           if RawFH.NumRecords > 0 then begin
              Analysis.Enabled := True ;
              mnPrint.Enabled := True ;
              mnExport.Enabled := True ;
              Edit.Enabled := True ;
              CopyRecord.Enabled := True ;
              DeleteRecord.Enabled := True ;
              DeleteRejected.Enabled := True ;
              mnShowRaw.Visible := True ;

              { Enable display of averages (if they exist) }
              if (AvgFH.FileHandle > 0) and (AvgFH.NumRecords > 0) then
                 mnShowAveraged.visible := True
              else mnShowAveraged.visible := False ;
              { Enable display of leak subtracted records (if they exist) }
              if (LeakFH.FileHandle > 0) and (LeakFH.NumRecords > 0) then
                 mnShowLeakSubtracted.visible := True
              else mnShowLeakSubtracted.visible := False ;
              { Enable display of leak subtracted records (if they exist) }
              if (DrvFH.FileHandle > 0) and (DrvFH.NumRecords > 0) then
                 mnShowDrivingFunction.visible := True
              else mnShowDrivingFunction.visible := False ;
              end ;
           end ;

     end ;


procedure TMain.mnCopyDataClick(Sender: TObject);
{ -------------------------------------------------------------
  Copy data values of displayed signal record/plot to clipboard
  ------------------------------------------------------------- }
begin
    Cursor := crHourGlass ;
    if ActiveMDIChild.Name = 'MeasureFrm' then
        TMeasureFrm(ActiveMDIChild).CopyDataToClipBoard
    else if ActiveMDIChild.Name = 'FitFrm' then
        TFItFrm(ActiveMDIChild).CopyDataToClipBoard
    else if ActiveMDIChild.Name = 'ReplayFrm' then
        TReplayFrm(ActiveMDIChild).CopyDataToClipBoard
    else if ActiveMDIChild.Name = 'PwrSpecFrm' then
        TPwrSpecFrm(ActiveMDIChild).CopyDataToClipBoard
    else if ActiveMDIChild.Name = 'RecPlotFrm' then
        RecPlotFrm.CopyDataToClipBoard
    else if ActiveMDIChild.Name = 'LogFrm' then
        TLogFrm(ActiveMDIChild).CopyToClipBoard ;
    Cursor := crDefault ;        
    end ;


procedure TMain.mnCopyImageClick(Sender: TObject);
{ -------------------------------------------------------
  Copy image of displayed signal record/plot to clipboard
  ------------------------------------------------------- }
begin
    if ActiveMDIChild.Name = 'FitFrm' then
        TFitFrm(ActiveMDIChild).CopyImageToClipBoard
    else if ActiveMDIChild.Name = 'MeasureFrm' then
        TMeasureFrm(ActiveMDIChild).CopyImageToClipBoard
    else if ActiveMDIChild.Name = 'ReplayFrm' then
        TReplayFrm(ActiveMDIChild).CopyImageToClipBoard
    else if ActiveMDIChild.Name = 'RecPlotFrm' then
        RecPlotFrm.CopyImageToClipBoard
    else if ActiveMDIChild.Name = 'PwrSpecFrm' then
        TPwrSpecFrm(ActiveMDIChild).CopyImageToClipBoard ;

     end ;


procedure TMain.SynapseClick(Sender: TObject);
{ ---------------------------------------
  Open synaptic current simulation module
  ---------------------------------------}
begin

     if FormExists('SynapeSim') then begin
        // Make form visible, active and on top
        if SynapseSim.WindowState = wsMinimized then SynapseSim.WindowState := wsNormal ;
        SynapseSim.BringToFront ;
        SynapseSim.SetFocus ;
        end
     else begin
        SynapseSim := TSynapseSim.Create(Self) ;
        SynapseSim.Left := 10 ;
        SynapseSim.Top := 10 ;
        end ;

     end;


procedure TMain.HHSimulationClick(Sender: TObject);
{ ---------------------------------------
  Open Hodgkin-Huxley simulation module
  ---------------------------------------}
begin

     if FormExists('VClampSim')  then begin
        // Make form visible, active and on top
        if VClampSim.WindowState = wsMinimized then VClampSim.WindowState := wsNormal ;
        VClampSim.BringToFront ;
        VClampSim.SetFocus ;
        end
     else begin
        VClampSim := TVClampSim.Create(Self) ;
        VClampSim.Left := 10 ;
        VClampSim.Top := 10 ;
        end ;

     end;


procedure TMain.mnSealTestClick(Sender: TObject);
// -------------------------------------
// Open seal test/monitor display window
// -------------------------------------
begin

     // Exit if no interface available
     if (not SESLabIO.LabInterfaceAvailable) or
        (SESLabIO.LabInterfaceType = NoInterface12) or
        (SESLabIO.LabInterfaceType = NoInterface16) then begin
         StatusBar.SimpleText := 'No laboratory interface: Seal Test not available!' ;
         Exit ;
         end ;

     if FormExists( 'SealTestFrm' ) then begin
        // Make form visible, active and on top
        if SealTestFrm.WindowState = wsMinimized then SealTestFrm.WindowState := wsNormal ;
        SealTestFrm.BringToFront ;
        SealTestFrm.SetFocus ;
        end
     else begin
        SealTestFrm := TSealTestFrm.Create(Self) ;
        SealTestFrm.Left := 15 ;
        SealTestFrm.Top := 15 ;
        end ;

     end;


procedure TMain.LeakCurrentSubtractionClick(Sender: TObject);
{ - Menu Item ----------------------------
  Run leak subtraction module (leaksub.pas)
  ----------------------------------------}
begin

     if FormExists('LeakSubFrm') then begin
        // Make form visible, active and on top
        if LeakSubFrm.WindowState = wsMinimized then LeakSubFrm.WindowState := wsNormal ;
        LeakSubFrm.BringToFront ;
        LeakSubFrm.SetFocus ;
        end
     else begin
        LeakSubFrm := TLeakSubFrm.Create(Self) ;
        LeakSubFrm.Left := 10 ;
        LeakSubFrm.Top := 10 ;
        end ;

     end;


procedure TMain.CopyRecordClick(Sender: TObject);
{ - Menu Item --------------------------------------------------
  Copy a signal record to the clipboard (in WCP internal format)
  --------------------------------------------------------------}
var
   RH : TRecHeader ;
   ClipFH : TFileHeader ;
   ADC : ^TSmallIntArray ;

begin

     New( ADC ) ;

     try
        { Get record to be copied to WCP clipboard file }
        GetRecord(FH,RH,FH.RecordNum,ADC^) ;
        { Copy current file header into clipboard header }
        ClipFH := FH ;
        { Open the clipboard file }
        ClipFH.FileName := WCPClipboardFileName ;
        ClipFH.FileHandle := FileCreate( ClipFH.FileName ) ;
        if ClipFH.FileHandle >= 0 then begin
           ClipFH.NumRecords := 1 ;
           { Save record to file }
           PutRecord(ClipFH,RH,ClipFH.NumRecords,ADC^) ;
           SaveHeader( ClipFH ) ;
           FileCloseSafe( ClipFH.FileHandle ) ;
           end ;
        SetMenus ;
     finally
        Dispose( ADC ) ;
        end ;
     end;


procedure TMain.AppendRecordClick(Sender: TObject);
{ - Menu Item --------------------------------------------------
  Append a signal record from the to the end of the data file
  --------------------------------------------------------------}
var
   RH : TRecHeader ;
   ClipFH : TFileHeader ;
   ADC : ^TSmallIntArray ;
   TempName : string ;
   TempHandle : Integer ;
   OK : Boolean ;
   InsertAt,i : Integer ;
   ch : Integer ;
   Scale : Array[0..WCPMaxChannels-1] of single ;
   
begin
     OK := True ;
     { Create a WCP format clipboard data record to hold the record }
     New( ADC ) ;

     try
        { Open the clipboard storage file }
        ClipFH.FileName := WCPClipboardFileName ;
        ClipFH.FileHandle := FileOpen( ClipFH.FileName, fmOpenReadWrite  or fmShareDenyWrite) ;
        if ClipFH.FileHandle < 0 then begin
           ShowMessage( ' Unable to open ' + ClipFH.FileName ) ;
           OK := False ;
           end ;

        if OK then begin
           { Get file header data }
           GetHeader( ClipFH ) ;

           { If the currently open data file is empty
           transfer the file header from the clipboard file }
           if FH.NumRecords = 0 then begin
              TempName := FH.FileName ;
              TempHandle := FH.FileHandle ;
              FH := ClipFH ;
              FH.FileName := TempName ;
              FH.FileHandle := TempHandle ;
              end ;

           { Calculate scaling factors to account for differences in channel
           calibration factors }
           GetHeader( FH ) ;
           for ch := 0 to FH.NumChannels-1 do begin
               Scale[ch] := Channel[ch].ADCCalibrationFactor ;
               end ;
           GetHeader (ClipFH) ;
           for ch := 0 to FH.NumChannels-1 do begin
               Scale[ch] := Scale[ch] / Channel[ch].ADCCalibrationFactor ;
               end ;
           GetHeader( FH ) ;

           { Check if the record is compatible with current file }
           if (FH.NumChannels <> ClipFH.NumChannels) or
              (FH.NumSamples <> ClipFH.NumSamples) then begin
              ShowMessage( ' Record not added. Size or no. channels incompatible' ) ;
              OK := False ;
              end ;
           end ;


        { Insert/append record from clip file }

        if OK then begin
           Inc(FH.NumRecords) ;

           if Sender = InsertRecord then begin
              { *** Insert record at current position in file *** }
              { Move all records above the current position up by 1 }
              for i := FH.NumRecords-1 downto FH.CurrentRecord do begin
                  GetRecord(FH,RH,i,ADC^) ;
                  PutRecord(FH,RH,i+1,ADC^) ;
                  end ;
              if FH.NumRecords = 1 then FH.CurrentRecord := 1 ;
              InsertAt := FH.CurrentRecord ;
              end
           else begin
              { *** Append to end of file *** }
              InsertAt := FH.NumRecords
              end ;

           { Get record from WCP clipboard file }
           GetRecord(ClipFH,RH,1,ADC^) ;
           { Close file }
           FileCloseSafe( ClipFH.FileHandle ) ;

           { Adjust for possible differences in channel calibration factors }
           for ch := 0 to FH.NumChannels-1 do begin
               RH.ADCVoltageRange[ch] := RH.ADCVoltageRange[ch]*Scale[ch] ;
               end ;

           { Copy record to file }
           PutRecord(FH,RH,InsertAt,ADC^) ;
           SaveHeader(FH) ;

           { Ensure that appropriate file header is updated }
           UpdateFileHeaderBlocks ;

           if (FH.NumRecords = 1) then begin
              { If this is the first record of a raw data file after New File
              enable menus and display the View window }
              FH := RawFH ;
              SetMenus ;
              mnShowRaw.click ;
              end
           else UpdateMDIWindows ;
           end
        else

     finally
        Dispose( ADC ) ;
        end ;
     end;


procedure TMain.InsertRecordClick(Sender: TObject);
{ - Menu Item --------------------------------------------------
  Append a signal record from the to the end of the data file
  --------------------------------------------------------------}
var
   RH : TRecHeader ;
   ClipFH : TFileHeader ;
   ADC : ^TSmallIntArray ;
   TempName : string ;
   TempHandle : Integer ;
   OK : Boolean ;
   InsertAt,i : Integer ;
   ch : Integer ;
   Scale : Array[0..WCPMaxChannels-1] of single ;
   
begin
     OK := True ;
     { Create a WCP format clipboard data record to hold the record }
     New( ADC ) ;

     try
        { Open the clipboard storage file }
        ClipFH.FileName := WCPClipboardFileName ;
        ClipFH.FileHandle := FileOpen( ClipFH.FileName, fmOpenReadWrite ) ;
        if ClipFH.FileHandle < 0 then begin
           ShowMessage( ' Unable to open ' + ClipFH.FileName ) ;
           OK := False ;
           end ;

        if OK then begin
           { Get file header data }
           GetHeader( ClipFH ) ;

           { If the currently open data file is empty
           transfer the file header from the clipboard file }
           if FH.NumRecords = 0 then begin
              TempName := FH.FileName ;
              TempHandle := FH.FileHandle ;
              FH := ClipFH ;
              FH.FileName := TempName ;
              FH.FileHandle := TempHandle ;
              end ;

           { Calculate scaling factors to account for differences in channel
           calibration factors }
           GetHeader( FH ) ;
           for ch := 0 to FH.NumChannels-1 do begin
               Scale[ch] := Channel[ch].ADCCalibrationFactor ;
               end ;
           GetHeader (ClipFH) ;
           for ch := 0 to FH.NumChannels-1 do begin
               Scale[ch] := Scale[ch] / Channel[ch].ADCCalibrationFactor ;
               end ;
           GetHeader( FH ) ;

           { Check if the record is compatible with current file }
           if (FH.NumChannels <> ClipFH.NumChannels) or
              (FH.NumSamples <> ClipFH.NumSamples) then begin
              ShowMessage( ' Record not added. Size or no. channels incompatible' ) ;
              OK := False ;
              end ;
           end ;


        { Insert/append record from clip file }

        if OK then begin
           Inc(FH.NumRecords) ;

           if Sender = InsertRecord then begin
              { *** Insert record at current position in file *** }
              { Move all records above the current position up by 1 }
              for i := FH.NumRecords-1 downto FH.CurrentRecord do begin
                  GetRecord(FH,RH,i,ADC^) ;
                  PutRecord(FH,RH,i+1,ADC^) ;
                  end ;
              if FH.NumRecords = 1 then FH.CurrentRecord := 1 ;
              InsertAt := FH.CurrentRecord ;
              end
           else begin
              { *** Append to end of file *** }
              InsertAt := FH.NumRecords
              end ;

           { Get record from WCP clipboard file }
           GetRecord(ClipFH,RH,1,ADC^) ;
           { Close file }
           FileCloseSafe( ClipFH.FileHandle ) ;

           { Adjust for possible differences in channel calibration factors }
           for ch := 0 to FH.NumChannels-1 do begin
               RH.ADCVoltageRange[ch] := RH.ADCVoltageRange[ch]*Scale[ch] ;
               end ;

           { Copy record to file }
           PutRecord(FH,RH,InsertAt,ADC^) ;
           SaveHeader(FH) ;

           { Ensure that appropriate file header is updated }
           UpdateFileHeaderBlocks ;

           if (FH.NumRecords = 1) then begin
              { If this is the first record of a raw data file after New File
              enable menus and display the View window }
              FH := RawFH ;
              SetMenus ;
              mnShowRaw.click ;
              end
           else UpdateMDIWindows ;
           end
        else

     finally
        Dispose( ADC ) ;
        end ;
     end;


procedure TMain.DeleteRecordClick(Sender: TObject);
{ - Menu Item -----------------------------------------------
  Delete a signal record from the data file
  31/5/98 File header blocks updated when a record is deleted
  -----------------------------------------------------------}
var
   RH : TRecHeader ;
   i,iDelete : Integer ;
   TempFH : TFileHeader ;
   ADC : ^TSmallIntArray ;
   OK : Boolean ;
begin
    OK := True ;
    New(ADC) ;

    try
       if MessageDlg( 'Delete record! Are you Sure? ', mtConfirmation,
          [mbYes,mbNo], 0 ) = mrNo then OK := False ;

       { Create temporary file }
       if OK then begin
          TempFH := FH ;
          TempFH.FileName := ChangeFileExt( FH.FileName, '.tmp' ) ;
          TempFH.FileHandle := FileCreate( TempFH.FileName ) ;
          if TempFH.FileHandle < 0 then begin
             ShowMessage( ' Unable to open ' + TempFH.FileName ) ;
             OK := False ;
             end ;
          end ;

       { Copy all records except the current one to the temp. file }
       if OK then begin
          TempFH.NumRecords := 0 ;
          iDelete := FH.RecordNum ;
          for i := 1 to FH.NumRecords do begin
              GetRecord(FH,RH,i,ADC^) ;
              if i <> iDelete then begin
                 Inc(TempFH.NumRecords) ;
                 PutRecord(TempFH,RH,TempFH.NumRecords,ADC^) ;
                 end ;
              end ;
          SaveHeader( TempFH ) ;

          { Close temporary and original file }
          FileCloseSafe( TempFH.FileHandle) ;
          FileCloseSafe( FH.FileHandle ) ;

          { Delete original file }
          DeleteFile( PChar(FH.FileName) ) ;
          { Rename temp. file }
          if not RenameFile( TempFH.FileName, FH.FileName ) then
             ShowMessage( ' Renaming of' + TempFH.FileName + ' failed' ) ;
          { Re-open file }
          FH.FileHandle := FileOpen( FH.FileName, fmOpenReadWrite  or fmShareDenyWrite) ;
          GetHeader( FH ) ;

          { Update data file header (added 31/5/98) }
          UpdateFileHeaderBlocks ;
          // Display next record after deleted
          FH.RecordNum := Min(iDelete,FH.NumRecords) ;
          { Refresh child windows }
          UpdateMDIWindows ;


          end ;

       finally
          Dispose(ADC) ;
          end ;
    end ;


procedure TMain.DeleteRejectedClick(Sender: TObject);
{ - Menu Item ------------------------------
  Delete rejected records from the data file
  ------------------------------------------}
var
   i : Integer ;
   TempFH : TFileHeader ;
   RH : TRecHeader ;
   ADC : ^TSmallIntArray ;
   OK : Boolean ;
begin

     OK := True ;
     New(ADC) ;

     try
        if MessageDlg( 'Delete rejected records! Are you Sure? ', mtConfirmation,
           [mbYes,mbNo], 0 ) = mrNo then OK := False ;

        if OK then begin
           { Create temporary file }
           TempFH := FH ;
           TempFH.FileName := ChangeFileExt( FH.FileName, '.tmp' ) ;
           TempFH.FileHandle := FileCreate( TempFH.FileName ) ;
           if TempFH.FileHandle < 0 then begin
              ShowMessage( ' Unable to open ' + TempFH.FileName ) ;
              OK := False ;
              end ;
          end ;

        { Copy all records except rejected one to the temp. file }
        if OK then begin
           TempFH.NumRecords := 0 ;
           for i := 1 to FH.NumRecords do begin
               GetRecord(FH,RH,i,ADC^) ;
               if RH.Status = 'ACCEPTED' then begin
                  Inc(TempFH.NumRecords) ;
                  PutRecord(TempFH,RH,TempFH.NumRecords,ADC^) ;
                  end ;
               end ;
           SaveHeader( TempFH ) ;

           { Close temporary and original file }
           FileCloseSafe( TempFH.FileHandle) ;
           FileCloseSafe( FH.FileHandle ) ;
           { Delete original file }
           DeleteFile( PChar(FH.FileName) ) ;

           { Rename temp. file }
           if not RenameFile( PChar(TempFH.FileName), FH.FileName ) then
              ShowMessage( ' Renaming of' + TempFH.FileName + ' failed' ) ;

           { Re-open file }
           FH.FileHandle := FileOpen( FH.FileName, fmOpenReadWrite  or fmShareDenyWrite) ;
           GetHeader( FH ) ;

           { Update file header blocks with changes made to FH }
           UpdateFileHeaderBlocks ;

           { Refresh child windows }
           UpdateMDIWindows ;
           end ;

     finally
        Dispose(ADC) ;
        end ;
     end;


procedure TMain.AboutClick(Sender: TObject);
{ - Menu Item --------------------
  Display About window (about.pas)
  -------------------------------}
begin
     AboutDlg := TAboutDlg.Create(Self) ;
     AboutDlg.ShowModal ;
     end;


procedure TMain.UpdateFileHeaderBlocks ;
{ --------------------------------------------------------------------
  Update original copies of file header blocks when changed made to FH
  --------------------------------------------------------------------}
begin
       if FH.FileName = RawFH.FileName then RawFH := FH
       else if FH.FileName = AvgFH.FileName then AvgFH := FH
       else if FH.FileName = LeakFH.FileName then LeakFH := FH
       else if FH.FileName = DrvFH.FileName then DrvFH := FH ;
       end ;


procedure TMain.EditRecordClick(Sender: TObject);
{ - Menu Item ----------------------
  Display signal editing module (rec.pas)
  ---------------------------------}
begin

     if FormExists('EditFrm') then begin
        // Make form visible, active and on top
        if EditFrm.WindowState = wsMinimized then EditFrm.WindowState := wsNormal ;
        EditFrm.BringToFront ;
        EditFrm.SetFocus ;
        end
     else EditFrm := TEditFrm.Create(Self) ;

     end;



procedure TMain.InspectLogFileClick(Sender: TObject);
// -----------------------
// Display log file window
// -----------------------
begin

     if FormExists( 'LogFrm' ) then begin
        // Make form visible, active and on top
        if LogFrm.WindowState = wsMinimized then LogFrm.WindowState := wsNormal ;
        LogFrm.BringToFront ;
        LogFrm.SetFocus ;
        end
     else begin
        LogFrm := TLogFrm.Create(Self) ;
        LogFrm.Top := 20 ;
        LogFrm.Left := 20 ;
        end ;
     end;


procedure TMain.mnQuantalContentClick(Sender: TObject);
{ - Menu Item ----------------------------------
  Run quantal content analysis module (qanal.pas)
  ----------------------------------------------}
begin

     if FormExists('QuantFrm') then begin
        // Make form visible, active and on top
        if QuantFrm.WindowState = wsMinimized then QuantFrm.WindowState := wsNormal ;
        QuantFrm.BringToFront ;
        QuantFrm.SetFocus ;
        end
     else begin
       QuantFrm := TQuantFrm.Create(Self) ;
       QuantFrm.Left := 10 ;
       QuantFrm.Top := 10 ;
       end;

     end;



procedure TMain.mnDrivingFunctionClick(Sender: TObject);
{ - Menu Item ---------------------------------
  Driving function analysis module (drvfun.pas)
  ---------------------------------------------}
begin

     if FormExists('DrvFunFrm') then begin
        // Make form visible, active and on top
        if DrvFunFrm.WindowState = wsMinimized then DrvFunFrm.WindowState := wsNormal ;
        DrvFunFrm.BringToFront ;
        DrvFunFrm.SetFocus ;
        end
     else begin
        DrvFunFrm := TDrvFunFrm.Create(Self) ;
        DrvFunFrm.Left := 10 ;
        DrvFunFrm.Top := 10 ;
        end ;

     end;



procedure TMain.mnImportClick(Sender: TObject);
{ - Menu Item --------------------------------
  Import records from a foreign data file type
  --------------------------------------------}
var
     i : Integer ;
begin

     { Close all child windows }
     with Main do
          for i := 0 to MDIChildCount-1 do MDICHildren[i].Close ;

     { Close any existing data file }
//     CloseAllDataFiles ;

     if ImportFromDataFile then begin
        LoadDataFiles(RawFH.FileName) ;
        // Update list of recently used files
        UpdateRecentFilesList ;
        end ;

     end;


procedure TMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{ ---------------------------------
  Warn user that program is closing
  --------------------------------- }
begin
     if MessageDlg( 'Exit Program! Are you Sure? ', mtConfirmation,
        [mbYes,mbNo], 0 ) = mrYes then CanClose := True
                                  else CanClose := False ;
     end;


procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
{ ---------------------------------
  Tidy up when program is shut down
  ---------------------------------}
var
    i : Integer ;  
begin

       { Close recording and seal test windows to ensure that
         laboratory interface systems are shutdown (to avoid system crash }
       for i := 0 to MDIChildCount-1 do begin
         if MDIChildren[i].Name = 'SealTestFrm' then SealTestFrm.Close ;
         if MDIChildren[i].Name = 'RecordFrm' then RecordFrm.Close ;
         end ;

        { Close data files }
        CloseAllDataFiles ;

        { Close log file }
        CloseLogFile ;

        { Save initialization file }
        SaveInitializationFile( SettingsFileName ) ;

        RecordTypes.Free ;
        ChannelNames.Free ;

        end;



procedure TMain.mnDClampClick(Sender: TObject);
// --------------------------------------------
// Display DCLAMP - Dynamic Clamp control panel
// --------------------------------------------
begin
     if FormExists( 'DCLAMPFrm' ) then begin
        // Make form visible, active and on top
        if DefSetFrm.WindowState = wsMinimized then DefSetFrm.WindowState := wsNormal ;
        DCLAMPFrm.BringToFront ;
        DCLAMPFrm.SetFocus ;
        end
     else begin
        DCLAMPFrm := TDCLAMPFrm.Create(Self) ;
        DCLAMPFrm.Top := 10 ;
        DCLAMPFrm.Left := 10 ;
        end ;

     end;


procedure TMain.mnDefaultSettingsClick(Sender: TObject);
{ --------------------------------------
  Display default outputs control window
  -------------------------------------- }
begin
     if (not Main.SESLabIO.LabInterfaceAvailable) or
        (Main.SESLabIO.LabInterfaceType = NoInterface12) or
        (Main.SESLabIO.LabInterfaceType = NoInterface16) then begin
        ShowMessage( 'No laboratory interface: Default Settings not available!' ) ;
        Exit ;
        end ;

     if FormExists( 'DefSetFrm' ) then begin
        // Make form visible, active and on top
        if DefSetFrm.WindowState = wsMinimized then DefSetFrm.WindowState := wsNormal ;
        DefSetFrm.BringToFront ;
        DefSetFrm.SetFocus ;
        end
     else begin
        DefSetFrm := TDefSetFrm.Create(Self) ;
        DefSetFrm.Top := 10 ;
        DefSetFrm.Left := 10 ;
        end ;

     end;


procedure TMain.mnCED1902Click(Sender: TObject);
{ -------------------------------
  Display CED 1902 control window
  ------------------------------- }
begin

     if FormExists( 'CED1902Frm' ) then begin
        // Make form visible, active and on top
        if CED1902Frm.WindowState = wsMinimized then CED1902Frm.WindowState := wsNormal ;
        CED1902Frm.BringToFront ;
        CED1902Frm.SetFocus ;
        end
     else begin
        CED1902Frm := TCED1902Frm.Create(Self) ;
        CED1902Frm.Top := 10 ;
        CED1902Frm.Left := 10 ;
        end ;

     end;


procedure TMain.ContentsClick(Sender: TObject);
begin
     //application.helpcommand( HELP_CONTENTS, 0 ) ;
     application.HelpContext(30);
     end;


procedure TMain.mnAppendClick(Sender: TObject);
{ - Menu Item -------------------------------------------
  Append records from another WCP data file (convert.pas)
  -------------------------------------------------------}
begin
     OpenDialog.options := [ofPathMustExist] ;
     OpenDialog.DefaultExt := 'DAT' ;
     OpenDialog.Filter := ' WCP Files (*.WCP)|*.WCP';
     OpenDialog.Title := 'Append File ' ;
     if Settings.DataDirectory <> '' then
        SetCurrentDir(Settings.DataDirectory) ;
        OpenDialog.InitialDir := Settings.DataDirectory ;

     if OpenDialog.execute then begin

        Settings.DataDirectory := ExtractFilePath( OpenDialog.FileName ) ;

        AppendWCPFile( OpenDialog.FileName ) ;
        fH := RawFH ;

        UpdateMDIWindows ;

        { Set display magnification to minimum }
        if fH.NumRecords > 0 then begin
           mnZoomOutAll.Click ;
           mnShowRaw.Visible := True ;
           mnShowRaw.Click ;
           end
        else mnShowRaw.Visible := False ;
        SetMenus ;
        { Update file header blocks with changes made to FH }
        UpdateFileHeaderBlocks ;
        end ;
     end;



procedure TMain.mnExportClick(Sender: TObject);
{ - Menu Item --------------------------------
  Export records to a foreign data file type
  --------------------------------------------}
begin
    ExportFrm.ShowModal ;
    end ;


procedure TMain.mnShowHintsClick(Sender: TObject);
{ --------------------
  Enable/Disable hints
  --------------------}
begin
     Application.ShowHint := not Application.ShowHint ;
     mnShowHints.Checked := Application.ShowHint ;
     end;


procedure TMain.CloseFormsAndDataFile ;
{ -------------------------
  Close all forms and files
  -------------------------}
var
   i : Integer ;
begin
     { Close all child windows }
     with Main do
          for i := 0 to MDIChildCount-1 do MDICHildren[i].Close ;

     { Close all files }
     CloseAllDataFiles ;

     { Let form close messages be processed }
     Application.ProcessMessages ;

     { Enable/disable menus }
     SetMenus ;

     end ;


procedure TMain.UpdateMDIWindows ;
begin

     if FormExists( 'ReplayFrm' ) then begin
        ReplayFrm.NewFile ;
        end
     else begin
        { If no replay form ... create one }
        if RawfH.NumRecords > 0 then ReplayFrm := TReplayFrm.Create(Self) ;
        end ;

     if FormExists( 'MeasureFrm' ) then MeasureFrm.NewFile ;
     if FormExists( 'FitFrm' ) then FitFrm.NewFile ;
     if FormExists( 'AvgFrm' ) then AvgFrm.NewFile ;

     SetMenus ;

     end;


procedure TMain.CloseAllDataFiles ;
{ -------------------------
  Close all open data files
  -------------------------}
begin

     if  RawFH.FileHandle >= 0 then begin
         { Close raw data file }
         FileCloseSafe( RawFH.FileHandle) ;
         end ;

     { Close averages file }
     FileCloseSafe( AvgFH.FileHandle) ;

     { Close leak subtracted file }
     FileCloseSafe( LeakFH.FileHandle) ;

     { Close driving function file }
     FileCloseSafe( DrvFH.FileHandle) ;

     end ;


procedure TMain.NewFileUpdate ;
{ -----------------------------------------------
  Update all open forms when data file is changed
  ----------------------------------------------- }
begin
     if FormExists( 'ReplayFrm' ) then ReplayFrm.NewFile ;
     if FormExists( 'RecordFrm' ) then RecordFrm.UpdateDisplay(False) ;
     if FormExists( 'MeasureFrm' ) then MeasureFrm.NewFile ;
     if FormExists( 'FitFrm' ) then FitFrm.NewFile ;
     if FormExists( 'AvgFrm' ) then AvgFrm.NewFile ;
     if FormExists( 'LeakSubFrm' ) then LeakSubFrm.NewFile ;
     if FormExists( 'EditFrm' ) then EditFrm.NewFile ;
     if FormExists( 'SynapseSim' ) then SynapseSim.NewFile ;
     if FormExists( 'VClampSim' ) then VClampSim.NewFile ;
     if FormExists( 'SimMEPSCFrm' ) then SimMEPSCFrm.NewFile ;
     if FormExists( 'DrvFunFrm' ) then DrvFunFrm.NewFile ;
     if FormExists( 'PwrSpecFrm' ) then PwrSpecFrm.NewFile ;

    end;


procedure TMain.mnRecentFile0Click(Sender: TObject);
{ - Menu Item -------------------
  Load a recently used data file
  ------------------------------- }
var
   FileName : string ;
begin
     { Get file name. Note, the .Tag property of the menu item was set
       at design time to point to the appropriate RecentFiles array item }
     FileName := Settings.RecentFiles[TMenuItem(Sender).Tag] ;
     if (FileName <> '') and FileExists(FileName) then begin
        if (FileGetAttr(FileName) AND faReadOnly) = 0 then LoadDataFiles( FileName )
        else ShowMessage( FileName + ' is READ-ONLY. Unable to open!' ) ;
        end ;
     end;

     
procedure TMain.mnStoreTracesClick(Sender: TObject);
{ -------------------------------
  Toggle store traces mode on/off
  ------------------------------- }
var
   i : Integer ;
begin
     mnStoreTraces.Checked := not mnStoreTraces.Checked ;
     for i := 0 to MDIChildCount-1 do begin
       if MDIChildren[I].Name = 'RecordFrm' then
          TRecordFrm(MDIChildren[I]).SetStoreMode(mnStoreTraces.Checked)
       else if MDIChildren[I].Name = 'ReplayFrm' then
          TReplayFrm(MDIChildren[I]).SetStoreMode(mnStoreTraces.Checked)
       else if MDIChildren[I].Name = 'MeasureFrm' then
          TMeasureFrm(MDIChildren[I]).SetStoreMode(mnStoreTraces.Checked) ;
       end ;
     Settings.AutoErase := not mnStoreTraces.Checked ;
     end;


procedure TMain.mnDisplayGridClick(Sender: TObject);
{ -----------------------------------------------------
  Enable/display grid overlay on oscilloscope displays
  ----------------------------------------------------- }
begin
     Settings.DisplayGrid := not Settings.DisplayGrid ;
     mnDisplayGrid.Checked := Settings.DisplayGrid ;
     UpdateDisplays ;

     end;


procedure TMain.UpdateDisplays ;
// ----------------------
// Update signal displays
// ----------------------
var
    i : Integer ;
begin
     for i := 0 to MDIChildCount-1 do begin
          if MDIChildren[I].Name = 'ReplayFrm' then
             TReplayFrm(MDIChildren[I]).ChangeDisplayGrid
          else if MDIChildren[I].Name = 'RecordFrm' then
             TRecordFrm(MDIChildren[I]).ChangeDisplayGrid
          else if MDIChildren[I].Name = 'SealTestFrm' then
             TSealTestFrm(MDIChildren[I]).ChangeDisplayGrid
          else if MDIChildren[I].Name = 'MeasureFrm' then
             TMeasureFrm(MDIChildren[I]).ChangeDisplayGrid
          else if MDIChildren[I].Name = 'FitFrm' then
             TFitFrm(MDIChildren[I]).ChangeDisplayGrid
          else if MDIChildren[I].Name = 'AvgFrm' then
             TAvgFrm(MDIChildren[I]).ChangeDisplayGrid
          else if MDIChildren[I].Name = 'LeakSubFrm' then
             TLeakSubFrm(MDIChildren[I]).ChangeDisplayGrid
          else if MDIChildren[I].Name = 'EditFrm' then
             TEditFrm(MDIChildren[I]).ChangeDisplayGrid
          else if MDIChildren[I].Name = 'SynapseSim' then
             TSynapseSim(MDIChildren[I]).ChangeDisplayGrid
          else if MDIChildren[I].Name = 'VClampSim' then
             TVClampSim(MDIChildren[I]).ChangeDisplayGrid
          else if MDIChildren[I].Name = 'SimMEPSCFrm' then
             TSimMEPSCFrm(MDIChildren[I]).ChangeDisplayGrid
          else if MDIChildren[I].Name = 'DrvFunFrm' then
             TDrvFunFrm(MDIChildren[I]).ChangeDisplayGrid ;
          end ;
    end ;


function TMain.UpdateCaption(
          var FH : TFileHeader ;
          Title : string
          ) : string ;
begin
     if ExtractFileExt( FH.FileName ) = '.avg' then
        Result := Title + '(Averages)'
     else if ExtractFileExt( FH.FileName ) = '.sub' then
        Result := Title + '(Leak Subtracted)'
     else if ExtractFileExt( FH.FileName ) = '.dfn' then
        Result := Title + '(Driving functions)'
     Else Result := Title + '(Recordings) ' ;
     end ;


procedure TMain.mnPwrSpecClick(Sender: TObject);
{ - Menu Item ------------------------------------
  Create noise analysis module (pwrspec.pas)
  ------------------------------------------------}
begin

     if FormExists('PwrSpecFrm') then begin
        // Make form visible, active and on top
        if PwrSpecFrm.WindowState = wsMinimized then PwrSpecFrm.WindowState := wsNormal ;
        PwrSpecFrm.BringToFront ;
        PwrSpecFrm.SetFocus ;
        end
     else begin
        PwrSpecFrm := TPwrSpecFrm.Create(Self) ;
        end ;

     end;


procedure TMain.mnSimMEPSCClick(Sender: TObject);
{ ---------------------------------------
  Open miniature EPSC simulation module
  ---------------------------------------}
begin

     if FormExists('SimMEPSCFrm') then begin
        // Make form visible, active and on top
        if SimMEPSCFrm.WindowState = wsMinimized then SimMEPSCFrm.WindowState := wsNormal ;
        SimMEPSCFrm.BringToFront ;
        SimMEPSCFrm.SetFocus ;
        end
     else begin
        SimMEPSCFrm := TSimMEPSCFrm.Create(Self) ;
        SimMEPSCFrm.Left := 10 ;
        SimMEPSCFrm.Top := 10 ;
        end ;
     end;


procedure TMain.mnShow0Click(Sender: TObject);
{ ---------------------------------
  Set/clear channel display status
  --------------------------------- }
var
   ch,NumChannelsOnDisplay : Integer ;
begin
     { Determine how many channels are on display }
     NumChannelsOnDisplay := 0 ;
     for ch := 0 to RawFH.NumChannels-1 do
         if Channel[ch].InUse then Inc(NumChannelsOnDisplay) ;

     { Toggle menu checked state }
     TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked ;
     { If this is the only channel on display, don't turn it off }
     if (NumChannelsOnDisplay=1) and (TMenuItem(Sender).Checked=False) then
        TMenuItem(Sender).Checked := True ;
     { Update channel display setting N.B. Tag property contains channel # }
     Channel[TMenuItem(Sender).Tag].InUse := TMenuItem(Sender).Checked ;
     { Update windows currently open }
     UpdateMDIWindows ;
     end;


procedure TMain.UpdateChannelScalingFactors(
          var RH : TRecHeader ) ;
// ------------------------------
// Update channel scaling factors
// ------------------------------
var
   ch : Integer ;
begin
     for ch := 0 to RawFH.NumChannels-1 do begin

         // Ensure that calibration factor is non-zero
         if Channel[ch].ADCCalibrationFactor = 0.0 then
            Channel[ch].ADCCalibrationFactor := 0.001 ;

         // Calculate bits->units scaling factor
         Channel[ch].ADCScale := Abs(RH.ADCVoltageRange[ch]) /
                                (Channel[ch].ADCCalibrationFactor
                                 *(Main.SESLabIO.ADCMaxValue+1) ) ;
         end ;
     end ;


procedure TMain.mnInterleaveClick(Sender: TObject);
{ - Menu Item -------------------------------------------
  Append records from another WCP data file (convert.pas)
  -------------------------------------------------------}
begin
     OpenDialog.options := [ofPathMustExist] ;
     OpenDialog.DefaultExt := 'WCP' ;
     OpenDialog.Filter := ' WCP Files (*.WCP)|*.WCP';
     OpenDialog.Title := 'Interleave File ' ;
     if Settings.DataDirectory <> '' then
        SetCurrentDir(Settings.DataDirectory);
        OpenDialog.InitialDir := Settings.DataDirectory ;

     if OpenDialog.execute then begin

        Settings.DataDirectory := ExtractFilePath( OpenDialog.FileName ) ;

        InterleaveWCPFile( OpenDialog.FileName ) ;
        fH := RawFH ;

        UpdateMDIWindows ;

        { Set display magnification to minimum }
        if fH.NumRecords > 0 then begin
           mnZoomOutAll.Click ;
           mnShowRaw.Visible := True ;
           mnShowRaw.Click ;
           end
        else mnShowRaw.Visible := False ;
        SetMenus ;
        { Update file header blocks with changes made to FH }
        UpdateFileHeaderBlocks ;
        end ;
     end;


procedure TMain.mnVP500Click(Sender: TObject);
// -------------------------------
//  Display VP500 control window
// ------------------------------- }
begin

     if FormExists( 'VP500PanelFrm' ) then begin
        // Make form visible, active and on top
        if VP500PanelFrm.WindowState = wsMinimized then VP500PanelFrm.WindowState := wsNormal ;
        VP500PanelFrm.BringToFront ;
        VP500PanelFrm.SetFocus ;
        end
     else begin
        VP500PanelFrm := TVP500PanelFrm.Create(Self) ;
        VP500PanelFrm.Top := 10 ;
        VP500PanelFrm.Left := 10 ;
        end ;

     end;


function TMain.ImportFromDataFile : Boolean ;
{ -----------------------------------------
  Import data from another data file format
  -----------------------------------------}
const
   BufMax = 32768 ;
Type
     TFilter = record
              Ext : string ;
              FType : TADCDataFileType ;
              end ;
var
   Filters : Array[1..8] of TFilter ;
   FileName : String ;
   FileType : TADCDataFileType ;
   i,j,j0 : Integer ;
   Buf : ^TSmallIntArray ;
   NumRead : Integer ;
   iRec,ch : Integer ;
   RH : TRecHeader ;
   WCPFileName : String ;
begin

     Result := False ;

     Filters[1].Ext := 'Axon Files (*.DAT,*.ABF)|*.DAT;*.ABF|' ;
     Filters[1].FType := ftUnknown ;
     Filters[2].Ext := 'CED Files (*.DAT,*.CFS)|*.DAT;*.CFS|' ;
     Filters[2].FType := ftCFS ;
     Filters[3].Ext := 'SCAN Files (*.SCA)|*.SCA|' ;
     Filters[3].FType := ftSCA ;
     Filters[4].Ext := 'IGOR Binary Files (*.IBW)|*.IBW|' ;
     Filters[4].FType := ftIBW ;
     Filters[5].Ext := 'ASCII Text (*.TXT,*.ASC)|*.TXT;*.ASC|' ;
     Filters[5].FType := ftASC ;
     Filters[6].Ext := 'Raw Binary (*.dat,*.raw)|*.dat;*.raw|' ;
     Filters[6].FType := ftRaw ;
     Filters[7].Ext := 'HEKA (*.ASC)|*.asc|' ;
     Filters[7].FType := ftHEK ;
     Filters[8].Ext := 'All Files (*.*)|*.*|' ;
     Filters[8].FType := ftUnknown ;

     OpenDialog.Filter := '' ;
     for i := 1 to High(Filters) do
         OpenDialog.Filter := OpenDialog.Filter + Filters[i].Ext ;
     OpenDialog.options := [ofPathMustExist] ;
     OpenDialog.DefaultExt := 'DAT' ;

     OpenDialog.Title := 'Import File ' ;
     if Settings.DataDirectory <> '' then begin
        SetCurrentDir(Settings.DataDirectory);
        OpenDialog.InitialDir := Settings.DataDirectory ;
        end;

     if not OpenDialog.execute then Exit ;

     Settings.DataDirectory := ExtractFilePath( OpenDialog.FileName ) ;
     FileType := Filters[OpenDialog.FilterIndex].FType ;
     FileName := OpenDialog.FileName ;

     { Create name of WCP file to hold imported file }
     WCPFileName := ChangeFileExt( FileName, DataFileExtension ) ;
     { Make sure an existing data file is not overwritten, unintentionally }
     if not FileOverwriteCheck(WCPFileName ) then Exit ;

     // Report progress
     Main.StatusBar.SimpleText := format(
     ' IMPORT: Importing data from %s ',[FileName] ) ;

     if FileType = ftASC then begin
        // ASCII format data files
        ImportASCIIFrm.ImportFile := ImportFile ;
        ImportASCIIFrm.FileName := FileName ;
        if ImportASCIIFrm.ShowModal <> mrOK Then Exit ;
        if not Main.ImportFile.OpenDataFile( FileName, FileType ) then Exit ;
        end
     else if FileType = ftRaw then begin
        // Raw binary data files
        ImportRawFrm.ImportFile := ImportFile ;
        if ImportRawFrm.ShowModal <> mrOK Then Exit ;
        if not Main.ImportFile.OpenDataFile( FileName, FileType ) then Exit ;
        end
     else if FileType = ftHEK then begin
        // HEKA data files
        if not Main.ImportFile.OpenDataFile( FileName, FileType ) then Exit ;
        end
     else begin
        // All other data files
        FileType := ImportFile.FindFileType( FileName ) ;
        if not Main.ImportFile.OpenDataFile( FileName, FileType ) then Exit ;
        end ;

     if (Main.ImportFile.NumScansPerRecord*Main.ImportFile.NumChannelsPerScan) > MaxADCSamples then begin
        ShowMessage( format(
        ' IMPORT: Unable to import files with more than %d samples/record!',
        [MaxADCSamples div Main.ImportFile.NumChannelsPerScan])) ;
        Main.ImportFile.CloseDataFile ;
        Exit ;
        end ;

     { Create WCP data file to hold import}
     if not CreateNewDataFile( WCPFileName ) then Exit ;

     GetMem( Buf, SizeOf(TSmallIntArray)) ;
     try

     RawFH.NumChannels := Main.ImportFile.NumChannelsPerScan ;

     // Ensure that no. of samples/channel is multiple of 256
     RawFH.NumSamples := (Main.ImportFile.NumScansPerRecord div 256)*256 ;
     if RawFH.NumSamples < Main.ImportFile.NumScansPerRecord then
        RawFH.NumSamples := RawFH.NumSamples + 256 ;

     RawFH.NumAnalysisBytesPerRecord := NumAnalysisBytesPerRecord(RawFH.NumChannels) ;

     RawFH.MaxADCValue := Main.ImportFile.MaxADCValue ;
     RawFH.MinADCValue := Main.ImportFile.MinADCValue ;

     RawFH.IdentLine := Main.ImportFile.IdentLine ;

     { Copy records }
     RawFH.NumRecords := 0 ;
     for iRec := 1 to Main.ImportFile.NumRecords do begin

         Main.ImportFile.RecordNum := iRec ;
         RawFH.ADCVoltageRange := Main.ImportFile.ChannelADCVoltageRange[0] ;
         for ch := 0 to Main.ImportFile.NumChannelsPerScan-1 do begin
             Channel[ch].ChannelOffset := Main.ImportFile.ChannelOffset[ch] ;
             Channel[ch].ADCName := Main.ImportFile.ChannelName[ch] ;
             Channel[ch].ADCUnits := Main.ImportFile.ChannelUnits[ch] ;
             Channel[ch].ADCSCale := Main.ImportFile.ChannelScale[ch] ;
             Channel[ch].ADCCalibrationFactor := Main.ImportFile.ChannelCalibrationFactor[ch] ;
             Channel[ch].ADCAmplifierGain := Main.ImportFile.ChannelGain[ch] ;
             Channel[ch].YMax := RawFH.MaxADCValue ;
             Channel[ch].YMin := RawFH.MinADCValue ;
             end ;

         { Copy sampling interval and A/D range }
         RawFH.dt := Main.ImportFile.ScanInterval ;
         RawFH.ADCVoltageRange := Main.ImportFile.ChannelADCVoltageRange[0] ;

         // Read A/D sample from source file
         NumRead := Main.ImportFile.LoadADCBuffer(0,Main.ImportFile.NumScansPerRecord,Buf^ ) ;
         if NumRead <= 0 then Break ;

         // Pad end of buffer
         j0 := (NumRead-1)*RawFH.NumChannels ;
         for i := NumRead-1 to RawFH.NumSamples-1 do begin
             j := i*RawFH.NumChannels ;
             for ch := 0 to RawFH.NumChannels-1 do Buf^[j+ch] := Buf^[j0+ch] ;
             end ;

         { Save record to file }
         Inc(RawFH.NumRecords) ;
         RH.Status := 'ACCEPTED' ;
         RH.RecType := 'TEST' ;
         RH.Number := RawFH.NumRecords ;
         RH.Time := RH.Number ;
         RH.dt := RawfH.dt ;
         RH.Ident := ' ' ;
         for ch := 0 to RawFH.NumChannels do RH.ADCVoltageRange[ch] :=
                                             Main.ImportFile.ChannelADCVoltageRange[ch] ;
         RH.Value[vFitEquation] := 0.0 ;
         RH.AnalysisAvailable := False ;
         PutRecord( RawfH, RH, RawfH.NumRecords, Buf^ ) ;

         // Report progress
         Main.StatusBar.SimpleText := format(
         ' IMPORT: Importing (%d channel) record %d/%d from %s ',
             [Main.ImportFile.NumChannelsPerScan,
              iRec,
              Main.ImportFile.NumRecords,
              FileName]) ;

         end ;

     // Final progress
     Main.StatusBar.SimpleText := format(
     'IMPORT: %d records (%dx%d channel scans) imported from %s to %s',
     [Main.ImportFile.NumRecords,
      Main.ImportFile.NumScansPerRecord,
      Main.ImportFile.NumChannelsPerScan,
      FileName,
      RawFH.FileName]) ;
     WriteToLogFile( Main.StatusBar.SimpleText ) ;

     { Save file header }
     SaveHeader( RawFH ) ;

     { Close source file }
     Main.ImportFile.CloseDataFile ;

     { Close dest. file }
     if RawFH.FileHandle >= 0 then begin
        FileClose( RawFH.FileHandle ) ;
        RawFH.FileHandle := -1 ;
        end ;
     Result := True ;

     Finally
         FreeMem ( Buf ) ;
         end ;

     end ;


function TMain.CreateNewDataFile(
         FileName : String
         ) : Boolean ;
// --------------------------------
// Create new (and empty) data file
// --------------------------------
var
     i,ch : Integer ;
     TempFile : String ;
begin

     { Close any existing data file }
     CloseAllDataFiles ;

     mnShowRaw.checked := False ;
     mnShowAveraged.checked := False ;
     mnShowAveraged.visible := False ;
     mnShowLeakSubtracted.checked := False ;
     mnShowLeakSubtracted.Visible := False ;

     { Open new and empty data file }
     RawFH.FileName := FileName ;
     RawFH.FileName := ChangeFileExt( RawFH.FileName, '.wcp' ) ;
     RawFH.FileHandle := FileCreate( RawFH.FileName ) ;
     if RawFH.FileHandle >= 0 then begin
        // Re-open allowing read only sharing
        FileClose( RawFH.FileHandle ) ;
        RawFH.FileHandle := FileOpen(  RawFH.FileName, fmOpenReadWrite or fmShareDenyWrite ) ;
        end ;
     //RawFH.NumBytesInHeader := MaxBytesInFileHeader ;

     // Time created
     RawFH.CreationTime := DateToStr(Now) ;
     RawFH.ProgVersion := ProgVersion ;    // WinWCP program version
     RawFH.NumRecords := 0 ;

     { Set No. of bytes in analysis record to default value }
     RawFH.NumAnalysisBytesPerRecord := NumAnalysisBytesPerRecord(RawFH.NumChannels) ;
     for ch := 0 to RawFH.NumChannels-1 do Channel[ch].InUse := True ;
     SaveHeader( RawFH ) ;

     for i := 0 to MDIChildCount-1 do
         if MDIChildren[i].Name = 'RecordFrm' then begin
            RecordFrm.caption := 'Record ' + RawFH.FileName ;
            RecordFrm.edStatus.Text := '' ;
            end ;

     { Delete averages file (if it exists) }
     TempFile := ChangeFileExt( RawFH.FileName, '.avg' ) ;
     if FileExists(TempFile) then DeleteFile(PChar(TempFile)) ;
     { Delete leak subtraction file (if it exists) }
     TempFile := ChangeFileExt( RawFH.FileName, '.sub' ) ;
     if FileExists(TempFile) then DeleteFile(PChar(TempFile)) ;
     TempFile := ChangeFileExt( RawFH.FileName, '.dfn' ) ;
     if FileExists(TempFile) then DeleteFile(PChar(TempFile)) ;

     { Re-load empty data file }
     LoadDataFiles( RawFH.FileName ) ;

     WriteToLogFile( 'New data file: ' + RawFH.FileName + ' created.' ) ;
     Result := True ;

     end ;


function TMain.CreateIndexedFileName(
         FileName : String ) : String ;
// ---------------------------------------------------
// Append an (incremented) index number to end of file
// ---------------------------------------------------
var
     i : Integer ;
     ExtensionStart : Integer ;
     IndexNumberStart : Integer ;
     IndexNum : Integer ;
     sDate,NewFileName : String ;
     FileStem : String ;
begin

     // Create new file name based on date

     DateTimeToString( sDate, 'yymmdd', Date() ) ;
     FileName := Settings.DataDirectory  + Settings.FileNamePrefix ;
     if Settings.FileNameIncludeDate then FileName := FileName + sDate ;
     FileName := FileName + '.wcp' ;

     // Find '_nnn' index number (if it exists)
     i := Length(FileName) ;
     ExtensionStart := Length(FileName)+1 ;
     IndexNumberStart := -1 ;
     While (i > 0) do begin
         if FileName[i] = '.' then ExtensionStart := i ;
         if FileName[i] = '_' then begin
            IndexNumberStart := i ;
            Break ;
            end ;
         Dec(i) ;
         end ;

     if ((ExtensionStart - IndexNumberStart) > 4)
        or (ExtensionStart < 5) then IndexNumberStart := -1 ;

     // Find next available (lowest) index number for this file name

     FileStem :=  '' ;
     if IndexNumberStart > 0 then begin
        for i := 1 to IndexNumberStart-1 do
            FileStem :=  FileStem + FileName[i] ;
        end
     else begin
        for i := 1 to ExtensionStart-1 do
            FileStem :=  FileStem + FileName[i] ;
        end ;

     IndexNum := 0 ;
     repeat
          Inc(IndexNum) ;
          NewFileName := FileStem + format('_%.3d',[IndexNum]) ;
          for i := ExtensionStart to Length(FileName) do
              NewFileName := NewFileName + FileName[i] ;
          until not FileExists(NewFileName) ;

     // Return name
     Result := NewFileName ;

     end ;


procedure TMain.mnZoomInCh0Click(Sender: TObject);
// --------------------------------------
// Vertically magnify selected channel X2
// --------------------------------------
var
    i : Integer ;
begin
     for i := 0 to MDIChildCount-1 do begin
          if MDIChildren[I].Name = 'ReplayFrm' then
             TReplayFrm(MDIChildren[I]).ZoomIn(TMenuItem(Sender).Tag)
          else if MDIChildren[I].Name = 'RecordFrm' then
             TRecordFrm(MDIChildren[I]).ZoomIn(TMenuItem(Sender).Tag) ;
          end ;
     end ;


procedure TMain.mnZoomOutCh0Click(Sender: TObject);
// --------------------------------------
// Vertically expand selected channel X2
// --------------------------------------
var
    i : Integer ;
begin
     for i := 0 to MDIChildCount-1 do begin
          if MDIChildren[I].Name = 'ReplayFrm' then
             TReplayFrm(MDIChildren[I]).ZoomOut(TMenuItem(Sender).Tag)
          else if MDIChildren[I].Name = 'RecordFrm' then
             TRecordFrm(MDIChildren[I]).ZoomOut(TMenuItem(Sender).Tag) ;
          end ;
     end ;


procedure TMain.mnZoomOutAllClick(Sender: TObject);
{ - Menu Item ------------------------------
  Zoom all windows out minimum magnification
  ------------------------------------------ }
var
   i : Integer ;
begin
     for i := 0 to MDIChildCount-1 do begin
          if MDIChildren[I].Name = 'ReplayFrm' then
             TReplayFrm(MDIChildren[I]).ZoomOutAll
          else if MDIChildren[I].Name = 'RecordFrm' then
             TRecordFrm(MDIChildren[I]).ZoomOutAll
          else if MDIChildren[I].Name = 'MeasureFrm' then
             TMeasureFrm(MDIChildren[I]).ZoomOut
          else if MDIChildren[I].Name = 'FitFrm' then
             TFitFrm(MDIChildren[I]).ZoomOut
          else if MDIChildren[I].Name = 'AvgFrm' then
             TAvgFrm(MDIChildren[I]).ZoomOut
          else if MDIChildren[I].Name = 'LeakSubFrm' then
             TLeakSubFrm(MDIChildren[I]).ZoomOut
          else if MDIChildren[I].Name = 'EditFrm' then
             TEditFrm(MDIChildren[I]).ZoomOut
          else if MDIChildren[I].Name = 'SynapseSim' then
             TSynapseSim(MDIChildren[I]).ZoomOut
          else if MDIChildren[I].Name = 'VClampSim' then
             TVClampSim(MDIChildren[I]).ZoomOut
          else if MDIChildren[I].Name = 'SimMEPSCFrm' then
             TSimMEPSCFrm(MDIChildren[I]).ZoomOut
          else if MDIChildren[I].Name = 'DrvFunFrm' then
             TDrvFunFrm(MDIChildren[I]).ZoomOut ;
          end ;
    end;


procedure TMain.ViewClick(Sender: TObject);
// --------------------------------
// Enable/disable View menu options
// --------------------------------
var
    Enabled : Boolean ;
begin

     // Enable display of recorded signals if not recording
     if FormExists('RecordFrm') then begin
        Enabled := not RecordFrm.Recording ;
        end
     else Enabled := True ;
     mnShowRaw.Enabled := Enabled ;
     mnShowAveraged.Enabled := Enabled ;
     mnShowLeakSubtracted.Enabled := Enabled ;
     mnShowDrivingFunction.Enabled := Enabled ;

     if RawFH.FileHandle >= 0 then mnShowRaw.Visible := True
                              else mnShowRaw.Visible := False ;
     if AvgFH.FileHandle >= 0 then mnShowAveraged.Visible := True
                              else mnShowAveraged.Visible := False ;
     if LeakFH.FileHandle >= 0 then mnShowLeakSubtracted.Visible := True
                               else mnShowLeakSubtracted.Visible := False ;
     if DrvFH.FileHandle >= 0 then mnShowDrivingFunction.Visible := True
                               else mnShowDrivingFunction.Visible := False ;

     end;


procedure TMain.mnFilePropsClick(Sender: TObject);
{ - Menu Item -------------------------------
  File properties dialog (fileprops.pas)
  -------------------------------------------}
begin
     FilePropsDlg := TFilePropsDlg.Create(Self) ;
     end;

function TMain.FormExists( FormName : String ) : Boolean ;
// --------------------------
// Return TRUE if form exists
// --------------------------
var
    i : Integer ;
begin
     Result := False ;
     for i := 0 to MDIChildCount-1 do
         if ANSIContainsText(MDIChildren[i].Name,FormName) then Result := True ;
     end ;


procedure TMain.EditClick(Sender: TObject);
// ---------
// Edit menu
// ---------
var
   EnableDataCopy : Boolean ;
   EnableImageCopy : Boolean ;
begin

     EnableDataCopy := False ;
     EnableImageCopy := False ;

     if MDIChildCount <= 0 then begin
        mnCopyData.Enabled := EnableDataCopy ;
        mnCopyImage.Enabled := EnableImageCopy ;
        Exit ;
        end ;

     if ActiveMDIChild.Name = 'ReplayFrm' then begin
        EnableDataCopy := True ;
        EnableImageCopy := True ;
        end
     else if ActiveMDIChild.Name = 'MeasureFrm' then begin
        EnableDataCopy := MeasureFrm.DataAvailable ;
        EnableImageCopy := MeasureFrm.ImageAvailable ;
        end
     else if ActiveMDIChild.Name = 'FitFrm' then begin
        EnableDataCopy := FitFrm.DataAvailable ;
        EnableImageCopy := FitFrm.ImageAvailable ;
        end
     else if ActiveMDIChild.Name = 'PwrSpecFrm' then begin
        EnableDataCopy := PwrSpecFrm.DataAvailable ;
        EnableImageCopy := PwrSpecFrm.ImageAvailable ;
        end
     else if ActiveMDIChild.Name = 'LogFrm' then begin
        EnableDataCopy := True ;
        end
     else if ActiveMDIChild.Name = 'RecPlotFrm' then begin
        EnableDataCopy := True ;
        EnableImageCopy := True ;
        end ;

     mnCopyData.Enabled := EnableDataCopy ;
     mnCopyImage.Enabled := EnableImageCopy ;

     end;

     
procedure TMain.File1Click(Sender: TObject);
// ---------
// File menu
// ---------
var
   EnablePrint : Boolean ;
begin

     EnablePrint := False ;

     if MDIChildCount <= 0 then begin
        mnPrint.Enabled := EnablePrint ;
        Exit ;
        end ;

     if ActiveMDIChild.Name = 'ReplayFrm' then begin
        EnablePrint := True ;
        end
     else if ActiveMDIChild.Name = 'MeasureFrm' then begin
        EnablePrint := MeasureFrm.ImageAvailable or MeasureFrm.DataAvailable ;
        end
     else if ActiveMDIChild.Name = 'FitFrm' then begin
        EnablePrint := FitFrm.ImageAvailable or FitFrm.DataAvailable ;
        end
     else if ActiveMDIChild.Name = 'PwrSpecFrm' then begin
        EnablePrint := PwrSpecFrm.ImageAvailable ;
        end
     else if ActiveMDIChild.Name = 'LogFrm' then begin
        EnablePrint := True ;
        end ;


     mnPrint.Enabled := EnablePrint ;

     end;


procedure TMain.mnTritonClick(Sender: TObject);
// -------------------------------
//  Display Triton control window
// ------------------------------- }
begin

     if FormExists( 'TritonPanelFrm' ) then begin
        // Make form visible, active and on top
        if TritonPanelFrm.WindowState = wsMinimized then TritonPanelFrm.WindowState := wsNormal ;
        TritonPanelFrm.BringToFront ;
        TritonPanelFrm.SetFocus ;
        end
     else begin
        TritonPanelFrm := TTritonPanelFrm.Create(Self) ;
        TritonPanelFrm.Top := 10 ;
        TritonPanelFrm.Left := 650 ;
        end ;

     end;

procedure TMain.SetupClick(Sender: TObject);
// -------------------
// Setup menu selected
// -------------------
var
    i : Integer ;
begin

     mnTriton.Enabled := False ;
     mnVP500.Enabled := False ;
     mnEPC9Panel.Enabled := False ;
     mnResetMulticlamp.Enabled := False ;
     case SESLabIO.LabInterfaceType of
          Triton : mnTriton.Enabled := True ;
          VP500 : mnVP500.Enabled := True ;
          HekaEPC9,HekaEPC10,HekaEPC10Plus,HekaEPC10USB,HekaEPC9USB : mnEPC9Panel.Enabled := True ;

          end ;

     // Enable/disable Multiclamp reset item
     mnResetMulticlamp.Enabled := False ;
     for i := 0 to 3 do begin
         if (Amplifier.AmplifierType[i] = amMulticlamp700A) or
            (Amplifier.AmplifierType[i] = amMulticlamp700B) then mnResetMulticlamp.Enabled := True ;
         end;

     end;


procedure TMain.UpdateRecentFilesList ;
// ----------------------------------
// Update list of recently used files
// ----------------------------------
var
    i : Integer ;
begin

     // If same file has been opened again, don't update
     if Settings.RecentFiles[0] = RawFH.FileName then Exit ;

     // Shift list along
     for i := High(Settings.RecentFiles) downto 1 do
         Settings.RecentFiles[i] := Settings.RecentFiles[i-1] ;
     Settings.RecentFiles[0] := RawFH.FileName ;

     { Update list in Files menu }
     mnRecentFileSeparator.Visible := False ;
     SetRecentFileItem( mnRecentFile0, Settings.RecentFiles[0] ) ;
     SetRecentFileItem( mnRecentFile1, Settings.RecentFiles[1] ) ;
     SetRecentFileItem( mnRecentFile2, Settings.RecentFiles[2] ) ;
     SetRecentFileItem( mnRecentFile3, Settings.RecentFiles[3] ) ;

     end ;


procedure TMain.mnShowAllChannelsClick(Sender: TObject);
// -------------------------------------
// Make all channels visible in displays
// -------------------------------------
var
    ch : Integer ;

begin

    for ch := 0 to WCPMaxChannels-1 do begin
        Channel[ch].InUse := True ;
        Main.SESLabIO.ADCChannelVisible[ch] := True ;
        end ;
    UpdateDisplays ;
        
    end;

procedure TMain.mnLaboratorInterfaceClick(Sender: TObject);
{ - Menu Item -------------------------------
  Record parameters set-up dialog (setup.pas)
  -------------------------------------------}
begin
     if FormExists( 'LabInterfaceSetupFrm' ) then begin
        // Make form visible, active and on top
        if LabInterfaceSetupFrm.WindowState = wsMinimized then LabInterfaceSetupFrm.WindowState := wsNormal ;
        LabInterfaceSetupFrm.BringToFront ;
        LabInterfaceSetupFrm.SetFocus ;
        end
     else begin
        LabInterfaceSetupFrm := TLabInterfaceSetupFrm.Create(Self) ;
        LabInterfaceSetupFrm.Top := 10 ;
        LabInterfaceSetupFrm.Left := 10 ;
        end ;

     end;

function TMain.GetSpecialFolder(const ASpecialFolderID: Integer): string;
// --------------------------
// Get Windows special folder
// --------------------------
var
  //vSFolder :  pItemIDList;
  vSpecialPath : array[0..MAX_PATH] of Char;
begin

    SHGetFolderPath( 0, ASpecialFolderID, 0,0,vSpecialPath) ;
//  SHGetSpecialFolderLocation(0, ASpecialFolderID, vSFolder);

//  SHGetPathFromIDList(vSFolder, vSpecialPath);

  Result := StrPas(vSpecialPath);

  end;

function TMain.DateToStr( DateTime : TDateTime ) : String ;
// -------------------------------------------------------------
// Convert date-time to date & time string (dd/mm/yyyy hh:mm:ss)
// -------------------------------------------------------------
var
   DateFormat : TFormatSettings ;
begin

  DateFormat := TFormatSettings.Create ;
  DateFormat.DateSeparator := '/' ;
  DateFormat.TimeSeparator := ':' ;
  DateFormat.ShortDateFormat := 'dd/MM/yyyy' ;
  DateFormat.ShortTimeFormat := 'hh:mm:ss' ;
  Result := System.SysUtils.DateTimeToStr( DateTime,DateFormat) ;
  end;


function TMain.StrToDate( DateTime : String ) : TDateTime ;
// -------------------------------------------------
// Convert GB format date & time string to DateTime
// -------------------------------------------------
var
   DateFormat : TFormatSettings ;
begin

  DateFormat := TFormatSettings.Create ;
  DateFormat.DateSeparator := '/' ;
  DateFormat.TimeSeparator := ':' ;
  DateFormat.ShortDateFormat := 'dd/MM/yyyy' ;
  DateFormat.ShortTimeFormat := 'hh:mm:ss' ;

  // If date is in yyyy-MM-dd format, adjust format
  if ANSIContainsText(DateTime,'-') then begin
     DateFormat.DateSeparator := '-' ;
     DateFormat.ShortDateFormat := 'yyyy-MM-dd' ;
     end ;
  Result :=  System.SysUtils.StrToDateTimeDef(DateTime,Now,DateFormat) ;

  end;


end.

