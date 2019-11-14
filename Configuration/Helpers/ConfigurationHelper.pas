unit ConfigurationHelper;

interface

uses
  ConfigurationBuilder.Intf, Configuration.Intf, System.Rtti, System.SysUtils,
  Generics.Collections, System.Math;


type
  TConfigurationHelper = class
  public
    /// <summary>
    /// Adds a new configuration source.
    /// </summary>
    /// <param name="builder">The <see cref="IConfigurationBuilder"/> to add to.</param>
    /// <param name="configureSource">Configures the source secrets.</param>
    /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
    class function Add<TSource : IConfigurationSource>(builder: IConfigurationBuilder; configurationSource: TProc<TSource>):IConfigurationBuilder;

    /// <summary>
    /// Shorthand for GetSection("ConnectionStrings")[name].
    /// </summary>
    /// <param name="configuration">The configuration.</param>
    /// <param name="name">The connection string key.</param>
    /// <returns></returns>
    class function GetConnectionString(configuration: IConfiguration; name: string): string;

    /// <summary>
    /// Get the enumeration of key value pairs within the <see cref="IConfiguration" />
    /// </summary>
    /// <param name="configuration">The <see cref="IConfiguration"/> to enumerate.</param>
    /// <returns>An enumeration of key value pairs.</returns>
    class function AsEnumerable(configuration: IConfiguration): TEnumerable<TPair<string, string>>; overload;

    /// <summary>
    /// Get the enumeration of key value pairs within the <see cref="IConfiguration" />
    /// </summary>
    /// <param name="configuration">The <see cref="IConfiguration"/> to enumerate.</param>
    /// <param name="makePathsRelative">If true, the child keys returned will have the current configuration's Path trimmed from the front.</param>
    /// <returns>An enumeration of key value pairs.</returns>
    class function AsEnumerable(configuration: IConfiguration; makePathsRelative : Boolean): TEnumerable<TPair<string, string>>; overload;

    /// <summary>
    /// Determines whether the section has a <see cref="IConfigurationSection.Value"/> or has children
    /// </summary>
    class function Exists(section: IConfigurationSection): Boolean;
  end;

  //TODO: Move to generic library
  TGenericHelper = class
  public
    class function CreateInstanse<T>: T;
  end;

  TEnumeratorHelper = class
  public
    class function Any<TSource>(source: IEnumerable<TSource>): Boolean;
    class function Reverse<TSource>(source: IEnumerable<TSource>): IEnumerable<TSource>;
    class function ReverseIterator<TSource>(source: IEnumerable<TSource>): IEnumerable<TSource>;
    //class function Empty<TResult>(): IEnumerable<TResult>;
  end;


  // We have added some optimization in SZArrayHelper class to cache the enumerator of zero length arrays so
  // the enumerator will be created once per type.
//  TEmptyEnumerable<TElement> = class
//  public
//     function Instance : TArray<TElement>;
//  end;

implementation

{ TConfigurationHelper }

class function TConfigurationHelper.Add<TSource>(builder: IConfigurationBuilder; configurationSource: TProc<TSource>): IConfigurationBuilder;
var
  source: TSource;
begin
  source := TGenericHelper.CreateInstanse<TSource>();

  if Assigned(configurationSource) then
    configurationSource(source);
  builder.Add(source);
end;

{ TConfigurationHelper }

class function TConfigurationHelper.AsEnumerable(configuration: IConfiguration;  makePathsRelative: Boolean): TEnumerable<TPair<string, string>>;
var
  stack : TStack<IConfiguration>;
  rootSection : IConfigurationSection;
  prefixLength: Integer;
  config : IConfiguration;
  section: IConfigurationSection;
//  pair: TPair<string,string>;
  list: TList<TPair<string, string>>;
  child: IConfigurationSection;
begin
  list := TList<TPair<string, string>>.Create;

  stack := TStack<IConfiguration>.Create();
  stack.Push(configuration);

  rootSection := configuration as IConfigurationSection;
  prefixLength := IfThen((makePathsRelative And Assigned(rootSection)), rootSection.Path.Length + 1 , 0);
  while (stack.Count > 0) do
  begin
    config := stack.Pop();
    // Don't include the sections value if we are removing paths, since it will be an empty key
    section := (config as IConfigurationSection);
    if (Assigned(section) And (Not makePathsRelative Or (config <> configuration))) then
    begin
      list.Add(TPair<string, string>.Create(section.Path.Substring(prefixLength), section.Value))
    end;

    for child in config.GetChildren do
    begin
        stack.Push(child);
    end;
  end;

  result := list;
end;

class function TConfigurationHelper.Exists(section: IConfigurationSection): Boolean;
begin
  if Not Assigned(section) then
    Exit(false);

  Result := Not section.Value.IsEmpty Or TEnumeratorHelper.Any<IConfigurationSection>(section.GetChildren);
end;

class function TConfigurationHelper.AsEnumerable(configuration: IConfiguration): TEnumerable<TPair<string, string>>;
begin
  Result := AsEnumerable(configuration, false);
end;

class function TConfigurationHelper.GetConnectionString(configuration: IConfiguration; name: string): string;
var
  section: IConfigurationSection;
begin
  Result := string.Empty;
  if Assigned(configuration) then
    section := configuration.GetSection('ConnectionStrings');
    if Assigned(section) then
      Result := section[name];
end;

{ TGenericHelper }

class function TGenericHelper.CreateInstanse<T>: T;
var
  ctx: TRttiContext;
  rType : TRttiType;
  method: TRttiMethod;
  instanceType: TRttiInstanceType;
  value: TValue;
  v1,v2: Boolean;
begin
  ctx := TRttiContext.Create;
  try
    rType := ctx.GetType(TypeInfo(T));

    for method in rType.GetMethods do
      begin
        if (method.IsConstructor) and (Length(method.GetParameters) = 0) then
        begin
          instanceType := rType.AsInstance;
          value := method.Invoke(instanceType.MetaclassType, []);

          Result := value.AsType<T>;

          Exit;
        end;
      end;

      raise EArgumentException.Create('Constructor');
  finally
    ctx.Free;
  end;
end;

{ TEnumeratorHelper }

class function TEnumeratorHelper.Any<TSource>(source: IEnumerable<TSource>): Boolean;
var
  enum: IEnumerator<TSource>;
begin
  if (Not Assigned(source)) then
    raise EArgumentNilException.Create('source');

  enum := source.GetEnumerator; // TODO: check memory leak
  Result := enum.MoveNext;
end;

//class function TEnumeratorHelper.Empty<TResult>: IEnumerable<TResult>;
//begin
//  Result := TEmptyEnumerable<TResult>.Instance;
//end;

class function TEnumeratorHelper.Reverse<TSource>(
  source: IEnumerable<TSource>): IEnumerable<TSource>;
begin
  if (Not Assigned(source)) then
    raise EArgumentNilException.Create('source');

  Result := ReverseIterator<TSource>(source);
end;

class function TEnumeratorHelper.ReverseIterator<TSource>(
  source: IEnumerable<TSource>): IEnumerable<TSource>;
var
  buffer : TArray<TSource>;
begin
  raise ENotImplemented.Create('ReverseIterator');
//  buffer :=  TArray<TSource>.Create(source);
//  for (int i = buffer.count - 1; i >= 0; i--)
//  yield return buffer.items[i];
end;

{ TEmptyEnumerable<TElement> }

//function TEmptyEnumerable<TElement>.Instance: TArray<TElement>;
//begin
//  Result := TArray.Create;
//end;

end.
