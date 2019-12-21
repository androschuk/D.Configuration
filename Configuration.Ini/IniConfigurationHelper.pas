unit IniConfigurationHelper;

interface

uses
  ConfigurationBuilder.Intf, FileProvider.Intf, System.SysUtils, IniConfigurationSource,
  System.Classes, ConfigurationHelper, IniStreamConfigurationSource;

type
  /// <summary>
  /// Extension methods for adding <see cref="IniConfigurationProvider"/>.
  /// </summary>
  TIniConfiguration = record
  private
    FConfigurationBuilder: IConfigurationBuilder;
  public
    /// <summary>
    ///  Implicit casting
    ///  <param name="value">The <see cref="IConfigurationBuilder"/> to use to.</param>
    /// </summary>
    class operator Implicit(const value: IConfigurationBuilder): TIniConfiguration;
    /// <summary>
    ///  Implicit casting
    ///  <param name="value">The <see cref="TIniConfiguration"/> to use to.</param>
    /// </summary>
    class operator Implicit(const value: TIniConfiguration): IConfigurationBuilder;

    /// <summary>
    /// Adds the INI configuration provider at <paramref name="path"/> to <paramref name="builder"/>.
    /// </summary>
    /// <param name="path">Path relative to the base path stored in
    /// <see cref="IConfigurationBuilder.Properties"/> of <paramref name="builder"/>.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    function AddIniFile(path: string): TIniConfiguration; overload;

    /// <summary>
    /// Adds the INI configuration provider at <paramref name="path"/> to <paramref name="builder"/>.
    /// </summary>
    /// <param name="path">Path relative to the base path stored in
    /// <see cref="IConfigurationBuilder.Properties"/> of <paramref name="builder"/>.</param>
    /// <param name="optional">Whether the file is optional.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    function AddIniFile(path: string; optional: Boolean): TIniConfiguration; overload;

    /// <summary>
    /// Adds the INI configuration provider at <paramref name="path"/> to <paramref name="builder"/>.
    /// </summary>
    /// <param name="path">Path relative to the base path stored in
    /// <see cref="IConfigurationBuilder.Properties"/> of <paramref name="builder"/>.</param>
    /// <param name="optional">Whether the file is optional.</param>
    /// <param name="reloadOnChange">Whether the configuration should be reloaded if the file changes.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    function AddIniFile(path: string; optional: Boolean; reloadOnChange: Boolean): TIniConfiguration; overload;

    /// <summary>
    /// Adds a INI configuration source to <paramref name="builder"/>.
    /// </summary>
    /// <param name="provider">The <see cref="IFileProvider"/> to use to access the file.</param>
    /// <param name="path">Path relative to the base path stored in
    /// <see cref="IConfigurationBuilder.Properties"/> of <paramref name="builder"/>.</param>
    /// <param name="optional">Whether the file is optional.</param>
    /// <param name="reloadOnChange">Whether the configuration should be reloaded if the file changes.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    function AddIniFile(provider: IFileProvider; path: string; optional: Boolean; reloadOnChange: Boolean): TIniConfiguration; overload;

    /// <summary>
    /// Adds a INI configuration source to <paramref name="builder"/>.
    /// </summary>
    /// <param name="configureSource">Configures the source.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    function AddIniFile(configureSource: TProc<TIniConfigurationSource>): TIniConfiguration; overload;

    /// <summary>
    /// Adds a INI configuration source to <paramref name="builder"/>.
    /// </summary>
    /// <param name="stream">The <see cref="Stream"/> to read the ini configuration data from.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    function AddIniStream(stream: TStream): TIniConfiguration;
  end;

implementation

{ TJsonConfigurationHelper }

function TIniConfiguration.AddIniFile(path: string): TIniConfiguration;
begin
  Result := AddIniFile(nil, path, false, false)
end;

function TIniConfiguration.AddIniFile(path: string;  optional: Boolean): TIniConfiguration;
begin
  Result := AddIniFile(Nil, path, optional, false);
end;

function TIniConfiguration.AddIniFile(path: string; optional, reloadOnChange: Boolean): TIniConfiguration;
begin
  Result := AddIniFile(Nil, path, optional, reloadOnChange);
end;

function TIniConfiguration.AddIniFile( provider: IFileProvider; path: string; optional, reloadOnChange: Boolean): TIniConfiguration;
begin
  if FConfigurationBuilder = Nil then
    raise EArgumentNilException.Create('builder');

  if path.IsEmpty then
    raise EArgumentException.Create('Invalid file path');

    Result := AddIniFile(
        procedure(s: TIniConfigurationSource)
        begin
          s.FileProvider := provider;
          s.Path := path;
          s.Optional := optional;
          s.ReloadOnChange := reloadOnChange;
          s.ResolveFileProvider;
        end);
end;

function TIniConfiguration.AddIniFile(configureSource: TProc<TIniConfigurationSource>): TIniConfiguration;
begin
  Result :=TConfigurationHelper.Add<TIniConfigurationSource>(FConfigurationBuilder, configureSource);
end;

function TIniConfiguration.AddIniStream(stream: TStream): TIniConfiguration;
begin
  if FConfigurationBuilder = Nil then
    raise EArgumentNilException.Create('builder');

  Result := TConfigurationHelper.Add<TIniStreamConfigurationSource>(FConfigurationBuilder,
      procedure(s: TIniStreamConfigurationSource)
        begin
          s.Stream := stream;
        end);
end;

class operator TIniConfiguration.Implicit(
  const value: IConfigurationBuilder): TIniConfiguration;
begin
    Result.FConfigurationBuilder := value;
end;

class operator TIniConfiguration.Implicit(
  const value: TIniConfiguration): IConfigurationBuilder;
begin
    Result := value.FConfigurationBuilder;
end;

end.
