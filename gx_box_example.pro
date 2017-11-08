pro gx_box_example
  out_dir = '$HOME/data_local/gx_box_test'
  tmp_dir = '$HOME/temp/jsoc_cache'
  
  time = '2016-02-20 17:00:00'
 
  centre=[0.d,190d]
  size_pix=[120,120,120]
  
  gx_box_prepare_box, time, centre, size_pix, dx_km, out_dir = out_dir, tmp_dir = tmp_dir,/auto_delete,/aia_euv, /aia_uv

end