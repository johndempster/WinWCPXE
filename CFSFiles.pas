unit CFSFiles;
{ ------------------------------------------------------------------
  Cambridge Electronic Design CFS data file import/export module
  ------------------------------------------------------------------
  23/7/00
  18/2/01 ... Modified to handle scaling to 12 or 16 bit WCP files }

interface

uses global,fileio,SysUtils,shared,Dialogs,Messages,forms,controls, maths,
     Import,Progress ;

function ConvertCFSToWCP( FileName : string ) : Boolean ;

implementation

uses mdiform ;

type
    TChannelDef = packed record
                ChanName : String[21] ;
                UnitsY : String[9] ;
                UnitsX : String[9] ;

                dType : Byte ;
	        dKind : Byte ;
	        dSpacing : Word ;
                OtherChan : Word ;
                end ;

    TChannelInfo = packed record
	        DataOffset : LongInt ; {offset to first point}
	        DataPoints : LongInt ; {number of points in channel}
	        scaleY : single ;
	        offsetY : single ;
	        scaleX : single ;
	        offsetX : single ;
                end ;

    TDataHeader = packed record
	lastDS : LongInt ;
	dataSt : LongInt ;
	dataSz : LongInt ;
	Flags : Word ;
      	Space : Array[1..8] of Word ;
        end ;

    TCFSFileHeader = packed record
	Marker : Array[1..8] of char ;
	Name : Array[1..14] of char ;
	FileSz : LongInt ;
        TimeStr : Array[1..8] of char ;
	DateStr : Array[1..8] of char ;
	DataChans : SmallInt ;
	FilVars : SmallInt ;
	DatVars : SmallInt ;
	fileHeadSz : SmallInt ;
	DataHeadSz : SmallInt ;
	EndPnt : LongInt ;
	DataSecs : SmallInt ;
	DiskBlkSize : SmallInt ;
	CommentStr : String[73] ;
	TablePos : LongInt ;
	Fspace : Array[1..20] of Word ;
        end ;


function ConvertCFSToWCP(
         FileName : string
         ) : Boolean ;
{ --------------------------------------------------------------
  Import data from an CFS data file and store in a WCP data file
  -------------------------------------------------------------- }

var
   ChannelDef : TChannelDef ;
   ChannelInfo : TChannelInfo ;
   CFSFileHeader : TCFSFileHeader ;
   RecHeader : TDataHeader ;
   FilePointer,DataPointer : Integer ;
   Rec : Integer ;
   FileHandle,i,LastChannel,Src,Dest,SrcStep,iOff,nSamples : Integer ;
   ADCScale : single ;
   OK,Quit : boolean ;
   Ch : Integer ;
   Buf,CEDBuf : ^TIntArray ;
   rH : ^TRecHeader ;
   NumSamplesInChannel :  Array[0..ChannelLimit] of Integer ;
   DataOffset :  Array[0..ChannelLimit] of Integer ;
   SampleSpacing :  Array[0..ChannelLimit] of Integer ;
   x : single ;
   s : string ;
   TimeUnits : string ;
   TScale,ScaleBits : single ;
