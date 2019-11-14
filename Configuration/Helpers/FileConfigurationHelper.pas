unit FileConfigurationHelper;

interface

uses
  System.SysUtils, ConfigurationBuilder.Intf, FileProvider.Intf, PhysicalFileProvider;

type
  /// <summary>
  /// Helper methods for <see cref="FileConfigurationProvider"/>.
  /// </summary>
  TFileConfigurationHelper = class
  private
    const
       FileProviderKey : string = 'FileProvider';
       FileLoadExceptionHandlerKey : string = 'FileLoadExceptionHandler';
  public
    /// <summary>
    /// Sets the default <see cref="IFileProvider"/> to be used for file-based providers.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/> to add to.</param>
    /// <param name="fileProvider">The default file provider instance.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    class function SetFileProvider(builder: IConfigurationBuilder; fileProvider: IFileProvider): IConfigurationBuilder;

    /// <summary>
    /// Gets the default <see cref="IFileProvider"/> to be used for file-based providers.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/>.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    class function GetFileProvider(builder: IConfigurationBuilder): IFileProvider;

    /// <summary>
    /// Sets the FileProvider for file-based providers to a PhysicalFileProvider with the base path.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/> to add to.</param>
    /// <param name="basePath">The absolute path of file-based providers.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    class function SetBasePath(builder: IConfigurationBuilder; basePath: string ): IConfigurationBuilder;

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

class function TFileConfigurationHelper.GetFileProvider(
  builder: IConfigurationBuilder): IFileProvider;
var
  prov: IInterface;
  provider: IFileProvider;
begin
  if builder = Nil then
    raise EArgumentNilException.Create('builder');

  if builder.Properties.TryGetValue(FileProviderKey, prov) then
  begin
    if Supports(prov, IFileProvider, provider) then
      Exit(provider)
    else
      Exit(Nil);
  end;

  //TODO: TPhysicalFileProvider.Create: AppContext.BaseDirectory?? string.Empty
  Result := TPhysicalFileProvider.Create(string.Empty);
end;

class function TFileConfigurationHelper.SetBasePath(
  builder: IConfigurationBuilder; basePath: string): IConfigurationBuilder;
begin
  if builder = Nil then
    raise EArgumentNilException.Create('builder');

  if basePath.IsEmpty then
    raise EArgumentNilException.Create('basePath');

  Result := TFileConfigurationHelper.SetFileProvider(builder, TPhysicalFileProvider.Create(basePath))
end;

class function TFileConfigurationHelper.SetFileProvider(
  builder: IConfigurationBuilder;
  fileProvider: IFileProvider): IConfigurationBuilder;
begin
  if builder = Nil then
    raise EArgumentNilException.Create('builder');

  if fileProvider = Nil then
    raise EArgumentNilException.Create('fileProvider');

  builder.Properties.AddOrSetValue(FileProviderKey, fileProvider);
  //builder.Properties[FileProviderKey] := fileProvider;

  Result := builder;
end;

end.
