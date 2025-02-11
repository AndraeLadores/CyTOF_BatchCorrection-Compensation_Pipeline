## This is an R script to easily streamline the batch correction and compensation part of CyTOF analysis 

By Andrae "Dodge"" Ladores from UCSF's Spitzer Lab, created on 02/11/2025. 
This was originally pulled from: https://github.com/sguldberg/pipelines/tree/main on 1/2/2025.
But it is altered to cater towards solely the batch correction & compensation parts.

## Log
### 1/2/25
- Deleted entire "pre-process" code since our data is already "pre-processed"
- Installing packages takes a very long time, ideally have this all installed overnight if not installed already.

- Had matrix issues with converting files into an SCE and then back into FCS files.
- Solution: our panel had spaces which caused the function to not recognize some antigens which caused missing objects down the line

### 1/16/25 
- Put in a function that checks for spaces in our panel when running the rmd.

- There's also an issue with installing CyCombine on your device, fortunately, this computer already has CyCombine.

### 1/23/25
- Can be a problem with compensate part when creating another SCE; check literal file names in folder

### 1/28/25
- Pay attention to the panel and whether or not "CD235CD61" needs to be a "type" or "none"
- This depends on wether or not it was gated in or out.

- Added a code (chunk 224) that fixes the file names (problem on 1/23/25) so it's more streamlined during the compensating part. 

### 1/29/25
- There's an error: vector memory exhausted (limit reached?) that occurs when making an SCE and/or converting SCE into an FCS.
- This was solved by "overwrite = TRUE" in the compCytof line (chunk 404)
- Not sure if this drastically changes our dataset or not but we will see once we look at it
