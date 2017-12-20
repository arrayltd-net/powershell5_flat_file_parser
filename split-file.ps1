Function Split-File{

    [cmdletbinding()]
    Param(
    [Parameter(Mandatory=$true,
            HelpMessage="Enter the string that will be identify the unique string: -WP, -EP, ... The returned
            field will be used as the file name")]
            [Alias('facility')]
            [string] $UniqueStringToSearchAndNameFile,
    [Parameter(Mandatory=$true,
            HelpMessage="Enter the path to the file that needs to be split")]
            [string] $InputFile,
    [Parameter(
            HelpMessage="Remove files that don't have a UniqueStringToSearchAndNameFile")]
            [string] $RemoveEmptyFiles = $false,
    [Parameter(Mandatory=$true,
            HelpMessage="Enter string to split files upon finding.")]
            [string] $SplitFileString,
    [Parameter(Mandatory=$true,
            HelpMessage="Enter folder path to store output files. e.g. c:\output or c:\output\")]
            [string] $outputpath,
    [Parameter(Mandatory=$true,
            HelpMessage="Enter folder path to store output files. e.g. c:\output or c:\output\")]
            [string] $SplitFileOnUniqueString = $true,
    [Parameter(Mandatory=$true,
            HelpMessage="Enter folder path to store output files. e.g. c:\output or c:\output\")]
            [string] $ElementOfUniqueStringToSearchAndNameFile

                   
                    
    )


    $contents = get-content $InputFile
    write-host $contents
    $count = -1
    $locationcount = 0


    #split file into files with names 0, 1, 2...
    foreach ($line in $contents){

    #create files with numbers as file names.
       
       if($line -match ($SplitFileString)) {
            $count ++
            $line |out-file (join-path -Path $outputpath -ChildPath $([string]$count))
       }
       
       else{
      
       $line |out-file -append (join-path -Path $outputpath -ChildPath $([string]$count))
       }
    }
   
   #One imperfection in this program is if there isn't a match to $splitfileon string
   #at the beginning of the file, it will write a file called -1 and leave it. This removes that file
   try{
    Remove-Item (join-path -Path $outputpath -ChildPath "-1" -ErrorAction Silentlycontinue)
   }
  catch{}  

    
  

    #rename each file to match the location which is defined as being
    
    #located at the first element of the line and ending with -WP
    
    
    
        #get all files and put into array to enable searching
        [array]$files = @()
        for($i = 0; $i -le $count; $i++){
          $files += (join-path -Path $outputpath -ChildPath $i)
        }
       
        
    
        foreach($file in $files){
            
            $linecount = 0   #used to locate the line number the location is found in
            $location = "" # used to store the line number of the UniqueStringToSearchAndNameFile if it's found
           
            $filecontent = Get-Content $file
          
            foreach($line in $filecontent){
                $linearray = $line -split '\s+' 

                    if($linearray[$ElementOfUniqueStringToSearchAndNameFile] -match ("$UniqueStringToSearchAndNameFile")){
                        $locationcount++
                       
                        $foundlocation = $linearray[$linecount]
                        $location = $filecontent |select -Index $linecount
                        
                        $joinedoutputfile = Join-Path -Path $outputpath -ChildPath $([string]$location + ".txt")
                     
                        #rename-Item -Path $([string]$file) -NewName  $([string]$location)
                        try{
                            Move-Item -path  $([string]$file) -Destination (Join-Path -Path $outputpath -ChildPath $([string]$location + ".txt")) -force
                        }
                        catch{}
                    }
                $linecount++
            }
            
                #Remove files that only have no UniqueStringToSearchAndName.
                if (($locationcount -eq 0) -and ($RemoveEmptyFiles -eq $true)){
                  Remove-Item -Path $file
              }
              
              
              
        }
        
        
        
   

"Number of Unique Records Found: " + $locationcount | out-file -force (Join-Path -Path $outputpath -ChildPath _output_summary.txt)


}
