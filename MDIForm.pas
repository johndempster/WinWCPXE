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
   V5.1.2 05.01.16    SESLABIO.pas: Now ensures FADCNumChannels > 1 when settings loaded by LoadFromXMLFile(). XML settings file
                      now checked for LABINTERFACESETTINGS record to avoid access violation if not present.
                      Digidata 1440,1550,1550A: Now loads DLLs from C:\Users\Public\Documents\SESLABIO
                      rather than (WinWCP program folder).
                      Amplifiers: XML settings file now checked for AMPLIFIERSETTINGS record to avoid access violation if not present.
   V5.1.3 04.02.16    Multiclamp 700A: Detected channels now correctly assigned to Amplifier #1/#2 instead of #3/#4.
   V5.1.4 09.02.16    Digidata 1440/1550 interfaces: wdapi1140.dll now loaded before axdd????.dll to allow dll to be loaded under Windows XP
                      File->Open Data File / File->Import: File Name box now cleared to ensure list of available file displayed
                      in Windows 7 standard desktop dialog box.
   V5.1.5 22.02.16    4 byte packing added to end TDD1440_Protocol record to avoid 'Error writing to device' error
                      when external trigger selected and running under 64 bit O/S Not clear why this is necessary
                      wdapi1140.dll no longer loaded before axdd1400.dll since not required by axdd1440.dll
   V5.1.6 16.03.16    View->Superimpose traces now works correctly again in recording window
   v5.1.7 07.07.16    4 byte packing added to end TDD1550_Protocol & TDD1550A_Protocol record to avoid 'Error writing to device' error
   V5.1.7 13.07.16    curvefit.pas Access violation when T=0 cursor > half of display width fixed.
                      HekaUnit.pas Correct output channels now set by Heka_WriteDACS()
