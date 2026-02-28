# Workflow

## Drive organization

- `C:` Fast SSD (500 GB), used for OS/apps.
- `D:` Data drive (4 TB HDD).
- `E:` Backup drive (4 TB HDD).
- Do not manually edit backup contents on `E:`.

## Project folders

### New pictures
- Create one folder per project in `D:/Pictures/Raw/`.
- Use this naming format: `yyyy-mm-dd-Project_Name`.

### New videos
- Create one folder per project in `D:/Videos/Raw/`.
- Use this naming format: `yyyy-mm-dd-Project_Name`.

## Adobe Lightroom Classic

### Catalog and files
- Keep the Lightroom catalog (`.lrcat`) and previews (`*.lrdata`) on `C:`.
- Keep photo source files in `D:/Pictures/Raw/` using the project naming format above.
- `E:` is the backup copy of `D:` images via `backup.ps1`.

### Import workflow
- In Lightroom Classic Import, use `D:\Pictures\Raw` as the destination.

### Lightroom Sync setting
- Important: In `Edit > Preferences > Lightroom Sync`, under `Location`, set `Specify location for Lightroom's Synced images` to `D:\Pictures\Raw`.

### Metadata and backups
- Enable writing metadata changes to XMP in Lightroom Classic Catalog Settings.
- In `Catalog Settings > Backups`, set `Backup Folder` to `D:\Pictures\Lightroom\Backups`.
- In `Catalog Settings > Backups`, set `Back up catalog` to `Every time Lightroom exits`.
- The live catalog stays on `C:`; these catalog backups on `D:` are included in the monthly `backup.ps1` run.

## Monthly backup

1. Connect and verify `E:` is available.
2. Run the backup script:

   ```powershell
   pwsh ./backup.ps1
   ```

3. Review console output for errors.
4. Optional: check the generated log on `D:` for troubleshooting (file name format: `robocopy-yyyy-MM-ddTHH-mm-ss.log`).
