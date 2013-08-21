UNIT CED1401h;
{
 Adapted for multiple 1401s using conditional compilation tpc /dmultiple1401
 Adapted to leave out windows code using conditional      tpc /dnowindows 
  only if program NEVER to be run under Windows and size is crucial within 2K

 Copyright Cambridge Electronic Design 1987,1988,1989,1990,1992,1993
 Author Greg P. Smith

*************** NOTE on changes from TURBO Version 3 ************************
 This interface for Turbo 4.0/5.0 is NOT the same as for 3.0.  This is due to
 differences in the way that Borland have implemented text devices.  Due to
 this, we have changed the interface to be similar to the MS-Pascal routines,
 but keeping as much as is possible the same.

 User changes required:

 We no longer use the device Usr to communicate with the the 1401.  Use Cin
 for input and Cout for output.
 We have added WriteLString and ReadLString to be compatible with the
 MS-Pascal implementation, plus SegAndR.

 To1401 and ToHost routines now use a WORD as the address, not a REAL.  We
 only used a REAL in version 3.0 because of the lack of a WORD type.
 We have added a new routine, Reset1401, which does what it says.  We have
 also tried to make the Open1401 routine much more robust.  It will try to
 wake up the 1401, even if it is hung in a loop with interrupts off!
*****************************************************************************
 The new routine Get1401Info can be used at any time after Open1401 to
 interrogate the 1401 during your program. It returns the revision level of
 the device driver, and the state and type of the 1401.
*****************************************************************************

 Revision history :

 30-Nov-87 GPS This is the first version for Turbo 4.0  (see note above)
 18-Jan-88 GPS Calls changed to return more error info
 01-Nov-88 SEC Added ESC sequence to flush buffers in open1401, plus bug
               fix: delay before reading back from port was in wrong place
	       in Open1401.
 31-Jan-89 GPS Doesn't hang if driver present, but no 1401.
 31-Jul-89 TDB Fixed to work with Turbo V5.5 - avoid new reserved words.
 28-May-90 SEC LdCmd now READLN's the error code rather than READ's it,
	       this prevents a spurious <CR> being left in the input buffer.

Work on version 1.0 as follows:

 17-Aug-90 JCN Add Get1401Info. Open1401 now uses this to get state of 1401,
               using Esc R and Esc W if revision level of the device driver
	       is at least 2. Open1401 returns 103 in addition to other codes.

  3-Oct-90 JCN Fixed bug in Get1401Info. It was sending '-'#13 before
               anything else causing error light to come on.

  8-Oct-90 JCN Fixed longstanding problem whereby when only enough file
               handles for Cout but not Cin Open1401 gave run time error instead
	       of returning the code 4.	TURBO45 needs 2 file handles for 1401.
	       Open1401 returns 4 if 2 file handles are not available.
	       If cin not opened, cout is closed again.

 17-Oct-90 JCN Open1401 sets unit VAR commandExt to be .GXC if it has found a
               1401+. Default is '.CMD'. The extension is used by LdCmd for
	       loading commands from \1401.

 17-Jan-91 JCN ToHost now avoids running TOHOST with 0 bytes, but returns TRUE
               Increase size of command which can be loaded by Ldcmd from (10K
	       to 12K).

 12-Feb-91 JCN ToHost now avoids running TOHOST with 0 bytes, but returns TRUE
	       To1401 and ToHost addr and bytes parameters changed from WORD
	       to LONGINT to communicate with 1401plus.

 13-Feb-91 JCN Internal routine Wait1401 routine added to allow a time-out
               on waiting for Stat1401 to become TRUE. This is then used to
	       replace Stat1401 in Ld and LdCmd so that they return with an
	       error code the loading does not come to an end.

 25-Feb-91 JCN VAR commandExt moved from interface into implementation. See
 	       Oct 17 above.

 11-Mar-91 JCN Version 1.0 released. These comments added!
               Put in the software data base and on m:201\turbo45

20-Mar-91 JCN      ToHost and To1401 return FALSE if addr or bytes are negative.
04-Dec-91 PNC      Added the Kill1401 function.
18-Feb-92 JCN 1.1  LdCmd, Ld, and Open1401 have new error codes as follows:
                     LdCmd
                        5:timing out on using CLOAD to load a command.
                          Replaces 3 which remains 'failure to load'.
                     Ld
                        5:LdCmd timeout code described above.
                        6:timing out waiting for reply to ERR after trying to
                         run the command it is about to load to see if present.
                     Open1401
                      104:Times out waiting from ERR sent after reset and
                            Get1401Info.
                      105:Received non-zero error code from ERR. (Unlikely)
                   
 31-Mar-92 JCN 1.2  Merge code for multiple 1401s from LOADM.PAS
                    LOADM 3 Mar-91 JG  Additions for multiple 1401s
                    Select 1401 added to choose between 1401s 1,2 or 3.
                    If number is not in thar range current 1401 stays the same.
                    Arrays added to save the inout and output file handles for
                    each 1401. These are initialised to zero. (end of unit).
                    current unit variable added initialised to 1 (as CONST)
                    Conditional compilation tpc/dmultiple1401 uses this code
                   
 31-Mar-92 JCN      VAR commandExt now ARRAY[0..1] OF STRING and introduce
                    VAR sort1401 to access it
                    my1401s has a field for sort1401 added so that we can
                    have multiple 1401s of different kinds.

 27-May-92 JCN      Changed LdCmd so that it allocates enough memory for loading
                    command instead of using an array on the stack.
                    Release changes done above for multiple 1401s.

 Spring 93 GPS      IFDEF VER70 compilation (true when TURBO version 7 is
                    in use) uses the CONST type in declarations of Ld,
                    LdCmd, WriteLString.

 27-May-93 1.3  JCN LdCmd now uses environment variable 1401DIR (if set) to
                    replace the default 1401 directory. This allows user to
                    hide 1401 commands in a subdirectory.
                
 11-Aug-93 2.0  JCN Creating version to run under DOS or windows as follows:
                TDB Added code to detect execution under Windows, and to call
                    the Windows VXD for 1401 access in those circumstances.
                    Extra functions added to replace Escape sequences neatly,
                    note that Windows VXD error codes may turn up! (5-Feb-93) 
                JCN IFNDEF NOWINDOWS conditional compilation to leave out all
                    the above additional code. Also slight change to Open1401
                    for tidiness.
                
 13-Jun-94 2.1  JCN Exporting Wait1401
                
 25-Apr-95 2.2  TDB Extended to know about the u1401.
                
 30-Jun-95      TDB Final work for u1401, primarily when in Windows DOS box.
                
 15-Feb-95 2.10 TDB Back-edited in work done by George Donohoe (ABD) to
                    provide conditional compilation for protected-mode
                    builds, then extended the memory locking\unlocking in
                    the SetSeg\UnSetSeg calls. In addition, the code to call
                    the Windows driver has been improved - the cx and bx
                    (in prot mode) registers are set correctly.
}

INTERFACE

USES DOS;

{$IFDEF multiple1401}
CONST MAX1401S = 3;
{$ENDIF}

TYPE TfName=STRING[80];

FUNCTION  Open1401:INTEGER;

PROCEDURE Close1401;

