unit uProcedure;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

procedure FindFiles(StartFolder, Mask: string; List: TStrings; ScanSubFolders: Boolean = True);

implementation

uses
  ShellApi, Masks;

procedure FindFiles(StartFolder, Mask: string; List: TStrings; ScanSubFolders: Boolean = True);
var
  SearchRec  : TSearchRec;
  FindResult : Integer;
begin
  List.BeginUpdate;
  try
    StartFolder := IncludeTrailingPathDelimiter(StartFolder);
    FindResult  := FindFirst(StartFolder + Mask, faAnyFile, SearchRec);
    try
      while FindResult = 0 do
        with SearchRec do
        begin
          if (Attr and faDirectory) <> 0 then
          begin
            if ScanSubFolders and (Name <> '.') and (Name <> '..') then
              FindFiles(StartFolder + Name, Mask, List, ScanSubFolders);
          end
          else
          begin
            if MatchesMask(Name, Mask) then
              List.Add(StartFolder + Name);
          end;
        FindResult := FindNext(SearchRec);
      end;
    finally
      FindClose(SearchRec);
    end;
  finally
    List.EndUpdate;
  end;
end;

end.
