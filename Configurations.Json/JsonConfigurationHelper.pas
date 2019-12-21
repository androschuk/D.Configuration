unit JsonConfigurationHelper;

interface

uses
  ConfigurationBuilder.Intf, FileProvider.Intf, System.SysUtils, JsonConfigurationSource,
  System.Classes, ConfigurationHelper, JsonStreamConfigurationSource;

type
  TJsonConfiguration = record
  private
    FConfigurationBuilder: IConfigurationBuilder;
  public
    /// <summary>
    ///  Implicit casting
    ///  <param name="value">The <see cref="IConfigurationBuilder"/> to use to.</param>
    /// </summary>
    class operator Implicit(const value: IConfigurationBuilder): TJsonConfiguration;
    /// <summary>
    ///  Implicit casting
    ///  <param name="value">The <see cref="TJsonConfiguration"/> to use to.</param>
    /// </summary>
    class operator Implicit(const value: TJsonConfiguration): IConfigurationBuilder;

    /// <summary>
    /// Adds the JSON configuration provider at <paramref name="path"/> to <paramref name="builder"/>.
    /// </summary>
    /// <param name="path">Path relative to the base path stored in
    /// <see cref="IConfigurationBuilder.Properties"/> of <paramref name="builder"/>.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    function AddJsonFile(path: string): TJsonConfiguration; overload;

    /// <summary>
    /// Adds the JSON configuration provider at <paramref name="path"/> to <paramref name="builder"/>.
    /// </summary>
    /// <param name="path">Path relative to the base path stored in
    /// <see cref="IConfigurationBuilder.Properties"/> of <paramref name="builder"/>.</param>
    /// <param name="optional">Whether the file is optional.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    function AddJsonFile(path: string; optional: Boolean): TJsonConfiguration; overload;

    /// <summary>
    /// Adds the JSON configuration provider at <paramref name="path"/> to <paramref name="builder"/>.
    /// </summary>
    /// <param name="path">Path relative to the base path stored in
    /// <see cref="IConfigurationBuilder.Properties"/> of <paramref name="builder"/>.</param>
    /// <param name="optional">Whether the file is optional.</param>
    /// <param name="reloadOnChange">Whether the configuration should be reloaded if the file changes.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    function AddJsonFile(path: string; optional: Boolean; reloadOnChange: Boolean): TJsonConfiguration; overload;

    /// <summary>
    /// Adds a JSON configuration source to <paramref name="builder"/>.
    /// </summary>
    /// <param name="provider">The <see cref="IFileProvider"/> to use to access the file.</param>
    /// <param name="path">Path relative to the base path stored in
    /// <see cref="IConfigurationBuilder.Properties"/> of <paramref name="builder"/>.</param>
    /// <param name="optional">Whether the file is optional.</param>
    /// <param name="reloadOnChange">Whether the configuration should be reloaded if the file changes.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    function AddJsonFile(provider: IFileProvider; path: string; optional: Boolean; reloadOnChange: Boolean): TJsonConfiguration; overload;

    /// <summary>
    /// Adds a JSON configuration source to <paramref name="builder"/>.
    /// </summary>
    /// <param name="configureSource">Configures the source.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    function AddJsonFile(configureSource: TProc<TJsonConfigurationSource>): TJsonConfiguration; overload;

    /// <summary>
    /// Adds a JSON configuration source to <paramref name="builder"/>.
    /// </summary>
    /// <param name="stream">The <see cref="Stream"/> to read the json configuration data from.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    function AddJsonStream(stream: TStream): TJsonConfiguration;
  end;

implementation

{ TJsonConfigurationHelper }

function TJsonConfiguration.AddJsonFile(path: string): TJsonConfiguration;
begin
  Result := AddJsonFile(nil, path, false, false)
end;

function TJsonConfiguration.AddJsonFile(path: string; optional: Boolean): TJsonConfiguration;
begin
  Result := AddJsonFile(Nil, path, optional, false);
end;

function TJsonConfiguration.AddJsonFile(path: string; optional, reloadOnChange: Boolean): TJsonConfiguration;
begin
  Result := AddJsonFile(Nil, path, optional, reloadOnChange);
end;

function TJsonConfiguration.AddJsonFile(provider: IFileProvider; path: string;
  optional, reloadOnChange: Boolean): TJsonConfiguration;
begin


  if path.IsEmpty then
    raise EArgumentException.Create('Invalid file path');

    Result := AddJsonFile(procedure (s: TJsonConfigurationSource)
        begin
          s.FileProvider := provider;
          s.Path := path;
          s.Optional := optional;
          s.ReloadOnChange := reloadOnChange;
          s.ResolveFileProvider;
        end);
end;

function TJsonConfiguration.AddJsonFile(configureSource: TProc<TJsonConfigurationSource>): TJsonConfiguration;
begin
  if FConfigurationBuilder = Nil then
    raise EArgumentNilException.Create('ConfigurationBuilder');

  Result := TConfigurationHelper.Add<TJsonConfigurationSource>(FConfigurationBuilder, configureSource);
end;

function TJsonConfiguration.AddJsonStream(stream: TStream): TJsonConfiguration;
begin
  if FConfigurationBuilder = Nil then
    raise EArgumentNilException.Create('ConfigurationBuilder');

  Result := TConfigurationHelper.Add<TJsonStreamConfigurationSource>(FConfigurationBuilder,
    procedure(s: TJsonStreamConfigurationSource)
    begin
      s.Stream := stream;
    end);
end;

class operator TJsonConfiguration.Implicit(const value: IConfigurationBuilder): TJsonConfiguration;
begin
    Result.FConfigurationBuilder := value;
end;

class operator TJsonConfiguration.Implicit(const value: TJsonConfiguration): IConfigurationBuilder;
begin
    Result := value.FConfigurationBuilder;
end;

end.
