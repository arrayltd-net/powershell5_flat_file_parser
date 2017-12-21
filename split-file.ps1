Function Split-File{


 Param(
    [Parameter(Mandatory=$true,
            HelpMessage="Enter the string that will be identify the unique string: -WP, -EP, ... The returned
            field will be used as the file name")]
            [Alias('facility')]
            [string] $unique_string,
    [Parameter(Mandatory=$true,
           HelpMessage = "Enter the element of line that will be used to name each file after
           it has been split. It also needs to be unique within
           the source file. The elements are space delimited so you can't have spaces in this field")]
            [string] $unique_element,
    [Parameter(Mandatory=$true,
           HelpMessage = "This is the output folder. Must include trailing backslash")]
            [string] $rootname,
    [Parameter(Mandatory=$true,
           HelpMessage = "This is the complete path of the input file.")]
            [string] $inputfile,                 
    [Parameter(
           HelpMessage = "This is the extension of the output file to use")]
            [string] $ext="txt",
    [Parameter(
           HelpMessage = "The file will split on this string")]
            [string] $SplitFileString                 
            
            
            
)
    #open the input file
    $reader = new-object System.IO.StreamReader("$inputfile")
    $count = 0
    $listoffiles = @()

    $unique_element = $unique_element
    $unique_string = $unique_string

    
    $fileName = "{0}{1}.{2}" -f ($rootName, $count, $ext)
    
    #read file and output to a file name, splitting on the $unique_string
    while(($line = $reader.ReadLine()) -ne $null)

    {
        if($line -notmatch "$splitfilestring"){
           $line |out-file -append $filename
           
        }
        
        if($line -match "$splitfilestring"){
           $fileName = "{0}{1}.{2}" -f ($rootName, $count, $ext)
           $line |out-file $fileName
           $listoffiles +=$filename
           $count++     
        }
       
    }

    $reader.Close()

    #wait for reader to close
    Start-Sleep -Milliseconds 2000

    #read each file and build a hash table - filename:unique_element
    $namepath_ht = @{}
    foreach($file in $listoffiles){
        $reader = new-object System.IO.StreamReader($file)
        
        while(($line = $reader.readline()) -ne $null){
            $eachline = $line -split '\s+'
            
            if($eachline[$unique_element] -match $unique_string){
                $namepath_ht.set_item([string]$file, $eachline[$unique_element])
                
            }
            
            
        }
    }    
    $reader.close()

    #wait for reader to close
    Start-Sleep -Milliseconds 2000 

    foreach($kvp in $namepath_ht.GetEnumerator())
    {
        $destination = $kvp.value
        $source = $kvp.key
        $source
        $destination
        try{
            Move-Item -path $source -Destination $("{0}{1}.{2}" -f ($rootName, $destination, $ext)) -force
        }
        catch{}
    }


}
