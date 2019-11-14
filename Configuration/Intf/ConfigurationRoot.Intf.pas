unit ConfigurationRoot.Intf;

interface

uses
  Configuration.Intf, ConfigurationProvider.Intf, Generics.Collections;

type
  /// <summary>
  /// Represents the root of an <see cref="IConfiguration"/> hierarchy.
  /// </summary>
  IConfigurationRoot = interface(IConfiguration)
  ['{5667C448-850D-4A7E-83EE-83258BF5E06F}']
    /// <summary>
    /// Force the configuration values to be reloaded from the underlying <see cref="IConfigurationProvider"/>s.
    /// </summary>
    procedure Reload;

    /// <summary>
    /// The <see cref="IConfigurationProvider"/>s for this configuration.
    /// </summary>
    function GetProviders: TList<IConfigurationProvider>;

    /// <summary>
    /// The <see cref="IConfigurationProvider"/>s for this configuration.
    /// </summary>
    property Providers: TList<IConfigurationProvider> read GetProviders;
  end;


implementation

end.
