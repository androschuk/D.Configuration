unit ExclusionFilters;

interface

type
  /// <summary>
  /// Specifies filtering behavior for files or directories.
  /// </summary>
  TExclusionFilters = (
        /// <summary>
        /// Exclude files and directories when the name begins with period.
        /// </summary>
        DotPrefixed = 1,

        /// <summary>
        /// Exclude files and directories when <see cref="FileAttributes.Hidden"/> is set on <see cref="FileSystemInfo.Attributes"/>.
        /// </summary>
        Hidden = 2,

        /// <summary>
        /// Exclude files and directories when <see cref="FileAttributes.System"/> is set on <see cref="FileSystemInfo.Attributes"/>.
        /// </summary>
        IsSystem = 4,

        /// <summary>
        /// Do not exclude any files.
        /// </summary>
        None = 0
  );

  TExclusionFilterSet = set of TExclusionFilters;


  TExclusionFiltersHelper = record helper for TExclusionFilters
  public
    function isSensitive : Boolean;
  end;

var
  /// <summary>
  /// Equivalent to <c>DotPrefixed | Hidden | System</c>. Exclude files and directories when the name begins with a period, or has either <see cref="FileAttributes.Hidden"/> or <see cref="FileAttributes.System"/> is set on <see cref="FileSystemInfo.Attributes"/>.
  /// </summary>
  TExclusionFiltersSensitive : array of TExclusionFilters = [TExclusionFilters.DotPrefixed, TExclusionFilters.Hidden, TExclusionFilters.IsSystem];
  TExclusionFiltersSet : set of TExclusionFilters = [TExclusionFilters.DotPrefixed, TExclusionFilters.Hidden, TExclusionFilters.IsSystem];

implementation

{ TExclusionFiltersHelper }

function TExclusionFiltersHelper.isSensitive: Boolean;
begin
  Result := Self in [TExclusionFilters.DotPrefixed, TExclusionFilters.Hidden, TExclusionFilters.IsSystem];
end;

end.
