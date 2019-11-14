unit FileProvider;

interface

uses
  FileProvider.Intf, FileInfo.Intf, DirectoryContents.Intf, ChangeToken.Intf,
  System.SysUtils;


type
  TFileProvider = class(TInterfacedObject, IFileProvider)
    /// <summary>
    /// Locate a file at the given path.
    /// </summary>
    /// <param name="subpath">Relative path that identifies the file.</param>
    /// <returns>The file information. Caller must check Exists property.</returns>
    function GetFileInfo(subPath: string) :IFileInfo;

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
  end;

implementation

{ TFileProvider }

function TFileProvider.GetDirectoryContents(
  subPath: string): IDirectoryContents;
begin
  raise ENotImplemented.Create('GetDirectoryContents');
end;

function TFileProvider.GetFileInfo(subPath: string): IFileInfo;
begin
  raise ENotImplemented.Create('GetFileInfo');
end;

function TFileProvider.Watch(filter: string): IChangeToken;
begin
  raise ENotImplemented.Create('Watch');
end;

end.
