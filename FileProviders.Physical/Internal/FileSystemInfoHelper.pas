unit FileSystemInfoHelper;

interface

uses
  System.IO.FileSystem, ExclusionFilters, System.SysUtils, System.IOUtils;

type
  TFileSystemInfoHelper = class
  public
    class function IsExcluded(fileSystemInfo: TFileSystemInfo; filters: TExclusionFilterSet): Boolean;
  end;

implementation

{ TFileSystemInfoHelper }

class function TFileSystemInfoHelper.IsExcluded(fileSystemInfo: TFileSystemInfo;
  filters: TExclusionFilterSet): Boolean;
begin
  if TExclusionFilters.None in filters then
    Exit(false)
  else
  if fileSystemInfo.Name.StartsWith('.') And (TExclusionFilters.DotPrefixed in filters) then
    Exit(true)
  else
  if fileSystemInfo.Exists And
  ((TFileAttribute.faHidden in fileSystemInfo.Attributes) And (TExclusionFilters.Hidden in filters)) Or
  ((TFileAttribute.faSystem in fileSystemInfo.Attributes) And (TExclusionFilters.IsSystem in filters))
  then
    Exit(true)
  else
    Result := False;
end;

end.
