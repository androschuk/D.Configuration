unit DirectoryContents.Intf;

interface

uses
  Generics.Collections, FileInfo.Intf;

type
  /// <summary>
  /// Represents a directory's content in the file provider.
  /// </summary>
  IDirectoryContents = interface(IEnumerable<IFileInfo>)
  ['{1529DC6B-6AFC-4F90-BD3E-5E600D6B9F89}']

    /// <summary>
    /// True if a directory was located at the given path.
    /// </summary>
    function Exists: Boolean;
  end;

implementation

end.
