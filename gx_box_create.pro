;+
  ; :Description:
  ;    Creates the GX-simulator compatible box structure from SDO/HMI full disk fits files
  ;
  ; :Output:
  ;   Returns GX-simulator compatible box structure
  ; :Params:
  ;    file_field - file name of the FIELD fits file
  ;    file_inclination - file name of the INCLINATION fits file
  ;    file_azimuth - file name of the AZIMUTH fits file
  ;    file_disambig - file name of the DISAMBIGuation fits file
  ;    file_continuum - file name of the continuum with removed limb darkening fits file
  ;    center_arcsec - center of the patch to be mapped into the base of the box
  ;    size_pixx - [nx, ny, nz] size of the resulting box in voxels
  ;    dx_km
  ;
  ; :Keywords:
  ;    carrington - set this keyword if the box center is given as carrington longitude and latitude in degrees
  ;    cea - set this keyword to use the CEA projection for the base of the box
  ;    top - set this keyword to use the TOP VIEW projection for the base of the box
  ;
  ; :Author: Sergey Anfinogentov (anfinogentov@iszf.irk.ru)
  ;-
function gx_box_create, file_field, file_inclination, file_azimuth, file_disambig, file_continuum,$
  center_arcsec, size_pix, dx_km, carrington = carrington, cea = cea, top = top
  
  basemaps = prepare_basemaps(file_field, file_inclination, file_azimuth, file_disambig, file_continuum,$
              center_arcsec, size_pix, dx_km, WCS = WCS, carrington = carrington, cea = cea, top = top)
    

  base={bx:basemaps.bp ,by:-basemaps.bt, bz:basemaps.br,ic:basemaps.ic}
  
  ;Prepare a dummy object for LOS reference maps
  refmaps=obj_new('map')
  dr = [dx_km*1d3,dx_km*1d3,dx_km*1d3]/wcs_rsun()
  
  index = wcs2fitshead(basemaps.wcs, /structure)
  
  bx = dblarr(size_pix)
  by = dblarr(size_pix)
  bz = dblarr(size_pix)
  bx[*,*,0] = base.bx
  by[*,*,0] = base.by
  bz[*,*,0] = base.bz
  refmaps=obj_new('map')
  
  return, {bx:bx,by:by,bz:bz,dr:dr, add_base_layer:0,base:base,index:index, refmaps: ptr_new(refmaps)}

end