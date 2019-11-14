unit ConfigurationProvider.Intf;

interface

uses
  ChangeToken.Intf;

type
  /// <summary>
  /// Provides configuration key/values for an application.
  /// </summary>
  IConfigurationProvider = interface
  ['{4B0BF0A8-9F9B-4172-BB10-B12A5E165C51}']
    /// <summary>
    /// Tries to get a configuration value for the specified key.
    /// </summary>
    /// <param name="key">The key.</param>
    /// <param name="value">The value.</param>
    /// <returns><c>True</c> if a value for the specified key was found, otherwise <c>false</c>.</returns>
    function TryGet(key: string; out value: string): Boolean;

    /// <summary>
    /// Sets a configuration value for the specified key.
    /// </summary>
    /// <param name="key">The key.</param>
    /// <param name="value">The value.</param>
    procedure SetValue(key: string; value: string);

    /// <summary>
    /// Returns a change token if this provider supports change tracking, null otherwise.
    /// </summary>
    /// <returns></returns>
    function GetReloadToken: IChangeToken;

    /// <summary>
    /// Loads configuration values from the source represented by this <see cref="IConfigurationProvider"/>.
    /// </summary>
    procedure Load;

    /// <summary>
    /// Returns the immediate descendant configuration keys for a given parent path based on this
    /// <see cref="IConfigurationProvider"/>'s data and the set of keys returned by all the preceding
    /// <see cref="IConfigurationProvider"/>s.
    /// </summary>
    /// <param name="earlierKeys">The child keys returned by the preceding providers for the same parent path.</param>
    /// <param name="parentPath">The parent path.</param>
    /// <returns>The child keys.</returns>
    function GetChildKeys (earlierKeys : IEnumerable<string>; parentPath: string): IEnumerator<string>;

    /// <summary>
    ///  Returns the provider name
    /// </summary>
    function ToString : string;
  end;

implementation

end.
