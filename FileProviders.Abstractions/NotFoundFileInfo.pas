unit NotFoundFileInfo;

interface

uses
  FileInfo.Intf, System.Classes, System.SysUtils, System.DateUtils;

type
  /// <summary>
  /// Represents a non-existing file.
  /// </summary>
  TNotFoundFileInfo = class(TInterfacedObject, IFileInfo)
  private
    FName: string;
  public
    /// <summary>
    /// Initializes an instance of <see cref="NotFoundFileInfo"/>.
    /// </summary>
    /// <param name="name">The name of the file that could not be found</param>
    constructor Create(name: string);

    /// <summary>
    /// Always false.
    /// </summary>
    function  Exists: Boolean;

    /// <summary>
    /// Always equals -1.
    /// </summary>
    function Length: Int64;

    /// <summary>
    /// Always empty.
    /// </summary>
    function PhysicalPath: string;

    /// <summary>
    /// The name of the file or directory, not including any path.
    /// </summary>
    function GetName: string;

    /// <summary>
    /// Returns <see cref="TDateTime.MinValue"/>.
    /// </summary>
    function LastModified: TDateTime;

    /// <summary>
    /// Always false.
    /// </summary>
    function IsDirectory: Boolean;

    /// <summary>
    /// Always throws. A stream cannot be created for non-existing file.
    /// </summary>
    /// <exception cref="FileNotFoundException">Always thrown.</exception>
    /// <returns>Does not return</returns>
    function CreateReadStream() : TStream;
  end;

implementation

{ TNotFoundFileInfo }

constructor TNotFoundFileInfo.Create(name: string);
begin
  FName:= name;
end;

function TNotFoundFileInfo.CreateReadStream: TStream;
begin
  raise EFileNotFoundException.Create(Format('The file %s does not exist.',[GetName]));
end;

function TNotFoundFileInfo.Exists: Boolean;
begin
  Result := False;
end;

function TNotFoundFileInfo.IsDirectory: Boolean;
begin
  Result := False;
end;

function TNotFoundFileInfo.LastModified: TDateTime;
begin
  Result := 0;
end;

function TNotFoundFileInfo.Length: Int64;
begin
  Result := -1;
end;

function TNotFoundFileInfo.GetName: string;
begin
  Result := FName;
end;

function TNotFoundFileInfo.PhysicalPath: string;
begin
  Result := string.Empty;
end;

end.
