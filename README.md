# IDL_magnetic

IDL rootines for working with SDO/HMI magnetograms.

## Routines

### prepare_cea_map
#### Description
    Generate magnetic field maps in Cylindrical Equal Area (CEA) projection from SDO/HMI magnetograms

#### Parameters
  *    file_field - file name of the FIELD fits file
  *    file_inclination - file name of the INCLINATION fits file
  *    file_azimuth - file name of the AZIMUTH fits file
  *    file_disambig - file name of the DISAMBIGuation fits file
  *    center_arcsec - center of the patch to be mapped into CEA projection
  *   size_pix - size of the resulting CEA map in pixels
  *   dx_deg - spatial resolution of the resulting CEA map in heliographic degrees
  
