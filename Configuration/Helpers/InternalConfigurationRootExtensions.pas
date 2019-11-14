unit InternalConfigurationRootExtensions;

interface

uses
  System.SysUtils, ConfigurationRoot.Intf, Configuration.Intf,
  ConfigurationProvider.Intf, EnumeratorHelper;

type
  TInternalConfigurationRootExtensions = class
    /// <summary>
    /// Gets the immediate children sub-sections of configuration root based on key.
    /// </summary>
    /// <param name="root">Configuration from which to retrieve sub-sections.</param>
    /// <param name="path">Key of a section of which children to retrieve.</param>
    /// <returns>Immediate children sub-sections of section specified by key.</returns>
    class function GetChildrenImplementation(root: IConfigurationRoot; path: string): IEnumerable<IConfigurationSection>;
  end;

implementation

{ TInternalConfigurationRootExtensions }

class function TInternalConfigurationRootExtensions.GetChildrenImplementation(
  root: IConfigurationRoot; path: string): IEnumerable<IConfigurationSection>;
var
  provider: IConfigurationProvider;
//  agregated: IEnumerable<string>;
begin
  raise ENotImplemented.Create('Implement distinct');

  for provider in root.Providers do
  begin
    //agregated := TEnumeratorHelper.Aggregate<IEnumerable<IConfigurationProvider>, IEnumerable<string>>(TEnumeratorHelper.Empty<string>(),
//    function(source: IConfigurationProvider; seed: IEnumerable<string>):IEnumerable<IConfigurationProvider>
//    begin
//        Result := source.GetChildKeys(seed, path);
//    end);
  end

//TODO: nee implement
//  Result := root.Providers.Aggregate(TEnumeratorHelper.Empty<string>(),
//                    (seed, source) => source.GetChildKeys(seed, path))
//                .Distinct(StringComparer.OrdinalIgnoreCase)
//                .Select(key => root.GetSection(path == null ? key : ConfigurationPath.Combine(path, key)));
end;

end.
