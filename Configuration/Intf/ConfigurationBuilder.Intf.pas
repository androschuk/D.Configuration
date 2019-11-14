unit ConfigurationBuilder.Intf;

interface

uses
  ConfigurationProvider.Intf, Generics.Collections, ConfigurationRoot.Intf;

type
  IConfigurationBuilder = interface;

  /// <summary>
  /// Represents a source of configuration key/values for an application.
  /// </summary>
  IConfigurationSource = interface
  ['{43A5AF66-4BDD-4523-BF56-BC06136CB86D}']
    /// <summary>
    /// Builds the <see cref="IConfigurationProvider"/> for this source.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/>.</param>
    /// <returns>An <see cref="IConfigurationProvider"/></returns>
    function Build(builder: IConfigurationBuilder) : IConfigurationProvider;
  end;

  /// <summary>
  /// Represents a type used to build application configuration.
  /// </summary>
  IConfigurationBuilder = interface
  ['{CD9ACBD9-9E05-478B-B5B3-48CC82574971}']
    /// <summary>
    /// Gets a key/value collection that can be used to share data between the <see cref="IConfigurationBuilder"/>
    /// and the registered <see cref="IConfigurationSource"/>s.
    /// </summary>
    function GetProperties: TDictionary<string, IInterface>;

    /// <summary>
    /// Gets the sources used to obtain configuration values
    /// </summary>
    function GetSources: TList<IConfigurationSource>;

    /// <summary>
    /// Adds a new configuration source.
    /// </summary>
    /// <param name="source">The configuration source to add.</param>
    /// <returns>The same <see cref="IConfigurationBuilder"/>.</returns>
    function Add(source: IConfigurationSource) : IConfigurationBuilder;

    /// <summary>
    /// Builds an <see cref="IConfiguration"/> with keys and values from the set of sources registered in
    /// <see cref="Sources"/>.
    /// </summary>
    /// <returns>An <see cref="IConfigurationRoot"/> with keys and values from the registered sources.</returns>
    function Build: IConfigurationRoot;

    /// <summary>
    /// Gets a key/value collection that can be used to share data between the <see cref="IConfigurationBuilder"/>
    /// and the registered <see cref="IConfigurationSource"/>s.
    /// </summary>
    property Properties : TDictionary<string, IInterface> read GetProperties;

    /// <summary>
    /// Gets the sources used to obtain configuration values
    /// </summary>
    property Sources : TList<IConfigurationSource> read GetSources;

  end;

implementation

end.
