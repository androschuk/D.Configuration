unit ConfigurationPath;

interface

uses
  Generics.Collections, SysUtils;

  type
    /// <summary>
    /// Utility methods and constants for manipulating Configuration paths
    /// </summary>
    TConfigurationPath = class
    public
      const
        /// <summary>
        /// The delimiter ":" used to separate individual keys in a path.
        /// </summary>
        KeyDelimiter : string = ':';

      /// <summary>
      /// Combines path segments into one path.
      /// </summary>
      /// <param name="pathSegments">The path segments to combine.</param>
      /// <returns>The combined path.</returns>
      class function Combine(pathSegments: array of const): string; overload;

      /// <summary>
      /// Combines path segments into one path.
      /// </summary>
      /// <param name="pathSegments">The path segments to combine.</param>
      /// <returns>The combined path.</returns>
      class function Combine(pathSegments: IEnumerable<string>): string; overload;

      /// <summary>
      /// Combines path segments into one path.
      /// </summary>
      /// <param name="pathSegments">The path segments to combine.</param>
      /// <returns>The combined path.</returns>
      class function Combine(pathSegments: TEnumerable<string>): string; overload;

      /// <summary>
      /// Extracts the last path segment from the path.
      /// </summary>
      /// <param name="path">The path.</param>
      /// <returns>The last path segment of the path.</returns>
      class function GetSectionKey(path : string): string;
      /// <summary>
      /// Extracts the path corresponding to the parent node for a given path.
      /// </summary>
      /// <param name="path">The path.</param>
      /// <returns>The original path minus the last individual segment found in it. Null if the original path corresponds to a top level node.</returns>
      class function GetParentPath(path : string): string;
    end;


implementation

//TODO: move into general utils
function IfThen(AValue: Boolean; const ATrue: String; const AFalse: String): String;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

class function TConfigurationPath.Combine(pathSegments: array of const): string;
begin
  if Length(pathSegments) = 0 then
    raise EArgumentException.Create('pathSegments');

  Result := String.Join(KeyDelimiter, pathSegments);
end;

class function TConfigurationPath.Combine(pathSegments: IEnumerable<string>): string;
begin
  if pathSegments = nil then
    raise EArgumentException.Create('pathSegments');

  Result := String.Join(KeyDelimiter, pathSegments);
end;

class function TConfigurationPath.Combine(pathSegments: TEnumerable<string>): string;
var
  enum: TEnumerator<string>;
begin
  if pathSegments = nil then
    raise EArgumentException.Create('pathSegments');

  enum := pathSegments.GetEnumerator;
  if (enum <> nil) and enum.MoveNext then
  begin
    Result := enum.Current;
    while enum.MoveNext do
      Result := Result + KeyDelimiter + enum.Current;
  end
  else
    Result := '';
end;

class function TConfigurationPath.GetParentPath(path: string): string;
var
  lastDelimiterIndex : Integer;
begin
  if path.IsEmpty then
    Exit(path);

  lastDelimiterIndex := path.LastIndexOf(KeyDelimiter);
  Result := IfThen(lastDelimiterIndex = -1, String.Empty,  path.Substring(0, lastDelimiterIndex));
end;

class function TConfigurationPath.GetSectionKey(path: string): string;
var
  lastDelimiterIndex : Integer;
begin
  if path.IsEmpty then
    Exit(path);

  lastDelimiterIndex := path.LastIndexOf(KeyDelimiter);

  Result := IfThen(lastDelimiterIndex = -1, path, path.Substring(lastDelimiterIndex + 1))
end;

end.