//                    fixing bug which caused holding voltage to be set to zero.
   V5.1.8 05.08.16    DCLAMPUnit.pas DCLAMP parameters now updated when form opened
                      sealtest.pas Holding potential setting in use now updated with default holding potential of selected amplifier
   V5.1.9 10.08.16    ampmodule.pas Axoclamp 2: Default current gains now correct (10,1,0.1 V/nA) for (HS10,1,0.1)
   V5.2.0 30.08.16    Record to Disk: Record scaling now updated correcting again after amplifier gain
                      is changed (fixes bug introduced in V5.1.7)
   V5.2.1 04.09.16    Digidata 1440,1550,1550A support updated to be compatible with drivers installed by PCLAMP V10.7
          09.09.16    Digidata 1550B supported added to SESLabIO component.
          23.09.16    Interleaved mode added to averaging module
                      Stimulus editor dialog boxes now open in default protocol folder
                      after first installation of WinWCP.
   V5.2.2 12.01.17   .VerticalCursors() now single type and converted to integer by round()
   V5.2.4 28.02.17   On-line analysis: Average within cursors added. settings now stored in
                     Settings.RecPlot and saved in INI file
                     Stimulus Protocols: DigWave protocol added. Scale/Offset parameters added to Wave
          01.03.17   User-defined digital waveform now working
   V5.2.5 03.03.17   Recompiled with Delphi XE6 to correct missing .Zoom property
                     from TRichEdit component which has been added since XE3
   V5.2.6 17.03.17   Record to Disk: Unwanted stimulus produced in first Free Run recording sweep
                     after a stimulus protocol now prevented (rec.pas).
   V5.2.7 28.04.17   Errors when selecting NI PCI-6010 board now fixed
   V5.2.8 19.07.17   Amplifiers: Analog input for secondary channel can now be remapped between
                     voltage- and current- clamp modes for amplifiers which require a different signal output
                     from the amplifier connected to the secondary channel in each clamp mode (applies to Axopatch 200 and AMS-2400)
                     ImportFromDataFile(): Multiple files can now be selected for import to WCP file format.
   V5.2.9 21.09.17   HekaUnit.pas code changed to try to get it working with EPC-9 USB
                     NPI ELC-03XS gain telegraph support updated fixed voltage scaling bug. Now supports alternative secondary channel analogue inputs
   V5.3.0 21.11.17   D/A update rate of NI USB-600X devices now forced to be no more than 500 Hz to avoid intermittent 5 sec delays when calling .ADCStop.
   V5.3.1 25.11.17   Unsupported function error prevented for non-600X boards fixing problem introduced V3.7.9
   V5.3.2 13.12.17   Position of real-time plot analysis area cursors on recording window now maintained when number of samples/record changes.
   V5.3.3 18.01.18   Amplifiers: AMS-2400 voltage gain in current clamp mode now detected correctly.
   V5.3.4 12.02.18   Measure.pas %Quantile calculation speeded up using QuickSort and by restricting no. points sorted to a sample of 5000 max. from analysis region
   V5.3.5 08.05.18   Tecella Triton support updated. Junction potential offset determined in voltage-clamp mode now subtracted from membrane potential in
                     current-clamp mode. Current stimulus bias current offset can now be added to set stimulus current to zero current-clamp mode.
   V5.3.6 16.05.18   Amplifiers: PrimaryScaleFactorX1, SecondayScaleFactorX1 now set in correct units by Multiclamp and therefore appears correctly in Amplifiers Setup.
   V5.3.7 31.05.18   Sine wave protocol element added to stimulus protocols
   V5.3.8 16.07.18   DD1550B.DLL now included in installation file
   V5.3.9 22.07.18   On-Line Analysis: Find Cursors button added allowing measurement cursors to be placed on default locations on the signal display
   V5.4.0 24.09.18   Seal Test: End of holding level averaging region shifted slightly early to avoid it overlapping with test pulse when D/A update
                     interval is longer than sampling interval. Amplifiers: Heka EPC-800 current command output now allocated to a different analog out channel
                     since this amplifier has separate voltage- and current-clamp command inputs.
   V5.4.1 05.11.18   LEAK records can now be excluded from on-line plots.
   V5.4.2 22.02.19   Seal Test: End of test pulse steady-state analysis region now defined from time of test pulse end
   //                rather than from 50% transition between test and holding levels Done to avoid possibility of inclusion
   //                of part of capacity current when edges of voltage step transitions are slow.
   V5.4.3 03.04.19   Tecella Triton control panel updated to simplify and improve capacity and JP compensation. Some bugs fixed.
                     Additional ACTIVE X commands added for control of Pico 2 functions from other applications.
   V5.4.4 05.04.19   THold now correctly set in SESLABIO.TritonAutoCompensate. THold=20ms, VStep=10mV, TStep=20ms now used as defaults for
                     autocomp test pulses.
   V5.4.5 17.04.19   Triton: G Leak now implemented as 3 components (Rleak, Rleak fine and Rleak digital). Seal test readout average now
                     reset when parameters change on Triton control panel
                     Sealtest: Reset Avg. button added allowing user to manually reset cell R/C averages.

   V5.4.6 22.05.19   Sealtest: Large incorrect measurements of Ga,Gm,Cm due to noise/interference now excluded
                     from average and average restricted to most recent <n> measurements. G access computation mode
                     (from peak or exponential amplitude) option setting now preserved in INI file and can be set
                     by .SealTestGaFromPeak Active X command. No. of cell parameter measurements averaged can now be set by
                     .SealTestNumAverages command. Ga,Gm,Cm etc. now displayed as 0 if no data available.
   V5.4.7 07.07.19  Position and size of WinWCP program window now saved in INI file and restored program restarted
                    SaveInitialisationFile() and other items in FormClose() moved to FormDestroy() to ensure they are
                    called when program shut down at end of COM command.
   V5.4.8 16.07.19  Records can now exported as ASCII tables as a series of columns containing channels and records.
   V5.4.9 30.07.19  Waveform measurement: Rise time limits now stored in WCP file header
   V5.5.0 12.08.19  Waveform measurement: Abs(Area) absolute area measurement added
   V5.5.1 15.08.19  Waveform measurement: % trigger point for latency measurement can now be set by user between 0.1 - 100% of peaK
   V5.5.2 28.08.19  Digidata 1440-1550B Axoscope program folder name used to obtain DLLs for 64 bit systems corrected
   V5.5.3 03.01.20  dd1320.pas Access violation when unable to find installed Digidata 132X device now fixed, so WinWCP now reverts to
                    no device selected when Digidata 1320X device selected and not present.
          28.01.20  Amplifiers: A-M Systems 2400 gain telegraphs now work correcly with latest versions of amplifiers which had
                    gain telegraph voltages reduced by 0.2V.
   V5.5.4 06.02.20  Stimulus Protocols: PulseStaircase waveform type producing a series of pulses on a rising staircase added.
   V5.5.5 04.06.20 Rec.pas Free run record duration and sampling interval can now be set more precisely.
                   Export.pas Export of data records as columns of ascii text now in correct columns
   V5.5.6 23.12.20 recplot.pas Rising Slope to absolute peak measurement now returned correctly. Previously, when absolute peak detection
                   selected TRise was returned by mistake
   V5.5.7 04.08.21 Seal test. Default holding voltage now updated when additional stimulus outputs selected. Seal test pulse update rate now faster
                   AmpModule.pas WPI EVC-4000 added and Axoclamp 900A support updated (but not tested with actual hardware)
   V5.5.8 17.08.21 Waveform Measurements: Peak-peak peak measurement option added
                   WCPMaxCHannels renamed MaxCHannels to allow modules to be swapped with WinEDR program
   V5.5.9 23.08.21 Tecella Triton X now supported.
   V5.6.0 27.08.21 Triton control panel updated. Now shuts down A/D and D/A in RecordFrm as well as seal test
   V5.6.1 14.09.21 Axoclamp 900A: debugging information now listed in status bar
   V5.6.2 14.09.21 Axoclamp 900A: Demo mode turned off
   V5.6.3 22.11.21 CED Micro 1401 Mk4 now supported. Bugs in ADCMEM and DIGTIM fixed by Greg Smith CED.
                   Bug in Qanal.pas causing standard deviation to be underestimated when non-linear summation correction in used fixed.
                   Corrected and uncorrected mean and s.d. now reported.
                   Synaptic signal simulation module updated to correctly apply effects of non-linear summation of potentials
                   so that simulated quantal content now correctly determined by qanal.pas
   V5.6.4 24.11.21 CED support updated to make consistent with WinEDR version
   V5.6.5 02.12.21 Stimulus Protocol Editor: Initial delay for user-entered waveforms no longer fixed at default of 10ms.
                   All amplitude and time parameters now displayed with 6 figure precision to avoid rounding errors in D/A update interval.
                   Speed of display of large user-defined waveforms increased by limiting display to a sample of 10000 points within waveform.
   V5.6.6 09.12.21 Stimulus protocols: Sine wave element frequency increments can now be multiplicative as well as additive.
                   CED 1401: Minimum D/A update rate of CED Power 1401s reduced from 100 microsec to 10 microsec
   V5.6.7 29.01.22 Heka amplifiers; Amplifier # no longer forced to be at zero.
   V5.6.8 21.02.22 Debug log for Digidata 1440 added
   V5.6.9 09.03.22 Waveform Measurements: Latency measurement now correctly calculated
   V5.7.0 23.05.22 Ext Trigger and Ext Stimulus Trigger now works with Tecella Pico 2 patch clamp
   V5.7.1 22.07.22 CopyStringGrid moved from shared to TMain.
                   Shared,global,plotlib units removed and methods redistributed to WCPFileUnit,Maths,Main
                   MeasureFrm: Option added to measure decay from peak to fixed signal level
   V5.7.2 09.11.22 Waveform measurements: Peak mode and T0,C0,C1 cursor positions now stored in WCP file header.
                   Screen position of main program window now saved in INI file
                   .FileName COM automation property added
   V5.7.3 21.02.23 ExportUnit.pas Incorrect scaling of channel signals when channel gains were non-unitary fixed.
                   Export now terminated when channel gain changes within WCP files.
                   Export file list now intialised to currently open file even if display window not initially openb.
   V5.7.4 03.04.23 Digital clock support temporarily disabled for NI 6353 devices to determine
                   if there is a programming incompatibility with 32 bit Port0
   V5.7.5 06.07.23 DCLAMPUNIT Settings now saved and loaded correctly fixing bug introduced in V5.7.1
   V5.7.6 04.09.23 Seal test holding voltages no longer updated by default holding voltage when seal test form opened
   V5.7.7 30.10.23 Seal test auto scale option  now toggled by F6 key
   V5.7.8 11.01.24 Rec.pas Protocol list editing issues fixed. Protocol addition disabled when no list exists. Protocols are now added to list in correct order
   V5.7.9 23.06.24 Measure & Curve Fit Time of day variable added
                   Curve fit results now stored in seperate .fit.fpd & .fit.csv data files
   V5.8.0 05.08.24 Minor changes in ExportUnit and StimUnit to fix issues which arose when porting to Delphi 11.1 compiler
            =======================================================================}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Menus, Replay,
  Measure, Average, PrintRec, Rec, CurvFit, SimSyn,SimHH, SealTest,
  LeakSub, About, RecEdit,Log, QAnal, DrvFun, defset,
  SESLabIO, ced1902u, ComCtrls, ADCDataFile, strutils, math, StdCtrls,FileCtrl,
  UITypes, Vcl.HtmlHelpViewer, shlobj, ioutils, WCPFIleUnit, VCL.Grids,ClipBrd ;

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
    mnInspectLogFile: TMenuItem;
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
    procedure mnInspectLogFileClick(Sender: TObject);
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
    procedure FormDestroy(Sender: TObject);
  private

    procedure SetRecentFileItem( MenuItem : TMenuItem ; FileName : string ) ;
    function ImportFromDataFile : Boolean ;

    procedure DefaultHandler( Var Message ) ; override ;

    procedure UpdateDisplays ;


  public

   // Cell parameters
   RSeal : Single ; // Seal Resistance (Ohms)
   Gm : Single ;    // Cell membrane conductance (S)
   Ga : Single ;    // Pipette access conductance (S)
   Cm : Single ;    // Cell capacity (F)
   Vm : Single ;    // Cell membrane voltage (V)
   Im : Single ;    // Cell membrane current (A)


   procedure NewFileUpdate ;
    procedure SetMenus ;
    procedure CloseFormsAndDataFile ;

    procedure ShowChannel( Chan : Integer ; MenuItem : TMenuItem ) ;
    procedure UpdateMDIWindows ;
    function UpdateCaption( var FH : TFileHeader ; Title : string ) : string ;
    function FormExists( FormName : String ) : Boolean ;

    function ShowTritonPanel : Boolean ;

    procedure UpdateRecentFilesList ;

    function DateToStr( DateTime : TDateTime ) : String ;
    function StrToDate( DateTime : String ) : TDateTime ;
    procedure CopyStringGrid( Table : TStringGrid ) ;
    end;