FUNCTION Wait1401(timeOut:WORD):BOOLEAN;

FUNCTION  Stat1401:BOOLEAN;

PROCEDURE SetSeg(seg:WORD);

PROCEDURE UnSetSeg;

FUNCTION  SegAndR(VAR item):WORD;

FUNCTION  To1401 (addr,bytes:LONGINT;VAR Arr):BOOLEAN;

FUNCTION  ToHost (addr,bytes:LONGINT;VAR Arr):BOOLEAN;

{$IFDEF VER70}

FUNCTION  LdCmd(const fName:TfName):INTEGER;

FUNCTION  Ld(const vl:TfName; str:TfName):INTEGER;

PROCEDURE WriteLString(const l:STRING);

{$ELSE}

FUNCTION  LdCmd(fName:TfName):INTEGER;

FUNCTION  Ld(vl,str:TfName):INTEGER;

PROCEDURE WriteLString(l:STRING);

{$ENDIF}

PROCEDURE ReadLString(VAR l:TfName);

PROCEDURE Reset1401;

PROCEDURE Flush1401;

PROCEDURE StopCircular;

PROCEDURE Kill1401;

FUNCTION DumpXfer(dump:BOOLEAN):WORD;

PROCEDURE Get1401Info(VAR driverRev,bus,type1401,state:INTEGER);

{$IFDEF multiple1401}
PROCEDURE Select1401(num:INTEGER);
{$ENDIF}

VAR cin,cout:TEXT;			    {devices used to talk to the 1401}

CONST __currentUnit:INTEGER=1;		       {says which 1401. start with 1}

{$IFDEF multiple1401}
VAR my1401s: ARRAY[1..MAX1401S] OF
                RECORD
                cin,cout:TextRec;
                mySort1401:INTEGER;			    {1401 or 1401plus}
                END;
{$ENDIF}

{--------------------- Below here is invisible to the user ----------}

IMPLEMENTATION

{$R-,S-}				{no range or stack checking for speed}

{$IFDEF DPMI }
    USES WinAPI;

    VAR  lockedHand : THandle;        {This is the handle of locked xfer area}
{$ENDIF}

TYPE TExtArr=ARRAY[0..2] OF STRING[4];

TYPE TVXTDESC = RECORD				   { Structure for VXD comms }
                wAreaNum : WORD;	 { number of transfer area to set up }
                wAddrSel : WORD;		  { 16 bit selector for area }
                dwAddrOfs: LONGINT;	      { 32 bit offset for area start }
                dwLength : LONGINT;		  { length of area to set up }
                END;


CONST CommandExt:TextArr=('.CMD','.GXC','.ARM'); {extension for command files}

CONST sort1401:INTEGER=0;    {0 for standard, 1 for 1401plus, 2 for u1401}

CONST VXD_OPEN=0;                          {Constants defining VXD operations}
      VXD_CLOSE=1;                                     {used in CallVXD calls}
      VXD_SENDS=2;
      VXD_RESET=3;
      VXD_LINES=7;
      VXD_GETS=8;
      VXD_SETX=11;
      VXD_UNSETX=12;
      VXD_OUTSPACE=14;
      VXD_GETX=17;
      VXD_KILLIO=18;
      VXD_STOPC=22;
      VXD_STATE=23;

{$IFDEF multiple1401}
VAR __index:INTEGER;
{$ENDIF}

VAR __name1401:PACKED ARRAY[0..5] OF CHAR;

VAR __Handle,__inHandle,__outHandle,__OpenErr:INTEGER;

VAR __char1401:CHAR;			 {used in the send and get procedures}

VAR __CEDError:INTEGER;			 {error code if trouble communicating}
{$IFNDEF nowindows}
VAR __isWindows : BOOLEAN;     {Set if we are operating under Windows 386 enh}
{$ENDIF}
VAR __VXD_PTR : Pointer;                         {Address of Windows 1401 VXD}

{$IFDEF multiple1401}
PROCEDURE Select1401(num:INTEGER);
BEGIN
IF (__currentUnit>0) AND (__currentUnit<=MAX1401S) THEN
    BEGIN
    my1401s[__currentUnit].cin  := TextRec(cin);		{ save state }
    my1401s[__currentUnit].cout := TextRec(cout);{ save state }
    my1401s[__currentUnit].mySort1401:=sort1401;
    END;

IF (num>0) AND (num<=MAX1401S) THEN	       { only do anything if in range}
   BEGIN
   TextRec(cin)  := my1401s[num].cin;				{ save state }
   TextRec(cout) := my1401s[num].cout;				{ save state }
   __inHandle := TextRec(cin).handle;		   {Program handle parameters}
   __outHandle:= TextRec(cout).handle;
   __currentUnit:=num;
   sort1401:=my1401s[__currentUnit].mySort1401;		    {standard or plus}
   END;
END;
{$ENDIF}

{$IFNDEF nowindows}
FUNCTION IsWin3e:BOOLEAN;
{Returns TRUE if we are under Windows 3 enhanced mode}
VAR   v : INTEGER;
BEGIN
asm
   mov  ax,1600H				   {Code to query for Windows}
   int  2FH						    {Do the interrupt}
   mov  v,ax					     {Save the result locally}
end;
v := v AND 255;					   {Get low byte of data (AL)}
IsWin3e := ((v > 1) AND (v <> $80));			      {The magic test}
END;
{$ENDIF}

FUNCTION CallVXD(main:BYTE; subFn:BYTE ;VAR params):INTEGER;
{ Makes a call to the Windows VXD real mode entry point. ax holds function
  code while es:di holds the address of params}
VAR  retval : INTEGER;
     func   : WORD;
BEGIN
func := main;                                       { Generate function code }
func := func * 256 + subFn;                                {avoiding overflow}
IF ((__VXD_PTR) <> nil)       {Only call if we have a decent function address}
   THEN BEGIN
        asm
           mov   ax,func                                {set function number }
           les   di,params                 {parameter block address in es:di }
                mov   cx,0                                {1401 number in cx }
{$IFDEF DPMI}
                mov   bx,0                       {Flag 16-bit protected mode }
{$ENDIF}
           call  DWORD PTR [__VXD_PTR]                   {call V1401D device }
           mov   retval,ax                           {retrieve driver result }
        end;
        CallVXD := retval;                        {Return value is VXD return}
        END
   ELSE CallVXD := -581;                            {Error code for no driver}
END{CallVXD};


FUNCTION XLateVXErr(err : INTEGER): INTEGER;
{ Converts an error code from the VXD into the most suitable value
  that matches the values returned under normal DOS operations}
VAR   ne : INTEGER;
BEGIN
IF (err = 0)                            {We want to handle zero values neatly}
   THEN BEGIN
        XLateVXErr := 0;
        EXIT;
        END;
