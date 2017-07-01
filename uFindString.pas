unit uFindString;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, SynCobjs, uFormats;

type
  /// <summary>Потік пошуку входження рядка в файл</summary>
  TFindStrThread = class(TThread)
   private
     ThreadListP: TThreadList;
     SearchText : TSearchAll;
     FileName   : string;
     Text       : string;
   public
     procedure AddToFindList;
     procedure Execute; override;
     constructor Create(AThreadList: TThreadList);
     destructor Destroy; override;
  end;

  /// <summary>Клас пошуку входження рядка в множину файлів</summary>
  TFindsString = class
  const
    NOT_FIND        = 'Задана строка не знайдена в жодному з файлів';
    Maska           = '*.*';
    TIMER_ITERATION = 1000;
  private
    class var ReturnList: TStrings;
    class var TimerID   : UINT;
    class var FindList  : TStrings;
    class var ThreadList: TThreadList;
    class procedure TimerProc(Wnd:HWND; uMsg:DWORD; idEvent:PDWORD; dwTime:DWORD); stdcall; static;
    /// <remarks>Виведення результату роботи пошуку</remarks>
    class procedure Return;
    class procedure CloseThread;
  private
    FileList: TStrings;
  public
    constructor Create;
    destructor Destroy; override;
    /// <param name="AFolder">Папка в якій буде пошук рядка</param>
    function GetFiles(AFolder: string; const DisplayList: TStrings = nil): Boolean;
    /// <param name="AText">Рядок який будемо шукати</param>
    procedure StartSearch(const AText: string; const DisplayList: TStrings = nil);
   /// <remarks>Зупинка пошуку</remarks>
    procedure StopSearch;
  end;

var
  cs: TCriticalSection;
  ThreadCounter: Integer = 0;

implementation

uses
  uProcedure, Dialogs {$IFDEF DEBUG},CodeSiteLogging{$ENDIF};

{ ------------------------------------------ TFindsString -------------------------------------------------------------}

class procedure TFindsString.TimerProc(Wnd:HWND; uMsg:DWORD; idEvent:PDWORD; dwTime:DWORD);
begin
  // Очікуємо на останній закриття останнього потоку
  if ThreadCounter = 0 then
  begin
    KillTimer(0, TimerID);
    TFindsString.Return;
    CloseThread;
  end;
end;

class procedure TFindsString.CloseThread;
var
  I: integer;
begin
  with ThreadList.LockList do
  try
    if Count > 0 then
    begin
      for I := 0 to Count-1 do
        if Assigned(TFindStrThread(Items[i])) then
        begin
          TFindStrThread(Items[i]).Terminate;
//          TFindStrThread(Items[i]).WaitFor;
//          TFindStrThread(Items[i]).Free;
        end;
      ThreadList.Clear;
    end;
  finally
    ThreadList.UnlockList;
  end;
end;

constructor TFindsString.Create;
begin
  cs        := TCriticalSection.Create;
  FileList  := TStringList.Create;
  FindList  := TStringList.Create;
  ReturnList:= nil;
  //Зберігаємо список потоків для їх закриття
  ThreadList:= TThreadList.Create;
  //Забороняємо дублікати
  TStringList(FindList).Duplicates := dupIgnore;
end;

destructor TFindsString.Destroy;
begin
  FreeAndNil( FileList );
  FreeAndNil( FindList );
  FreeAndNil( ThreadList );
  FreeAndNil( cs );
  KillTimer(0, TimerID);
  inherited;
end;

class procedure TFindsString.Return;
var
  tmp: string;
  i,j: Integer;
begin
  // Якщо нічого не знайдено виходимо (-:
  if FindList.Count = 0 then
  begin
    ShowMessage( NOT_FIND );
    Exit;
  end;

  // Виводимо результат у вигляді списку файлів
  for i := 0 to FindList.Count-1 do
  begin
    j := ReturnList.IndexOf( FindList[i] );
    if j > -1 then
      ReturnList[ j ] := Format('[%s] %s', [Chr($221A), ReturnList[ j ]]);
  end;
end;

procedure TFindsString.StartSearch(const AText: string; const DisplayList: TStrings);
var
  tmp: string;
begin
  {$IFDEF DEBUG}
    CodeSite.EnterMethod('TFindsString.StartSearch');
  {$ENDIF}

  if Assigned(DisplayList) then
    ReturnList := DisplayList;

  FindList.Clear;
  // Проходисося по всім знайденим файлам в списку
  for tmp in FileList do
  begin
    { TODO : Для прискорення потрібно: Файл бється на поток, кожна частина файла обробляється своїм потоком, без обриву текстового рядка}
    // Для кожного файлу запускаємо окремий потік на пошук тексту
    with TFindStrThread.Create( ThreadList ) do
     begin
       FileName    := tmp;
       Text        := AText;
       Start;
     end;
  end;
  // Запускаємо таймер для виведення результату
  TimerID := SetTimer(0, 0, TIMER_ITERATION, @TimerProc);
end;

procedure TFindsString.StopSearch;
begin
  CloseThread;
  {$IFDEF DEBUG}
    CodeSite.ExitMethod('TFindsString.StopSearch');
    CodeSite.AddSeparator;
  {$ENDIF}
end;

// Завантаження списку для роботи
function TFindsString.GetFiles(AFolder: string; const DisplayList: TStrings): Boolean;
begin
  Result := False;
  FileList.Clear;
  FindFiles(AFolder, Maska, FileList);
  Result := FileList.Count > 0;
  if Assigned(DisplayList) then
  begin
    DisplayList.Clear;
    DisplayList.AddStrings( FileList );
  end;
end;

{ ------------------------------------------ TFindStrThread ---------------------------------------------------------- }

procedure TFindStrThread.AddToFindList;
begin
  cs.Enter;
  try
    TFindsString.FindList.Add( FileName );
  finally
    cs.Leave;
  end;
end;

constructor TFindStrThread.Create(AThreadList: TThreadList);
begin
  inherited Create( true );
  FreeOnTerminate := True;

  ThreadListP := AThreadList;
  ThreadListP.Add( Self );

  InterlockedIncrement( ThreadCounter );

  {$IFDEF DEBUG}
    CodeSite.SendFmtMsg('Create: %d',[Self.Handle]);
  {$ENDIF}
end;

destructor TFindStrThread.Destroy;
begin
  InterlockedDecrement( ThreadCounter );

  cs.Enter;
  try
    ThreadListP.Remove( Self );
  finally
    cs.Leave;
  end;

  {$IFDEF DEBUG}
    CodeSite.SendFmtMsg('Destroy: %d',[Self.Handle]);
  {$ENDIF}
  inherited;
end;

// Пошук входження тексту
procedure TFindStrThread.Execute;
var
  isFind: Boolean;
begin
  SearchText := TSearchAll.Create( FileName );
  try
    SearchText.Thread := Self;
    isFind := SearchText.Search( Text );
    if isFind then
      AddToFindList;
  finally
    FreeAndNil( SearchText );
  end;
end;

end.
