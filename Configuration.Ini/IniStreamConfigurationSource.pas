unit IniStreamConfigurationSource;

interface

uses
  StreamConfigurationSource, ConfigurationBuilder.Intf, ConfigurationProvider.Intf,
  IniStreamConfigurationProvider;

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
  TIniStreamConfigurationSource = class(TStreamConfigurationSource)
  public
    /// <summary>
    /// Builds the <see cref="IniConfigurationProvider"/> for this source.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/>.</param>
    /// <returns>An <see cref="IniConfigurationProvider"/></returns>
    function Build(builder: IConfigurationBuilder): IConfigurationProvider; override;
  end;

implementation

{ TJsonStreamConfigurationSource }

function TIniStreamConfigurationSource.Build(builder: IConfigurationBuilder): IConfigurationProvider;
begin
  Result := TIniStreamConfigurationProvider.Create(Self);
end;

end.
