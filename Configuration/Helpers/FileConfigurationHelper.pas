unit FileConfigurationHelper;

interface

uses
  System.SysUtils, ConfigurationBuilder.Intf, FileProvider.Intf, PhysicalFileProvider,
  ConfigurationBuilder;

type
  /// <summary>
  /// Helper record for <see cref="FileConfigurationProvider"/>.
  /// </summary>
  TFileConfiguration = record
  private
    var
      FConfigurationBuilder: IConfigurationBuilder;
  {$HINTS OFF}
    // cause record to be passed as reference on const parameter
    // because it does not fit in a register
    fDummy: Pointer;
  {$HINTS ON}
    const
       FileProviderKey : string = 'FileProvider';
       FileLoadExceptionHandlerKey : string = 'FileLoadExceptionHandler';
  public
    /// <summary>
    ///  Implicit casting
    ///  <param name="value">The <see cref="IConfigurationBuilder"/> to use to.</param>
    /// </summary>
    class operator Implicit(const value: IConfigurationBuilder): TFileConfiguration;
    /// <summary>
    ///  Implicit casting
    ///  <param name="value">The <see cref="TFileConfiguration"/> to use to.</param>
    /// </summary>
    class operator Implicit(const value: TFileConfiguration): IConfigurationBuilder;

    /// <summary>
    /// Sets the default <see cref="IFileProvider"/> to be used for file-based providers.
    /// </summary>
    /// <param name="fileProvider">The default file provider instance.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    function SetFileProvider(fileProvider: IFileProvider): IConfigurationBuilder;

    /// <summary>
    /// Gets the default <see cref="IFileProvider"/> to be used for file-based providers.
    /// </summary>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    function GetFileProvider: IFileProvider;

    /// <summary>
    /// Sets the FileProvider for file-based providers to a PhysicalFileProvider with the base path.
    /// </summary>
    /// <param name="basePath">The absolute path of file-based providers.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    function SetBasePath(basePath: string ): IConfigurationBuilder;

    //TODO: SetFileLoadExceptionHandler
    //SetFileLoadExceptionHandler(builder: IConfigurationBuilder; handler: TFunc<TFileLoadExceptionContext> ): IConfigurationBuilder;

    /// <summary>
    /// Gets the default <see cref="IFileProvider"/> to be used for file-based providers.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/>.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    //TODO: GetFileLoadExceptionHandler
    //function GetFileLoadExceptionHandler(builder: IConfigurationBuilder): IInterface;
  end;

implementation

{ TFileConfigurationHelper }

//function TFileConfigurationHelper.GetFileLoadExceptionHandler(
//  builder: IConfigurationBuilder): IInterface; //TAction<TFileLoadExceptionContext>
//
//var
//  handler: IInterface;
//begin
//  if builder = Nil then
//      raise EArgumentNilException.Create('builder');
//
//  if builder.Properties.TryGetValue(FileLoadExceptionHandlerKey, handler) then
//    Exit(handler);
//
//  Result := Nil;
//end;

function TFileConfiguration.GetFileProvider: IFileProvider;
var
  prov: IInterface;
  provider: IFileProvider;
begin
  if FConfigurationBuilder.Properties.TryGetValue(FileProviderKey, prov) then
  begin
    if Supports(prov, IFileProvider, provider) then
      Exit(provider)
    else
      Exit(Nil);
  end;

  //TODO: TPhysicalFileProvider.Create: AppContext.BaseDirectory?? string.Empty
  Result := TPhysicalFileProvider.Create(string.Empty);
end;

class operator TFileConfiguration.Implicit(const value: IConfigurationBuilder): TFileConfiguration;
begin
    Result.FConfigurationBuilder := value;
end;

class operator TFileConfiguration.Implicit(const value: TFileConfiguration): IConfigurationBuilder;
begin
    Result := value.FConfigurationBuilder;
end;

function TFileConfiguration.SetBasePath(basePath: string): IConfigurationBuilder;
begin
  if basePath.IsEmpty then
    raise EArgumentNilException.Create('basePath');

  Result := SetFileProvider(TPhysicalFileProvider.Create(basePath));
end;

function TFileConfiguration.SetFileProvider(fileProvider: IFileProvider): IConfigurationBuilder;
begin
  if fileProvider = Nil then
    raise EArgumentNilException.Create('fileProvider');

  FConfigurationBuilder.Properties.AddOrSetValue(FileProviderKey, fileProvider);
  //builder.Properties[FileProviderKey] := fileProvider;

  Result := FConfigurationBuilder;
end;

end.
