unit JsonConfigurationFileParser;

interface

uses
  System.Generics.Collections, System.SysUtils, System.Classes, System.JSON,
  ConfigurationPath, System.Generics.Dictionary, System.Generics.Defaults, EnumeratorHelper;

type
  TJsonConfigurationFileParser = class
  private
    FData: IDictionary<string,string>;
    FContext: TStack<string>;
    FCurrentPath: string;

    function ParseStream(input: TStream): IDictionary<string, string>;

    procedure VisitElement(elements: TJSONObject);
    procedure VisitValue(value: TJSONValue);

    procedure EnterContext(context: string);
    procedure ExitContext;
  public
    /// <summar>
    /// Initialize a new <see cref="TJsonConfigurationFileParser"/>
    /// </summar>
    constructor Create;
    destructor Destroy; override;

    class function Parse(input: TStream): IDictionary<string,string>;
  end;

implementation

{ TJsonConfigurationFileParser }

constructor TJsonConfigurationFileParser.Create;
begin
  FData := System.Generics.Dictionary.TDictionary<string, string>.Create(TIStringComparer.Ordinal);
  FContext := TStack<string>.Create;
end;

destructor TJsonConfigurationFileParser.Destroy;
begin
  FreeAndNil(FContext);

  inherited;
end;

procedure TJsonConfigurationFileParser.EnterContext(context: string);
begin
  FContext.Push(context);
  FCurrentPath := TConfigurationPath.Combine(FContext);
end;

procedure TJsonConfigurationFileParser.ExitContext;
begin
  FContext.Pop;
  FCurrentPath := TConfigurationPath.Combine(FContext);
end;

class function TJsonConfigurationFileParser.Parse(input: TStream): IDictionary<string, string>;
var
  parser : TJsonConfigurationFileParser;
begin
  parser := TJsonConfigurationFileParser.Create;
  try
    Result := parser.ParseStream(input);
  finally
    FreeAndNil(parser);
  end;
end;

function TJsonConfigurationFileParser.ParseStream(input: TStream): IDictionary<string, string>;
var
  jsonObj: TJSONObject;
  jsonStream: TBytesStream;
  jsonValue: TJSONValue;
begin
  FData.Clear;

  jsonStream := TBytesStream.Create;
  try
    input.Seek(0, TSeekOrigin.soBeginning);

    jsonStream.LoadFromStream(input);
    jsonStream.Seek(0, TSeekOrigin.soBeginning);

    jsonValue := TJSONObject.ParseJSONValue(jsonStream.Bytes, 0, jsonStream.Size);

    if Not (jsonValue is TJSONObject) then
      raise EInvalidOperation.CreateFmt('Unsupported Json token', [jsonValue.ClassName]);

    jsonObj := jsonValue as TJSONObject;

    VisitElement(jsonObj);
  finally
    FreeAndNil(jsonStream);
  end;

  Result := FData;
end;

procedure TJsonConfigurationFileParser.VisitElement(elements: TJSONObject);
var
  element: TJSONPair;
  name: string;
begin
  for element in elements do
  begin
    name := element.JsonString.Value;
    EnterContext(name);
    VisitValue(elements.Values[name]);
    ExitContext();
  end;
end;

procedure TJsonConfigurationFileParser.VisitValue(value: TJSONValue);
var
  index: Integer;
  arrayElement: TJSONValue;
  key: string;
begin
  if value is TJsonObject then
  begin
     VisitElement(value as TJsonObject);
  end
  else
  if value is TJSONArray then
  begin
    index := 0;
    for arrayElement in value.AsType<TJSONArray> do
    begin
      EnterContext(index.ToString);
      VisitValue(arrayElement);
      ExitContext;
      Inc(index);
    end;
  end
  else
  if (value is TJSONNumber) Or
    (value is TJSONString) Or
    (value is TJSONTrue) Or
    (value is TJSONFalse) Or
    (value is TJSONNull) then
  begin
     key := FCurrentPath;

     if FData.ContainsKey(key) then
       raise Exception.CreateFmt('Key %s is duplicated', [key]);

     FData.Add(key, value.ToString);
  end
  else
    raise Exception.CreateFmt('Unsupported Json Token %s', [value.ClassName]);
end;

end.
