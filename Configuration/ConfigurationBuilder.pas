unit ConfigurationBuilder;

interface

uses
  System.SysUtils, Generics.Collections, ConfigurationBuilder.Intf,
  ConfigurationProvider.Intf, ConfigurationRoot.Intf, ConfigurationRoot;

type
  TConfigurationBuilder = class(TInterfacedObject, IConfigurationBuilder)
  private
    FProperties: TDictionary<string, IInterface>;
    FSources: TList<IConfigurationSource>;
  public
    constructor Create;
    destructor Destroy; override;

    //IConfigurationBuilder
    /// <summary>
    /// Gets a key/value collection that can be used to share data between the <see cref="IConfigurationBuilder"/>
    /// and the registered <see cref="IConfigurationProvider"/>s.
    /// </summary>
    function GetProperties: TDictionary<string, IInterface>;
    /// <summary>
    /// Used to build key/value based configuration settings for use in an application.
    /// </summary>
    function GetSources: TList<IConfigurationSource>;
    /// <summary>
    /// Adds a new configuration source.
    /// </summary>
    /// <param name="source">The configuration source to add.</param>
    /// <returns>The same <see cref="IConfigurationBuilder"/>.</returns>
    function Add(source: IConfigurationSource) : IConfigurationBuilder;
    /// <summary>
    /// Builds an <see cref="IConfiguration"/> with keys and values from the set of providers registered in
    /// <see cref="Sources"/>.
    /// </summary>
    /// <returns>An <see cref="IConfigurationRoot"/> with keys and values from the registered providers.</returns>
    function Build: IConfigurationRoot;
  end;


implementation

{ TConfigurationBuilder }

function TConfigurationBuilder.Add(source: IConfigurationSource): IConfigurationBuilder;
begin
  if not Assigned(source) then
    raise EArgumentNilException.Create('source');

  FSources.Add(source);

  Result := Self;
end;

function TConfigurationBuilder.Build: IConfigurationRoot;
var
  providers: TList<IConfigurationProvider>;
  provider: IConfigurationProvider;
  source: IConfigurationSource;
begin
  providers := TList<IConfigurationProvider>.Create;
  for source in GetSources do
  begin
    provider := source.Build(Self);
    providers.Add(provider);
  end;

  Result := TConfigurationRoot.Create(providers);
end;

constructor TConfigurationBuilder.Create;
begin
  FSources := TList<IConfigurationSource>.Create;
  FProperties := TDictionary<string, IInterface>.Create();
end;

destructor TConfigurationBuilder.Destroy;
begin
  FreeAndNil(FProperties);
  FreeAndNil(FSources);

  inherited;
end;

function TConfigurationBuilder.GetProperties: TDictionary<string, IInterface>;
begin
  Result := FProperties;
end;

function TConfigurationBuilder.GetSources: TList<IConfigurationSource>;
begin
  Result := FSources;
end;

end.
