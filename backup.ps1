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
  '/COPY:DAT'                    # Copy data, attributes, and timestamps only
  '/XD'                          # Exclude directories (next entries)
  $recycleBinPath                # Exclude Windows recycle bin
  $systemVolumeInfoPath          # Exclude Windows system metadata folder
  '/XF'                          # Exclude files (next entry)
  $logFilePath                   # Exclude log file from main copy
  '/TEE'                         # Write output to console and log file
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
  '/COPY:DAT'  # Copy data, attributes, and timestamps only
  '/TEE'       # Write output to console and log file
)

& robocopy @logCopyArgs
if ($LASTEXITCODE -ge 8) {
  throw "robocopy log pass failed with exit code $LASTEXITCODE"
}
