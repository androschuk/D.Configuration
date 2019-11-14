unit IniStreamConfigurationProvider;

interface

uses
  StreamConfigurationProvider, System.Classes, System.Generics.Dictionary,
  System.Generics.Defaults, System.SysUtils, ConfigurationPath;

type
  /// <summary>
  /// An INI file based <see cref="TStreamConfigurationProvider"/>.
  /// </summary>
  TIniStreamConfigurationProvider = class(TStreamConfigurationProvider)
  public
    /// <summary>
    /// Read a stream of INI values into a key/value dictionary.
    /// </summary>
    /// <param name="stream">The stream of INI data.</param>
    /// <returns></returns>
    class function Read(stream: TStream): IDictionary<string, string>;
    /// <summary>
    /// Loads INI configuration key/values from a stream into a provider.
    /// </summary>
    /// <param name="stream">The <see cref="Stream"/> to load ini configuration data from.</param>
    procedure Load(stream: TStream); override;
  end;

implementation

{ TIniStreamConfigurationProvider }

procedure TIniStreamConfigurationProvider.Load(stream: TStream);
begin
  Data := TIniStreamConfigurationProvider.Read(stream);
end;


class function TIniStreamConfigurationProvider.Read(
  stream: TStream): IDictionary<string, string>;
var
  innerData: IDictionary<string, string>;
  key: string;
  reader: TStreamReader;
  sectionPrefix: string;
  rawLine: string;
  line: string;
  separator: Integer;
  value: string;
begin
  innerData := TDictionary<string, string>.Create(TIStringComparer.Ordinal);

  reader := TStreamReader.Create(stream);
  try
    sectionPrefix := EmptyStr;

    while(reader.Peek <> -1) do
    begin
      rawLine := reader.ReadLine;
      line := rawLine.Trim;

      // Ignore blank lines
      if line.IsEmpty then
        Continue;

      // Ignore comments
      if (line[1] = ';') Or (line[1] = '#') Or (line[1] = '/') then
        Continue;

      // [Section:header]
      if (line[1] = '[') And (line[line.Length] = ']') then
      begin
        // remove the brackets
        sectionPrefix := line.Substring(1, line.Length - 2) + TConfigurationPath.KeyDelimiter;
        Continue;
      end;

      // key = value OR "value"
      separator := line.IndexOf('=');
      if separator < 0 then
        raise Exception.CreateFmt('Unrecognized line format: %s', [rawLine]);

      key := sectionPrefix + line.Substring(0, separator).Trim();
      value := line.Substring(separator + 1).Trim();

      // Remove quotes
      if (value.Length > 1) And (value[1] = '"') And (value[value.Length] = '"') then
        value := value.Substring(1, value.Length - 2);

      if innerData.ContainsKey(key) then
        raise Exception.CreateFmt('Key %s is duplicated', [key]);

      innerData.Add(key, value);
    end;

    Result := innerData;
  finally
    FreeAndNil(reader);
  end;
end;

end.
