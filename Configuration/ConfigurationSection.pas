unit ConfigurationSection;

interface

uses
  Configuration.Intf, ConfigurationRoot.Intf, ConfigurationPath, ChangeToken.Intf,
  System.SysUtils, InternalConfigurationRootExtensions;

type
  TConfigurationSection = class(TInterfacedObject, IConfigurationSection)
  private
    FRoot: IConfigurationRoot;
    FPath: string;
    FKey: string;
  public
    /// <summary>
    /// Initializes a new instance.
    /// </summary>
    /// <param name="root">The configuration root.</param>
    /// <param name="path">The path to this section.</param>
    constructor Create(root: IConfigurationRoot; path: string);

    /// <summary>
    /// Gets the key this section occupies in its parent.
    /// </summary>
    function GetKey : string;

    /// <summary>
    /// Gets the full path to this section within the <see cref="IConfiguration"/>.
    /// </summary>
    function GetPath : string;

    /// <summary>
    /// Gets the section value.
    /// </summary>
    function GetValue : string;

    /// <summary>
    /// Sets the section value.
    /// </summary>
    procedure SetValue(value : string);

    //IConfiguration

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
    /// Gets the immediate descendant configuration sub-sections.
    /// </summary>
    /// <returns>The configuration sub-sections.</returns>
    function GetChildren(): IEnumerable<IConfigurationSection>;

    /// <summary>
    /// Returns a <see cref="IChangeToken"/> that can be used to observe when this configuration is reloaded.
    /// </summary>
    /// <returns></returns>
    function GetReloadToken(): IChangeToken;
  end;

implementation

{ TConfigurationSection }

constructor TConfigurationSection.Create(root: IConfigurationRoot; path: string);
begin
  if root = Nil then
    raise EArgumentNilException.Create('root');

  if path.IsEmpty then
    raise EArgumentNilException.Create('path');

  FRoot := root;
  FPath := path;
end;

function TConfigurationSection.GetChildren: IEnumerable<IConfigurationSection>;
begin
  Result := TInternalConfigurationRootExtensions.GetChildrenImplementation(FRoot, GetPath);
end;

function TConfigurationSection.GetItem(const key: string): string;
begin
  Result := FRoot.Items[TConfigurationPath.Combine([GetPath, key])];
end;

function TConfigurationSection.GetKey: string;
begin
  if FKey.IsEmpty then
  begin
    FKey := TConfigurationPath.GetSectionKey(FPath);
  end;

  Result := FKey;
end;

function TConfigurationSection.GetPath: string;
begin
  Result := FPath;
end;

function TConfigurationSection.GetReloadToken: IChangeToken;
begin
  Result := FRoot.GetReloadToken;
end;

function TConfigurationSection.GetSection(key: string): IConfigurationSection;
begin
  FRoot.GetSection(TConfigurationPath.Combine([GetPath, key]))
end;

function TConfigurationSection.GetValue: string;
begin
  Result := FRoot[GetPath];
end;

procedure TConfigurationSection.SetItem(const key: string; value: string);
begin
  FRoot.Items[TConfigurationPath.Combine([GetPath, key])] := value;
end;

procedure TConfigurationSection.SetValue(value: string);
begin
  FRoot[GetPath] := value;
end;

end.
