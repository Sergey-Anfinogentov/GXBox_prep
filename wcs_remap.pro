
;+
  ; :Description:
  ;    Remaps data from one World Coordinate System (WCS) to anothe
  ;
  ; :Params:
  ;    data_from - data to be remapped
  ;    wcs_from - WCS structure describing coordinate system of the given
  ;    wcs_to - WCS structure describing coordinate system where the data will be remapped to
  ;
  ;
  ;
  ; :Author: Sergey Anfinogentov (anfinogentov@iszf.irk.ru)
  ;-
function wcs_remap, data_from, wcs_from, wcs_to
  cc_to = wcs_get_coord(wcs_to)
  wcs_convert_from_coord,wcs_to,cc_to,'HG', lon, lat, /carrington
  wcs_convert_to_coord,wcs_from,cc_from,'HG', lon, lat, /carrington
  pix = wcs_get_pixel(wcs_from, cc_from)
  return, reform(interpolate(data_from,pix[0,*,*],pix[1,*,*], cubic=-0.5))
end