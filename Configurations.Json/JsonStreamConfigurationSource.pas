unit JsonStreamConfigurationSource;

interface

uses
  StreamConfigurationSource, ConfigurationBuilder.Intf, ConfigurationProvider.Intf,
  JsonStreamConfigurationProvider;

type
  /// <summary>
  /// Represents a JSON file as an <see cref="IConfigurationSource"/>.
  /// </summary>
  TJsonStreamConfigurationSource = class(TStreamConfigurationSource)
  public
    /// <summary>
    /// Builds the <see cref="JsonStreamConfigurationProvider"/> for this source.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/>.</param>
    /// <returns>An <see cref="JsonStreamConfigurationProvider"/></returns>
    function Build(builder: IConfigurationBuilder): IConfigurationProvider; override;
  end;

implementation

{ TJsonStreamConfigurationSource }

function TJsonStreamConfigurationSource.Build(builder: IConfigurationBuilder): IConfigurationProvider;
begin
  Result := TJsonStreamConfigurationProvider.Create(Self);
end;

end.
