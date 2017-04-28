# Instruction for creation of GX-simulator compatible box file
Please, check the most recent version of needed IDL routines at https://github.com/Sergey-Anfinogentov/IDL_magnetic.

## Downloading requered SDO/HMI FITS files
SDO/HMI FITS files can be downloaded from the http://jsoc.stanford.edu/ajax/lookdata.html. The toolchain is designed to use the full disk images and magnetograms:
1. Full disk vector magnetograms with resolved azimuthal ambiguity `hmi.B_720s`. The following data segments are needed:
   * Field
   * Inclination
   * Azimuth
   * Disambig
1.	Full disk SDO/HMI continuum image with limb darkening removed `hmi.Ic_noLimbDark_720s`
1.	Full disk SDO/HMI line of sight magnetogram `hmi.M_720s`
1.	Additional observational data if required (EUV, radio, etc)

## Creating the box structure
The box structure can be created using the following IDL code:
```IDL
box = gx_box_create(file_field, file_inclination, file_azimuth,$
file_disambig, file_continuum, centre, size_pix, dx_km, /cea)
```
where:
* `file_field`, `file_inclination`, `file_azimuth`, `file_disambig` and  `file_continuum` are paths to the SDO/HMI FITS files, 
* `centre` is the position of the cetre of the box in arcseconds,
* `size_pix` is requested size of the box in voxels,
* `dx_km` is the requsted spatial resolution (voxel size) of the box,
* `\cea` is a keyword indicating that the base of the box will be calculated in *CEA* projection. It can be replced with the *top view* projection by setting the `\top` keyword instead.

## Calculating the potential field inside the box
After creating the magnetic field data cube inside the box structure is filled with zeroes. To fill it with the potential field one can call `gx_box_make_potential_field` routine:
```IDL
gx_box_make_potential_field, box
```
Where `box` is the box structure created with the `gx_box_create` function.

## Adding reference maps to the box
Optionally, on can add to the box structure reference maps using the `gx_box_add_refmap` procedure. For example, the following code ads to the box structue LOS field and Continuum  reference maps:
```IDL
gx_box_add_refmap, box, file_bz, id = 'Bz_reference'
gx_box_add_refmap, box, file_continuum, id = 'Ic_reference'
```
where:
* `box` is the box structure created with the `gx_box_create` function
* `file_bz` is the path of the FITS file containing LOS field observations
* `id = 'Bz_reference'` is the keyword, specifing ID of the map

## Saving the result
Now the box structure  can be saves to a file, which can be later imported into GX-Simulator
```IDL
 save, box, file ='testbox.sav'
```
