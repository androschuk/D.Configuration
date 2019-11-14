unit JsonConfigurationProvider;

interface

uses
  FileConfigurationSource, System.Classes, System.SysUtils, JsonConfigurationFileParser,
  System.JSON;

type
  /// <summary>
  /// A JSON file based <see cref="FileConfigurationProvider"/>.
  /// </summary>
  TJsonConfigurationProvider = class(TFileConfigurationProvider)
  public
    /// <summary>
    /// Loads the JSON data from a stream.
    /// </summary>
    /// <param name="stream">The stream to read.</param>
    procedure Load(stream: TStream); override;
  end;

implementation

{ TJsonConfigurationProvider }

procedure TJsonConfigurationProvider.Load(stream: TStream);
begin
  try
     Data := TJsonConfigurationFileParser.Parse(stream);
  except
    on E: EJSONException do
    begin
      E.Message := Format('Json parser error. %s', [E.Message]);
      raise E;
    end;
  end;

end;

end.
