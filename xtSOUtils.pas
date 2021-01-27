unit xtSOUtils;

interface

uses System.Types
{$IFDEF MACOS}
{$IFDEF IOS}
    , iOSapi.Foundation, Macapi.Helpers, FMX.Helpers.iOS

{$ELSE}
    , Macapi.CocoaTypes, Macapi.Helpers
{$ENDIF}
{$ENDIF}
{$IFDEF MSWINDOWS}
    , FMX.Platform.Win, WINDOWS, ShellAPI, PsAPI

{$ENDIF}
{$IFDEF ANDROID}
    , Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Os
{$ENDIF}
   ,FMX.Types;

type

{$IFDEF MSWINDOWS}
  TWinVersion = (wvUnknown, wvWin95, wvWin98, wvWin98SE, wvWinNT, wvWinME,
    wvWin2000, wvWinXP, wvWinVista, wvWin7, wvWin8, wvWin10);
{$ELSE}
  HWND = type System.UIntPtr;  // NativeUInt;
{$ENDIF}



  TSOVersion = record
    SOType: String;
    VersionDescription: String;
    VerisonName: String;
    VersionClass: Integer; // 1 = WinNT Class, 0 = oldWinClass
    MajorNumber: Integer;
    MinorNumber: Integer;
    Supported: Boolean;
{$IFDEF MSWINDOWS}
    WinVer: TWinVersion;
{$ENDIF}
  end;

  TSynapticaSOUtils = class
  public
    class function GetAppVersionStr: string;
    class function getSOVersion : TSOVersion;
    class function executeFile(FileName: String; Handle: TWindowHandle = nil;
      executeAsAdmin: Boolean = false;
      ForceRunWithDefaultApp: Boolean = True): Boolean;

    class function RunAsAdmin(hWnd: HWND; filename: string; Parameters: string): Boolean;

    class function UnzipFile(ArcFileName,PathDest : String): Boolean;
  end;

Var
{$IFDEF MSWINDOWS}
  winVer: TWinVersion;
{$ENDIF}
  SOVersion: TSOVersion;
  InPlay: Boolean;

implementation

uses
  System.Classes, System.SysUtils, IdGlobalProtocols, System.IOUtils,
  System.zip, idUri
{$IFDEF MSWINDOWS}
    , TlHelp32, Winapi.Messages,
  System.UITypes, idStack, System.Win.Registry

{$ENDIF}
{$IFDEF LINUX}
    , idStack
    , uLinuxExecCommand
{$ENDIF}
{$IFDEF MACOS}
    , Macapi.CoreFoundation,
{$IFNDEF IOS}
  Macapi.CoreGraphics,
  Macapi.ImageIO,
  Macapi.AppKit,
  Macapi.QuartzCore,
  Macapi.OpenGL,
  Macapi.KeyCodes,
{$ENDIF}
  Posix.StdLib,
  Posix.Unistd,
  idStack
{$ENDIF}
{$IFDEF ANDROID}
    , Androidapi.JNI.media, FMX.Helpers.Android, Androidapi.JNI.JavaTypes,
  Androidapi.JNIBridge,
  Androidapi.Helpers, Androidapi.JNI.Net, Androidapi.JNI,
  Androidapi.Input, Androidapi.NativeActivity, QAndroid.Shell, fedeWrapper
{$ENDIF}
    ;

{ TSynapticaSOUtils }

class function TSynapticaSOUtils.executeFile(FileName: String;
  Handle: TWindowHandle; executeAsAdmin,
  ForceRunWithDefaultApp: Boolean): Boolean;
{$IFDEF ANDROID}
var
  Intent: JIntent;
  idMimeTable: TIdMimeTable;
  PM : JPackageManager;
  lst : JList;
  itr : Jiterator;
  ri : JResolveInfo;
  ts: TStringList;
{$ENDIF}
{$IFDEF IOS}
var
  NSU: NSUrl;
{$ENDIF}


