# Instruction for creating a GX-simulator compatible box file
Please, check the most recent version of needed IDL routines at https://github.com/Sergey-Anfinogentov/IDL_magnetic.

## Automated preparation of the box file

The library contains `GX_BOX_PREPARE_BOX` routine that allows preparation of the GX-Simulator compatible box file with automatic download of all required data. To use this routine, one can follow the following template code.

Specify the output directory to store the box file and temporary directory to save downloaded compressed data segments for futher usage:
```idl
  out_dir = '/Users/sergey/data_local/gx_box_test'
  tmp_dir = '/Users/sergey/temp/jsoc_cache'
```
Then, one need to set up the observation time, centre of the box in arc seconds measured from the disk centre, required spatial resolution, and size of the box in voxels.
```idl
  time='2017-08-05 18:05:00'
  centre=[-422.,-192.0]
  dx_km=1500.
  size_pix=[128,128,128]
```

All of this parameters should be passed to the  `GX_BOX_PREPARE_BOX` routine. It will download all required data or take them from temporary directory if present, produce a GX-Simulator compatible box file in the output directory.
```idl
 gx_box_prepare_box, time, centre, size_pix, dx_km,$
    out_dir = out_dir,/top, tmp_dir = tmp_dir,/auto_delete
```
 `GX_BOX_PREPARE_BOX` routine supports the following options:

- `/cea` set this keyword to calculate the base of the box using the CEA projection
- `/top` set this keyword to calculate the base of the box using the CEA projection
- `/carrington` set this keyword to indicate that the box centre is given as Carrington longitude and latitude
- `/auto_delete` set this keyword to automaticly delete decompressed FITS files from the output directory
- `/aia_euv` set this keyword to download SDO/AIA images in EUV channels and to include them in the model as reference maps
- `/aia_uv` set this keyword to download SDO/AIA images in UV (1600 and 1700 Angstrom) channels and to include them in the model as reference maps

The low level procedure of "manual" creation of the box file is given below.

## Manual preparation of the box file

### Downloading requered SDO/HMI FITS files

SDO/HMI FITS files can be downloaded from the http://jsoc.stanford.edu/ajax/lookdata.html. 

Alternatively, all required data can be downloaded using the `GX_BOX_DOWNLOAD_HMI_DATA` routine: 

```idl
time = '2016-02-20 17:00:00'
out_dir = 'C:\data'
gx_box_download_hmi_data, time, out_dir
```

The toolchain is designed to use the full disk images and magnetograms:

1. Full disk vector magnetograms with resolved azimuthal ambiguity `hmi.B_720s`. The following data segments are needed:
   * Field
   * Inclination
   * Azimuth
   * Disambig
2. Full disk SDO/HMI continuum image with limb darkening removed `hmi.Ic_noLimbDark_720s`
3. Full disk SDO/HMI line of sight magnetogram `hmi.M_720s`
4. Additional observational data if required (EUV, radio, etc)

### Creating the box structure
The box structure can be created using the following IDL code:
```idl
box = gx_box_create(file_field, file_inclination, file_azimuth,$
file_disambig, file_continuum, centre, size_pix, dx_km, /cea)
```
where:
* `file_field`, `file_inclination`, `file_azimuth`, `file_disambig` and  `file_continuum` are paths to the SDO/HMI FITS files, 
* `centre` is the position of the cetre of the box in arcseconds,
* `size_pix` is requested size of the box in voxels,
* `dx_km` is the requsted spatial resolution (voxel size) of the box,
* `/cea` is a keyword indicating that the base of the box will be calculated in *CEA* projection. It can be replced with the *top view* projection by setting the `/top` keyword instead.

### Calculating the potential field inside the box
After creating the magnetic field data cube inside the box structure is filled with zeroes. To fill it with the potential field one can call `gx_box_make_potential_field` routine:
```IDL
gx_box_make_potential_field, box
```
Where `box` is the box structure created with the `gx_box_create` function.

### NLFFF extrapolation (Windows only)

The NLFFF extrapolation can be performed using the code developed by Alexey G. Stupishin (Saint Petersburg State University).

```idl
return_code = gx_box_make_nlfff_wwas_field("WWNLFFFReconstruction.dll", box)
```



### Adding reference maps to the box
Optionally, one can add to the box reference maps using the `gx_box_add_refmap` procedure. For example, the following code adds LOS field and Continuum  reference maps:
```IDL
gx_box_add_refmap, box, file_bz, id = 'Bz_reference'
gx_box_add_refmap, box, file_continuum, id = 'Ic_reference'
```
where:
* `box` is the box structure created with the `gx_box_create` function
* `file_bz` is the path of the FITS file containing LOS field observations
* `id = 'Bz_reference'` is the keyword, specifing ID of the map

## +Saving the result
Now the box structure  can be saved to a file, which can be later imported into GX-Simulator.
```IDL
 save, box, file ='testbox.sav'
```