CASE err OF
   -500 : ne := 100;                              {Open 1401 error map easily}
   -501 : ne := 101;
   -502 : ne := 102;
   -503 : ne := 103;
   -504 : ne := 104;
   -505 : ne := 102;	 {Bad I/F switches -> problem with driver/1401 unwell}
   -506 : ne := 104;
   -507 : ne := 102;	      {Couldn't get int vector -> problem with driver}
   -508 : ne := 4;			  {1401 in use -> out of file handles}
   -509 : ne := 102;		{Couldn't get DMA chan -> problem with driver}
   -522 : ne := 160;			   {OP buf full -> device write fault}
   -523 : ne := 161;					    {similarly for IP}
   -524 : ne := 160;					     {String too long}
   -540 : ne := 1;					 {These are LD errors}
   -541 : ne := 2;
   -542 : ne := 3;
   -543 : ne := 4;
   -544 : ne := 4;
   -545 : ne := 5;
   -581 : ne := 2;					{Problems with driver}
   -582 : ne := 2;
   -590 : ne := 161;				       {timeout -> read fault}
   -600 : ne := 161;			      {string too short -> read fault}
   ELSE   ne := err;
END{CASE};
(*** WRITELN('VXD error code ',err:0,' converted to ',ne:0); *)
XLateVXErr := ne;
END;


PROCEDURE Out1401(c:CHAR);    	      {send character TO 1401 - for DOS only}
BEGIN
asm
   mov  al,c                       {Get character}
   mov  __char1401,al              {save in a global}
   mov  dx,OFFSET __char1401       {offset to char variable in DX}
   mov  cx,1		      	   {count of bytes}
   mov  bx,__outHandle	      	   {handle in bx}
   mov  ah,40H                     {Code for write to handle}
   int  21H
   jc   @1		      	   {Go on if failed}
   mov  __CEDError,ax	      	   {Save count of bytes}
  @1:
end;
END;


FUNCTION In1401:CHAR;		      {Get character from 1401 - for DOS only}
VAR     ch : CHAR;
BEGIN
asm
   mov  bx,__inHandle	      	   {handle in bx}
   mov  cx,1		      	   {count of bytes}
   mov  dx,OFFSET __char1401       {offset to char variable in DX}
   mov  ah,3FH		           {Code for read data}
   int  21H
   jc   @1		      	   {Go on if failed}
   mov  __CEDError,ax	      	   {Save count of bytes}
  @1:
end;
In1401:=__char1401                                 {REturn value is char read}
END;


FUNCTION Stat1401:BOOLEAN;
{Returns TRUE IF input chars in 1401}
VAR  lval : LONGINT;
     flag : INTEGER;
BEGIN
{$IFNDEF nowindows}
IF (__isWindows)					{Use the VXD method ?}
   THEN BEGIN
        lval := 0;			  {To ensure a good number at the end}
        flag := CallVXD(VXD_LINES,0,lval);	   {VXD GetLineCount function}
        IF (flag = 0)
           THEN Stat1401 := (lval > 0)
           ELSE Stat1401 := FALSE;
        END
   ELSE {$ENDIF}BEGIN
        asm
           mov  bx,__inHandle			   {Get handle for 1401 reads}
           mov  ax,4406H			   {Code for get input status}
           int  21H						    {Call DOS}
           mov  flag,ax					 {save result for use}
        end;
        Stat1401:=LO(flag)=255;
        END;
END;


FUNCTION Clock(lastTime,timeOut:WORD):BOOLEAN;
{returns true if timeOut/100 seconds have passed since lasttime in 1/100 secs}
{timeOut cannot be greater than 5999 (1 minute-1/100 sec)}
VAR h,m,s,hu,newTime:WORD;

BEGIN
GetTime(h,m,s,hu);						{get the time}
newTime:=s*100+hu;		 {latest seconds and hundredths in hundredths}
IF (newTime+6000-lastTime) MOD 6000 >= timeOut       {compare time with limit}
  THEN Clock:=TRUE
  ELSE Clock:=FALSE;
END;								       {Clock}

FUNCTION Wait1401(timeOut:WORD):BOOLEAN;
{Waits for Stat1401 to be TRUE or for timeOut/100 seconds to pass}
{Returns TRUE if wait ended by stat1401 becoming TRUE
         FALSE if the time runs out}
VAR h,m,s,hu,startTime:WORD;

BEGIN
GetTime(h,m,s,hu);						{get the time}
startTime:=s*100+hu;					       {in 1/100 secs}
  REPEAT
  UNTIL Stat1401 OR Clock(startTime,timeOut);
Wait1401:=Stat1401;	      {TRUE if 1401 has chars ready for input by host}
END;

{$IFNDEF nowindows}
FUNCTION WaitOutput(timeOut, len:WORD):BOOLEAN;
{ Waits for space for len characters in output buffer or for timeOut/100
  seconds to pass. Returns TRUE if wait ended by space becoming available,
  FALSE if the time runs out. Note : For VXD operations only!}
VAR h,m,s,hu,startTime:WORD;
    flag : INTEGER;
    lval : LONGINT;
BEGIN
WaitOutput := TRUE;
IF NOT __isWindows THEN EXIT;                    {Return with dummy OK if DOS}
GetTime(h,m,s,hu);						{get the time}
startTime:=s*100+hu;					       {in 1/100 secs}
  REPEAT
     lval := 0;                           {To ensure a good number at the end}
     flag := CallVXD(VXD_OUTSPACE,0,lval);           {VXD GetOutBufSpace call}
     IF (flag <> 0)                              {If error, assume zero space}
        THEN lval := 0;
  UNTIL (lval >= len) OR Clock(startTime,timeOut);
WaitOutput:= (lval >= len);             {TRUE if 1401 driver has enough space}
END;
{$ENDIF}

PROCEDURE ReadLSTRING(VAR l:TfName);
VAR p:INTEGER;
BEGIN
{$IFNDEF nowindows}
IF (__isWindows)
   THEN ReadLn(Cin,l)                {Just use simple access for windows case}
   ELSE {$ENDIF}BEGIN
        p:=0;
        REPEAT
           INC(p);				    {move the pointer onwards}
           l[p]:=In1401;				 {get a new character}
        UNTIL (l[p]=CHR(10)) OR (p>50);			{put some limit on it}
        IF p>1
           THEN p:=p-2
           ELSE p:=0;					       {chop the CRLF}
        l[0]:=CHR(p);				       {set the string length}
        END;
END;


{$IFDEF VER70}
PROCEDURE WriteLString(const l:STRING);
{$ELSE}
PROCEDURE WriteLString(l:STRING);
{$ENDIF}
BEGIN
WRITE(Cout,l);
END;

PROCEDURE UnSetSeg;
{does nothing unless Virtual X Device driver}
VAR   flag : INTEGER;
      lval : LONGINT;
BEGIN
{$IFNDEF nowindows}
IF (__isWindows)
   THEN BEGIN
        lval := 0;                                {Area number 0 to be unused}
        flag := CallVXD(VXD_UNSETX,0,lval);       {VXD UnSetTransfer function}
{$IFDEF DPMI}
        IF (lockedHand <> 0)                        {If we have locked memory}
           THEN BEGIN
                GlobalPageUnLock(lockedHand);        {Do windows-style unlock}
                lockedHand := 0;               {and flag that it is unlocked }
                END;
{$ENDIF}
        END
        ELSE
{$ENDIF}
        BEGIN
{$IFDEF DPMI}
        IF (lockedHand <> 0)                        {If we have locked memory}
           THEN BEGIN
                GlobalUnFix(lockedHand);             {Do windows-style unlock}
                lockedHand := 0;               {and flag that it is unlocked }
                END;
{$ENDIF}
        END;
END;

PROCEDURE SetSeg(seg:WORD);                      {set data segment in handler}
VAR   desc : TVXTDESC;
      flag : INTEGER;
{$IFDEF DPMI}
      i4_temp   :LONGINT;
      hand      :THandle;
{$ENDIF}

   PROCEDURE OutHex(v:LONGINT;i:INTEGER);           {output v as i hex digits}
   TYPE THex=STRING[16];
   CONST Hex:THex='0123456789ABCDEF';
   VAR j:INTEGER;
   BEGIN
   IF i>1 THEN OutHex(v SHR 4,I-1);
   WRITE(Cout,Hex[(v AND 15)+1]);
   END{OutHex};

TYPE TVXTDESC = RECORD				   { Structure for VXD comms }
                wAreaNum : WORD;         { number of transfer area to set up }
                wAddrSel : WORD;	          { 16 bit selector for area }
                dwAddrOfs: LONGINT;	      { 32 bit offset for area start }
                dwLength : LONGINT;	          { length of area to set up }
                END;
BEGIN{SetSeg}
UnSetSeg;                                    {Release any previously set area}
{$IFNDEF nowindows}
IF (__isWindows)
   THEN BEGIN
{$IFDEF DPMI}
        GlobalPageLock(seg);                {Ensure that memory does not move}
        lockedHand := seg;                {and save memory selector for later}
{$ENDIF}
        desc.wAreaNum := 0;
        desc.wAddrSel := seg;
        desc.dwAddrOfs:= 0;
        desc.dwLength := 65536;
        flag := CallVXD(VXD_SETX,0,desc);           {VXD SetTransfer function}
        END
        ELSE
{$ENDIF}
        BEGIN
{$IFDEF DPMI}
        hand := GlobalHandle(seg);      {Get handle corresponding to selector}
        IF (hand <> 0)
           THEN BEGIN
                GlobalFix(hand);                        {Wire the memory down}
                lockedHand := hand;            {and save the handle as before}
                END
           ELSE BEGIN
(***                WRITELN('Global handle function failed !!!'); *)
                lockedHand := 0;
                END;
        WRITE(Cout,CHR(27),'L');          {Use ESC-L sequence for 32-bit base}
        i4_temp := GetSelectorBase(seg);
        OutHex(i4_temp,8);
        WRITELN(Cout);
{$ELSE}
        WRITE(Cout,CHR(27),'S');      {or Esc-S to set a normal base segment }
        OutHex(seg,4);
        WRITELN(Cout);
{$ENDIF}
        END;
END{SetSeg};


FUNCTION SegAndR(VAR item):WORD;
BEGIN
SetSeg(Seg(item));
SegAndR:=Ofs(item);
END{SegAndR};


FUNCTION To1401 (addr,bytes:LONGINT;VAR Arr):BOOLEAN;
{Transfers array in host to 1401 memory}
{Returns TRUE if transfer successful or if 0 bytes requested}
{Returns FALSE if transfer request is for -ve addr or bytes or if
 the TO1401 command produces an error}
VAR  e0,e1:INTEGER;
BEGIN
SetSeg(Seg(Arr));				  {Set segment FOR block xfer}
IF (addr<0) OR (bytes<0)			    {fail if negative numbers}
  THEN To1401:=FALSE
  ELSE BEGIN
       IF bytes=0
         THEN To1401:=TRUE	    {Successfully transferred no bytes at all}
         ELSE BEGIN				 {want to transfer some bytes}
              WRITELN(Cout,'TO1401,',addr:6,',',bytes:6,',',Ofs(Arr),';ERR');
                REPEAT UNTIL Stat1401;			{wait until xfer done}
              READLN(Cin,e0,e1);			    {Read error flags}
              To1401:=e0=0;		       {Return TRUE IF error was zero}
              END;
       END;
UnSetSeg;                                                   {Release set area}
END;								      {To1401}


FUNCTION ToHost (addr,bytes:LONGINT;VAR Arr):BOOLEAN;
{Transfers block of 1401 memory to array in host
 Returns TRUE if transfer successful or if 0 bytes requested
 Returns FALSE if transfer request is for -ve addr or bytes or if
 the TOHOST command produces an error}
VAR  e0,e1:INTEGER;
BEGIN
SetSeg(Seg(Arr));				  {Set segment FOR block xfer}
IF (addr<0) OR (bytes<0)		   {fail if negative address or bytes}
  THEN ToHost:=FALSE
  ELSE BEGIN
       IF bytes=0
         THEN ToHost:=TRUE		   {Return TRUE if no bytes asked for}
         ELSE BEGIN				 {want to transfer some bytes}
              WRITELN(Cout,'TOHOST,',addr:6,',',bytes:6,',',Ofs(Arr),';ERR');
                REPEAT UNTIL Stat1401;			{wait until xfer done}
              READLN(Cin,e0,e1);			    {Read error flags}
              ToHost:=e0=0;		       {Return TRUE IF error was zero}
              END;
       END;
UnSetSeg;                                                   {Release set area}
END;								      {ToHost}


{$IFDEF VER70}
FUNCTION  LdCmd(const fName:TfName):INTEGER;
{$ELSE}
FUNCTION LdCmd(fName:TfName):INTEGER;{load a command}
{$ENDIF}
{Load one 1401 command regardless of whether it is already present in the
1401. LdCmd times out after 2 seconds if the 1401 does not respond after
loading the command}
{
 0 Success
 1 File not found
 2 Error reading file
 3 Failed TO load  (Error code returned after CLOAD)
 4 Command too big to load
 5 Timed out loading command (after 2 seconds)
 6 Not used in this version so that Ld can return 6 itself and 0 to 5 from
   LdCmd
}
CONST DiscBlockSize=511;			{number bytes-1 in disc block}
      MaxBlocks=24;		     {Number of disk blocks which we can load}
TYPE TBlock =  PACKED RECORD CASE BOOLEAN OF
               TRUE:(block:PACKED ARRAY[0..DiscBlockSize] OF BYTE);
               FALSE:(basic:PACKED ARRAY[0..4] OF BYTE;	   {basic private use}
                      basicLength:INTEGER;		   {basic file length}
                      cmdSize:INTEGER;			      {command length}
                      relPnt:INTEGER;			   {points at rel tab}
                      name:PACKED ARRAY[0..7] OF CHAR;{command name}
                      monrev:BYTE;			    {mon rev expected}
                      cmdRev:BYTE;               {command revision});
               END;

     TMemory = ARRAY[0..MaxBlocks-1] OF TBlock;		  {12K bytes can load}

VAR xin:FILE OF TBlock;
    firstBlock:TBlock;
    space:^TMemory;
    e0,e1,i,blocks:INTEGER;
    cmdSize,address:INTEGER;
    localName:TfName;
    maxSpace:REAL;
    sizeAlloc:WORD;			      {bytes required to load command}
    path1401:STRING[64];     {path to 1401 command file}
LABEL 1,2;

BEGIN{LdCmd}
LdCmd:=0;						      {no errors yet!}
IF POS(commandExt[sort1401],fname)=0           {commandExt holds .CMD or .GXC}
  THEN BEGIN				   {IF we don't have a full file name}
       path1401:=GetEnv('1401DIR');         {see if they have provided a path}
       IF path1401<>''                                                 {if so}
         THEN BEGIN
              IF path1401[Length(path1401)]<>'\'              {if no \ at end}
                THEN path1401:=path1401+'\';            {add \ to end of path}
              END
         ELSE path1401:='\1401\';                 {use default 1401 directory}
       localName:=path1401+fName+commandExt[sort1401];
       END
  ELSE localName:=fName;				{IF we have full name}
ASSIGN(xin,LocalName);
{$I-}
RESET(xin);					  {we can test using IOResult}
{$I+}
IF IOResult<>0					      {could we open the file}
  THEN BEGIN
       LdCmd:=1;				   {flag file not found error}
       GOTO 2;					{and skip rest of the command}
       END;
{$I-}
READ(xin,firstBlock);					    {read first block}
{$I+}
IF IOResult<>0				      {could we read the first block?}
  THEN BEGIN
       LdCmd:=2;				     {flag error reading file}
       GOTO 2;					{and skip rest of the command}
       END;
CmdSize:=firstBlock.CmdSize;			   {size of command FOR CLOAD}
Blocks:=ORD ((cmdSize+9+511) DIV 512);		       {number of disc blocks}
{allocate space for blocks in memory}
space:=NIL;								{init}
sizeAlloc:=blocks*512;
GetMem(space,sizeAlloc);
IF (space=NIL)				   {not enough space for this command}
  THEN BEGIN
       LdCmd:=4;					   {flag out of space}
       GOTO 1;						       {skip the rest}
       END;
space^[0]:=firstBlock;
FOR i:=1 TO blocks-1 DO				       {and the rest (IF any)}
  BEGIN
{$i-}
  READ(xin,space^[i]);
  IF IOResult<>0
    THEN BEGIN
         LdCmd:=2;
         GOTO 1;				 {dispose of P and close file}
         END;
  END;
{$I+}
SetSeg(Seg(space^[0]));				     {set segment FOR command}
address:=Ofs(space^[0])+9;{and offset TO start of command}
WRITELN(Cout,'CLOAD,',address:6,',',cmdSize:6,';ERR');
IF Wait1401(200)	   {wait no longer than 2 seconds for CLOAD to finish}
  THEN BEGIN
       READLN(Cin,e0,e1);				       {wait FOR done}
       IF e0<>0
         THEN LdCmd:=3;					      {failed TO load}
       END
  ELSE LdCmd:=5;		       {Timed out waiting for CLOAD to finish}
UnSetSeg;                                    {Unlock memory for DPMI purposes}
1:CLOSE(xin);						   {and the file used}
IF space<>Nil
  THEN FreeMem(space,sizeAlloc);
2:END{LdCmd};


{$IFDEF VER70}
FUNCTION  Ld(const vl:TfName; str:TfName):INTEGER;
{$ELSE}
FUNCTION Ld(vl,str:TfName):INTEGER;{load a series of commands}
{$ENDIF}
{If any one of the commands is already present in the 1401 it is not loaded.
 Ld times out after 1/2 second and returns error code if no response is
 received from 1401 when checking to see if a command already present.}
{Returns a code
256*n+m where n and m are as follows:
   n Number of command in the list from 0 onwards
   m Error code :

0      Command present or loaded OK
1 to 5 Error code from LdCmd
6      Timed out (1/2 sec) waiting for reply to ERR after attempting to run
       command to see if it is present.
}
VAR filNam,fName:TfName;
    j,e0,e1,dum,command:INTEGER;

BEGIN								   {UNIT LOAD}
command:=0;					   {command number to work on}
  REPEAT				      {until all commands in str used}
  command:=command+1;					      {command number}
  j:=POS(',',str);				  {find next command division}
  IF j=0						      {IF no division}
    THEN filNam:=str			       {then this is the last command}
    ELSE BEGIN						{otherwise remove one}
         filNam:=str;
         DELETE(filNam,j,Length(filNam)-j+1);
         DELETE(str,1,j)
         END;
 WRITELN(Cout,filNam,';ERR');		     {see if command is already there}
 IF Wait1401(50)		{wait no longer than half a second for answer}
   THEN BEGIN
        READLN(Cin,e0,e1);				 {read the error code}
        IF e0=255					     {IF non-existent}
          THEN BEGIN				 {attempt TO load the command}
               IF vl=''				  {IF no device specification}
                 THEN fName:=filNam			   {set just the name}
                 ELSE fName:=vl+filNam+commandExt[sort1401];{commandExt set in Open1401}
               dum:=LdCmd(fName);		     {try TO load the command}
               END
          ELSE dum:=0;				   {no error IF already there}
        END
   ELSE dum:=6;			{timed out seeing if command is already there}
 UNTIL (j=0) OR (dum<>0);			   {repeat until nothing left}
IF dum=0
  THEN Ld:=0					      {return 0 if all was OK}
  ELSE Ld:=command*256+dum;	     {else low byte is error, high is command}
END{Ld};


{$F+}	    {------------------ Force FAR calls for the I/O routines---------}


FUNCTION CEDInput(VAR F: TextRec): INTEGER;
VAR p : Word;
    ch: CHAR;
    s : ARRAY[0..255] OF CHAR;
    flag : INTEGER;
BEGIN
CEDInput:=0;                                        {Start result off as zero}
{$IFNDEF nowindows}
IF (__isWindows)
   THEN BEGIN
        WITH f DO
           BEGIN
           IF NOT Wait1401(200)     {wait no longer than 2 seconds for string}
              THEN BEGIN
(***                   WRITELN('Timeout in GetString'); *)
                   BufPos := 0;
                   BufEnd := 0;
                   CedInput := 161;                    {Read fault error code}
                   EXIT;
                   END;
           s[0] := #255;                   {Max length in the buffer variable}
           s[1] := #0;
           IF (bufSize < 255)                     {Truncate to TP buffer size}
              THEN s[0] := CHR(bufSize);
           flag := CallVXD(VXD_GETS,0,s);                  {and read a string}
           IF (flag <> 0)
              THEN BEGIN
(***                   WRITELN('flag ',flag,' returned by GetString'); *)
                   BufPos := 0;
                   BufEnd := 0;
                   CEDInput := XLateVXErr(flag);          {Pass on error code}
                   EXIT;
                   END;
           p:=0;
           REPEAT
              ch := s[p];		{get the next character from the 1401}
              IF (ch = ',')
                 THEN ch := ' ';                    {Convert commas to spaces}
              BufPtr^[p]:=ch; Inc(p);	{and save the character in the buffer}
              IF (ch = #13) AND (p < bufSize)
                 THEN BEGIN
                      ch := #10;
                      BufPtr^[p]:=ch;
                      Inc(p);   	{and save the character in the buffer}
                      END;
           UNTIL (ch=CHR(10)) OR (ch=CHR(0)) OR (p>=bufSize);
           IF (ch = CHR(0))
              THEN p := p-1;
           BufPos:=0; BufEnd:=p;
           END;
        END
   ELSE {$ENDIF}BEGIN
        WITH F DO
           BEGIN
           p:=0;
           REPEAT
              ch:=In1401;		{get the next character from the 1401}
              BufPtr^[p]:=ch; Inc(p);	{and save the character in the buffer}
           UNTIL (ch=CHR(10)) OR (p>bufSize);
           BufPos:=0; BufEnd:=p;
           END;
        END;
END;


FUNCTION CEDOutput(VAR F: TextRec): INTEGER;
{ This function writes a text string out to the 1401 }
VAR p : Word;
    s : ARRAY[0..255] OF CHAR;
    flag : INTEGER;
BEGIN
CEDOutput:=0;                                  {We expect result will be zero}
{$IFNDEF nowindows}
IF (__isWindows)
   THEN BEGIN
        WITH f DO
           BEGIN
           IF (BufPos <= 0)              {Simple trap for zero-length strings}
              THEN EXIT;
           IF (BufPtr^[0] = #27)            {Simple trap for escape sequences}
              THEN BEGIN
(*                   WRITELN('Escape ',BufPtr^[1],' sequence discarded'); *)
                   BufPos := 0;
                   EXIT;
                   END;
           IF (BufPtr^[BufPos-1] = #10)            {Simple trap for line feed}
              THEN BufPos := BufPos-1;                   {But only at the end}
           FOR p := 0 TO (BufPos-1) DO
              s[p] := BufPtr^[p];                        {Copy string locally}
           s[BufPos] := #0;                            {Terminate with a zero}
           IF NOT WaitOutput(200,BufPos)
              THEN BEGIN
                   CedOutput := 160;           {Device write fault error code}
(***                   WRITELN('Timeout in SendString'); *)
                   BufPos := 0;
                   EXIT;
                   END;
           flag := CallVXD(VXD_SENDS,0,s);               {and send the string}
           IF (flag <> 0)
              THEN BEGIN
(***                   WRITELN('flag ',flag,' returned by SendString'); *)
                   CEDOutput := XLateVXErr(flag);         {Pass on error code}
                   END;
           BufPos:=0;
           END;
        END
   ELSE {$ENDIF}BEGIN
        WITH F DO
           BEGIN
           p:=0;
           WHILE p<BufPos DO
              BEGIN
              Out1401(BufPtr^[p]);
              Inc(p);
              END;
           BufPos:=0;
           END;
        END;
END;


FUNCTION CEDIgnore(VAR F: TextRec): INTEGER;
BEGIN
CEDIgnore:=0;
END;


FUNCTION CEDClose(VAR f:TextRec):INTEGER;
VAR   lval : LONGINT;
      flag : INTEGER;
BEGIN
{$IFNDEF nowindows}
IF (__isWindows)
   THEN BEGIN
        WITH F DO
           BEGIN
           IF (Mode=fmInput) OR (Mode=fmOutput)
              THEN BEGIN
                   IF (Mode=fmOutput)
                      THEN flag := CallVXD(VXD_CLOSE,0,lval);
                   Mode:=fmClosed;      	    {say the file is now shut}
                   END;
           END;
        END
   ELSE {$ENDIF}BEGIN
        WITH f DO
           BEGIN
           __Handle:=Handle;				 {get the file handle}
           IF (Mode=fmInput) OR (Mode=fmOutput)
              THEN BEGIN
                   asm
                      mov bx,__Handle                    {get handle for 1401}
                      mov ax,3E00H                {close handle function code}
                      int   21H			                    {call DOS}
                   end;
                   Mode:=fmClosed;		    {say the file is now shut}
                   Handle := 0;			  {handle no longer available}
                   END;
           END;
        END;
CEDClose:=0;				  {We do not admit to errors in close}
END;


FUNCTION CEDOpen(VAR F: TextRec): INTEGER;
VAR     vseg  : WORD;
        voffs : WORD;
        lval  : LONGINT;
        flag  : INTEGER;
BEGIN
__OpenErr := 0;						 {No errors yet found}
{$IFNDEF nowindows}
__isWindows := FALSE;
{$ENDIF}
WITH F DO
{$IFNDEF nowindows}
   IF (IsWin3e)                               {Are we running under Windows ?}
      THEN BEGIN                                     {Open for use in Windows}
           asm
              mov     ax, 1684H               { get device API call }
              mov     bx, 2952H        { ID for the 1401 VxD }
              int     2FH                     { get api entry point }
              mov     voffs, di     { save the callback address }
              mov     vseg, es               {for later }
           end;
           IF ((vseg OR voffs) = 0)
              THEN BEGIN
                   __VXD_PTR := nil;
                   CEDOpen := 2;
                   EXIT;
                   END;
           __VXD_PTR := Ptr(vseg, voffs);    {Generate a pointer from results}
           IF Mode=fmInput	     {are we opening for INPUT or for OUTPUT?}
              THEN BEGIN                           {We dont do much for input}
                   InOutFunc:=@CEDInput;
                   END
              ELSE BEGIN                  {all the action happens with output}
                   Mode:=fmOutput;      {Which assumes output is set up first}
                   InOutFunc:=@CEDOutput;
                   FlushFunc:=@CEDOutput;    {force flush to empty the buffer}
                   flag := CallVXD(VXD_CLOSE,VXD_CLOSE,lval);  {Force a close}
                   lval := 0;                {Ensure upper word is clear here}
                   __OpenErr := CallVXD(VXD_OPEN,0,lval);
                   IF ( (__OpenErr = 0) AND
                        (lval <> 4) AND (lval<>5) AND (lval <> 6))
                      THEN __OpenErr := XLateVXErr(lval)
                      ELSE IF (__OpenErr <> 0)         {Translate as required}
                         THEN __OpenErr := XLateVXErr(__OpenErr);
                   END;
           __isWindows := TRUE;            {Set flag to indicate windows mode}
           END
      ELSE {$ENDIF}BEGIN
           IF Mode=fmInput	     {are we opening for INPUT or for OUTPUT?}
              THEN BEGIN
                   CASE __currentUnit OF		{ name for input file}
                     1:__name1401:='LABI '#0;
                     2:__name1401:='LAB2I'#0;
                     3:__name1401:='LAB3I'#0;
                   END;
                   asm
                      mov dx,OFFSET __name1401		     {pointer to name}
                      mov ax,3D00H		       {open with handle code}
                      int 21H					    {call DOS}
                      jc  @1				       {jump if error}
                      mov __inHandle,ax			 {save the __inHandle}
                      xor ax,ax					 {flag all ok}
                    @1:
                      mov __OpenErr,ax		       {return the error code}
                   end;
                   InOutFunc:=@CEDInput;
                   Handle:=__inHandle;
                   END
              ELSE BEGIN
                   CASE __currentUnit OF	       { name for output file}
                     1:__name1401:='LABO '#0;
                     2:__name1401:='LAB2O'#0;
                     3:__name1401:='LAB3O'#0;
                   END;
                   asm
                      mov dx,OFFSET __name1401		     {pointer to name}
                      mov ax,3D01H			{open for output code}
                      int 21H					    {call DOS}
                      jc  @1				       {jump if error}
                      mov __outHandle,ax		{save the __outHandle}
                      xor ax,ax					 {flag all ok}
                    @1:
                      mov __OpenErr,ax		       {return the error code}
                   end;
                   Mode:=fmOutput;
                   InOutFunc:=@CEDOutput;
                   FlushFunc:=@CEDOutput;    {force flush to empty the buffer}
                   Handle:=__outHandle;
                   END;
           END;
CEDOpen:=__OpenErr;
END; {CEDOpen}

{$F-}	      {------------------- You can stop forceing FAR calls now-------}

PROCEDURE Assign1401(VAR f:TEXT);
BEGIN
WITH TextRec(F) DO
  BEGIN
    Handle:=$FFFF;		  {set the file handle to an impossible value}
    Mode:=fmClosed;
    BufSize:=SizeOf(Buffer);
    BufPtr:=@Buffer;
    OpenFunc:=@CEDOpen;
    InOutFunc:=@CEDIgnore;	     {in case anyone tries to use it too soon}
    FlushFunc:=@CEDIgnore;
    CloseFunc:=@CEDClose;
    Name[0]:=#0;
  END;
END;


PROCEDURE Close1401;				   {Shut the 1401 handle down}
BEGIN
UnSetSeg;                                    {Release any previously set area}
Close(cin);
Close(Cout);
END;


PROCEDURE Reset1401;
VAR  lvar : LONGINT;
     flag : INTEGER;
BEGIN	                                 {Reset 1401 and flush device buffers}
{$IFNDEF nowindows}
IF (__isWindows)
   THEN flag:=CallVXD(VXD_RESET,0,lvar)                   {VXD reset function}
   ELSE {$ENDIF}WRITELN(Cout,CHR(27),'I');                {or escape sequence}
END;


PROCEDURE Flush1401;
VAR  lvar : LONGINT;
     flag : INTEGER;
BEGIN	                                 {Reset 1401 and flush device buffers}
{$IFNDEF nowindows}
IF (__isWindows)
   THEN flag:=CallVXD(VXD_KILLIO,0,lvar)
   ELSE {$ENDIF}WRITELN(Cout,CHR(27),'F');
END;


PROCEDURE StopCircular;
VAR  lvar : LONGINT;
     flag : INTEGER;
BEGIN	                                        {Terminate circular transfers}
{$IFNDEF nowindows}
IF (__isWindows)
   THEN flag:=CallVXD(VXD_STOPC,0,lvar)           {VXD stop circular function}
   ELSE {$ENDIF}WRITELN(Cout,CHR(27),';');                {or escape sequence}
END;


CONST  GET_TX_MAX=17;                    { Array size for GetTransfer struct }

TYPE   TxEnt = RECORD
               phys : LONGINT;
               size : LONGINT;
               END;

       TxBlck =RECORD
               sz   : LONGINT;
               lin  : LONGINT;
               seg  : INTEGER;
               res  : INTEGER;
               avail: INTEGER;
               used : INTEGER;
               ents : ARRAY[1..GET_TX_MAX] OF TxEnt;
               END;

FUNCTION DumpXfer(dump:BOOLEAN):WORD;
{For VXD only}
VAR  flag : INTEGER;
     tx   : TxBlck;

BEGIN	                                        {Terminate circular transfers}
{$IFNDEF nowindows}
IF (__isWindows)
   THEN BEGIN
        tx.sz := 0;                                       {area number to use}
        flag := CallVXD(VXD_GETX,0,tx);            {ask the VXD for xfer info}
        IF (flag = 0)
           THEN BEGIN
                DumpXfer := tx.ents[1].size;
                IF NOT dump
                   THEN EXIT;
                WRITELN('Get xfer ',tx.sz:12,tx.lin:12,tx.seg:12,tx.used:12);
                FOR flag := 1 TO tx.used DO
                    WRITELN('Section ',flag:4,tx.ents[flag].phys:12,tx.ents[flag].size:12);
                END
           ELSE Writeln('Get transfer error ',flag);
        END;
{$ENDIF}
END; {DumpXFer}

PROCEDURE Kill1401;
{                                                               }
{  This procedure is used to kill any 1401 activity, it does    }
{  not use any facilities in the Load unit, so that it can be   }
{  called as a last-ditch clear up in error handling routines.  }
{                                                               }
CONST   kname   : ARRAY[1..5] OF CHAR ='LABO'+#0;		 {device name}
CONST   kdata	: ARRAY[1..3] OF CHAR =#27+'I'+#13;	      {ESC I sequence}
VAR     flag    : INTEGER;
        lvar    : LONGINT;
BEGIN
{$IFNDEF nowindows}
IF (__isWindows)
   THEN flag:=CallVXD(VXD_RESET,0,lvar)         {Reset code is best we can do}
   ELSE {$ENDIF}BEGIN
        ASM
	   MOV	AH,3DH					  {Code for file open}
	   MOV	AL,2					   {Read/write access}
	   MOV	DX,OFFSET kname			      {Address of device name}
	   INT	21H				  {Open handle output to LABO}
	   JC	@killf					{Give up now if error}
	   PUSH	AX					     {Save the handle}

	   MOV	BX,AX					{Get handle in BX too}
	   MOV	AH,40H				    {Write to handle function}
	   MOV	DX,OFFSET kdata			       {Address of ESC I data}
	   MOV	CX,3					     {Amount to write}
	   INT	21H				{Send ESC I sequence to reset}

	   MOV	AH,3EH					   {Close handle code}
	   POP	BX				  {Get handle back from stack}
	   INT	21H				       { and close the handle}
        @killf:
        END{asm};
        END;
END{Kill1401};


PROCEDURE Get1401Info(VAR driverRev,bus,type1401,state:INTEGER);
{ Returns values in parameters giving useful information:

  driverRev : device driver revision level or        -1 for not found out
  bus       : 0 for AT  , 1 for PS/2	            -1 for not found out
  type1401  : 0 for 1401, 1 for 1401+, 2 for u1401   -1 for not found out
  state     : same values as Open1401 with           -1 for not found out

  Get1401Info returns the revision level of the device driver (CED1401.COM)
  and the type of bus.

  If driverRev is at least 2 Get1401Info returns the current state of the 1401,
  then if the 1401 is connected and switched on Get1401Info returns the type of
  1401.

  Ranges of values are as follows:

  driverRev    -1         0      1      2       3
  bus	       -1         0      1
  type1401     -1         0      1      2
  state        -1         0      2     100     101      102     103
}

VAR w,rev,at_ps2,cga_her:INTEGER;
    lvar : LONGINT;
    flag : INTEGER;
BEGIN
type1401:=-1;							 {do not know}
state:=-1;							 {do not know}
rev:=-1;
at_ps2:=-1;
{$IFNDEF nowindows}
IF (__isWindows)
   THEN BEGIN
        flag := CallVXD(VXD_STATE,0,lvar);             {Get the state of 1401}
        IF (flag = 0)
           THEN CASE lvar OF			  {Convert OK codes to zeroes}
                  4 : BEGIN                         {Code 4 for standard 1401}
                      type1401 := 0;
                      state := 0;
                      END;
                  5 : BEGIN                                 {Code 5 for u1401}
                      type1401 := 2;
                      state := 0;
                      END;
                  6 : BEGIN                            {Code 6 for a 1401plus}
                      type1401 := 1;
                      state := 0;
                      END;
                  ELSE state := XLateVXErr(lvar);
                END{CASE}
           ELSE state := XLateVXErr(flag);
        bus := 0;
        driverRev := 3;			 {Look like a modern driver to Pascal}
        END
   ELSE {$ENDIF}BEGIN
        WRITE(Cout,#27'R'#13);					  {Send Esc R}
        IF Stat1401
           THEN READLN(Cin,rev,at_ps2,cga_her) {read codes, cga_her discarded}
           ELSE state:=2;			  {device driver not speaking}
        driverRev:=rev;			 {return device driver revision level}
        bus:=at_ps2;					     {return bus type}
        IF driverRev>=2
           THEN BEGIN
                WRITE(Cout,#27'W'#13);				  {Send Esc W}
                IF Stat1401
                   THEN BEGIN
       	                READLN(CIn,w);
	                CASE w OF
	                0:BEGIN state:=103; type1401:=-1; END;	{no interface}
	                1:BEGIN state:=100; type1401:=-1; END;      {1401 off}
	                2:BEGIN state:=101; type1401:=-1; END; {not connected}
	                4:BEGIN state:=102; type1401:=0; END;{1401 not speaking}
	                5:BEGIN state:=102; type1401:=2; END;{u1401 not speaking}
	                6:BEGIN state:=102; type1401:=1; END;{1401+ not speaking}
	                8:BEGIN state:=0;   type1401:=0; END;	     {1401 OK}
	                9:BEGIN state:=0;   type1401:=2; END;       {u1401 OK}
	                10:BEGIN state:=0;  type1401:=1; END;	    {1401+ OK}
	                ELSE BEGIN
                             state:=2;
                             type1401:=-1;              	{unknown code}
                             END;
	                END{CASE}
                        END{IF}
                END
	   ELSE BEGIN state:=2; type1401:=-1; END;		   {no answer}
        END;
END;								 {Get1401Info}

FUNCTION Open1401:INTEGER;
VAR err,rev,typeBus,type1401,state:INTEGER;
    e0,e1       :INTEGER;			   {for reading back from err}
{
0     1401 opened ok with no errors
2     Unsuitable or missing device driver, e.g.:
        Device driver not found
        1401+ but device driver older than revision level 2
        Device driver present but not giving expected responses
	Device driver revision level 0
4     Not enough file handles. TURBO needs 2
100   1401 switched off
101   1401 disconnected from interface card
102   bad communication	: 1401 present but not responding: sick, serious fault
103   No interface card
104    Timed out waiting for a response from 1401 itself
105    non-zero code from 1401 itself after sending err (exceedingly unlikely)
other? error code from?
}


FUNCTION oldErr:INTEGER;	 {ONLY used on old device drivers, Revision 1}
{this tests the 1401 in the old and dirty way. Perhaps we should just return
 with an error level such as 2 for unsuitable device driver}
VAR err,base,increment,__BUSL,__CSR1401,i,j:INTEGER;
BEGIN
WRITE(Cout,'-'#13#27'?'#13);
IF Stat1401
  THEN BEGIN
       READLN(Cin,base,increment);				 {get it back}
       __CSR1401:=base+increment;	     {calculate the 1401 port address}
       __BUSL:=__CSR1401+increment;	   {the 1401 low bus address register}
       Port[__CSR1401]:=$80;			     {freeze 1401, IF present}
       Port[__BUSL]:=$AA;		 {set bus low, which should read back}
         FOR i:=1 TO 10000 DO j:=i;			     {waste some time}
         CASE Port[__BUSL] OF
           $AA:err:=0;							  {ok}
	   $08:err:=2;				    {1401+ but driver too old}
	   $09:err:=2;				    {u1401 but driver too old}
           0  :err:=100;				  {1401 is turned off}
           $FF:err:=101;			      {probably not connected}
           ELSE err:=102;		{1401 is not communicating IF present}
         END{CASE};
       Port[__CSR1401]:=0;			      {release the 1401 again}
       END
  ELSE err:=2;				      {no response from device driver}
OldErr:=err;
END;								      {OldErr}


BEGIN								    {Open1401}
Assign1401(Cin);			       {start up the 1401 assignments}
Assign1401(Cout);
{$I-}
REWRITE(Cout);					 {try to open the output file}
err:=ioResult;        {Note Cout is opened first, the VXD code relies on this}
IF err=0
  THEN BEGIN
       {$IFNDEF nowindows}
       IF __isWindows
         THEN err:=0                   {ok so far if windows do not send char}
         ELSE {$ENDIF}BEGIN
              WRITE(Cout,#27);             {only want to time out on one char}
              err:=__CEDError-1;         {__CEDError holds #chars transferred}
              END;
       IF (err<>0)                    
         THEN err := 2          {see if there was any problem, say bad driver}
         ELSE BEGIN
              RESET(Cin);
              err := ioResult;
              IF err<>0
                THEN Close(Cout); {close cout after all as we cannot continue}
              END;
       END;
{$I+}
IF err=0					 {all ok, have a handle on it}
   THEN BEGIN		{turn off screen echo, set Pascal mode, flush buffers}
{$IFNDEF nowindows}
        IF NOT __isWindows
           THEN {$ENDIF}
                WRITE(Cout,'-'#13#27'M'#13#27'B'#13#27'F'#13);
	Reset1401;				   {so Get1401Info is correct}
    	Get1401Info(rev,typeBus,sort1401,state);    {typeBus is not used here}
        IF (sort1401 > 2)
          THEN sort1401 := 2;                   {Protect against weird values}
	IF (rev=1)			{will only get here if 1401 opened OK}
	  THEN err:=OldErr			   {get state by dirty method}
	  ELSE IF rev>=2
	         THEN err:=state	      {state found out by Get1401Info}
		 ELSE err:=2;			  {device driver 0 or unknown}
        IF err=0
          THEN BEGIN
               WRITELN(cout,'ERR');		   {see if it is really awake}
               IF Wait1401(500)	 {wait no longer than 5 seconds for an answer}
                 THEN BEGIN
                      READLN(Cin,e0,e1);		 {read the error code}
                      IF (e0<>0) OR (e1<>0)		      {should be zero}
                        THEN err:=105;			 {??? not very likely}
                      END
                 ELSE err:=104;	      {even a 1401plus should be awake by now}
               END;
        IF err<>0
          THEN Close1401;			    {release any file handles}
        END;
Open1401:=err;
END;								    {Open1401}

{initialise array values for Cin,Cout handles and modes to zero}
BEGIN
{$IFDEF multiple1401}
FOR __index:=1 TO MAX1401S DO
  BEGIN
  my1401s[__index].cin.Mode := fmClosed;
  my1401s[__index].cin.Handle := 0;
  my1401s[__index].cout.Mode := fmClosed;
  my1401s[__index].cout.Handle := 0;
  my1401s[__index].mySort1401:=0;  {standard 1401 until we find out otherwise}
  END;
{$ELSE}
__currentUnit:=1;					     {assume number 1}
sort1401:=0;						     {assume standard}
{$ENDIF}
{$IFNDEF nowindows}
__isWindows := FALSE;                                             {assume DOS}
{$ENDIF}
END.
