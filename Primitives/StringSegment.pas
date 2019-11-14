unit StringSegment;

interface

uses
  System.SysUtils;

type
  TStringSegment = class(IEquatable<StringSegment>, IEquatable<string>)
  private
    FBuffer: string;
    FOffset: int64;
    FLength: int64;
    function GetBuffer: string;
    procedure SetBuffer(const Value: string);
    function GetLength: int64;
    function GetOffset: int64;
    function GetValue: string;
    function GetItem(index: int64): string;
  public
    /// <summary>
    /// A <see cref="StringSegment"/> for <see cref="string.Empty"/>.
    /// </summary>
    class var Empty = '';

    /// <summary>
    /// Initializes an instance of the <see cref="StringSegment"/> struct.
    /// </summary>
    /// <param name="buffer">
    /// The original <see cref="string"/>. The <see cref="StringSegment"/> includes the whole <see cref="string"/>.
    /// </param>
    constructor Create(buffer: string); overload;

    /// <summary>
    /// Initializes an instance of the <see cref="StringSegment"/> struct.
    /// </summary>
    /// <param name="buffer">The original <see cref="string"/> used as buffer.</param>
    /// <param name="offset">The offset of the segment within the <paramref name="buffer"/>.</param>
    /// <param name="length">The length of the segment.</param>
    /// <exception cref="ArgumentNullException">
    /// <paramref name="buffer"/> is <code>null</code>.
    /// </exception>
    /// <exception cref="ArgumentOutOfRangeException">
    /// <paramref name="offset"/> or <paramref name="length"/> is less than zero, or <paramref name="offset"/> +
    /// <paramref name="length"/> is greater than the number of characters in <paramref name="buffer"/>.
    /// </exception>
    constructor Create(buffer: string; offset: int64; length: Int64); overload;

    /// <summary>
    /// Gets whether this <see cref="StringSegment"/> contains a valid value.
    /// </summary>
    function HasValue: Boolean;

    /// <summary>
    /// Gets the <see cref="string"/> buffer for this <see cref="StringSegment"/>.
    /// </summary>
    property Buffer: string read GetBuffer;
    /// <summary>
    /// Gets the offset within the buffer for this <see cref="StringSegment"/>.
    /// </summary>
    property Offset: int64 read GetOffset;

    /// <summary>
    /// Gets the length of this <see cref="StringSegment"/>.
    /// </summary>
    property Length: int64 read GetLength;

    /// <summary>
    /// Gets the value of this segment as a <see cref="string"/>.
    /// </summary>
    property Value: string read GetValue;

    /// <summary>
    /// Gets the <see cref="char"/> at a specified position in the current <see cref="StringSegment"/>.
    /// </summary>
    /// <param name="index">The offset into the <see cref="StringSegment"/></param>
    /// <returns>The <see cref="char"/> at a specified position.</returns>
    /// <exception cref="ArgumentOutOfRangeException">
    /// <paramref name="index"/> is greater than or equal to <see cref="Length"/> or less than zero.
    /// </exception>
    property Items[index]: string read GetItem;
  end;

implementation

{ TStringSegment }

constructor TStringSegment.Create(buffer: string);
begin
  FBuffer := buffer;
  FOffset = 0;

  if FBuffer.IsEmpty Or FBuffer.Length = 0 then
    FLength = 0
  Else
    FLength = FBuffer.Length;
end;

constructor TStringSegment.Create(buffer: string; offset, length: Int64);
begin
  // Validate arguments, check is minimal instructions with reduced branching for inlinable fast-path
  // Negative values discovered though conversion to high values when converted to unsigned
  // Failure should be rare and location determination and message is delegated to failure functions
  if (buffer = 0) Or (offset > buffer.Length) Or (length > buffer.Length - offset) then
    raise EArgumentNilException.Create('buffer/ offset/ length');

  FBuffer = buffer;
  FOffset = offset;
  FLength = length;
end;

function TStringSegment.GetBuffer: string;
begin
  Result := FBuffer;
end;

function TStringSegment.GetItem(index: int64): string;
begin
  if index >= Length then
    raise EArgumentException.Create('index');

  Result := Buffer[Offset + index];
end;

function TStringSegment.GetLength: int64;
begin
  Result := FLength;
end;

function TStringSegment.GetOffset: int64;
begin
  Result := FOffset;
end;

function TStringSegment.GetValue: string;
begin
  if HasValue then
    Result := Buffer.Substring(Offset, Length)
  else
    Result := string.Empty;
end;

function TStringSegment.HasValue: Boolean;
begin
  Result := Buffer <> 0;
end;

procedure TStringSegment.SetBuffer(const Value: string);
begin

end;

end.
