unit EnvironmentVariablesConfigurationProvider;

interface

uses
  ConfigurationProvider, System.SysUtils, System.Environment, System.Generics.Dictionary,
  System.Generics.Defaults, System.Generics.Collections;

type
  TEnvironmentVariablesConfigurationProvider = class(TConfigurationProvider)
  private
    FPrefix: string;

    procedure InternalLoad(envVariables: IDictionary<string, string>);
  public
    /// <summary>
    /// Initializes a new instance with the specified prefix.
    /// </summary>
    /// <param name="prefix">A prefix used to filter the environment variables.</param>
    constructor Create(prefix: string); overload;

    /// <summary>
    /// Loads the environment variables.
    /// </summary>
    procedure Load; override;
  end;

implementation

{ TEnvironmentVariablesConfigurationProvider }

constructor TEnvironmentVariablesConfigurationProvider.Create(prefix: string);
begin
  FPrefix := prefix;
end;

procedure TEnvironmentVariablesConfigurationProvider.Load;
begin
  InternalLoad(TEnvironment.GetEnvironmentVariables);
end;

procedure TEnvironmentVariablesConfigurationProvider.InternalLoad(envVariables: IDictionary<string, string>);
var
  filtered: IDictionary<string, string>;
  item: TPair<string, string>;
  key: string;
begin
  filtered := System.Generics.Dictionary.TDictionary<string, string>.Create;

  for item in envVariables do
  begin
    if item.Key.StartsWith(FPrefix, True) then
    begin
      key := item.Key.Substring(FPrefix.Length);
      filtered.Add(key, item.Value);
    end;
  end;

  Data := filtered;
end;

end.
