# IDL_magnetic

IDL rootines for working with SDO/HMI magnetograms.

## Dependencies
All routines are designed to be used in [Solar Soft](http://www.lmsal.com/solarsoft/sswdoc/sswdoc_jtop.html) environment and requre _SDO/HMI_ and _Ontology_ packages.

## Routines

### prepare_cea_map.pro
#### Description
    Generate magnetic field maps in Cylindrical Equal Area (CEA) projection from SDO/HMI magnetograms
    
#### Calling sequence

 ```idl
 res = prepare_cea_map(file_field, file_inclination, file_azimuth, file_disambig, center, sz, dx)
 ```
#### Returning value
Returns a structure containing the following fields
  * *WCS* - WCS structure containing information about the map position and projection
  * *Bp* - PHI component of the magnetic field
  * *Bt* - THETA component of the magnetic field
  * *Br* - RADIAL magnetic field component
  
#### Parameters
  *   *file_field* - file name of the FIELD fits file
  *   *file_inclination* - file name of the INCLINATION fits file
  *   *file_azimuth* - file name of the AZIMUTH fits file
  *   *file_disambig* - file name of the DISAMBIGuation fits file
  *   *center_arcsec* - 2 element array, center of the patch to be mapped into CEA projection
  *   *size_pix* - 2 element array, size of the resulting CEA map in pixels
  *   *dx_deg* - spatial resolution of the resulting CEA map in heliographic degrees
  
  
  
