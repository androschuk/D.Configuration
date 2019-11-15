# D.Configuration
D.Configuration is a framework for accessing Key/Value based configuration settings in an application. 
Includes configuration providers for environment variables, INI files, JSON files, and XML files.

The basic idea is taken from [.NET APIs configuration utilities](https://github.com/aspnet/Extensions)

### Example
```pascal
function BuildConfig: IConfigurationRoot;
var
  configBuilder: IConfigurationBuilder;
begin
  configBuilder := TConfigurationBuilder.Create;
  TFileConfigurationHelper.SetBasePath(configBuilder, ExtractFilePath(ParamStr(0)));
  // Add json configuration file
  TJsonConfigurationHelper.AddJsonFile(configBuilder, 'appsettings.json', false, true);
  // Add ini configuration file
  TIniConfigurationHelper.AddIniFile(configBuilder, 'appsettings.ini', false, true);
  
  // Add all Environment Variables
  TEnvironmentVariablesHelper.AddEnvironmentVariables(configBuilder);
  
  // Add filtered Environment Variables
  TEnvironmentVariablesHelper.AddEnvironmentVariables(configBuilder, 'CUSTOM');

  Result := configBuilder.Build;
end;

var
  config: IConfigurationRoot;
  section: IConfigurationSection;
begin
    // Prepare build configuration
    config := BuildConfig();
    
    // get data from json
    section := config.GetSection('Logging:LogLevel:Default');
    Writeln(section.Value);
    
    // get data from ini
    section := config.GetSection('Section1:Key3');
    Writeln(section.Value);

    // get data Environment Variables 
    section := config.GetSection('Path');
    Writeln(section.Value);

    Readln;
end;
```
