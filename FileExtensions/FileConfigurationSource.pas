unit FileConfigurationSource;

interface

uses
  ConfigurationBuilder.Intf, ConfigurationProvider.Intf, FileProvider.Intf,
  FileConfigurationHelper, System.SysUtils, System.IOUtils, PhysicalFileProvider,
  ConfigurationProvider, FileInfo.Intf, Generics.Collections, System.Generics.Defaults,
  System.Classes, System.Generics.Dictionary;

type
  TFileConfigurationProvider = class;

  /// <summary>
  /// Contains information about a file load exception.
  /// </summary>
  TFileLoadExceptionContext = class
  private
    FProvider : TFileConfigurationProvider;
    FException: Exception;
    FIgnore: boolean;
    //TODO: not implemented _changeTokenRegistration;
    //_changeTokenRegistration
  public
    constructor Create(Provider: TFileConfigurationProvider; ex:Exception; Ignore: boolean = false);

    /// <summary>
    /// The <see cref="FileConfigurationProvider"/> that caused the exception.
    /// </summary>
    property Provider: TFileConfigurationProvider read FProvider write FProvider;
    /// <summary>
    /// The exception that occured in Load.
    /// </summary>
    property Exception: Exception read FException write FException;

    /// <summary>
    /// If true, the exception will not be rethrown.
    /// </summary>
    property Ignore: boolean read FIgnore write FIgnore;
  end;

  TFileConfigurationSource = class(TInterfacedObject, IConfigurationSource)
  private
    FFileProvider: IFileProvider;
    FPath: string;
    FOptional: Boolean;
    FReloadOnChange: Boolean;
    FReloadDelay: Integer;
    FOnLoadException: TProc<TFileLoadExceptionContext>;
    function GetFileProvider: IFileProvider;
    procedure SetFileProvider(const Value: IFileProvider);
    function GetPath: string;
    procedure SetPath(const Value: string);
    function GetOptional: Boolean;
    procedure SetOptional(const Value: Boolean);
    function GetReloadOnChange: Boolean;
    procedure SetReloadOnChange(const Value: Boolean);
    function GetReloadDelay: Integer;
    procedure SetReloadDelay(const Value: Integer);
  public
    constructor Create;
    function Build(builder: IConfigurationBuilder) : IConfigurationProvider; virtual; abstract;

    /// <summary>
    /// Called to use any default settings on the builder like the FileProvider or FileLoadExceptionHandler.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/>.</param>
    procedure EnsureDefaults(builder: IConfigurationBuilder);

    /// <summary>
    /// If no file provider has been set, for absolute Path, this will creates a physical file provider
    /// for the nearest existing directory.
    /// </summary>
    procedure ResolveFileProvider();

    /// <summary>
    /// Used to access the contents of the file.
    /// </summary>
    property FileProvider: IFileProvider read GetFileProvider write SetFileProvider;
    /// <summary>
    /// The path to the file.
    /// </summary>
    property Path: string read GetPath write SetPath;
    /// <summary>
    /// Determines if loading the file is optional.
    /// </summary>
    property Optional: Boolean read GetOptional write SetOptional;
    /// <summary>
    /// Determines whether the source will be loaded if the underlying file changes.
    /// </summary>
    property ReloadOnChange: Boolean read GetReloadOnChange write SetReloadOnChange;
    /// <summary>
    /// Number of milliseconds that reload will wait before calling Load.  This helps
    /// avoid triggering reload before a file is completely written. Default is 250.
    /// </summary>
    property ReloadDelay: Integer read GetReloadDelay write SetReloadDelay;

    /// <summary>
    /// Will be called if an uncaught exception occurs in TFileConfigurationProvider.Load.
    /// </summary>
    property OnLoadException : TProc<TFileLoadExceptionContext> read FOnLoadException write FOnLoadException;
  end;

  /// <summary>
  /// Base class for file based <see cref="ConfigurationProvider"/>.
  /// </summary>
  TFileConfigurationProvider = class abstract (TConfigurationProvider)
  protected
    FSource: TFileConfigurationSource;

    procedure Load(reload: Boolean); overload;
    procedure HandleException(ex: Exception);
  public
    /// <summary>
    /// Initializes a new instance with the specified source.
    /// </summary>
    /// <param name="source">The source settings.</param>
    constructor Create(src: TFileConfigurationSource); virtual;
    destructor Destroy; override;

    /// <summary>
    /// Generates a string representing this provider name and relevant details.
    /// </summary>
    /// <returns> The configuration name. </returns>
    function ToString: string; override;

    /// <summary>
    /// Loads this provider's data from a stream.
    /// </summary>
    /// <param name="stream">The stream to read.</param>
    procedure Load(stream: TStream); overload; virtual; abstract;

    /// <summary>
    /// Loads the contents of the file at <see cref="Path"/>.
    /// </summary>
    /// <exception cref="FileNotFoundException">If Optional is <c>false</c> on the source and a
    /// file does not exist at specified Path.</exception>
    procedure Load(); overload; override;

    /// <summary>
    /// The source settings for this provider.
    /// </summary>
    property Source: TFileConfigurationSource read FSource;
  end;

implementation

{ TFileConfigurationSource }
constructor TFileConfigurationSource.Create;
begin
  FReloadDelay := 250;
end;