var
  Main: TMain;

implementation

{$R *.dfm}

uses Pwrspec, SimMEPSC, AmpModule, maths , VP500Panel,
  ImportASCIIUnit, ImportRawUnit , exportUnit, FilePropsUnit,
  RecPlotUnit, TritonPanelUnit , EditProtocolUnit, LabInterfaceSetup,
  InputChannelSetup, EPC9PanelUnit , DCLAMPUnit ;

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

      WCPFile.ProgVersion := 'V5.8.0' ;
      Caption := 'WinWCP : Strathclyde Electrophysiology Software ' + WCPFile.ProgVersion ;

      Application.HelpFile := WCPFile.Settings.ProgDirectory + 'WinWCP.chm';

      { Create clipboard file name for Copy/Insert of records }
      WCPClipboardFileName := TPath.GetTempPath + 'WCPClipboardFile.tmp' ;
      { Delete any existing clipboard files }
      if FileExists(WCPClipboardFileName) then DeleteFile (PChar(WCPClipboardFileName)) ;

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

     mnDisplayGrid.Checked := WCPFile.Settings.DisplayGrid ;
     mnStoreTraces.Checked := not WCPFile.Settings.AutoErase ;

     { Enable Windows menu to show active MDI windows }
     WindowMenu := Windows ;

     WCPFile.RawfH.MinADCValue := SESLabIO.ADCMinValue ;
     WCPFile.RawFH.MaxADCValue := SESLabIO.ADCMaxValue ;

     { Add names of recently accessed data files to Files menu }
     mnRecentFileSeparator.Visible := False ;
     SetRecentFileItem( mnRecentFile0, WCPFile.Settings.RecentFiles[0] ) ;
     SetRecentFileItem( mnRecentFile1, WCPFile.Settings.RecentFiles[1] ) ;
     SetRecentFileItem( mnRecentFile2, WCPFile.Settings.RecentFiles[2] ) ;
     SetRecentFileItem( mnRecentFile3, WCPFile.Settings.RecentFiles[3] ) ;

     { Open a data file if one has been supplied in parameter string }
     FileName :=  '' ;
     for i := 1 to ParamCount do begin
         if i > 1 then FileName := FileName + ' ' ;
         FileName := FileName + ParamStr(i) ;
         end ;

     // Initialise channel display settings to minimum magnification
     for ch := 0 to WCPMaxChannels-1 do begin
         WCPFile.Channel[ch].Cursor0 := 0 ;
         WCPFile.Channel[ch].Cursor1 := WCPFile.RawFH.NumSamples div 2 ;
         WCPFile.Channel[ch].xMin := 0. ;
         WCPFile.Channel[ch].xMax := WCPFile.RawfH.NumSamples-1 ;
         WCPFile.Channel[ch].yMin := SESLabIO.ADCMinValue ;
         WCPFile.Channel[ch].yMax := SESLabIO.ADCMaxValue ;
         end ;

     if ANSIContainsText( ExtractFileExt(FileName),'.wcp') then begin
        if FileExists(FileName) then begin
           if (FileGetAttr(FileName) AND faReadOnly) = 0 then WCPFile.LoadDataFiles(FileName)
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
     if WCPFile.Settings.DataDirectory <> '' then begin
        SetCurrentDir(WCPFile.Settings.DataDirectory) ;
        OpenDialog.InitialDir := WCPFile.Settings.DataDirectory ;
        end;
     OpenDialog.FileName := '' ;

     OpenDialog.Filter := ' WCP Files (*.WCP)|*.WCP';
     OpenDialog.Title := 'Open File ' ;

     if OpenDialog.execute then begin
        // Load selected file
        if (FileGetAttr(OpenDialog.FileName) AND faReadOnly) = 0 then begin
            WCPFile.LoadDataFiles( OpenDialog.FileName ) ;
            // Update list of recently used files
            UpdateRecentFilesList ;
            WCPFile.WriteToLogFile( 'Data file: ' + OpenDialog.FileName + ' open.' ) ;
            end
         else ShowMessage( OpenDialog.FileName + ' is READ-ONLY. Unable to open!') ;
         end ;

     end;


