unit PhysicalFileProvider;

interface

uses
  FileProvider.Intf, FileInfo.Intf, DirectoryContents.Intf, ChangeToken.Intf,
  ExclusionFilters, System.IOUtils, System.SysUtils, PathUtils, PhysicalFilesWatcher,
  NotFoundDirectoryContents, System.IO.FileSystem, FileSystemInfoHelper, PhysicalFileInfo,
  NotFoundFileInfo;

type
  /// <summary>
  /// Looks up files using the on-disk file system
  /// </summary>
  /// <remarks>
  /// When the environment variable "DOTNET_USE_POLLING_FILE_WATCHER" is set to "1" or "true", calls to
  /// <see cref="Watch(string)" /> will use <see cref="PollingFileChangeToken" />.
  /// </remarks>
  TPhysicalFileProvider = class(TInterfacedObject, IFileProvider)
  private
    FRoot: string;
    FFilters: TExclusionFilterSet;
    FFileWatcher: TPhysicalFilesWatcher;
    FUsePollingInit : Boolean;
    FUsePollingFileWatcher: Boolean;
    FUseActivePolling: Boolean;
    function GetUseActivePolling: Boolean;
    procedure SetUseActivePolling(const Value: Boolean);
//    FFileWatcherFactory:
    const
      PollingEnvironmentKey : string = 'DELPHI_USE_POLLING_FILE_WATCHER';
    function GetRoot: string;
    function CreateFileWatcher: TPhysicalFilesWatcher;
    procedure SetUsePollingFileWatcher(const Value: Boolean);
    procedure ReadPollingEnvironmentVariables;
    function GetFullPath(path: string): string;
    function IsUnderneathRoot(fullPath: string): Boolean;
  public
    /// <summary>
    /// Initializes a new instance of a PhysicalFileProvider at the given root directory.
    /// </summary>
    /// <param name="root">The root directory. This should be an absolute path.</param>
    constructor Create(root: string); overload;

    /// <summary>
    /// Initializes a new instance of a PhysicalFileProvider at the given root directory.
    /// </summary>
    /// <param name="root">The root directory. This should be an absolute path.</param>
    /// <param name="filters">Specifies which files or directories are excluded.</param>
    constructor Create(root: string; filters: TExclusionFilterSet); overload;

  //IFileProvider
    /// <summary>
    /// Locate a file at the given path.
    /// </summary>
    /// <param name="subpath">Relative path that identifies the file.</param>
    /// <returns>The file information. Caller must check Exists property.</returns>
    function GetFileInfo(subPath: string): IFileInfo;

    /// <summary>
    /// Enumerate a directory at the given path, if any.
    /// </summary>
    /// <param name="subpath">Relative path that identifies the directory.</param>
    /// <returns>Returns the contents of the directory.</returns>
    function GetDirectoryContents(subPath: string): IDirectoryContents;

    /// <summary>
    /// Creates a <see cref="IChangeToken"/> for the specified <paramref name="filter"/>.
    /// </summary>
    /// <param name="filter">Filter string used to determine what files or folders to monitor. Example: **/*.cs, *.*, subFolder/**/*.cshtml.</param>
    /// <returns>An <see cref="IChangeToken"/> that is notified when a file matching <paramref name="filter"/> is added, modified or deleted.</returns>
    function Watch(filter: string): IChangeToken;

    function GetUsePollingFileWatcher : boolean;

    /// <summary>
    /// The root directory for this instance.
    /// </summary>
    property Root: string read GetRoot;

    /// <summary>
    /// Gets or sets a value that determines if this instance of <see cref="PhysicalFileProvider"/>
    /// uses polling to determine file changes.
    /// <para>
    /// By default, <see cref="PhysicalFileProvider"/>  uses <see cref="FileSystemWatcher"/> to listen to file change events
    /// for <see cref="Watch(string)"/>. <see cref="FileSystemWatcher"/> is ineffective in some scenarios such as mounted drives.
    /// Polling is required to effectively watch for file changes.
    /// </para>
    /// <seealso cref="UseActivePolling"/>.
    /// </summary>
    /// <value>
    /// The default value of this property is determined by the value of environment variable named <c>DOTNET_USE_POLLING_FILE_WATCHER</c>.
    /// When <c>true</c> or <c>1</c>, this property defaults to <c>true</c>; otherwise false.
    /// </value>
    property UsePollingFileWatcher: Boolean read GetUsePollingFileWatcher write SetUsePollingFileWatcher;

    /// <summary>
    /// Gets or sets a value that determines if this instance of <see cref="PhysicalFileProvider"/>
    /// actively polls for file changes.
    /// <para>
    /// When <see langword="true"/>, <see cref="IChangeToken"/> returned by <see cref="Watch(string)"/> will actively poll for file changes
    /// (<see cref="IChangeToken.ActiveChangeCallbacks"/> will be <see langword="true"/>) instead of being passive.
    /// </para>
    /// <para>
    /// This property is only effective when <see cref="UsePollingFileWatcher"/> is set.
    /// </para>
    /// </summary>
    /// <value>
    /// The default value of this property is determined by the value of environment variable named <c>DOTNET_USE_POLLING_FILE_WATCHER</c>.
    /// When <c>true</c> or <c>1</c>, this property defaults to <c>true</c>; otherwise false.
    /// </value>
    property UseActivePolling: Boolean read GetUseActivePolling write SetUseActivePolling;
  end;

implementation

{ TPhysicalFileProvider }