{$IFDEF MSWINDOWS}



 procedure WindowsExec(fname : String;runAsAdministrator : Boolean);
  var
    go: Boolean;
  Begin
    if winVer = wvUnknown then
         Begin
          SOVersion := getSOVersion;
         End;
    if runAsAdministrator then
     Begin


        if ((winVER in [wvWin7,wvWinVista,wvWin8])or(winVER > wvWin8)) then

         go := RunAsAdmin(FmxHandleToHWND(Handle),fname,'/DIR="' + ExtractFileDir(fname) + '" /LOG="' + ExtractFileDir(fname) + '\UPGP.LOG"')
       else
         ShellExecute(0,'open',PChar(fname),PChar('/DIR="' +  ExtractFileDir(fname) + '" /LOG="' +  ExtractFileDir(fname) + '\UPGP.LOG"'),PChar( ExtractFileDir(fname)),sw_shownormal);
     End
    Else
      ShellExecute(0, 'open', pWideChar(ExtractFileName(fname.Replace('\\','\'))), '',
    pWideChar(ExtractFileDir(fname).Replace('\\','\')), SW_SHOW);
  End;



{$ENDIF}



begin
{$IFDEF LINUX}

 ExecPCommand(FileName);

{$ENDIF}


{$IFDEF MACOS}
  (* ***** SHELLEXECUTE EQUIVALENT FOR MACOSX ****** *)
  (* - E' L'EQUIVALENTE DI LANCIARE UN COMANDO DA SHELL
    - IL PARAMETRO -N (APRE IL FILE ANCHE SE E' GIA' APERTO)
  *)
  _system(PAnsiChar('open ' + '"' + AnsiString(FileName) + '" -F'));
{$ENDIF}
{$IFDEF MSWINDOWS}
 if FileName.ToLower.StartsWith('http') then
  Begin

    ShellExecute(0, 'open', PChar(FileName), '',
    '', SW_SHOW);
  End
 Else
  Begin
   WindowsExec(FileName,executeAsAdmin);

  End;

{$ENDIF}
{$IFDEF ANDROID}
// There may be an issue with the geo: prefix and URLEncode.
// will need to research
  (*
  intent = new Intent(context, SplashScreen.class);
  intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
  intent.setAction(Intent.ACTION_MAIN);
  intent.addCategory(Intent.CATEGORY_LAUNCHER);
  startActivity(intent);
  *)

  (*
   **************************************
   CERCO DI PORTARE REMODE IN PRIMO PIANO
   *)
  try
  Intent := TJIntent.JavaClass.init(SharedActivityContext,SharedActivityContext.getClass);
  intent.addFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK);
  intent.setAction(TJIntent.JavaClass.ACTION_MAIN);
  intent.addCategory(TJIntent.JavaClass.CATEGORY_LAUNCHER);
  SharedActivity.startActivity(Intent);
  Except
   On E:Exception do
    Begin

    End;
  End;

  InPlay := True;
  if (ExtractFileExt(FileName).ToLower = '.html')and(not(FileName.toLower.StartsWith('http://'))) then
   Begin
  {  frmWebBrowser := TfrmWebBrowser.Create(nil);

    ts := TStringList.Create;
    try
    ts.LoadFromFile(FileName);
    frmWebBrowser.WebBrowser1.LoadFromStrings(ts.Text,'http://localhost:9999');
    //frmWebBrowser.WebBrowser1.URL := FileName;
    //frmWebBrowser.WebBrowser1.Navigate;
    frmWebBrowser.Show;
    finally
     ts.Free;
    End;
   }
   End
  else if FileName.toLower.StartsWith('http://')or(FileName.toLower.StartsWith('https://')) then
    Begin
      Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW,  TJnet_Uri.JavaClass.parse(StringToJString(TIdURI.URLEncode(FileName))));
    End
  Else
    Begin
     try
       idMimeTable := TidMimeTable.Create;
       Intent := TJIntent.Create;
       Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
       if not FileName.ToLower.StartsWith('file://') then
         FileName := 'file://' + FileName;
       Intent.setDataAndType(StrToJURI(FileName),  StringToJString(idMimeTable.GetFileMIMEType(FileName)));
       Intent.setFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK);

       if ForceRunWithDefaultApp then
        Begin
         PM := SharedActivity.getPackageManager;
         lst := PM.queryIntentActivities(Intent,0);

         itr := lst.iterator;
         if lst.size >0 then
          Begin
           ri := TJResolveInfo.Wrap((itr.next as ILocalObject).getObjectId);
           Intent.setPackage(ri.activityInfo.applicationInfo.packageName);
          End;
        End;
     Finally
       try idMimeTable.Free; except end;
     End;

    End;
  try
    SharedActivity.startActivity(Intent);
    exit(true);
  except
    (* on e: Exception do
    begin
      if DisplayError then ShowMessage('Error: ' + e.Message);
      exit(false);
    end;           *)
  end;
{$ENDIF}
{$IFDEF IOS}
  // iOS doesn't like spaces, so URL encode is important.
  NSU := StrToNSUrl(TIdURI.URLEncode(Filename));
  if SharedApplication.canOpenURL(NSU) then
    exit(SharedApplication.openUrl(NSU))
  else
  begin
//    if DisplayError then
//      ShowMessage('Error: Opening "' + URL + '" not supported.');
    exit(false);
  end;
 {$ENDIF}
end;

class function TSynapticaSOUtils.GetAppVersionStr: string;
{$IFDEF MACOS}
var
  CFStr: CFStringRef;
  Range: CFRange;
begin
  CFStr := CFBundleGetValueForInfoDictionaryKey(
    CFBundleGetMainBundle, kCFBundleVersionKey);
  Range.location := 0;
  Range.length := CFStringGetLength(CFStr);
  SetLength(Result, Range.length);
  CFStringGetCharacters(CFStr, Range, PChar(Result));
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
var
  Exe: string;
  Size, Handle: DWORD;
  Buffer: TBytes;
  FixedPtr: PVSFixedFileInfo;
begin
  Exe := ParamStr(0);
  Size := GetFileVersionInfoSize(PChar(Exe), Handle);
  if Size = 0 then
    RaiseLastOSError;
  SetLength(Buffer, Size);
  if not GetFileVersionInfo(PChar(Exe), Handle, Size, Buffer) then
    RaiseLastOSError;
  if not VerQueryValue(Buffer, '\', Pointer(FixedPtr), Size) then
    RaiseLastOSError;
  Result := Format('%d.%d.%d.%d',
    [LongRec(FixedPtr.dwFileVersionMS).Hi,  //major
     LongRec(FixedPtr.dwFileVersionMS).Lo,  //minor
     LongRec(FixedPtr.dwFileVersionLS).Hi,  //release
     LongRec(FixedPtr.dwFileVersionLS).Lo]) //build
end;
{$ENDIF}
{$IFDEF ANDROID}

 {code}

 var
   PackageManager: JPackageManager;
   PackageInfo: JPackageInfo;
 begin
   PackageManager := SharedActivityContext.getPackageManager;
   PackageInfo := PackageManager.getPackageInfo
     (SharedActivityContext.getPackageName, 0);
   result := JStringToString(PackageInfo.versionName);
 End;
{$ENDIF}
{$IFDEF LINUX64}
 var
   RS : TResourceStream;
   TS : TStringList;
 begin
   RS := nil;
   ts := nil;
   Result := '';
   try
     ts := TStringList.Create;
     RS := TResourceStream.Create(HInstance, 'versione', RT_RCDATA);
     ts.LoadFromStream(RS);
     Result := ts.Text;
   Finally
     if RS <> nil then
       try
         RS.Free;
       Except
       End;

     if TS <> nil then
       try
         TS.Free;
       Except
       End;
   End;

//   result := '';
//   raise Exception.Create('not implemented');

 End;
{$ENDIF}

   // codeverge.com/embarcadero.delphi.firemonkey/ios-and-android-get-application/1060702#sthash.WwHh1av9.dpuf
(*
{$IFDEF IOS} Result := TNSString.Wrap(CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle, kCFBundleVersionKey)).UTF8String; {$ENDIF} - See more at: http://codeverge.com/embarcadero.delphi.firemonkey/ios-and-android-get-application/1060702#sthash.fo31DA7J.dpuf
*)


class function TSynapticaSOUtils.getSOVersion: TSOVersion;
  {$IFDEF MSWINDOWS}
    type
      TIntSOVer = record
        WinVer : TWinVersion;
        MajorVersion : Integer;
        MinorVersion : Integer;
        VersionClass : Integer; // 1 = WinNT Class, 0 = oldWinClass
      end;


    function GetWinVersion: TIntSOVer;
     var
        osVerInfo: TOSVersionInfo;
        majorVersion, minorVersion: Integer;
     begin
        Result.WinVer := wvUnknown;
        osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo) ;
        if GetVersionEx(osVerInfo) then
        begin
          minorVersion := osVerInfo.dwMinorVersion;
          majorVersion := osVerInfo.dwMajorVersion;
          Result.MajorVersion := majorVersion;
          Result.MinorVersion := minorVersion;

          case osVerInfo.dwPlatformId of
            VER_PLATFORM_WIN32_NT:
            begin
              Result.VersionClass := 1;
              if majorVersion <= 4 then
                Result.WinVer := wvWinNT
              else if (majorVersion = 5) and (minorVersion = 0) then
                Result.WinVer := wvWin2000
              else if (majorVersion = 5) and (minorVersion = 1) then
                Result.WinVer := wvWinXP
              else if (majorVersion = 6) then
                Result.WinVer := wvWinVista
              else if (majorVersion = 7) then
                Result.WinVer := wvWin7;
            end;
            VER_PLATFORM_WIN32_WINDOWS:
            begin
              Result.VersionClass := 0;
              if (majorVersion = 4) and (minorVersion = 0) then
                Result.WinVer := wvWin95
              else if (majorVersion = 4) and (minorVersion = 10) then
              begin
                if osVerInfo.szCSDVersion[1] = 'A' then
                  Result.WinVer := wvWin98SE
                else
                  Result.WinVer := wvWin98;
              end
              else if (majorVersion = 4) and (minorVersion = 90) then
                Result.WinVer := wvWinME
              else
                Result.WinVer := wvUnknown;
            end;
          end;
        end;
     end;
var
  wVer: TIntSOVer;
{$ENDIF}


Begin
 {$IFDEF MSWINDOWS}
   wVer := GetWinVersion;
   Result.SOType := 'MSWINDOWS';
   Result.VersionDescription := '';
   Result.VerisonName := '';
   Result.VersionClass := wVer.VersionClass;
   Result.MajorNumber := wVer.MajorVersion;
   Result.MinorNumber := wVer.MinorVersion;
   Result.winVer      := wVer.winVer;
   Result.Supported := True;


   winVer := wVer.WinVer;
 {$ELSE}
   raise Exception.Create('not implemented');
   Result.Supported := False;
 {$ENDIF}
End;

class function TSynapticaSOUtils.RunAsAdmin(hWnd: HWND; filename,
  Parameters: string): Boolean;
{$IFDEF MSWINDOWS}
 var
     sei: TShellExecuteInfo;
 begin

     ZeroMemory(@sei, SizeOf(sei));
     sei.cbSize := SizeOf(TShellExecuteInfo);
     sei.Wnd := hwnd;
     sei.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
     sei.lpVerb := PChar('runas');
     sei.lpFile := PChar(Filename); // PAnsiChar;
     if parameters <> '' then
         sei.lpParameters := PChar(parameters); // PAnsiChar;
     sei.nShow := SW_SHOWNORMAL; //Integer;
     Result := ShellExecuteEx(@sei);
 end;

{$ELSE}
Begin
 result := False;
End;
{$ENDIF}

class function TSynapticaSOUtils.UnzipFile(ArcFileName,
  PathDest: String): Boolean;
var zf:TZipFile;
begin
 zf:= TZipFile.Create;
 Try
   Try
    Result := False;
    If ArcFileName <> '' then
     Begin
      if zf.IsValid(ArcFileName) then
       zf.ExtractZipFile(ArcFileName,PathDest);

      Result := zf.FileCount > 0;
     End;
   Except
    Result := False;
   End;
 Finally
  zf.free;
 End;
End;


end.
