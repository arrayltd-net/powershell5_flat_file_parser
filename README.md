# powershell5_flat_file_parser
If file contains multiple records with headings and unique values in a defined location, split each record to separate file and make file name equal to the unique value

Records that no unique identifier will be stored in a temp directory with a #.extension name.

Temp directory is removed on every run.

Records that have identical unique identifiers within it will not work right -not a handled situation. The most recent read record will overwrite the earlier record

Script has 2x 10 second delays to allow filereader stream to close.  So the script takes about 20 seconds to run.



