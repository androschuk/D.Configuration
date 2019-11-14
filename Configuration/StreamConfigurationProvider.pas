unit StreamConfigurationProvider;

interface

uses
  ConfigurationProvider, StreamConfigurationSource, System.SysUtils,
  System.Classes;

type
  /// <summary>
  /// Stream based configuration provider
  /// </summary>
  TStreamConfigurationProvider = class abstract (TConfigurationProvider)
  private
    FSource: TStreamConfigurationSource;
    FLoaded: Boolean;
  public
    /// <summary>
    /// Constructor.
    /// </summary>
    /// <param name="source">The source.</param>
    constructor Create(source: TStreamConfigurationSource);

    /// <summary>
    /// Load the configuration data from the stream.
    /// </summary>
    /// <param name="stream">The data stream.</param>
    procedure Load(stream: TStream); overload; virtual; abstract;

    /// <summary>
    /// Load the configuration data from the stream. Will throw after the first call.
    /// </summary>
    procedure Load; overload; override;

    /// <summary>
    /// The source settings for this provider.
    /// </summary>
    property Source: TStreamConfigurationSource read FSource;
  end;

implementation

{ TStreamConfigurationProvider }

constructor TStreamConfigurationProvider.Create(
  source: TStreamConfigurationSource);
begin
inherited Create;

  if Not Assigned(source) then
    raise EArgumentNilException.Create('source');

  FSource := source;
end;

procedure TStreamConfigurationProvider.Load;
begin
  if FLoaded then
    raise EInvalidOperation.Create('TStreamConfigurationProviders cannot be loaded more than once.');

  Load(Source.Stream);
  FLoaded := true;
end;

end.
