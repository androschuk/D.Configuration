unit IniConfigurationSource;

interface

uses
  FileConfigurationSource, ConfigurationBuilder.Intf, ConfigurationProvider.Intf,
  IniConfigurationProvider;

type
/// <summary>
/// Represents an INI file as an <see cref="IConfigurationSource"/>.
/// Files are simple line structures (<a href="https://en.wikipedia.org/wiki/INI_file">INI Files on Wikipedia</a>)
/// </summary>
/// <examples>
/// [Section:Header]
/// key1=value1
/// key2 = " value2 "
/// ; comment
/// # comment
/// / comment
/// </examples>
  TIniConfigurationSource = class(TFileConfigurationSource)
  public
    constructor Create;
    /// <summary>
    /// Builds the <see cref="IniConfigurationProvider"/> for this source.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/>.</param>
    /// <returns>An <see cref="IniConfigurationProvider"/></returns>
    function Build(builder: IConfigurationBuilder) : IConfigurationProvider; override;
  end;

implementation

{ TJsonConfigurationSource }

function TIniConfigurationSource.Build(
  builder: IConfigurationBuilder): IConfigurationProvider;
begin
  EnsureDefaults(builder);
  Result := TIniConfigurationProvider.Create(Self);
end;

constructor TIniConfigurationSource.Create;
begin
  inherited Create;

end;

end.
