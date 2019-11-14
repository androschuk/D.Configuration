unit NotFoundDirectoryContents;

interface

uses
  System.SysUtils, DirectoryContents.Intf, FileInfo.Intf, EnumeratorHelper,
  Generics.Collections;

type
  /// <summary>
  /// Represents a non-existing directory
  /// </summary>
  TNotFoundDirectoryContents = class(TInterfacedObject, IDirectoryContents)
  private
    class var FSingleton: TNotFoundDirectoryContents;

    function GetGenericEnum:  IEnumerator<IFileInfo>;
  public
    //IDirectoryContents

    /// <summary>
    /// True if a directory was located at the given path.
    /// </summary>
    function Exists: Boolean;

    /// <summary>Returns an enumerator that iterates through the collection.</summary>
    /// <returns>An enumerator to an empty collection.</returns>
    function IDirectoryContents.GetEnumerator = GetGenericEnum;
    function GetEnumerator: IEnumerator;

    class function Singleton : TNotFoundDirectoryContents;
  end;

implementation

{ TNotFoundDirectoryContents }

function TNotFoundDirectoryContents.Exists: Boolean;
begin
  Result := False;
end;

//function TNotFoundDirectoryContents.GetEnum: IEnumerator;
//begin
//  raise ENotImplemented.Create('GetGenericEnum');
//  //Result := TEmptyEnumerator<IFileInfo>.Instance
//end;
//
//function TNotFoundDirectoryContents.GetGenericEnum: IEnumerator<IFileInfo>;
//begin
//  raise ENotImplemented.Create('GetGenericEnum');
//  //Result :=  TEmptyEnumerator<IFileInfo>.Instance;
//end;

function TNotFoundDirectoryContents.GetEnumerator: IEnumerator;
begin
  raise ENotImplemented.Create('GetGenericEnum');
end;

function TNotFoundDirectoryContents.GetGenericEnum: IEnumerator<IFileInfo>;
begin
  raise ENotImplemented.Create('GetGenericEnum');
  //Result :=  TEmptyEnumerator<IFileInfo>.Instance;
end;

class function TNotFoundDirectoryContents.Singleton: TNotFoundDirectoryContents;
begin
  if Not Assigned(FSingleton) then
    FSingleton := TNotFoundDirectoryContents.Create;

  Result := FSingleton;
end;

end.
