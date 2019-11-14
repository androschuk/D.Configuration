unit IniConfigurationProvider;

interface

uses
  FileConfigurationSource, System.Classes, System.SysUtils, IniStreamConfigurationProvider,
  System.JSON;

type
  /// <summary>
  /// An INI file based <see cref="ConfigurationProvider"/>.
  /// Files are simple line structures (<a href="https://en.wikipedia.org/wiki/INI_file">INI Files on Wikipedia</a>)
  /// </summary>
  /// <examples>
  /// [Section:Header]
  /// key1=value1
  /// key2 = " value2 "
  /// ; comment
  /// # comment
  /// / comment
  /// </examples>
  TIniConfigurationProvider = class(TFileConfigurationProvider)
  public
    /// <summary>
    /// Loads the INI data from a stream.
    /// </summary>
    /// <param name="stream">The stream to read.</param>
    procedure Load(stream: TStream); override;
  end;

implementation

{ TJsonConfigurationProvider }

procedure TIniConfigurationProvider.Load(stream: TStream);
begin
  Data := TIniStreamConfigurationProvider.Read(stream);
end;

end.
