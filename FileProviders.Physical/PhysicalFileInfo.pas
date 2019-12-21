unit PhysicalFileInfo;

interface

uses
  FileInfo.Intf, System.Classes, System.SysUtils, System.IO.FileSystem,
  System.IOUtils;

type
  /// <summary>
  /// Represents a file on a physical filesystem
  /// </summary>
  TPhysicalFileInfo = class(TInterfacedObject, FileInfo.Intf.IFileInfo)
  private
    FFileInfo : TFileInfo;
  public

    /// <summary>
    /// Initializes an instance of <see cref="PhysicalFileInfo"/> that wraps an instance of <see cref="System.IO.FileInfo"/>
    /// </summary>
    /// <param name="info">The <see cref="System.IO.FileInfo"/></param>
    constructor Create(fileInfo: TFileInfo);
    destructor Destroy; override;

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
    /// Always false.
    /// </summary>
    function IsDirectory: Boolean;

    /// <summary>
    /// Return file contents as readonly stream. Caller should dispose stream when complete.
    /// </summary>
    /// <returns>The file stream</returns>
    function CreateReadStream() : TStream;
  end;

implementation

{ TPhysicalFileInfo }

constructor TPhysicalFileInfo.Create(fileInfo: TFileInfo);
begin
  FFileInfo := fileInfo;
end;

function TPhysicalFileInfo.CreateReadStream: TStream;
begin
  Result :=  TFileStream.Create(PhysicalPath, fmOpenRead Or fmShareDenyNone);
end;

destructor TPhysicalFileInfo.Destroy;
begin
  FreeAndNil(FFileInfo);
  inherited;
end;

function TPhysicalFileInfo.Exists: Boolean;
begin
  Result := FFileInfo.Exists;
end;

function TPhysicalFileInfo.IsDirectory: Boolean;
begin
  Result := False
end;

function TPhysicalFileInfo.LastModified: TDateTime;
begin
  Result := FFileInfo.LastWriteTimeUtc;
end;

function TPhysicalFileInfo.Length: Int64;
begin
  Result := FFileInfo.Length;
end;

function TPhysicalFileInfo.GetName: string;
begin
  Result := FFileInfo.Name;
end;

function TPhysicalFileInfo.PhysicalPath: string;
begin
  Result := FFileInfo.FullName;
end;

end.
