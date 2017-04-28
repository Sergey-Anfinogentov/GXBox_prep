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