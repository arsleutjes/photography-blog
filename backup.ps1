$source = 'D:\'
$destination = 'E:\'
$logFileName = 'robocopy.log'
$logFilePath = Join-Path $source $logFileName

$mainArgs = @(
  $source                        # Source root
  $destination                   # Destination root
  '/E'                           # Copy subdirectories, including empty ones
  '/L'                           # Dry-run (list only, no file changes)
  '/XD'                          # Exclude directories (next entries)
  'D:\$RECYCLE.BIN'              # Exclude Windows recycle bin
  'D:\System Volume Information' # Exclude Windows system metadata folder
  '/XF'                          # Exclude files (next entry)
  $logFilePath                   # Exclude log file from main copy
  '/LOG+:' + $logFilePath        # Append output to log file
)

& robocopy @mainArgs
if ($LASTEXITCODE -ge 8) {
  throw "robocopy main pass failed with exit code $LASTEXITCODE"
}

$logCopyArgs = @(
  $source      # Source for log file
  $destination # Destination for log file
  $logFileName # File to copy
  '/L'         # Dry-run (list only)
)

& robocopy @logCopyArgs
if ($LASTEXITCODE -ge 8) {
  throw "robocopy log pass failed with exit code $LASTEXITCODE"
}
