#requires -version 2.0
function Set-ImageFilter {
    <#
    .Synopsis
    Applies an image filter to one or more images.

    .Description
    The Set-ImageFilter function changes an image by applying an image filter to the image.
    For example, to crop an image, you can apply a crop filter to the image.
    This strategy is particularly useful when you want to make the same change to many images, such as flipping them all vertically.

    You can change images without a filter by using the methods of the Get-Image function.
    For example, to crop an image, you can use the Crop method of Get-Image.
    Get-Image actually creates the filter for you and applies it.

    .Parameter Image
    Applies the filter to the specified images.
    Enter image objects, such as those returned by the Get-Image function.
    This parameter is optional. If you do not specify an image, Set-ImageFilter creates a crop filter that is not image-specific.

    .Parameter passThru
    If set, the image or images will be emitted onto the pipeline       

    .Parameter Filter
    Enter a filter collection (Wia.ImageProcess COM object).
    Each filter in the collection represents a unit of modification to a WiA ImageFile object.

    .Link
    Get-Image

    .Link
    Add-CropFilter

    .Link
    Add-OverlayFilter

    .Link
    Add-RotateFlipFilter

    .Link
    Add-ScaleFilter

    .Link
    Image Manipulation in PowerShell:
    http://blogs.msdn.com/powershell/archive/2009/03/31/image-manipulation-in-powershell.aspx

    .Link
    "ImageProcess object" in MSDN
    http://msdn.microsoft.com/en-us/library/ms630507(VS.85).aspx

    .Link
    "Filter Object" in MSDN 
    http://msdn.microsoft.com/en-us/library/ms630501(VS.85).aspx

    .Link
    "How to Use Filters" in MSDN
    http://msdn.microsoft.com/en-us/library/ms630819(VS.85).aspx

    .Example
    $image = Get-Image .\Photo01.jpg            
    $filter = Add-RotateFlipFilter –flipHorizontal -passthru
    $NewImage = $image | Set-ImageFilter -filter $filter -passThru                    
    $Newimage.SaveFile(".\Photo01_edited.jpg")

    $images = dir $home\Pictures\Resize\*.jpg | Get-Image            
    $filter = Add-ScaleFilter –width 100 –height 150 -passthru
    $smallImages = $images | Set-ImageFilter -filter $filter –passThru
    $count = 1
    foreach ($si in $smallImages) {$si.savefile(".\Thumbs\Thumb_$count.jpg"); ++$count}
    #>
    param(
    [Parameter(ValueFromPipeline=$true)]
    $image,
    
    [__ComObject[]]
    $filter,
    
    [switch]
    $passThru
    )
    
    process {
        if (-not $image.LoadFile) { return }
        $i = $image
        foreach ($f in $filter) {
            if (-not $f) { continue }
            $i = $f.Apply($i.PSObject.BaseObject)
        }       
        if ($passThru) { 
            $i
        }
    }
}
 
