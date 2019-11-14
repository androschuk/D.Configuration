unit ConfigurationRoot;

interface

uses
  Generics.Collections, System.SysUtils, ConfigurationRoot.Intf,
  ConfigurationProvider.Intf, Configuration.Intf, EnumeratorHelper,
  ChangeToken.Intf, ConfigurationReloadToken, InternalConfigurationRootExtensions,
  ConfigurationSection, System.SyncObjs;

type
  TConfigurationRoot = class(TInterfacedObject, IConfigurationRoot)
  private
    FProviders: TList<IConfigurationProvider>;
    FChangeTokenRegistrations: TList<IInterface>;
    FChangeToken : TConfigurationReloadToken;

    procedure RaiseChanged;
  public
    constructor Create(providers: TList<IConfigurationProvider>);
    destructor Destroy; override;
    // IConfigurationRoot
    //procedure Reload;

    /// <summary>
    /// The <see cref="IConfigurationProvider"/>s for this configuration.
    /// </summary>
    function GetProviders: TList<IConfigurationProvider>;

    /// <summary>
    /// Gets a configuration value.
    /// </summary>
    /// <param name="key">The configuration key.</param>
    /// <returns>The configuration value.</returns>
    function GetItem(const key: string): string;
    /// <summary>
    /// Sets a configuration value.
    /// </summary>
    /// <param name="key">The configuration key.</param>
    /// <param name="value">The configuration value.</param>
    procedure SetItem(const key: string; value: string);

    /// <summary>
    /// Gets the immediate children sub-sections.
    /// </summary>
    /// <returns></returns>
    function GetChildren(): IEnumerable<IConfigurationSection>;

    /// <summary>
    /// Returns a <see cref="IChangeToken"/> that can be used to observe when this configuration is reloaded.
    /// </summary>
    /// <returns></returns>
    function GetReloadToken(): IChangeToken;

    /// <summary>
    /// Gets a configuration sub-section with the specified key.
    /// </summary>
    /// <param name="key">The key of the configuration section.</param>
    /// <returns>The <see cref="IConfigurationSection"/>.</returns>
    /// <remarks>
    ///     This method will never return <c>null</c>. If no matching sub-section is found with the specified key,
    ///     an empty <see cref="IConfigurationSection"/> will be returned.
    /// </remarks>
    function GetSection(key: string): IConfigurationSection;

    /// <summary>
    /// Force the configuration values to be reloaded from the underlying sources.
    /// </summary>
    procedure Reload;
  end;

implementation

{ TConfigurationRoot }

constructor TConfigurationRoot.Create(providers: TList<IConfigurationProvider>);
var
  provider: IConfigurationProvider;
begin
  if not Assigned(providers) then
    raise EArgumentNilException.Create('Error Message');

  FProviders := providers;

  FChangeTokenRegistrations := TList<IInterface>.Create;
  FChangeToken := TConfigurationReloadToken.Create;

  for provider in providers do
  begin
    provider.Load;
    //TODO:  _changeTokenRegistrations.Add(ChangeToken.OnChange(() => p.GetReloadToken(), () => RaiseChanged()));
  end;
end;

destructor TConfigurationRoot.Destroy;
begin
  FreeAndNil(FChangeToken);
  FreeAndNil(FChangeTokenRegistrations);

  FreeAndNil(FProviders);

  inherited;
end;

function TConfigurationRoot.GetChildren: IEnumerable<IConfigurationSection>;
begin
  Result := TInternalConfigurationRootExtensions.GetChildrenImplementation(Self, string.Empty);
end;

function TConfigurationRoot.GetItem(const key: string): string;
var
  I: Integer;
  provider: IConfigurationProvider;
  value: string;
begin
  for I := FProviders.Count - 1 downto 0 do
  begin
    provider := FProviders[i];

    if provider.TryGet(key, value) then
      Exit(value);
  end;

  Result := String.Empty;
end;

function TConfigurationRoot.GetProviders: TList<IConfigurationProvider>;
begin
  Result := FProviders;
end;

function TConfigurationRoot.GetReloadToken: IChangeToken;
begin
  Result := FChangeToken;
end;

function TConfigurationRoot.GetSection(key: string): IConfigurationSection;
begin
  Result := TConfigurationSection.Create(Self, key);
end;

procedure TConfigurationRoot.RaiseChanged;
var
  previousToken: TConfigurationReloadToken;
begin
  previousToken := TInterlocked.Exchange(FChangeToken, TConfigurationReloadToken.Create);
  previousToken.OnReload();
end;

procedure TConfigurationRoot.Reload;
var
  provider: IConfigurationProvider;
begin
  for provider in FProviders do
  begin
    provider.Load;
  end;

  RaiseChanged;
end;

procedure TConfigurationRoot.SetItem(const key: string; value: string);
var
  provider: IConfigurationProvider;
begin
  if FProviders.Count = 0 then
    raise EInvalidOpException.Create('No sources');

  for provider in FProviders do
  begin
    provider.SetValue(key, value);
  end;
end;

end.
