
;+
  ; :Description:
  ;    Example of preparing GX-Simulator compatible box file 
  ;
  ;
  ;
  ;
  ;
  ; :Author: Sergey Anfinigentov (sergey.istp@gmail.com)
  ;-
pro gx_box_example
  out_dir = '/Users/sergey/data_local/gx_box_test'
  tmp_dir = '/Users/sergey/temp/jsoc_cache2'
  
  time='2017-08-05 18:05:00'
  centre=[-422.,-192.0] ; arcseconds
  dx_km=1500.
  size_pix=[128,128,128]
  
  gx_box_prepare_box, time, centre, size_pix, dx_km, out_dir = out_dir,/cea, tmp_dir = tmp_dir,/aia_uv,/aia_euv;,/sfq;,/aia_euv;, /aia_uv
;stop
end