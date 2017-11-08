;
;
;pro gx_box_download_hmi_data_get_fits, t1, t2, ds, segment, out_dir, cache_dir = cache_dir
;  ssw_jsoc_time2data, t1, t2, index, urls, /urls_only, ds=ds, segment=segment
;  time_s = strreplace(index.t_rec,'.','')
;  time_s = strreplace(time_s,':','')
;  out_file = ds+'.'+time_S+'.'+segment+'.fits'
;  out_file = filepath(out_file, root = out_dir)
;  ;sock_copy,urls[0], out_file
;  data_file = gx_box_download_jsoc(urls[0], cache_dir = cache_dir)
;  read_sdo,data_file, temp_index, data
;  mwritefits,index, data, outfile = out_file
;  ;hdr = struct2fitshead(index)
;  ;writefits, outfile, data, hdr, /compress
;end






;+
; :Description:
;    Downloads from JSOC all SDO/HMI files required to produce GX-simulator box
;
; :Params:
;    t - time of the magnetogram (any format recognised by ANYTIM)
;    out_dir - directory to save downloaded files
;
;
; :Author: Sergey Anfinogentov (sergey.istp@gmail.com)
;-
pro gx_box_download_hmi_data, t, out_dir, cache_dir = cache_dir
  
  t_ = anytim(t)
  t1 = t_ - 720d/2d
  t2 = t_ + 720d/2d

  if not keyword_set(out_dir) then outdir = ''
  ; ssw_jsoc_time2data, t1, t2, index_field,            ds='hmi.B_720s', segment='field'
  ds = ['hmi.B_720s','hmi.B_720s','hmi.B_720s','hmi.B_720s','hmi.M_720s','hmi.Ic_noLimbDark_720s']
  segment = ['field','inclination','azimuth','disambig','magnetogram','continuum']
  
  for i = 0, n_elements(ds)-1 do begin
    gx_box_download_jsoc_data_get_fits, t1, t2, ds[i], segment[i], out_dir, cache_dir = cache_dir
  endfor
 
end