function gx_box_jsoc_make_query,t1,t2,ds,segment, waves = waves
  query = ssw_jsoc_time2query(t1, t2, ds=ds)
  if keyword_set(waves) then query=query+'['+arr2str(strtrim(waves,2))+']'
  query=query+'{'+segment+'}'
  return, query
end

function gx_box_jsoc_try_cache, dir, query
  index_file = filepath('index.sav', root = cache_dir)
  If not file_test(index_file) then begin
    queries = []
    files = []
    save, queries, files, file = index_file
    return, ''
  Endif
  restore, index_file
  ind = where(queries eq query)
  if ind[0] eq -1 then return, ''
  return, files[ind]
end

pro gx_box_jsoc_save2cache, dir, query, data, index, wave = wave
  index_file = filepath('index.sav', root = cache_dir)
  If not file_test(index_file) then begin
    queries = []
    files = []
    save, queries, files, file = index_file
  Endif
  restore, index_file
  queries = [queries, query]
  
  file = gx_box_jsoc_make_filename(index, ds, wave)
  
  date_dir = anytim(strreplace(index.t_rec,'.','-'),/ccsds,/date)
  
  local_file = filepath(file, subdir = date_dir, root = dir)
  
  writefits, local_file, data, struct2fitshead(index)
  
  save, queries, files, file = index_file
  
end

function gx_box_jsoc_make_filename, index, ds, segment, wave = wave
  
  time_s = strreplace(index.t_rec,'.','')
  time_s = strreplace(time_s,':','')
  
  if keyword_set(wave) then begin
    file = ds+'.'+time_S+'.'+segment+'.'+waves+'.fits'
  endif else begin
    file = ds+'.'+time_S+'.'+segment+'.fits'
  endelse
  return, file
end


function gx_box_jsoc_get_fits, t1, t2, ds, segment, cache_dir = cache_dir, wave = wave
  index_file = filepath('index.sav', root = cache_dir)
  query = gx_box_jsoc_make_query(t1,t2,ds,segment, wave = wave)
  If not file_test(index_file) then begin
    queries = []
    files = []
    save, queries, files, file = index_file
  Endif

  ssw_jsoc_time2data, t1, t2, index, urls, /urls_only, ds=ds, segment=segment, wave=wave
 
  index = index[0]
  urls  = urls[0] 
  local_file = gx_box_jsoc_make_filename(index, ds, segment,wave = wave)
  tmp_dir = GETENV('IDL_TMPDIR')
  tmp_file = filepath(local_file, /tmp)
  
  sock_copy,url, tmp_file
  read_sdo, tmp_file, tmp_index, data
  file_delete, tmp_file
  
  gx_box_jsoc_save2cache, cache_dir, query, data, index, wave = wave
  return, gx_box_jsoc_try_cache(dir, query)
  
end

pro gx_box_download_jsoc_data_get_fits, t1, t2, ds, segment, out_dir, cache_dir = cache_dir, waves = waves
  ssw_jsoc_time2data, t1, t2, index, urls, /urls_only, ds=ds, segment=segment, waves=waves
  
  ;Select only the first image if multiple images were found
  index = index[0]
  urls  = urls[0]
  
;  time_s = strreplace(index.t_rec,'.','')
;  time_s = strreplace(time_s,':','')
;  if keyword_set(waves) then begin
;    out_file = ds+'.'+time_S+'.'+segment+'.'+waves+'.fits'
;  endif else begin
;    out_file = ds+'.'+time_S+'.'+segment+'.fits'
;  endelse
  out_file = gx_box_jsoc_make_filename(index, ds,segment, wave = waves)
  out_file = filepath(out_file, root = out_dir)
  data_file = gx_box_download_jsoc(urls, cache_dir = cache_dir)
  if !VERSION.OS_FAMILY eq "unix" then  begin
    read_sdo,data_file, temp_index, data, /use_shared_lib
  endif else begin
    read_sdo,data_file, temp_index, data, /uncomp_delete
  endelse
  mwritefits,index, data, outfile = out_file
end