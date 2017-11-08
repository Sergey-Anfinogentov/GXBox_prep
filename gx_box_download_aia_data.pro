pro gx_box_download_aia_data, t,waves, out_dir, cache_dir = cache_dir, UV = UV, EUV = EUV
  
  if not keyword_set(UV) and not keyword_set(EUV) then EUV = 1
  
  t_ = anytim(t)
 

  if not keyword_set(out_dir) then outdir = ''

  
  if keyword_set(EUV) then begin
    t1 = t_ - 12d/2d
    t2 = t_ + 12d/2d +12d
    ds = replicate('aia.lev1_euv_12s',7)
    segment = replicate('image',7)
    waves = ['171','193', '211', '94','131','304','335']
    for i = 0, n_elements(ds)-1 do begin
      gx_box_download_jsoc_data_get_fits, t1, t2, ds[i], segment[i], waves = waves[i], out_dir, cache_dir = cache_dir
    endfor
  endif
  
  if keyword_set(UV) then begin
    t1 = t_ - 24d/2d
    t2 = t_ + 24d/2d +24d
    ds = replicate('aia.lev1_uv_24s',2)
    segment = replicate('image',2)
    waves = ['1600','1700']
    for i = 0, n_elements(ds)-1 do begin
      gx_box_download_jsoc_data_get_fits, t1, t2, ds[i], segment[i], waves = waves[i], out_dir, cache_dir = cache_dir
    endfor
  endif

end