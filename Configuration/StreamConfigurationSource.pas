unit StreamConfigurationSource;

interface

uses
  ConfigurationBuilder.Intf, ConfigurationProvider.Intf, System.Classes;

type
  /// <summary>
  /// Stream based <see cref="IConfigurationSource" />.
  /// </summary>
  TStreamConfigurationSource = class(TInterfacedObject, IConfigurationSource)
  private
    FStream: TStream;
  public
    /// <summary>
    /// Builds the <see cref="StreamConfigurationProvider"/> for this source.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/>.</param>
    /// <returns>An <see cref="IConfigurationProvider"/></returns>
    function Build(builder: IConfigurationBuilder) : IConfigurationProvider; virtual; abstract;

    /// <summary>
    /// The stream containing the configuration data.
    /// </summary>
    property Stream: TStream read FStream write FStream;
  end;

implementation

end.