procedure TMain.ShowChannel(
          Chan : Integer ;
          MenuItem : TMenuItem
          ) ;
{ --------------------------------------
  Make Channel item in View menu visible
  -------------------------------------- }
begin
     if Chan < WCPFile.RawFH.NumChannels then begin
        MenuItem.Visible := True ;
        MenuItem.Checked := WCPFile.Channel[Chan].InUse ;
        MenuItem.Caption := format(' Ch.%d %s',[Chan,WCPFile.Channel[Chan].ADCName]) ;
        end
     else  MenuItem.Visible := False ;
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

     if WCPFile.RawFH.NumRecords <= 0 then Exit ;

     WCPFile.fH := WCPFile.RawFH ;
     WCPFile.GetHeader(WCPFile.fH) ;

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
     WCPFile.fH := WCPFile.AvgFH ;
     WCPFile.GetHeader( WCPFile.fH ) ;
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
     WCPFile.fH := WCPFile.LeakFH ;
     WCPFile.GetHeader( WCPFile.fH) ;
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
     WCPFile.fH := WCPFile.DrvFH ;
     WCPFile.GetHeader( WCPFile.fH ) ;
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
     WCPFile.CloseAllDataFiles ;

     Caption := 'WinWCP : Strathclyde Electrophysiology Software ' + WCPFile.ProgVersion ;
     
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
var
    i : integer ;
