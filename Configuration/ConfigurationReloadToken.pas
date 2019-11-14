unit ConfigurationReloadToken;

interface

uses
  ChangeToken.Intf;

type
  TConfigurationReloadToken = class(TInterfacedObject, IChangeToken)
  public
    procedure OnReload;
  end;

implementation

{ TConfigurationReloadToken }

procedure TConfigurationReloadToken.OnReload;
begin
  //TODO: need implement ConfigurationReloadToken;
end;

end.
