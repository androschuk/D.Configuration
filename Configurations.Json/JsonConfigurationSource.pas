unit JsonConfigurationSource;

interface

uses
  FileConfigurationSource, ConfigurationBuilder.Intf, ConfigurationProvider.Intf,
  JsonConfigurationProvider;

type
  TJsonConfigurationSource = class(TFileConfigurationSource)
  public
    constructor Create;
    /// <summary>
    /// Builds the <see cref="JsonConfigurationProvider"/> for this source.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/>.</param>
    /// <returns>A <see cref="JsonConfigurationProvider"/></returns>
    function Build(builder: IConfigurationBuilder) : IConfigurationProvider; override;
  end;

implementation

{ TJsonConfigurationSource }

function TJsonConfigurationSource.Build(
  builder: IConfigurationBuilder): IConfigurationProvider;
begin
  EnsureDefaults(builder);
  Result := TJsonConfigurationProvider.Create(Self);
end;

constructor TJsonConfigurationSource.Create;
begin
  inherited Create;

end;

end.
