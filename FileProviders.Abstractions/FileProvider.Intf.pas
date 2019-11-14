unit FileProvider.Intf;

interface

uses
  ChangeToken.Intf, FileInfo.Intf, DirectoryContents.Intf;

type
  /// <summary>
  /// A read-only file provider abstraction.
  /// </summary>
  IFileProvider = interface
  ['{036663CD-B523-41E9-B0EB-3CA6A59B82F8}']
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
  end;

implementation

end.
