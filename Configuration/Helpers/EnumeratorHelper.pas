unit EnumeratorHelper;

interface

uses
  System.SysUtils, System.Generics.Collections;

type
  TFunc<TAccumulate, TSource> = reference to function(accumulate: TAccumulate; source: TSource):TAccumulate;


  TEnumeratorHelper = class
  public
    class function Any<TSource>(source: IEnumerable<TSource>): Boolean;
    class function Reverse<TSource>(source: IEnumerable<TSource>): IEnumerable<TSource>;
    class function ReverseIterator<TSource>(source: IEnumerable<TSource>): IEnumerable<TSource>;
    class function Empty<TResult>(): IEnumerable<TResult>;
    class function Aggregate<TSource, TAccumulate>(source: IEnumerable<TSource>; seed: TAccumulate; func: TFunc<TAccumulate, TSource>): TAccumulate;
  end;


  //TODO: check it
  // We have added some optimization in SZArrayHelper class to cache the enumerator of zero length arrays so
  // the enumerator will be created once per type.
  TEmptyEnumerable<TElement> = class
  public
     class function Instance : IEnumerable<TElement>;
  end;

  TEmptyEnumerator<TElement> = class(TInterfacedObject, IEnumerator, IEnumerator<TElement>)
  private
    class var FInstance: IEnumerator;
  protected
    function GetTypedEnum: TElement;
  public
    class function Instance: IEnumerator;
    //IEnumerator
    function GetCurrent: TObject;
    function MoveNext: Boolean;
    procedure Reset;

    //IEnumerator<T>
    function IEnumerator<TElement>.GetCurrent = GetTypedEnum;
  end;


implementation

{ TEnumeratorHelper }

class function TEnumeratorHelper.Aggregate<TSource, TAccumulate>(source: IEnumerable<TSource>; seed: TAccumulate; func: TFunc<TAccumulate, TSource>): TAccumulate;
var
  res: TAccumulate;
  element: TSource;
begin
  if not Assigned(source) then
    raise EArgumentException.Create('source');

  if not Assigned(func) then
    raise EArgumentException.Create('func');

  res := seed;

  for element in source do
    res := func(res, element);

  Result := res;
end;

class function TEnumeratorHelper.Any<TSource>(source: IEnumerable<TSource>): Boolean;
var
  enum: IEnumerator<TSource>;
begin
  if (Not Assigned(source)) then
    raise EArgumentNilException.Create('source');

  enum := source.GetEnumerator; // TODO: check memory leak
  Result := enum.MoveNext;
end;

class function TEnumeratorHelper.Empty<TResult>: IEnumerable<TResult>;
begin
  Result := TEmptyEnumerable<TResult>.Instance;
end;

class function TEnumeratorHelper.Reverse<TSource>(source: IEnumerable<TSource>): IEnumerable<TSource>;
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

class function TEmptyEnumerable<TElement>.Instance: IEnumerable<TElement>;
begin
  //TODO: not implemented;
  raise ENotImplemented.Create('TEmptyEnumerable<TElement>.Instance');
end;



{ TEmptyEnumerator<TElement> }

function TEmptyEnumerator<TElement>.GetCurrent: TObject;
begin
  Result := TObject(TEmptyEnumerator<TElement>.Instance);
end;

//function TEmptyEnumerator<TElement>.GetEnumeratorTyped: IEnumerator<TElement>;
//begin
//  Result := TEmptyEnumerator<TElement>.Instance;
//end;

function TEmptyEnumerator<TElement>.GetTypedEnum: TElement;
begin
  Result := default(TElement);
end;

class function TEmptyEnumerator<TElement>.Instance: IEnumerator;
begin
  if FInstance = Nil then
    FInstance := TEmptyEnumerator<TElement>.Create;

  Result := FInstance;
end;

function TEmptyEnumerator<TElement>.MoveNext: Boolean;
begin
  // Do nothing
end;

procedure TEmptyEnumerator<TElement>.Reset;
begin
  // Do nothing
end;

end.