begin

     { Present user with standard Save File dialog box }
     SaveDialog.options := [ofOverwritePrompt,ofHideReadOnly,ofPathMustExist] ;
     SaveDialog.DefaultExt := 'WCP' ;
     SaveDialog.FileName := WCPFile.CreateIndexedFileName( WCPFile.RawFH.FileName ) ;
     SaveDialog.Filter := ' WCP Files (*.WCP)|*.WCP' ;
     SaveDialog.Title := 'New Data File' ;
     if WCPFile.Settings.DataDirectory <> '' then begin
        SaveDialog.InitialDir := WCPFile.Settings.DataDirectory ;
        SetCurrentDir(WCPFile.Settings.DataDirectory) ;
        end;

     if SaveDialog.execute then
        begin

        WCPFile.CreateNewDataFile( SaveDialog.FileName ) ;

        mnShowRaw.checked := False ;
        mnShowAveraged.checked := False ;
        mnShowAveraged.visible := False ;
        mnShowLeakSubtracted.checked := False ;
        mnShowLeakSubtracted.Visible := False ;

        for i := 0 to MDIChildCount-1 do
            if MDIChildren[i].Name = 'RecordFrm' then
            begin
            RecordFrm.caption := 'Record ' + WCPFile.RawFH.FileName ;
            RecordFrm.edStatus.Text := '' ;
            end ;

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
     if WCPFile.RawFH.FileHandle >= 0 then begin
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
           if WCPFile.RawFH.NumRecords > 0 then begin
              Analysis.Enabled := True ;
              mnPrint.Enabled := True ;
              mnExport.Enabled := True ;
              Edit.Enabled := True ;
              CopyRecord.Enabled := True ;
              DeleteRecord.Enabled := True ;
              DeleteRejected.Enabled := True ;
              mnShowRaw.Visible := True ;

              { Enable display of averages (if they exist) }
              if (WCPFile.AvgFH.FileHandle > 0) and (WCPFile.AvgFH.NumRecords > 0) then
                 mnShowAveraged.visible := True
              else mnShowAveraged.visible := False ;
              { Enable display of leak subtracted records (if they exist) }
              if (WCPFile.LeakFH.FileHandle > 0) and (WCPFile.LeakFH.NumRecords > 0) then
                 mnShowLeakSubtracted.visible := True
              else mnShowLeakSubtracted.visible := False ;
              { Enable display of leak subtracted records (if they exist) }
              if (WCPFile.DrvFH.FileHandle > 0) and (WCPFile.DrvFH.NumRecords > 0) then
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
        WCPFile.GetRecord(WCPFile.FH,RH,WCPFile.FH.RecordNum,ADC^) ;
        { Copy current file header into clipboard header }
        ClipFH := WCPFile.FH ;
        { Open the clipboard file }
        ClipFH.FileName := WCPClipboardFileName ;
        ClipFH.FileHandle := FileCreate( ClipFH.FileName ) ;
        if ClipFH.FileHandle >= 0 then begin
           ClipFH.NumRecords := 1 ;
           { Save record to file }
           WCPFile.PutRecord(ClipFH,RH,ClipFH.NumRecords,ADC^) ;
           WCPFile.SaveHeader( ClipFH ) ;
           WCPFile.FileCloseSafe( ClipFH.FileHandle ) ;
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
           WCPFile.GetHeader( ClipFH ) ;

           { If the currently open data file is empty
           transfer the file header from the clipboard file }
           if WCPFile.FH.NumRecords = 0 then begin
              TempName := WCPFile.FH.FileName ;
              TempHandle := WCPFile.FH.FileHandle ;
              WCPFile.FH := ClipFH ;
              WCPFile.FH.FileName := TempName ;
              WCPFile.FH.FileHandle := TempHandle ;
              end ;

           { Calculate scaling factors to account for differences in channel
           calibration factors }
           WCPFile.GetHeader( WCPFile.FH ) ;
           for ch := 0 to WCPFile.FH.NumChannels-1 do begin
               Scale[ch] := WCPFile.Channel[ch].ADCCalibrationFactor ;
               end ;
           WCPFile.GetHeader (ClipFH) ;
           for ch := 0 to WCPFile.FH.NumChannels-1 do begin
               Scale[ch] := Scale[ch] / WCPFile.Channel[ch].ADCCalibrationFactor ;
               end ;
           WCPFile.GetHeader( WCPFile.FH ) ;

           { Check if the record is compatible with current file }
           if (WCPFile.FH.NumChannels <> ClipFH.NumChannels) or
              (WCPFile.FH.NumSamples <> ClipFH.NumSamples) then begin
              ShowMessage( ' Record not added. Size or no. channels incompatible' ) ;
              OK := False ;
              end ;
           end ;


        { Insert/append record from clip file }

        if OK then begin
           Inc(WCPFile.FH.NumRecords) ;

           if Sender = InsertRecord then begin
              { *** Insert record at current position in file *** }
              { Move all records above the current position up by 1 }
              for i := WCPFile.FH.NumRecords-1 downto WCPFile.FH.CurrentRecord do begin
                  WCPFile.GetRecord(WCPFile.FH,RH,i,ADC^) ;
                  WCPFile.PutRecord(WCPFile.FH,RH,i+1,ADC^) ;
                  end ;
              if WCPFile.FH.NumRecords = 1 then WCPFile.FH.CurrentRecord := 1 ;
              InsertAt := WCPFile.FH.CurrentRecord ;
              end
           else begin
              { *** Append to end of file *** }
              InsertAt := WCPFile.FH.NumRecords
              end ;

           { Get record from WCP clipboard file }
           WCPFile.GetRecord(ClipFH,RH,1,ADC^) ;
           { Close file }
           WCPFile.FileCloseSafe( ClipFH.FileHandle ) ;

           { Adjust for possible differences in channel calibration factors }
           for ch := 0 to WCPFile.FH.NumChannels-1 do begin
               RH.ADCVoltageRange[ch] := RH.ADCVoltageRange[ch]*Scale[ch] ;
               end ;

           { Copy record to file }
           WCPFile.PutRecord(WCPFile.FH,RH,InsertAt,ADC^) ;
           WCPFile.SaveHeader(WCPFile.FH) ;

           { Ensure that appropriate file header is updated }
           WCPFile.UpdateFileHeaderBlocks ;

           if (WCPFile.FH.NumRecords = 1) then begin
              { If this is the first record of a raw data file after New File
              enable menus and display the View window }
              WCPFile.FH := WCPFile.RawFH ;
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
           WCPFile.GetHeader( ClipFH ) ;

           { If the currently open data file is empty
           transfer the file header from the clipboard file }
           if WCPFile.FH.NumRecords = 0 then begin
              TempName := WCPFile.FH.FileName ;
              TempHandle := WCPFile.FH.FileHandle ;
              WCPFile.FH := ClipFH ;
              WCPFile.FH.FileName := TempName ;
              WCPFile.FH.FileHandle := TempHandle ;
              end ;

           { Calculate scaling factors to account for differences in channel
           calibration factors }
           WCPFile.GetHeader( WCPFile.FH ) ;
           for ch := 0 to WCPFile.FH.NumChannels-1 do begin
               Scale[ch] := WCPFile.Channel[ch].ADCCalibrationFactor ;
               end ;
           WCPFile.GetHeader (ClipFH) ;
           for ch := 0 to WCPFile.FH.NumChannels-1 do begin
               Scale[ch] := Scale[ch] / WCPFile.Channel[ch].ADCCalibrationFactor ;
               end ;
           WCPFile.GetHeader( WCPFile.FH ) ;

           { Check if the record is compatible with current file }
           if (WCPFile.FH.NumChannels <> ClipFH.NumChannels) or
              (WCPFile.FH.NumSamples <> ClipFH.NumSamples) then begin
              ShowMessage( ' Record not added. Size or no. channels incompatible' ) ;
              OK := False ;
              end ;
           end ;

        { Insert/append record from clip file }

        if OK then begin
           Inc(WCPFile.FH.NumRecords) ;

           if Sender = InsertRecord then begin
              { *** Insert record at current position in file *** }
              { Move all records above the current position up by 1 }
              for i := WCPFile.FH.NumRecords-1 downto WCPFile.FH.CurrentRecord do begin
                  WCPFile.GetRecord(WCPFile.FH,RH,i,ADC^) ;
                  WCPFile.PutRecord(WCPFile.FH,RH,i+1,ADC^) ;
                  end ;
              if WCPFile.FH.NumRecords = 1 then WCPFile.FH.CurrentRecord := 1 ;
              InsertAt := WCPFile.FH.CurrentRecord ;
              end
           else begin
              { *** Append to end of file *** }
              InsertAt := WCPFile.FH.NumRecords
              end ;

           { Get record from WCP clipboard file }
           WCPFile.GetRecord(ClipFH,RH,1,ADC^) ;
           { Close file }
           WCPFile.FileCloseSafe( ClipFH.FileHandle ) ;

           { Adjust for possible differences in channel calibration factors }
           for ch := 0 to WCPFile.FH.NumChannels-1 do begin
               RH.ADCVoltageRange[ch] := RH.ADCVoltageRange[ch]*Scale[ch] ;
               end ;

           { Copy record to file }
           WCPFile.PutRecord(WCPFile.FH,RH,InsertAt,ADC^) ;
           WCPFile.SaveHeader(WCPFile.FH) ;

           { Ensure that appropriate file header is updated }
           WCPFIle.UpdateFileHeaderBlocks ;

           if (WCPFile.FH.NumRecords = 1) then begin
              { If this is the first record of a raw data file after New File
              enable menus and display the View window }
              WCPFile.FH := WCPFile.RawFH ;
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
begin
    if MessageDlg( 'Delete record! Are you Sure? ', mtConfirmation,
          [mbYes,mbNo], 0 ) = mrYes then
          begin
          WCPFile.DeleteRecord ;
          { Refresh child windows }
          UpdateMDIWindows ;
          end ;

    end ;


procedure TMain.DeleteRejectedClick(Sender: TObject);
{ - Menu Item ------------------------------
  Delete rejected records from the data file
  ------------------------------------------}
