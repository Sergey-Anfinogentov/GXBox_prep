


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
  
  if keyword_set(all) then begin
    field = 1
    inclination = 1
    azimuth = 1
    disambig = 1
    magnetogram = 1
    continuum = 1
  endif
  
  t_ = anytim(t)
  t1 = t_ - 720d/2d
  t2 = t_ + 720d/2d

  if not keyword_set(out_dir) then outdir = ''
  ; ssw_jsoc_time2data, t1, t2, index_field,            ds='hmi.B_720s', segment='field'
  
  ds = []
  segment = []
  
  if  gx_box_get_file(out_dir,/field) eq '' then begin
    ds      = [ds,'hmi.B_720s']
    segment = [segment,'field']
  endif
  if gx_box_get_file(out_dir,/inclination) eq '' then begin
    ds      = [ds,'hmi.B_720s']
    segment = [segment,'inclination']
  endif
  if gx_box_get_file(out_dir, /azimuth) eq '' then begin
    ds      = [ds,'hmi.B_720s']
    segment = [segment,'azimuth']
  endif
  if gx_box_get_file(out_dir, /disambig) eq '' then begin
    ds      = [ds,'hmi.B_720s']
    segment = [segment,'disambig']
  endif
  if gx_box_get_file(out_dir, /magnetogram) eq '' then begin
    ds      = [ds,'hmi.M_720s']
    segment = [segment,'magnetogram']
  endif
  if gx_box_get_file(out_dir, /continuum) eq '' then begin
    ds      = [ds,'hmi.Ic_noLimbDark_720s']
    segment = [segment,'continuum']
  endif
  
  ;ds = ['hmi.B_720s','hmi.B_720s','hmi.B_720s','hmi.B_720s','hmi.M_720s','hmi.Ic_noLimbDark_720s']
  ;segment = ['field','inclination','azimuth','disambig','magnetogram','continuum']
  
  for i = 0, n_elements(ds)-1 do begin
    gx_box_download_jsoc_data_get_fits, t1, t2, ds[i], segment[i], out_dir, cache_dir = cache_dir
  endfor
 
end