unit PathUtils;

interface

uses
  System.IOUtils, System.SysUtils, System.Classes;

type
  TPathUtils = class
  public
    class function EnsureTrailingSlash(path: string): string;
    class function PathNavigatesAboveRoot(path: string): Boolean;
  end;

implementation

{ TPathUtils }

class function TPathUtils.EnsureTrailingSlash(path: string): string;
begin
  if (Not path.IsEmpty And (path[path.Length] <> TPath.DirectorySeparatorChar)) then
    Exit(path + TPath.DirectorySeparatorChar);

  Exit(path);
end;


class function TPathUtils.PathNavigatesAboveRoot(path: string): Boolean;
begin
  //TODO: need implement PathNavigatesAboveRoot

  Result := False;
end;

end.
