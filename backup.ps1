$source = 'D:\'
$destination = 'E:\'

$timestamp = Get-Date -Format 'yyyy-MM-ddTHH-mm-ss'
$logFileName = "robocopy-$timestamp.log"
$logFilePath = Join-Path $source $logFileName

$recycleBinPath = Join-Path $source '$RECYCLE.BIN'
$systemVolumeInfoPath = Join-Path $source 'System Volume Information'

$mainArgs = @(
  $source                        # Source root
  $destination                   # Destination root
  '/E'                           # Copy subdirectories, including empty ones
  '/COPYALL'                     # Copy all file info (data, attrs, timestamps, ACL, owner, audit)
  '/L'                           # Dry-run (list only, no file changes)
  '/XD'                          # Exclude directories (next entries)
  $recycleBinPath                # Exclude Windows recycle bin
  $systemVolumeInfoPath          # Exclude Windows system metadata folder
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
