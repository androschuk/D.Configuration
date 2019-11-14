unit PhysicalFilesWatcher;

interface

uses
  System.IOUtils, ExclusionFilters;

type
  TFileSystemWatcher = class
  public
    constructor Create(root: string);
  end;

  TPhysicalFilesWatcher = class
  public
    constructor Create(root: string; fileSysWatcher: TFileSystemWatcher; pollForChanges: Boolean); overload;
    constructor Create(root: string; fileSysWatcher: TFileSystemWatcher; pollForChanges: Boolean; filters: TExclusionFilterSet); overload;
  end;

implementation

{ TPhysicalFilesWatcher }

constructor TPhysicalFilesWatcher.Create(root: string;
  fileSysWatcher: TFileSystemWatcher; pollForChanges: Boolean;
  filters: TExclusionFilterSet);
begin

end;

constructor TPhysicalFilesWatcher.Create(root: string;
  fileSysWatcher: TFileSystemWatcher; pollForChanges: Boolean);
begin
  Create(root, fileSysWatcher, pollForChanges, TExclusionFiltersSet);
end;

{ TFileSystemWatcher }

constructor TFileSystemWatcher.Create(root: string);
begin
// TODO: need implement FileSystemWatcher
end;

end.