procedure TFileConfigurationSource.EnsureDefaults(builder: IConfigurationBuilder);
begin
  If FFileProvider  = Nil then
    FFileProvider :=  TFileConfiguration(builder).GetFileProvider();

//TODO: GetFileLoadExceptionHandler
//  if Not Assigned(OnLoadException) then
//    OnLoadException := TFileConfigurationHelper.GetFileLoadExceptionHandler;
end;

function TFileConfigurationSource.GetFileProvider: IFileProvider;
begin
  Result := FFileProvider;
end;

function TFileConfigurationSource.GetOptional: Boolean;
begin
  Result := FOptional;
end;

function TFileConfigurationSource.GetPath: string;
begin
  Result := FPath;
end;

function TFileConfigurationSource.GetReloadDelay: Integer;
begin
  Result := FReloadDelay;
end;

function TFileConfigurationSource.GetReloadOnChange: Boolean;
begin
  Result := FReloadOnChange;
end;

procedure TFileConfigurationSource.ResolveFileProvider;
var
  directory: string;
  pathToFile: string;
begin
  if (FileProvider = Nil) And (Path.IsEmpty) And (TPath.IsPathRooted(Path)) then
  begin
    directory := TPath.GetDirectoryName(Path);
    pathToFile := TPath.GetFileName(Path);

    while (Not directory.IsEmpty And Not TDirectory.Exists(directory)) do
    begin

      pathToFile := TPath.Combine(TPath.GetFileName(directory), pathToFile);
      directory := TPath.GetDirectoryName(directory);

      if (TDirectory.Exists(directory)) then
      begin
        FileProvider := TPhysicalFileProvider.Create(directory);
        Path := pathToFile;
      end;
    end;
  end;
end;

procedure TFileConfigurationSource.SetFileProvider(const Value: IFileProvider);
begin
  FFileProvider := Value;
end;

procedure TFileConfigurationSource.SetOptional(const Value: Boolean);
begin
  FOptional := Value;
end;

procedure TFileConfigurationSource.SetPath(const Value: string);
begin
  FPath := Value;
end;

procedure TFileConfigurationSource.SetReloadDelay(const Value: Integer);
begin
  FReloadDelay := Value;
end;

procedure TFileConfigurationSource.SetReloadOnChange(const Value: Boolean);
begin
  FReloadOnChange := Value;
end;

{ TFileConfigurationProvider }

constructor TFileConfigurationProvider.Create(src: TFileConfigurationSource);
begin
  if src = Nil then
    raise EArgumentNilException.Create('source');

  FSource := src;

  if Source.ReloadOnChange Or Assigned(Source.FileProvider) then
  begin
    //TODO: _changeTokenRegistration
    //_changeTokenRegistration := TCha
  end;


end;

destructor TFileConfigurationProvider.Destroy;
begin
  //FreeAndNil(FChangeTokenRegistration);
  inherited;
end;

procedure TFileConfigurationProvider.HandleException(ex: Exception);
var
  ignoreException: Boolean;
  exceptionContext: TFileLoadExceptionContext;
begin
  ignoreException := False;

  if Assigned(Source.OnLoadException) then
  begin
    exceptionContext := TFileLoadExceptionContext.Create(Self, ex);
    Source.OnLoadException(exceptionContext);
    ignoreException := exceptionContext.Ignore;
  end;

  if not ignoreException  then
    raise ex;
end;

procedure TFileConfigurationProvider.Load;
begin
  Load(False);
end;

procedure TFileConfigurationProvider.Load(reload: Boolean);
var
  fileInfo: IFileInfo;
  provider: IFileProvider;
  error: TStringBuilder;
  stream: TStream;
begin
  provider := Source.FileProvider;

  if provider = nil then
    fileInfo := Nil
  else
    fileInfo := provider.GetFileInfo(Source.Path);

  if not Assigned(fileInfo) Or Not fileInfo.Exists then
  begin
    if Source.Optional or reload then
    begin
      Data := TDictionary<string,string>.Create(TIStringComparer.Ordinal);
    end
    else
    begin
      error:= TStringBuilder.Create(Format('The configuration file "%s" was not found and is not optional.', [Source.Path]));

      if fileInfo.PhysicalPath.IsEmpty then
      begin
        error.Append(Format(' The physical path is "%s".', [fileInfo.PhysicalPath]))
      end;

      HandleException(EFileNotFoundException(error.ToString));
    end;
  end
  else
  begin
    // Always create new Data on reload to drop old keys
    if reload then
      Data := TDictionary<string,string>.Create(TIStringComparer.Ordinal);

    stream := fileInfo.CreateReadStream;
    try
      try
        Load(stream);
      except
        On E: Exception do
          HandleException(e);
      end;
    finally
      FreeAndNil(stream);
    end;
  end;

  // REVIEW: Should we raise this in the base as well / instead?
  OnReload();
end;

function TFileConfigurationProvider.ToString: string;
var
  value: string;
begin

  if Source.Optional then
    value := 'Optional'
  else
    value := 'Required';


  Result := Format('%s for "%s" (%s)',[Self.ClassName, Source.Path, Source.Optional, value]);
end;

{ TFileLoadExceptionContext }

constructor TFileLoadExceptionContext.Create(Provider: TFileConfigurationProvider; ex:Exception; Ignore: boolean = false);
begin
  inherited Create;

  FProvider := Provider;
  FException := ex;
  FIgnore := Ignore;
end;

end.
