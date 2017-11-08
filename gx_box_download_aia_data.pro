pro gx_box_download_aia_data, t, out_dir, cache_dir = cache_dir, UV = UV, EUV = EUV
  
  if not keyword_set(UV) and not keyword_set(EUV) then EUV = 1
  
  t_ = anytim(t)
 

  if not keyword_set(out_dir) then outdir = ''
  ; ssw_jsoc_time2data, t1, t2, index_field,            ds='hmi.B_720s', segment='field'
  
  if keyword_set(EUV) then begin
    t1 = t_ - 12d/2d
    t2 = t_ + 12d/2d +12d

    ds = []
    segment = []
    waves = []
    if gx_box_get_file(out_dir,/aia_171) eq '' then waves = [waves,'171']
    if gx_box_get_file(out_dir,/aia_193) eq '' then waves = [waves,'193']
    if gx_box_get_file(out_dir,/aia_211) eq '' then waves = [waves,'211']
    if gx_box_get_file(out_dir,/aia_94)  eq '' then waves = [waves,'94']
    if gx_box_get_file(out_dir,/aia_131) eq '' then waves = [waves,'131']
    if gx_box_get_file(out_dir,/aia_304) eq '' then waves = [waves,'304']
    if gx_box_get_file(out_dir,/aia_335) eq '' then waves = [waves,'335']
    
    n = n_elements(waves)
    if n gt 0 then begin
      ds = replicate('aia.lev1_euv_12s',n)
      segment = replicate('image',n)
    endif
    
    
    for i = 0, n_elements(ds)-1 do begin
      gx_box_download_jsoc_data_get_fits, t1, t2, ds[i], segment[i], waves = waves[i], out_dir, cache_dir = cache_dir
    endfor
  endif
  
  if keyword_set(UV) then begin
    t1 = t_ - 24d/2d
    t2 = t_ + 24d/2d +24d

    ds = []
    segment = []
    waves = []
    if gx_box_get_file(out_dir,/aia_1600) eq '' then waves = [waves,'1600']
    if gx_box_get_file(out_dir,/aia_1700) eq '' then waves = [waves,'1700']


    n = n_elements(waves)
    if n gt 0 then begin
      ds = replicate('aia.lev1_uv_24s',n)
      segment = replicate('image',n)
    endif
    
    
    for i = 0, n_elements(ds)-1 do begin
      gx_box_download_jsoc_data_get_fits, t1, t2, ds[i], segment[i], waves = waves[i], out_dir, cache_dir = cache_dir
    endfor
  endif

end