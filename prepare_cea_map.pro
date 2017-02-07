function prepare_cea_map, file_field, file_inclination, file_azimuth, file_disambig, center_arcsec, size_pix, dx_deg

  files = [file_field, file_inclination, file_azimuth]
  read_sdo,files, index, data, /uncomp_delete, /use_shared_lib
  
  wcs0 = FITSHEAD2WCS( index[0] )
  
  ;Apply disambigution--------------------------------
  read_sdo, file_disambig, index, disambig
  azimuth  =reform(data[*,*,2])
  hmi_disambig, azimuth, disambig, 2
  data[*,*,2] = azimuth
  ;-------------------------------------
  
  ;Converting field to spherical coordinates
  hmi_b2ptr, index[0], data, bptr, lonlat=lonlat
  
  ;Calculating reference point in HG spherical coordinate system
  wcs_convert_from_coord,wcs0,center_arcsec,'hg', lon, lat
  
  ;Make WCS for resulting CEA map
  wcs = WCS_2D_SIMULATE( size_pix[0], size_pix[1],cdelt = dx_deg, crval =[lon,lat], type ='HG', projection = 'cea')
  
 ;Coordinate transformnation----
  cc = wcs_get_coord( wcs )
  wcs_convert_from_coord,wcs,cc,'HG', lon, lat
  wcs_convert_to_coord,wcs0,cc0,'HG', lon, lat
  pix = wcs_get_pixel(wcs0, cc0)
  ;------------------------------
  
  ;Interpolating data
  bp =  reform(interpolate(bptr[*,*,0],pix[0,*,*],pix[1,*,*], cubic=-0.5))
  bt =  reform(interpolate(bptr[*,*,1],pix[0,*,*],pix[1,*,*], cubic=-0.5))
  br =  reform(interpolate(bptr[*,*,2],pix[0,*,*],pix[1,*,*], cubic=-0.5))
  
  return, {wcs:wcs, bp:bp, bt:bt, br:br}


end