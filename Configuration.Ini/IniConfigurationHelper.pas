unit IniConfigurationHelper;

interface

uses
  ConfigurationBuilder.Intf, FileProvider.Intf, System.SysUtils, IniConfigurationSource,
  System.Classes, ConfigurationHelper, IniStreamConfigurationSource;

type
  /// <summary>
  /// Extension methods for adding <see cref="IniConfigurationProvider"/>.
  /// </summary>
  TIniConfigurationHelper = class
  public

    /// <summary>
    /// Adds the INI configuration provider at <paramref name="path"/> to <paramref name="builder"/>.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/> to add to.</param>
    /// <param name="path">Path relative to the base path stored in
    /// <see cref="IConfigurationBuilder.Properties"/> of <paramref name="builder"/>.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    class function AddIniFile(builder: IConfigurationBuilder; path: string): IConfigurationBuilder; overload;

    /// <summary>
    /// Adds the INI configuration provider at <paramref name="path"/> to <paramref name="builder"/>.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/> to add to.</param>
    /// <param name="path">Path relative to the base path stored in
    /// <see cref="IConfigurationBuilder.Properties"/> of <paramref name="builder"/>.</param>
    /// <param name="optional">Whether the file is optional.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    class function AddIniFile(builder: IConfigurationBuilder; path: string; optional: Boolean): IConfigurationBuilder; overload;

    /// <summary>
    /// Adds the INI configuration provider at <paramref name="path"/> to <paramref name="builder"/>.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/> to add to.</param>
    /// <param name="path">Path relative to the base path stored in
    /// <see cref="IConfigurationBuilder.Properties"/> of <paramref name="builder"/>.</param>
    /// <param name="optional">Whether the file is optional.</param>
    /// <param name="reloadOnChange">Whether the configuration should be reloaded if the file changes.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    class function AddIniFile(builder: IConfigurationBuilder; path: string; optional: Boolean; reloadOnChange: Boolean): IConfigurationBuilder; overload;

    /// <summary>
    /// Adds a INI configuration source to <paramref name="builder"/>.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/> to add to.</param>
    /// <param name="provider">The <see cref="IFileProvider"/> to use to access the file.</param>
    /// <param name="path">Path relative to the base path stored in
    /// <see cref="IConfigurationBuilder.Properties"/> of <paramref name="builder"/>.</param>
    /// <param name="optional">Whether the file is optional.</param>
    /// <param name="reloadOnChange">Whether the configuration should be reloaded if the file changes.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    class function AddIniFile(builder: IConfigurationBuilder; provider: IFileProvider; path: string; optional: Boolean; reloadOnChange: Boolean): IConfigurationBuilder; overload;

    /// <summary>
    /// Adds a INI configuration source to <paramref name="builder"/>.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/> to add to.</param>
    /// <param name="configureSource">Configures the source.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    class function AddIniFile(builder: IConfigurationBuilder; configureSource: TProc<TIniConfigurationSource>): IConfigurationBuilder; overload;

    /// <summary>
    /// Adds a INI configuration source to <paramref name="builder"/>.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/> to add to.</param>
    /// <param name="stream">The <see cref="Stream"/> to read the ini configuration data from.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    class function AddIniStream(builder: IConfigurationBuilder; stream: TStream): IConfigurationBuilder;
  end;

implementation

{ TJsonConfigurationHelper }

class function TIniConfigurationHelper.AddIniFile(
  builder: IConfigurationBuilder; path: string): IConfigurationBuilder;
begin
  Result := AddIniFile(builder, nil, path, false, false)
end;

class function TIniConfigurationHelper.AddIniFile(
  builder: IConfigurationBuilder; path: string;
  optional: Boolean): IConfigurationBuilder;
begin
  Result := AddIniFile(builder, Nil, path, optional, false);
end;

class function TIniConfigurationHelper.AddIniFile(
  builder: IConfigurationBuilder; path: string; optional,
  reloadOnChange: Boolean): IConfigurationBuilder;
begin
  Result := AddIniFile(builder, Nil, path, optional, reloadOnChange);
end;

class function TIniConfigurationHelper.AddIniFile(
  builder: IConfigurationBuilder; provider: IFileProvider; path: string;
  optional, reloadOnChange: Boolean): IConfigurationBuilder;
begin
  if builder = Nil then
    raise EArgumentNilException.Create('builder');

  if path.IsEmpty then
    raise EArgumentException.Create('Invalid file path');

    Result := TIniConfigurationHelper.AddIniFile(builder,
    procedure(s: TIniConfigurationSource)
    begin
      s.FileProvider := provider;
      s.Path := path;
      s.Optional := optional;
      s.ReloadOnChange := reloadOnChange;
      s.ResolveFileProvider;
    end);
end;

class function TIniConfigurationHelper.AddIniFile(builder: IConfigurationBuilder; configureSource: TProc<TIniConfigurationSource>): IConfigurationBuilder;
begin
  Result :=TConfigurationHelper.Add<TIniConfigurationSource>(builder, configureSource);
end;

class function TIniConfigurationHelper.AddIniStream(
  builder: IConfigurationBuilder; stream: TStream): IConfigurationBuilder;
begin
  if builder = Nil then
    raise EArgumentNilException.Create('builder');

  Result := TConfigurationHelper.Add<TIniStreamConfigurationSource>(builder,
    procedure(s: TIniStreamConfigurationSource)
    begin
      s.Stream := stream;
    end);
end;

end.
