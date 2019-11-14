unit EnvironmentVariablesHelper;

interface

uses
  System.SysUtils, ConfigurationBuilder.Intf, EnvironmentVariablesConfigurationSource,
  ConfigurationHelper;

type
  /// <summary>
  /// Helper methods for registering <see cref="TEnvironmentVariablesConfigurationProvider"/> with <see cref="IConfigurationBuilder"/>.
  /// </summary>
  TEnvironmentVariablesHelper = class
  public
    /// <summary>
    /// Adds an <see cref="IConfigurationProvider"/> that reads configuration values from environment variables.
    /// </summary>
    /// <param name="configurationBuilder">The <see cref="IConfigurationBuilder"/> to add to.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    class function AddEnvironmentVariables(configurationBuilder: IConfigurationBuilder): IConfigurationBuilder; overload;
    /// <summary>
    /// Adds an <see cref="IConfigurationProvider"/> that reads configuration values from environment variables
    /// with a specified prefix.
    /// </summary>
    /// <param name="configurationBuilder">The <see cref="IConfigurationBuilder"/> to add to.</param>
    /// <param name="prefix">The prefix that environment variable names must start with. The prefix will be removed from the environment variable names.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    class function AddEnvironmentVariables(configurationBuilder: IConfigurationBuilder; prefix: string): IConfigurationBuilder; overload;
    /// <summary>
    /// Adds an <see cref="IConfigurationProvider"/> that reads configuration values from environment variables.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/> to add to.</param>
    /// <param name="configureSource">Configures the source.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    class function AddEnvironmentVariables(configurationBuilder: IConfigurationBuilder; configureSource: TProc<TEnvironmentVariablesConfigurationSource>): IConfigurationBuilder; overload;
  end;

implementation

{ TEnvironmentVariablesHelper }

class function TEnvironmentVariablesHelper.AddEnvironmentVariables(
  configurationBuilder: IConfigurationBuilder): IConfigurationBuilder;
begin
  configurationBuilder.Add(TEnvironmentVariablesConfigurationSource.Create());
  Result := configurationBuilder;
end;

class function TEnvironmentVariablesHelper.AddEnvironmentVariables(
  configurationBuilder: IConfigurationBuilder;
  prefix: string): IConfigurationBuilder;
begin
  configurationBuilder.Add(TEnvironmentVariablesConfigurationSource.Create(prefix));
  Result := configurationBuilder;
end;

class function TEnvironmentVariablesHelper.AddEnvironmentVariables(
  configurationBuilder: IConfigurationBuilder;
  configureSource: TProc<TEnvironmentVariablesConfigurationSource>): IConfigurationBuilder;
begin
  Result := TConfigurationHelper.Add<TEnvironmentVariablesConfigurationSource>(configurationBuilder, configureSource);
end;

end.
