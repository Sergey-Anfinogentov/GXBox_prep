pro gx_box_download_aia_data, t, out_dir, cache_dir = cache_dir

  t_ = anytim(t)
  t1 = t_ - 12d/2d
  t2 = t_ + 12d/2d

  if not keyword_set(out_dir) then outdir = ''
  ; ssw_jsoc_time2data, t1, t2, index_field,            ds='hmi.B_720s', segment='field'
  ds = replicate('aia.lev1_euv_12s',7)
  segment = replicate('image',7)
  waves = ['171','193', '211', '94','131','304','335']

  for i = 0, n_elements(ds)-1 do begin
    gx_box_download_jsoc_data_get_fits, t1, t2, ds[i], segment[i], waves = waves[i], out_dir, cache_dir = cache_dir
  endfor

end