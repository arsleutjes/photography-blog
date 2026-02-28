# Workflow

## Project folders

### New pictures
- Create one folder per project in `D:/Pictures/Raw/`.
- Use this naming format: `yyyy-mm-dd-Project_Name`.

### New videos
- Create one folder per project in `D:/Videos/Raw/`.
- Use this naming format: `yyyy-mm-dd-Project_Name`.

## Drive organization

- `D:` Data / Primary drive.
- `E:` Backup drive.
- Do not manually edit backup contents on `E:`.

## Monthly backup

1. Connect and verify `E:` is available.
2. Run the backup script:

   ```powershell
   pwsh ./backup.ps1
   ```

3. Review console output for errors.
4. Check the generated log on `D:` (file name format: `robocopy-yyyy-MM-ddTHH-mm-ss.log`).