begin

     OK := True ;

     { Create buffers }
     New(Buf) ;
     New(rH) ;
     New(CEDBuf) ;

     try

        { Close existing WCP data file }
        if RawFH.FileHandle >= 0 then FileClose( RawFH.FileHandle ) ;

        { Create name of WCP file to hold CED file }
        RawFH.FileName := ChangeFileExt( FileName, '.wcp' ) ;

        { Open CFS data file }
        FileHandle := FileOpen( FileName, fmOpenRead ) ;
        if FileHandle < 0 then begin
           OK := False ;
           WriteToLogFile( 'Unable to open ' + FileName ) ;
           end ;

        {  Read CFS file header block }
        if OK then begin
           FileSeek( FileHandle, 0, 0 ) ;
           if FileRead(FileHandle,CFSFileHeader,Sizeof(CFSFileHeader))
              <> Sizeof(CFSFileHeader) then begin
              WriteToLogFile( FileName + ' - CFS Header unreadable') ;
              OK := False ;
              end ;
           end ;

        { Check that this is a CFS data file }
        if OK then begin
           s := ArrayToString(CFSFileHeader.Marker) ;
           if Pos('CEDFILE',s) = 0 then begin
              WriteToLogFile( FileName + ' - is not a CFS file.') ;
              OK := False ;
              end ;
           end ;

        { Get data from header block }
        if OK then begin
            { No. of analog input channels held in file }
            if CFSFileHeader.DataChans > (ChannelLimit+1) then
               WriteToLogFile( format( 'Input channels 6-%d ignored',
                                       [CFSFileHeader.DataChans-1])) ;
            { Number of analog input channels }
            RawFH.NumChannels := IntLimitTo(CFSFileHeader.DataChans,1,ChannelLimit+1) ;
            { Last channel number }
            LastChannel := RawFH.NumChannels - 1 ;

            { Get experiment identification text }
            RawFH.IdentLine := CFSFileHeader.CommentStr ;
            WriteToLogFile( 'CFS File : ' + FileName ) ;
	    WriteToLogFile( RawFH.IdentLine ) ;
	    WriteToLogFile( CFSFileHeader.TimeStr ) ;
	    WriteToLogFile( CFSFileHeader.DateStr ) ;

            { A/D converter input voltage range }
	    RawFH.ADCVoltageRange := 5. ;
            // Scale from 16 bit CED format to 16 or 12 bit WCP
            ScaleBits := 32768.0 / (Main.SESLabIO.ADCMaxValue + 1) ;

            { Read Channel definition records }
	    for Ch := 0 to LastChannel do begin
                { Read signal channel definition record }
                if FileRead(FileHandle,ChannelDef,Sizeof(ChannelDef))
                   = Sizeof(ChannelDef) then begin
                   { Name of signal channel }
                   Channel[Ch].ADCName := ChannelDef.ChanName ;
                   { Units of signal channel }
                   Channel[Ch].ADCUnits := ChannelDef.UnitsY ;

                   { Time units }
                   TimeUnits := ChannelDef.UnitsX ;
                   { Determine scaling to secs factor }
                   if Pos( 'us', TimeUnits ) > 0 then TScale := 1E-6
                   else if Pos( 'ms', TimeUnits ) > 0 then TScale := 1E-3
                                                      else TScale := 1. ;

                   SampleSpacing[Ch] := ChannelDef.dSpacing ;
                   end
                else WriteToLogFile( format( 'Ch.%d definition record unreadable',[Ch])) ;
                end ;
            end ;

        { Create a new WCP file to hold converted data }
        if OK then begin
            RawFH.FileHandle := FileCreate( RawFH.FileName ) ;
            if RawFH.FileHandle < 0 then begin
               OK := False ;
               WriteToLogFile( 'Unable to open ' + FileName ) ;
               end ;
            end ;

        { Read data records from CFS file }
        if OK then begin
            RawFH.NumRecords := 0 ;
            ProgressFrm.Initialise( 1,CFSFileHeader.DataSecs ) ;
            ProgressFrm.Show ;
            While not ProgressFrm.Done do begin

                Rec := ProgressFrm.Position ;

                { Get pointer to start of data record #Rec }
                FileSeek( FileHandle,CFSFileHeader.TablePos + (Rec-1)*4, 0 ) ;
                FileRead(FileHandle,DataPointer,SizeOf(DataPointer)) ;

                { Read record data header }
                FileSeek( FileHandle, DataPointer, 0 ) ;
                FileRead(FileHandle,RecHeader,SizeOf(RecHeader)) ;

                { Read channel offset/scaling information records
                  which follow data record }
	        for Ch := 0 to LastChannel do begin

                    { Read channel definition record }
                    FileRead(FileHandle,ChannelInfo,SizeOf(ChannelInfo)) ;

                    { Derive WCP's calibration factors from first record
                      scaling factor }
                    If Rec = 1 then begin
                       { Get signal bits->units scaling factor }
                       Channel[ch].ADCScale := ChannelInfo.ScaleY *  ScaleBits ;
                       Channel[ch].ADCCalibrationFactor := rawFH.ADCVoltageRange /
                                      ( Channel[ch].ADCScale * (MaxADCValue+1) ) ;
                       Channel[ch].ADCAmplifierGain := 1. ;
                       end ;

                    { Correct record's input voltage range setting to
                      account for an changes in signal scaling }
                    rH^.ADCVoltageRange[Ch] := ( RawFH.ADCVoltageRange *
                                            ChannelInfo.ScaleY * ScaleBits )
                                            / Channel[ch].ADCScale ;

                    { Offset into groups of A/D samples for this channel }
                    Channel[ch].ChannelOffset := Ch ;

                    { Inter sample interval }
		    RawFH.dt := ChannelInfo.scaleX*TScale ;
                    rH^.dt := RawfH.dt ;

                    { Number of samples in this channel }
		    NumSamplesInChannel[Ch] := ChannelInfo.DataPoints ;
                    { Offset (bytes) of samples for this channel in
                      record data area }
		    DataOffset[Ch] := ChannelInfo.DataOffset ;

                    end ;

                { Find a suitable number of samples per record }
		if Rec = 1 then begin
		    RawFH.NumSamples := 256 ;
                    Quit := False ;
		    while not Quit do begin
                       Quit := True ;
                       for Ch := 0 to LastChannel do begin
                           { Increase in steps of 256 }
                           if NumSamplesInChannel[Ch] > RawFH.NumSamples then begin
                              RawFH.NumSamples := RawFH.NumSamples + 256 ;
                              Quit := False ;
                              end ;
                           { Stop if buffer space limit reached }
                           if (RawFH.NumSamples*RawFH.NumChannels)
                              >= (MaxTBuf+1) then Quit := True ;
                           end ;
                       end ;
                    end ;

                { Read binary data from CED data file into CED record buffer }
                FileSeek( FileHandle,RecHeader.DataSt,0) ;
                FileRead( FileHandle, CEDBuf^, RecHeader.DataSz ) ;

                { Copy from CED buffer to WCP buffer }
	        for Ch := 0 to LastChannel do begin
                    { Increment between samples for this channel in CED buffer }
                    SrcStep := SampleSpacing[Ch] div 2 ;
                    { Number of samples for this channel }
                    nSamples := NumSamplesInChannel[Ch] ;
                    { Starting point of sample data in CED buffer }
                    Src := DataOffset[Ch] div 2 ;
                    { Place samples in WCP buffer starting here }
		    Dest := Channel[ch].ChannelOffset ;
		    for i := 1 to RawFH.NumSamples do begin
                        { Re-scale samples from 16 -> 12 bits }
			if( i <= nSamples ) then
                            Buf^[Dest] := Round(CEDBuf^[Src] / ScaleBits )
                        else Buf^[Dest] := 0 ;
                        { Increment WCP buffer point by sample spacing }
			Dest := Dest + RawFH.NumChannels ;
                        { Increment CED buffer point by sample spacing }
			Src := Src + SrcStep ;
		        end ;
                    end ;

                { Save record to WCP data file }
                Inc(RawFH.NumRecords) ;
                rH^.Status := 'ACCEPTED' ;
                rH^.RecType := 'TEST' ;
                rH^.Number := RawFH.NumRecords ;
                rH^.Time := rH^.Number ;
                rH^.Ident := ' ' ;
                rH^.Equation.Available := False ;
                rH^.Analysis.Available := False ;
                PutRecord( RawfH, rH^, RawfH.NumRecords, Buf^ ) ;

                ProgressFrm.Increment ;

                end ;

            { Save file header }
            SaveHeader( RawFH ) ;
            { Close WCP file }
            if RawFH.FileHandle >= 0 then FileClose( RawFH.FileHandle ) ;
            WriteToLogFile( 'converted to WCP file : ' + RawFH.FileName ) ;

            end ;

     finally

        { Close CED file }
        if FileHandle >= 0 then FileClose( FileHandle ) ;
        { Free buffers }
        Dispose(rH) ;
        Dispose(Buf) ;
        Dispose(CEDBuf) ;

        if not OK then MessageDlg( 'Unable to import ' + FileName,mtWarning,[mbOK],0) ;
        Result := OK ;
        end ;
     end ;


end.
