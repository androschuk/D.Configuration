unit EnvironmentVariablesHelper;

interface

uses
  System.SysUtils, ConfigurationBuilder.Intf, EnvironmentVariablesConfigurationSource,
  ConfigurationHelper;

type
  /// <summary>
  /// Helper methods for registering <see cref="TEnvironmentVariablesConfigurationProvider"/> with <see cref="IConfigurationBuilder"/>.
  /// </summary>
  TEnvVariablesConfiguration = record
  private
    FConfigurationBuilder: IConfigurationBuilder;
  public
    /// <summary>
    ///  Implicit casting
    ///  <param name="value">The <see cref="IConfigurationBuilder"/> to use to.</param>
    /// </summary>
    class operator Implicit(const value: IConfigurationBuilder): TEnvVariablesConfiguration;
    /// <summary>
    ///  Implicit casting
    ///  <param name="value">The <see cref="TEnvVariablesConfiguration"/> to use to.</param>
    /// </summary>
    class operator Implicit(const value: TEnvVariablesConfiguration): IConfigurationBuilder;

    /// <summary>
    /// Adds an <see cref="IConfigurationProvider"/> that reads configuration values from environment variables
    /// with a specified prefix.
    /// </summary>
    /// <param name="prefix">The prefix that environment variable names must start with. The prefix will be removed from the environment variable names.</param>
    /// <returns>The <see cref="TEnvVariablesConfiguration"/>.</returns>
    function AddEnvironmentVariables(prefix: string = ''): TEnvVariablesConfiguration; overload;
    /// <summary>
    /// Adds an <see cref="IConfigurationProvider"/> that reads configuration values from environment variables.
    /// </summary>
    /// <param name="configureSource">Configures the source.</param>
    /// <returns>The <see cref="TEnvVariablesConfiguration"/>.</returns>
    function AddEnvironmentVariables(configureSource: TProc<TEnvironmentVariablesConfigurationSource>): TEnvVariablesConfiguration; overload;
  end;

implementation

{ TEnvironmentVariablesHelper }

function TEnvVariablesConfiguration.AddEnvironmentVariables(prefix: string = ''): TEnvVariablesConfiguration;
begin
  FConfigurationBuilder.Add(TEnvironmentVariablesConfigurationSource.Create(prefix));
  Result := FConfigurationBuilder;
end;

function TEnvVariablesConfiguration.AddEnvironmentVariables(configureSource: TProc<TEnvironmentVariablesConfigurationSource>): TEnvVariablesConfiguration;
begin
  Result := TConfigurationHelper.Add<TEnvironmentVariablesConfigurationSource>(FConfigurationBuilder, configureSource);
end;

class operator TEnvVariablesConfiguration.Implicit(const value: IConfigurationBuilder): TEnvVariablesConfiguration;
begin
    Result.FConfigurationBuilder := value;
end;

class operator TEnvVariablesConfiguration.Implicit(const value: TEnvVariablesConfiguration): IConfigurationBuilder;
begin
    Result := value.FConfigurationBuilder;
end;

end.