begin

     if MessageDlg( 'Delete rejected records! Are you Sure? ', mtConfirmation,
                    [mbYes,mbNo], 0 ) = mrYes then
       begin
       WCPFile.DeleteRejected ;
       { Refresh child windows }
       UpdateMDIWindows ;
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



procedure TMain.mnInspectLogFileClick(Sender: TObject);
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

     if ImportFromDataFile then begin
        WCPFile.LoadDataFiles(WCPFile.RawFH.FileName) ;
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


procedure TMain.FormDestroy(Sender: TObject);
{ ---------------------------------
  Tidy up when form is destroyed
  ---------------------------------}
var
    i : Integer ;
begin

       { Close recording and seal test windows to ensure that
         laboratory interface systems are shutdown (to avoid system crash }
       for i := 0 to MDIChildCount-1 do begin
         if MDIChildren[i].Name = 'SealTestFrm' then SealTestFrm.Close ;
         if MDIChildren[i].Name = 'TritonPanelFrm' then TritonPanelFrm.Close ;
         if MDIChildren[i].Name = 'EPC9PanelFrm' then EPC9PanelFrm.Close ;
         if MDIChildren[i].Name = 'RecordFrm' then RecordFrm.Close ;
         end ;


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
     if WCPFile.Settings.DataDirectory <> '' then SetCurrentDir(WCPFile.Settings.DataDirectory) ;
     OpenDialog.InitialDir := WCPFile.Settings.DataDirectory ;

     if OpenDialog.execute then begin

        WCPFile.Settings.DataDirectory := ExtractFilePath( OpenDialog.FileName ) ;

        WCPFile.AppendWCPFile( OpenDialog.FileName ) ;
        WCPFile.fH := WCPFile.RawFH ;

        UpdateMDIWindows ;

        { Set display magnification to minimum }
        if WCPFile.fH.NumRecords > 0 then begin
           mnZoomOutAll.Click ;
           mnShowRaw.Visible := True ;
           mnShowRaw.Click ;
           end
        else mnShowRaw.Visible := False ;
        SetMenus ;
        { Update file header blocks with changes made to FH }
        WCPFile.UpdateFileHeaderBlocks ;
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
     WCPFile.CloseAllDataFiles ;

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
        if WCPFile.RawfH.NumRecords > 0 then ReplayFrm := TReplayFrm.Create(Self) ;
        end ;

     if FormExists( 'MeasureFrm' ) then MeasureFrm.NewFile ;
     if FormExists( 'FitFrm' ) then FitFrm.NewFile ;
     if FormExists( 'AvgFrm' ) then AvgFrm.NewFile ;

     SetMenus ;

     end;




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
     FileName := WCPFile.Settings.RecentFiles[TMenuItem(Sender).Tag] ;
     if (FileName <> '') and FileExists(FileName) then begin
        if (FileGetAttr(FileName) AND faReadOnly) = 0 then WCPFile.LoadDataFiles( FileName )
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
     WCPFile.Settings.AutoErase := not mnStoreTraces.Checked ;
     end;


procedure TMain.mnDisplayGridClick(Sender: TObject);
{ -----------------------------------------------------
  Enable/display grid overlay on oscilloscope displays
  ----------------------------------------------------- }
begin
     WCPFile.Settings.DisplayGrid := not WCPFile.Settings.DisplayGrid ;
     mnDisplayGrid.Checked := WCPFile.Settings.DisplayGrid ;
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
     for ch := 0 to WCPFile.RawFH.NumChannels-1 do
         if WCPFile.Channel[ch].InUse then Inc(NumChannelsOnDisplay) ;

     { Toggle menu checked state }
     TMenuItem(Sender).Checked := not TMenuItem(Sender).Checked ;
     { If this is the only channel on display, don't turn it off }
     if (NumChannelsOnDisplay=1) and (TMenuItem(Sender).Checked=False) then
        TMenuItem(Sender).Checked := True ;
     { Update channel display setting N.B. Tag property contains channel # }
     WCPFile.Channel[TMenuItem(Sender).Tag].InUse := TMenuItem(Sender).Checked ;
     { Update windows currently open }
     UpdateMDIWindows ;
     end;




procedure TMain.mnInterleaveClick(Sender: TObject);
{ - Menu Item -------------------------------------------
  Append records from another WCP data file (convert.pas)
  -------------------------------------------------------}
begin
     OpenDialog.options := [ofPathMustExist] ;
     OpenDialog.DefaultExt := 'WCP' ;
     OpenDialog.Filter := ' WCP Files (*.WCP)|*.WCP';
     OpenDialog.Title := 'Interleave File ' ;
     if WCPFile.Settings.DataDirectory <> '' then SetCurrentDir(WCPFile.Settings.DataDirectory);
     OpenDialog.InitialDir := WCPFile.Settings.DataDirectory ;

     if OpenDialog.execute then begin

        WCPFile.Settings.DataDirectory := ExtractFilePath( OpenDialog.FileName ) ;

        WCPFile.InterleaveWCPFile( OpenDialog.FileName ) ;
        WCPFile.fH := WCPFile.RawFH ;

        UpdateMDIWindows ;

        { Set display magnification to minimum }
        if WCPFile.fH.NumRecords > 0 then begin
           mnZoomOutAll.Click ;
           mnShowRaw.Visible := True ;
           mnShowRaw.Click ;
           end
        else mnShowRaw.Visible := False ;
        SetMenus ;
        { Update file header blocks with changes made to FH }
        WCPFile.UpdateFileHeaderBlocks ;
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
   i,j,j0,iFile : Integer ;
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
     OpenDialog.options := [ofPathMustExist,ofAllowMultiSelect] ;
     OpenDialog.DefaultExt := 'DAT' ;
     OpenDialog.FileName := '' ;

     OpenDialog.Title := 'Import File ' ;
     if WCPFile.Settings.DataDirectory <> '' then begin
        SetCurrentDir(WCPFile.Settings.DataDirectory);
        OpenDialog.InitialDir := WCPFile.Settings.DataDirectory ;
        end;

     if not OpenDialog.execute then Exit ;

     for iFile := 0 to OpenDialog.Files.Count-1 do
         begin

         WCPFile.Settings.DataDirectory := ExtractFilePath( OpenDialog.FileName ) ;
         FileType := Filters[OpenDialog.FilterIndex].FType ;
         FileName := OpenDialog.Files[iFile] ;

         { Create name of WCP file to hold imported file }
         WCPFileName := ChangeFileExt( FileName, DataFileExtension ) ;
         { Make sure an existing data file is not overwritten, unintentionally }
         if not WCPFile.FileOverwriteCheck(WCPFileName ) then Exit ;

         // Report progress
         Main.StatusBar.SimpleText := format(
         ' IMPORT: Importing data from %s ',[FileName] ) ;

         if FileType = ftASC then
            begin
            // ASCII format data files
            ImportASCIIFrm.ImportFile := ImportFile ;
            ImportASCIIFrm.FileName := FileName ;
            if ImportASCIIFrm.ShowModal <> mrOK Then Exit ;
            if not Main.ImportFile.OpenDataFile( FileName, FileType ) then Exit ;
            end
         else if FileType = ftRaw then
            begin
            // Raw binary data files
            ImportRawFrm.ImportFile := ImportFile ;
            if ImportRawFrm.ShowModal <> mrOK Then Exit ;
            if not Main.ImportFile.OpenDataFile( FileName, FileType ) then Exit ;
            end
         else if FileType = ftHEK then
            begin
            // HEKA data files
            if not Main.ImportFile.OpenDataFile( FileName, FileType ) then Exit ;
            end
         else begin
           // All other data files
           FileType := ImportFile.FindFileType( FileName ) ;
           if not Main.ImportFile.OpenDataFile( FileName, FileType ) then Exit ;
           end ;

         if (Main.ImportFile.NumScansPerRecord*Main.ImportFile.NumChannelsPerScan)
             > MaxADCSamples then begin
             ShowMessage( format(
             ' IMPORT: Unable to import files with more than %d samples/record!',
             [MaxADCSamples div Main.ImportFile.NumChannelsPerScan])) ;
             Main.ImportFile.CloseDataFile ;
             Exit ;
             end ;

         { Create WCP data file to hold import}
         if not WCPFile.CreateNewDataFile( WCPFileName ) then Exit ;

         GetMem( Buf, SizeOf(TSmallIntArray)) ;
         WCPFile.RawFH.NumChannels := Main.ImportFile.NumChannelsPerScan ;

         // Ensure that no. of samples/channel is multiple of 256
         WCPFile.RawFH.NumSamples := (Main.ImportFile.NumScansPerRecord div 256)*256 ;
         if WCPFile.RawFH.NumSamples < Main.ImportFile.NumScansPerRecord then
         WCPFile.RawFH.NumSamples := WCPFile.RawFH.NumSamples + 256 ;

         WCPFile.RawFH.NumAnalysisBytesPerRecord := WCPFile.NumAnalysisBytesPerRecord(WCPFile.RawFH.NumChannels) ;
         WCPFile.RawFH.MaxADCValue := Main.ImportFile.MaxADCValue ;
         WCPFile.RawFH.MinADCValue := Main.ImportFile.MinADCValue ;
         WCPFile.RawFH.IdentLine := Main.ImportFile.IdentLine ;

         { Copy records }
         WCPFile.RawFH.NumRecords := 0 ;
         for iRec := 1 to Main.ImportFile.NumRecords do
             begin
             Main.ImportFile.RecordNum := iRec ;
             WCPFile.RawFH.ADCVoltageRange := Main.ImportFile.ChannelADCVoltageRange[0] ;
             for ch := 0 to Main.ImportFile.NumChannelsPerScan-1 do
                 begin
                 WCPFile.Channel[ch].ChannelOffset := Main.ImportFile.ChannelOffset[ch] ;
                 WCPFile.Channel[ch].ADCName := Main.ImportFile.ChannelName[ch] ;
                 WCPFile.Channel[ch].ADCUnits := Main.ImportFile.ChannelUnits[ch] ;
                 WCPFile.Channel[ch].ADCSCale := Main.ImportFile.ChannelScale[ch] ;
                 WCPFile.Channel[ch].ADCCalibrationFactor := Main.ImportFile.ChannelCalibrationFactor[ch] ;
                 WCPFile.Channel[ch].ADCAmplifierGain := Main.ImportFile.ChannelGain[ch] ;
                 WCPFile.Channel[ch].YMax := WCPFile.RawFH.MaxADCValue ;
                 WCPFile.Channel[ch].YMin := WCPFile.RawFH.MinADCValue ;
                 end ;

             { Copy sampling interval and A/D range }
             WCPFile.RawFH.dt := Main.ImportFile.ScanInterval ;
             WCPFile.RawFH.ADCVoltageRange := Main.ImportFile.ChannelADCVoltageRange[0] ;

             // Read A/D sample from source file
             NumRead := Main.ImportFile.LoadADCBuffer(0,Main.ImportFile.NumScansPerRecord,Buf^ ) ;
             if NumRead <= 0 then Break ;

             // Pad end of buffer
             j0 := (NumRead-1)*WCPFile.RawFH.NumChannels ;
             for i := NumRead-1 to WCPFile.RawFH.NumSamples-1 do
                 begin
                 j := i*WCPFile.RawFH.NumChannels ;
                 for ch := 0 to WCPFile.RawFH.NumChannels-1 do Buf^[j+ch] := Buf^[j0+ch] ;
                 end ;

             { Save record to file }
             Inc(WCPFile.RawFH.NumRecords) ;
             RH.Status := 'ACCEPTED' ;
             RH.RecType := 'TEST' ;
             RH.Number := WCPFile.RawFH.NumRecords ;
             RH.Time := RH.Number ;
             RH.dt := WCPFile.RawfH.dt ;
             RH.Ident := ' ' ;
             for ch := 0 to WCPFile.RawFH.NumChannels do RH.ADCVoltageRange[ch] :=
                                                 Main.ImportFile.ChannelADCVoltageRange[ch] ;
             RH.Value[vFitEquation] := 0.0 ;
             RH.AnalysisAvailable := False ;
             WCPFile.PutRecord( WCPFile.RawfH, RH, WCPFile.RawfH.NumRecords, Buf^ ) ;

             // Report progress
             Main.StatusBar.SimpleText := format(
             ' IMPORT: Importing (%d channel) record %d/%d from %s ',
             [Main.ImportFile.NumChannelsPerScan,iRec,Main.ImportFile.NumRecords,FileName]) ;

             end ;

        //Final progress
        Main.StatusBar.SimpleText := format(
        'IMPORT: %d records (%dx%d channel scans) imported from %s to %s',
        [ Main.ImportFile.NumRecords,
          Main.ImportFile.NumScansPerRecord,
          Main.ImportFile.NumChannelsPerScan,
          FileName,
          WCPFile.RawFH.FileName]) ;
        WCPFile.WriteToLogFile( Main.StatusBar.SimpleText ) ;

        { Save file header }
        WCPFile.SaveHeader( WCPFile.RawFH ) ;

        { Close source file }
        Main.ImportFile.CloseDataFile ;

        { Close dest. file }
        if WCPFile.RawFH.FileHandle >= 0 then
           begin
           FileClose( WCPFile.RawFH.FileHandle ) ;
           WCPFile.RawFH.FileHandle := -1 ;
           end ;

        FreeMem ( Buf ) ;
        Result := True ;
        end ;

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

     if WCPFile.RawFH.FileHandle >= 0 then mnShowRaw.Visible := True
                              else mnShowRaw.Visible := False ;
     if WCPFile.AvgFH.FileHandle >= 0 then mnShowAveraged.Visible := True
                              else mnShowAveraged.Visible := False ;
     if WCPFile.LeakFH.FileHandle >= 0 then mnShowLeakSubtracted.Visible := True
                               else mnShowLeakSubtracted.Visible := False ;
     if WCPFile.DrvFH.FileHandle >= 0 then mnShowDrivingFunction.Visible := True
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
        TritonPanelFrm.Top := 15 ;
        TritonPanelFrm.Left := 710 ;
        end ;

     end;



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

     mnInspectLogFile.Enabled := WCPFile.LogFileAvailable ;

     // Only enable Export dialog if replay form exists
     mnExport.Enabled := FormExists( 'ReplayFrm' ) ;

     end;


function TMain.ShowTritonPanel : Boolean ;
// -------------------------------
//  Display Triton control window
// ------------------------------- }
begin
     // Display Triton control panel if it is not open
     Result := False ;
     case Main.SESLabIO.LabInterfaceType of
          Triton : begin
             if not Main.FormExists( 'TritonPanelFrm' ) then
                begin
                // Create form
                TritonPanelFrm := TTritonPanelFrm.Create(Self) ;
                TritonPanelFrm.Top := 15 ;
                TritonPanelFrm.Left := 710 ;
                end
             else
                begin
                // Make form visible, active and on top
                if TritonPanelFrm.WindowState = wsMinimized then TritonPanelFrm.WindowState := wsNormal ;
                TritonPanelFrm.BringToFront ;
                TritonPanelFrm.SetFocus ;
                end ;
             Result := True ;
             end ;
          end;
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
     if WCPFile.Settings.RecentFiles[0] = WCPFile.RawFH.FileName then Exit ;

     // Shift list along
     for i := High(WCPFile.Settings.RecentFiles) downto 1 do
         WCPFile.Settings.RecentFiles[i] := WCPFile.Settings.RecentFiles[i-1] ;
     WCPFile.Settings.RecentFiles[0] := WCPFile.RawFH.FileName ;

     { Update list in Files menu }
     mnRecentFileSeparator.Visible := False ;
     SetRecentFileItem( mnRecentFile0, WCPFile.Settings.RecentFiles[0] ) ;
     SetRecentFileItem( mnRecentFile1, WCPFile.Settings.RecentFiles[1] ) ;
     SetRecentFileItem( mnRecentFile2, WCPFile.Settings.RecentFiles[2] ) ;
     SetRecentFileItem( mnRecentFile3, WCPFile.Settings.RecentFiles[3] ) ;

     end ;


procedure TMain.mnShowAllChannelsClick(Sender: TObject);
// -------------------------------------
// Make all channels visible in displays
// -------------------------------------
var
    ch : Integer ;

begin

    for ch := 0 to WCPMaxChannels-1 do begin
        WCPFile.Channel[ch].InUse := True ;
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

procedure TMain.CopyStringGrid( Table : TStringGrid ) ;
{ -----------------------------------------------
  Print the contents of a string grid spreadsheet
  -----------------------------------------------
  21/7/99 }
var
   Row,Col,TopRow,BottomRow,LeftCol,RightCol : Integer ;
   TabText : String ;
   UseColumn : Array[0..MaxChannels*MaxAnalysisVariables-1] of boolean ;
   First : Boolean ;
begin
     { Find which columns contain data (based on first row) }
     for Col := 0 to Table.ColCount-1 do
         if Table.Cells[Col,0] = '' then UseColumn[Col] := False
                                    else UseColumn[Col] := True ;


     { Set row,column range to be copied }

     if (Table.Selection.Top = Table.Selection.Bottom) and
        (Table.Selection.Left = Table.Selection.Right) then begin
        { Whole table if no block selected }
        TopRow := 0 ;
        BottomRow := Table.RowCount - 1 ;
        LeftCol := 0 ;
        RightCol := Table.ColCount - 1 ;
        end
     else begin
        { Selected block }
        TopRow := Table.Selection.Top ;
        BottomRow := Table.Selection.Bottom ;
        LeftCol := Table.Selection.Left ;
        RightCol := Table.Selection.Right ;
        end ;

     { Copy table to tab-text string buffer }
     TabText := '' ;
     for Row := TopRow to BottomRow do begin
         First := True ;
         for Col := LeftCol to RightCol do
             if UseColumn[Col] then begin
             if First then begin
                TabText := TabText + Table.Cells[Col,Row] ;
                First := False ;
                end
             else TabText := TabText + chr(9) + Table.Cells[Col,Row] ;
             end ;
         TabText := TabText + chr(13) + chr(10) ;
         end ;

     { Copy string buffer to clipboard }
     ClipBoard.SetTextBuf( PChar(TabText) ) ;

     end ;



end.

