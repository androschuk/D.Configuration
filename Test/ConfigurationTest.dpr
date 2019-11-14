program ConfigurationTest;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Generics.Collections,
  System.Generics.Dictionary,
  System.Environment,
  FileProvider in '..\FileExtensions\FileProvider.pas',
  FileProvider.Intf in '..\FileProviders.Abstractions\FileProvider.Intf.pas',
  FileInfo.Intf in '..\FileProviders.Abstractions\FileInfo.Intf.pas',
  DirectoryContents.Intf in '..\FileProviders.Abstractions\DirectoryContents.Intf.pas',
  NotFoundDirectoryContents in '..\FileProviders.Abstractions\NotFoundDirectoryContents.pas',
  PhysicalFileProvider in '..\FileProviders.Physical\PhysicalFileProvider.pas',
  ExclusionFilters in '..\FileProviders.Physical\ExclusionFilters.pas',
  PathUtils in '..\FileProviders.Physical\PathUtils.pas',
  PhysicalFilesWatcher in '..\FileProviders.Physical\PhysicalFilesWatcher.pas',
  JsonConfigurationHelper in '..\Configurations.Json\JsonConfigurationHelper.pas',
  JsonConfigurationSource in '..\Configurations.Json\JsonConfigurationSource.pas',
  FileConfigurationSource in '..\FileExtensions\FileConfigurationSource.pas',
  JsonConfigurationProvider in '..\Configurations.Json\JsonConfigurationProvider.pas',
  JsonStreamConfigurationSource in '..\Configurations.Json\JsonStreamConfigurationSource.pas',
  JsonStreamConfigurationProvider in '..\Configurations.Json\JsonStreamConfigurationProvider.pas',
  JsonConfigurationFileParser in '..\Configurations.Json\JsonConfigurationFileParser.pas',
  FileSystemInfoHelper in '..\FileProviders.Physical\Internal\FileSystemInfoHelper.pas',
  PhysicalFileInfo in '..\FileProviders.Physical\PhysicalFileInfo.pas',
  NotFoundFileInfo in '..\FileProviders.Abstractions\NotFoundFileInfo.pas',
  ChangeToken.Intf in '..\Configuration\Intf\ChangeToken.Intf.pas',
  Configuration.Intf in '..\Configuration\Intf\Configuration.Intf.pas',
  ConfigurationBuilder.Intf in '..\Configuration\Intf\ConfigurationBuilder.Intf.pas',
  ConfigurationProvider.Intf in '..\Configuration\Intf\ConfigurationProvider.Intf.pas',
  ConfigurationRoot.Intf in '..\Configuration\Intf\ConfigurationRoot.Intf.pas',
  ConfigurationBuilder in '..\Configuration\ConfigurationBuilder.pas',
  ConfigurationProvider in '..\Configuration\ConfigurationProvider.pas',
  ConfigurationReloadToken in '..\Configuration\ConfigurationReloadToken.pas',
  ConfigurationRoot in '..\Configuration\ConfigurationRoot.pas',
  ConfigurationSection in '..\Configuration\ConfigurationSection.pas',
  StreamConfigurationProvider in '..\Configuration\StreamConfigurationProvider.pas',
  StreamConfigurationSource in '..\Configuration\StreamConfigurationSource.pas',
  ConfigurationHelper in '..\Configuration\Helpers\ConfigurationHelper.pas',
  ConfigurationPath in '..\Configuration\Helpers\ConfigurationPath.pas',
  ConfigurationRootHelper in '..\Configuration\Helpers\ConfigurationRootHelper.pas',
  EnumeratorHelper in '..\Configuration\Helpers\EnumeratorHelper.pas',
  FileConfigurationHelper in '..\Configuration\Helpers\FileConfigurationHelper.pas',
  InternalConfigurationRootExtensions in '..\Configuration\Helpers\InternalConfigurationRootExtensions.pas',
  IniConfigurationHelper in '..\Configuration.Ini\IniConfigurationHelper.pas',
  IniStreamConfigurationSource in '..\Configuration.Ini\IniStreamConfigurationSource.pas',
  IniConfigurationSource in '..\Configuration.Ini\IniConfigurationSource.pas',
  IniConfigurationProvider in '..\Configuration.Ini\IniConfigurationProvider.pas',
  IniStreamConfigurationProvider in '..\Configuration.Ini\IniStreamConfigurationProvider.pas',
  EnvironmentVariablesConfigurationProvider in '..\Configuration.EnvironmentVariables\EnvironmentVariablesConfigurationProvider.pas',
  EnvironmentVariablesConfigurationSource in '..\Configuration.EnvironmentVariables\EnvironmentVariablesConfigurationSource.pas',
  EnvironmentVariablesHelper in '..\Configuration.EnvironmentVariables\EnvironmentVariablesHelper.pas';

function BuildConfig: IConfigurationRoot;
var
  configBuilder: IConfigurationBuilder;
begin
  configBuilder := TConfigurationBuilder.Create;
  TFileConfigurationHelper.SetBasePath(configBuilder, ExtractFilePath(ParamStr(0)));
  TJsonConfigurationHelper.AddJsonFile(configBuilder, 'appsettings.json', false, true);
  TIniConfigurationHelper.AddIniFile(configBuilder, 'appsettings.ini', false, true);
  TEnvironmentVariablesHelper.AddEnvironmentVariables(configBuilder);
  TEnvironmentVariablesHelper.AddEnvironmentVariables(configBuilder, 'ARK');

  Result := configBuilder.Build;
end;

var
  config: IConfigurationRoot;
  section: IConfigurationSection;
  dict: IDictionary<string,string>;
  item: TPair<string,string>;
begin
  try
    dict := TEnvironment.GetEnvironmentVariables();

    for item in dict do
    begin
      Writeln(item.Key + ' = ' + item.Value);
    end;

    config := BuildConfig();
    section := config.GetSection('Logging:LogLevel:Default');
    Writeln(section.Value);
    section := config.GetSection('Section1:Key3');
    Writeln(section.Value);

    Readln;

    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

