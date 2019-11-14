unit ConfigurationRootHelper;

interface

uses
  ConfigurationRoot.Intf, Configuration.Intf, ConfigurationProvider.Intf,
  System.SysUtils, EnumeratorHelper, Generics.Collections;

type
  TValueProvider = class
  private
    FValue: string;
    FProvider: IConfigurationProvider;
    function GetValue: string;
    function Getrovider: IConfigurationProvider;
  public
    constructor Create(value: string; provider: IConfigurationProvider);
    property Value: string read GetValue;
    property Provider: IConfigurationProvider read Getrovider;
  end;

  TonfigurationRootHelper = class
    /// <summary>
    /// Generates a human-readable view of the configuration showing where each value came from.
    /// </summary>
    /// <returns> The debug view. </returns>
    class function GetDebugView(root: IConfigurationRoot): string;
    class function GetValueAndProvider(root: IConfigurationRoot; key: string): TValueProvider;
  end;

implementation

{ TonfigurationRootHelper }

class function TonfigurationRootHelper.GetDebugView(root: IConfigurationRoot): string;

  procedure RecurseChildren(stringBuilder : TStringBuilder; children: IEnumerable<IConfigurationSection>; indent: string);
  var
    child: IConfigurationSection;
    valueAndProvider: TValueProvider;
  begin
    for child in children do
    begin
      valueAndProvider := GetValueAndProvider(root, child.Path);

      if valueAndProvider.Provider <> Nil then
      begin
        stringBuilder
          .Append(indent)
          .Append(child.Key)
          .Append('=')
          .Append(valueAndProvider.Value)
          .Append(' (')
          .Append(valueAndProvider.Provider.ToString)
          .Append(')');
      end
      else
      begin
        stringBuilder
          .Append(indent)
          .Append(child.Key)
          .Append(':');
      end;

      RecurseChildren(stringBuilder, child.GetChildren, indent + '  ');
    end;
  end;

var
  builder: TStringBuilder;
begin
  builder := TStringBuilder.Create;
  RecurseChildren(builder, root.GetChildren(), '');
  Result := builder.ToString;
end;

class function TonfigurationRootHelper.GetValueAndProvider(root: IConfigurationRoot; key: string): TValueProvider;
var
  provider: IConfigurationProvider;
  value : string;
  localProv: TList<IConfigurationProvider>;
begin
  localProv := TList<IConfigurationProvider>.Create;
  try
    localProv.InsertRange(0, root.Providers);
    localProv.Reverse;

    for provider in localProv do
    begin
      if provider.TryGet(key, value) then
      begin
        Exit(TValueProvider.Create(value, provider));
      end;
    end;
  finally
    FreeAndNil(localProv);
  end;

  Result := Nil;
end;

{ TValueProvider }

constructor TValueProvider.Create(value: string;  provider: IConfigurationProvider);
begin
  FValue := value;
  FProvider := provider;
end;

function TValueProvider.Getrovider: IConfigurationProvider;
begin
  Result := FProvider;
end;

function TValueProvider.GetValue: string;
begin
  Result := FValue;
end;

end.
