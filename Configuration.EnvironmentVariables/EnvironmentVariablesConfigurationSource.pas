unit EnvironmentVariablesConfigurationSource;

interface

uses
  ConfigurationBuilder.Intf, ConfigurationProvider.Intf, EnvironmentVariablesConfigurationProvider;

type
  TEnvironmentVariablesConfigurationSource = class(TInterfacedObject, IConfigurationSource)
  private
    /// <summary>
    /// A prefix used to filter environment variables.
    /// </summary>
    FPrefix: string;
  public
    constructor Create(prefix: string = '');

    /// <summary>
    /// Builds the <see cref="EnvironmentVariablesConfigurationProvider"/> for this source.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/>.</param>
    /// <returns>A <see cref="EnvironmentVariablesConfigurationProvider"/></returns>
    function Build(builder: IConfigurationBuilder) : IConfigurationProvider;
  end;

implementation

{ TEnvironmentVariablesConfigurationSource }

function TEnvironmentVariablesConfigurationSource.Build(builder: IConfigurationBuilder): IConfigurationProvider;
begin
  Result := TEnvironmentVariablesConfigurationProvider.Create(FPrefix);
end;

constructor TEnvironmentVariablesConfigurationSource.Create(prefix: string = '');
begin
  FPrefix := prefix;
end;

end.
