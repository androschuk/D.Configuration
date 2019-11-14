unit Configuration.Intf;

interface

uses
  ChangeToken.Intf;

type
  IConfigurationSection = interface;


  /// <summary>
  /// Represents a set of key/value application configuration properties.
  /// </summary>
  IConfiguration = interface
  ['{A3106D8C-F780-451B-B3F9-7EE4F9B0FBFC}']
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
    ///     This method will never return <c>nil</c>. If no matching sub-section is found with the specified key,
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
    /// <returns>A <see cref="IChangeToken"/>.</returns>
    function GetReloadToken(): IChangeToken;

    /// <summary>
    /// Gets or sets a configuration value.
    /// </summary>
    /// <param name="key">The configuration key.</param>
    /// <returns>The configuration value.</returns>
    property Items[const key: string] : string read GetItem write SetItem; default;
  end;

  /// <summary>
  /// Represents a section of application configuration values.
  /// </summary>
  IConfigurationSection = interface(IConfiguration)
  ['{67D184A9-0F1B-4BE3-A381-E7E0FD47011E}']
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

    /// <summary>
    /// Gets the key this section occupies in its parent.
    /// </summary>
    property Key : string read GetKey;

    /// <summary>
    /// Gets the full path to this section within the <see cref="IConfiguration"/>.
    /// </summary>
    property Path : string read GetPath;

    /// <summary>
    /// Gets or sets the section value.
    /// </summary>
    property Value: string read GetValue write SetValue;
  end;

implementation

end.
