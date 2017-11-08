pro gx_box_download_jsoc_data_get_fits, t1, t2, ds, segment, out_dir, cache_dir = cache_dir, waves = waves
  ssw_jsoc_time2data, t1, t2, index, urls, /urls_only, ds=ds, segment=segment, waves=waves
  
  ;Select only the first image if multiple images were found
  index = index[0]
  urls  = urls[0]
  
  time_s = strreplace(index.t_rec,'.','')
  time_s = strreplace(time_s,':','')
  if keyword_set(waves) then begin
    out_file = ds+'.'+time_S+'.'+segment+'.'+waves+'.fits'
  endif else begin
    out_file = ds+'.'+time_S+'.'+segment+'.fits'
  endelse
  out_file = filepath(out_file, root = out_dir)
  data_file = gx_box_download_jsoc(urls, cache_dir = cache_dir)
  if !VERSION.OS_FAMILY eq "unix" then  begin
    read_sdo,data_file, temp_index, data, /use_shared_lib
  endif else begin
    read_sdo,data_file, temp_index, data, /uncomp_delete
  endelse
  mwritefits,index, data, outfile = out_file
end