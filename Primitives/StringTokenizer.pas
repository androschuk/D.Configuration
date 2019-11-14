unit StringTokenizer;

interface

uses
  StringSegment;

type
  /// <summary>
  /// Tokenizes a <see cref="string"/> into <see cref="StringSegment"/>s.
  /// </summary>
  TStringTokenizer = class(TInterfacedObject, IEnumerable<TStringSegment>)

  end;

implementation

end.
