# IDL_magnetic

IDL rootines for working with SDO/HMI magnetograms.

## Dependencies
All routines are designed to be used in [Solar Soft](http://www.lmsal.com/solarsoft/sswdoc/sswdoc_jtop.html) environment and requre SDO/HMI intrument package.

## Routines

### prepare_cea_map.pro
#### Description
    Generate magnetic field maps in Cylindrical Equal Area (CEA) projection from SDO/HMI magnetograms

#### Parameters
  *    file_field - file name of the FIELD fits file
  *    file_inclination - file name of the INCLINATION fits file
  *    file_azimuth - file name of the AZIMUTH fits file
  *    file_disambig - file name of the DISAMBIGuation fits file
  *    center_arcsec - 2 element array, center of the patch to be mapped into CEA projection
  *   size_pix - 2 element array, size of the resulting CEA map in pixels
  *   dx_deg - spatial resolution of the resulting CEA map in heliographic degrees
  