constructor TPhysicalFileProvider.Create(root: string);
begin
  Create(root, [TExclusionFilters.DotPrefixed, TExclusionFilters.Hidden, TExclusionFilters.IsSystem ])
end;

constructor TPhysicalFileProvider.Create(root: string;
  filters: TExclusionFilterSet);
var
  fullRoot: string;
begin
  if Not TPath.IsPathRooted(root) then
    raise EArgumentException.Create('The path must be absolute. root');

  fullRoot := TPath.GetFullPath(root);

  // When we do matches in GetFullPath, we want to only match full directory names.
  FRoot := TPathUtils.EnsureTrailingSlash(fullRoot);
  if Not TDirectory.Exists(FRoot) then
    raise EDirectoryNotFoundException(FRoot);

  FFilters := filters;
//  FFileWatcherFactory = () => CreateFileWatcher(); TODO: need implement
end;

function TPhysicalFileProvider.CreateFileWatcher: TPhysicalFilesWatcher;
var
  root: string;
//  watcher: TPhysicalFilesWatcher;
begin
  root := TPathUtils.EnsureTrailingSlash(TPath.GetFullPath(FRoot));

  //TODO: need implement
  result := TPhysicalFilesWatcher.Create(root, TFileSystemWatcher.Create(root), UsePollingFileWatcher, FFilters);
end;

function TPhysicalFileProvider.GetDirectoryContents(subPath: string): IDirectoryContents;
var
  fullPath: string;
begin
  try
    if subPath.IsEmpty Or Not TPath.HasValidPathChars(subpath, false) then
      Exit(TNotFoundDirectoryContents.Singleton);

    // Relative paths starting with leading slashes are okay
    subpath := subpath.TrimLeft([TPath.DirectorySeparatorChar, TPath.AltDirectorySeparatorChar]);

    // Absolute paths not permitted.
    if TPath.IsPathRooted(subpath) then
      Exit(TNotFoundDirectoryContents.Singleton);

    fullPath := GetFullPath(subpath);

  except
    on E: EDirectoryNotFoundException do
    begin
      // do nothing
    end;
    on E: EInOutError do
    begin
      // do nothing
    end;
  end;

  Result := TNotFoundDirectoryContents.Singleton;
end;

function TPhysicalFileProvider.GetFileInfo(subPath: string): IFileInfo;
var
  fullPath: string;
  fileInfo: TFileInfo;
begin
  if subPath.IsEmpty Or Not TPath.HasValidPathChars(subPath, false) then
    Exit(TNotFoundFileInfo.Create(subPath));

  // Relative paths starting with leading slashes are okay
  subPath := subPath.TrimLeft([TPath.DirectorySeparatorChar, TPath.AltDirectorySeparatorChar]);

  // Absolute paths not permitted.
  if TPath.IsPathRooted(subPath) then
    Exit(TNotFoundFileInfo.Create(subPath));

  fullPath := GetFullPath(subPath);
  if fullPath.IsEmpty then
    Exit(TNotFoundFileInfo.Create(subPath));

  fileInfo := TFileInfo.Create(fullPath);

  if TFileSystemInfoHelper.IsExcluded(fileInfo, FFilters) then
    Exit(TNotFoundFileInfo.Create(subPath));

  Result :=  TPhysicalFileInfo.Create(fileInfo);
end;

function TPhysicalFileProvider.GetFullPath(path: string): string;
var
  fullPath: string;
begin
  if TPathUtils.PathNavigatesAboveRoot(path) then
    Exit(string.Empty);

  try
    fullPath := TPath.GetFullPath(TPath.Combine(Root, path))
  except
    Exit(string.Empty);
  end;


  if Not IsUnderneathRoot(fullPath) then
    Exit(string.Empty);

  Result := fullPath;
end;

function TPhysicalFileProvider.GetRoot: string;
begin
  Result := FRoot;
end;

function TPhysicalFileProvider.GetUseActivePolling: Boolean;
begin
  if Not FUsePollingInit then
      ReadPollingEnvironmentVariables;

  Result := FUseActivePolling
end;

function TPhysicalFileProvider.GetUsePollingFileWatcher: boolean;
begin
  if FFileWatcher <> Nil then
    raise EInvalidOpException.Create('Cannot modify UsePollingFileWatcher once file watcher has been initialized.');

  if Not FUsePollingInit then
      ReadPollingEnvironmentVariables;

  Result := FUsePollingFileWatcher
end;

function TPhysicalFileProvider.IsUnderneathRoot(fullPath: string): Boolean;
begin
  Result := fullPath.StartsWith(Root, true);
end;

procedure TPhysicalFileProvider.ReadPollingEnvironmentVariables;
var
  environmentValue: string;
  pollForChanges: Boolean;
begin
  environmentValue := GetEnvironmentVariable(PollingEnvironmentKey);
  pollForChanges := string.Equals(environmentValue, '1') Or
      string.Equals(environmentValue, 'true');

  FUsePollingFileWatcher := pollForChanges;
  FUseActivePolling := pollForChanges;

  FUsePollingInit := True;
end;

procedure TPhysicalFileProvider.SetUseActivePolling(const Value: Boolean);
begin
  FUseActivePolling := Value;
  FUsePollingInit := True;
end;

procedure TPhysicalFileProvider.SetUsePollingFileWatcher(const Value: Boolean);
begin
  FUsePollingFileWatcher := Value;
  FUsePollingInit := True;
end;

function TPhysicalFileProvider.Watch(filter: string): IChangeToken;
begin

end;

end.
