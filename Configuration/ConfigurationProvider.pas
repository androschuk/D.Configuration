unit ConfigurationProvider;

interface

uses
  ConfigurationProvider.Intf, Generics.Collections, System.SysUtils, ConfigurationPath,
  ChangeToken.Intf, ConfigurationReloadToken, Generics.Defaults, System.Generics.Dictionary;

type
  TConfigurationProvider = class(TInterfacedObject, IConfigurationProvider)
  private
    FDate : IDictionary<string,string>;
    FReloadToken: TConfigurationReloadToken;
  protected
    /// <summary>
    /// Triggers the reload change token and creates a new one.
    /// </summary>
    procedure OnReload;

    /// <summary>
    /// The configuration key value pairs for this provider.
    /// </summary>
    property Data: IDictionary<string,string> read FDate write FDate;
  public
    /// <summary>
    /// Initializes a new <see cref="IConfigurationProvider"/>
    /// </summary>
    constructor Create();
    destructor Destroy; override;

    //IConfigurationProvider

    /// <summary>
    /// Attempts to find a value with the given key, returns true if one is found, false otherwise.
    /// </summary>
    /// <param name="key">The key to lookup.</param>
    /// <param name="value">The value found at key if one is found.</param>
    /// <returns>True if key has a value, false otherwise.</returns>
    function TryGet(key: string; out value: string): Boolean;

    /// <summary>
    /// Sets a value for a given key.
    /// </summary>
    /// <param name="key">The configuration key to set.</param>
    /// <param name="value">The value to set.</param>
    procedure SetValue(key: string; value: string);

    /// <summary>
    /// Loads (or reloads) the data for this provider.
    /// </summary>
    procedure Load; virtual;

    /// <summary>
    /// Returns the list of keys that this provider has.
    /// </summary>
    /// <param name="earlierKeys">The earlier keys that other providers contain.</param>
    /// <param name="parentPath">The path for the parent IConfiguration.</param>
    /// <returns>The list of keys for this provider.</returns>
    function GetChildKeys (earlierKeys : IEnumerable<string>; parentPath: string): IEnumerator<string>;

    /// <summary>
    /// Returns a <see cref="IChangeToken"/> that can be used to listen when this provider is reloaded.
    /// </summary>
    /// <returns></returns>
    function GetReloadToken: IChangeToken;

    /// <summary>
    /// Generates a string representing this provider name and relevant details.
    /// </summary>
    /// <returns> The configuration name. </returns>
    function ToString: string; override;
  end;

implementation

{ TConfigurationProvider }

constructor TConfigurationProvider.Create;
begin
  FDate := TDictionary<string, string>.Create(TIStringComparer.Ordinal);
  FReloadToken := TConfigurationReloadToken.Create;
end;

destructor TConfigurationProvider.Destroy;
begin
  FreeAndNil(FReloadToken);

  inherited;
end;

function TConfigurationProvider.GetChildKeys(earlierKeys: IEnumerable<string>;
  parentPath: string): IEnumerator<string>;

  function Segment(key: string; prefixLength: Integer): string;
  var
    indexOf: Integer;
  begin
    indexOf := key.IndexOf(TConfigurationPath.KeyDelimiter, prefixLength);

    if indexOf < 0 then
      Result := key.Substring(prefixLength)
    else
      Result :=  key.Substring(prefixLength, indexOf - prefixLength);
  end;


var
  prefix: string;
  kv: TPair<string, string>;
  list: TList<string>;
begin
  if parentPath.IsEmpty then
    prefix := string.Empty
  else
    prefix :=parentPath + TConfigurationPath.KeyDelimiter;

  list := TList<string>.Create;
  try

    for kv in Data do
    begin
      if kv.Key.StartsWith(prefix, true) then
        list.Add(Segment(kv.Key, prefix.Length));
    end;

    list.AddRange(earlierKeys);
    list.Sort;

  finally
    FreeAndNil(list);
  end;

end;

function TConfigurationProvider.GetReloadToken: IChangeToken;
begin
  Result := FReloadToken;
end;

procedure TConfigurationProvider.Load;
begin
// to do something.
end;

procedure TConfigurationProvider.OnReload;
begin
// var previousToken = Interlocked.Exchange(ref _reloadToken, new ConfigurationReloadToken());
// previousToken.OnReload();
//TODO: not implemented  TConfigurationProvider.OnReload
end;

procedure TConfigurationProvider.SetValue(key, value: string);
begin
  FDate[key] := value;
end;

function TConfigurationProvider.ToString: string;
begin
  Result := Self.ClassName
end;

function TConfigurationProvider.TryGet(key: string; out value: string): Boolean;
begin
  Result := Data.TryGetValue(key, value);
end;

end.
