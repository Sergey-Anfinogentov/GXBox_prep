pro gx_box_download_jsoc_data_get_fits, t1, t2, ds, segment, out_dir, cache_dir = cache_dir, waves = waves
  ssw_jsoc_time2data, t1, t2, index, urls, /urls_only, ds=ds, segment=segment, waves=waves
  time_s = strreplace(index.t_rec,'.','')
  time_s = strreplace(time_s,':','')
  if keyword_set(waves) then begin
    out_file = ds+'.'+time_S+'.'+segment+'.'+waves+'.fits'
  endif else begin
    out_file = ds+'.'+time_S+'.'+segment+'.fits'
  endelse
  out_file = filepath(out_file, root = out_dir)
  ;sock_copy,urls[0], out_file
  data_file = gx_box_download_jsoc(urls[0], cache_dir = cache_dir)
  read_sdo,data_file, temp_index, data, /delete_uncomp
  mwritefits,index, data, outfile = out_file
  ;hdr = struct2fitshead(index)
  ;writefits, outfile, data, hdr, /compress
end