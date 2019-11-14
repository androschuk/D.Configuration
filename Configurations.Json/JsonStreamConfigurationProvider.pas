unit JsonStreamConfigurationProvider;

interface

uses
  FileConfigurationSource, System.Classes, System.SysUtils, JsonConfigurationFileParser,
  StreamConfigurationProvider;

type
  TJsonStreamConfigurationProvider = class(TStreamConfigurationProvider)
  public
    procedure Load(stream: TStream); override;
  end;

implementation

{ TJsonStreamConfigurationProvider }

procedure TJsonStreamConfigurationProvider.Load(stream: TStream);
begin
  try
    Data := TJsonConfigurationFileParser.Parse(stream);
  except
    On E: Exception do //JsonException
    begin
      e.Message := 'Json parser error' + e.Message;
      raise e;
    end;
  end;

end;

end.
