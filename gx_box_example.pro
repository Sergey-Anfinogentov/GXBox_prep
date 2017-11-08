
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
  tmp_dir = '/Users/sergey/temp/jsoc_cache'
  
 ; time = '2016-02-20 17:00:00'
 
 ; centre=[0.0d,190d]
  ;size_pix=[120,120,120]
  ;dx_km = 1000d
  
  time='2017-08-05 18:05:00'
  centre=[-422.,-192.0]
  dx_km=1500.
  size_pix=[128,128,128]
  
  gx_box_prepare_box, time, centre, size_pix, dx_km, out_dir = out_dir,/cea, tmp_dir = tmp_dir,/auto_delete;,/aia_euv, /aia_uv

end