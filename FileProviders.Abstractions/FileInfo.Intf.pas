unit FileInfo.Intf;

interface

uses
  Classes;

type
  /// <summary>
  /// Represents a file in the given file provider.
  /// </summary>
  IFileInfo = interface
  ['{39F6946B-75C0-46DE-B4FE-C7588A9FBEFB}']

    /// <summary>
    /// True if resource exists in the underlying storage system.
    /// </summary>
    function  Exists: Boolean;

    /// <summary>
    /// The length of the file in bytes, or -1 for a directory or non-existing files.
    /// </summary>
    function Length: Int64;

    /// <summary>
    /// The path to the file, including the file name. Return null if the file is not directly accessible.
    /// </summary>
    function PhysicalPath: string;

    /// <summary>
    /// The name of the file or directory, not including any path.
    /// </summary>
    function GetName: string;

    /// <summary>
    /// When the file was last modified
    /// </summary>
    function LastModified: TDateTime;

    /// <summary>
    /// True for the case TryGetDirectoryContents has enumerated a sub-directory
    /// </summary>
    function IsDirectory: Boolean;

    /// <summary>
    /// Return file contents as readonly stream. Caller should dispose stream when complete.
    /// </summary>
    /// <returns>The file stream</returns>
    function CreateReadStream() : TStream;

    /// <summary>
    /// The name of the file or directory, not including any path.
    /// </summary>
    property Name: string read GetName;
  end;

implementation

end.
