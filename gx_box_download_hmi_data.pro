


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
pro gx_box_download_hmi_data, t, out_dir, cache_dir = cache_dir, field = field,$
  inclination = inclination, azimuth = azimuth, disambig = disambig, magnetogram = magnetogram,$
  continuum = continuum, all = all
  
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
  
  if keyword_set(field) then begin
    ds      = [ds,'hmi.B_720s']
    segment = [segment,'field']
  endif
  if keyword_set(inclination) then begin
    ds      = [ds,'hmi.B_720s']
    segment = [segment,'inclination']
  endif
  if keyword_set(azimuth) then begin
    ds      = [ds,'hmi.B_720s']
    segment = [segment,'azimuth']
  endif
  if keyword_set(azimuth) then begin
    ds      = [ds,'hmi.B_720s']
    segment = [segment,'azimuth']
  endif
  if keyword_set(disambig) then begin
    ds      = [ds,'hmi.B_720s']
    segment = [segment,'disambig']
  endif
  if keyword_set(magnetogram) then begin
    ds      = [ds,'hmi.M_720s']
    segment = [segment,'magnetogram']
  endif
  if keyword_set(continum) then begin
    ds      = [ds,'hmi.Ic_noLimbDark_720s']
    segment = [segment,'continuum']
  endif
  
  ;ds = ['hmi.B_720s','hmi.B_720s','hmi.B_720s','hmi.B_720s','hmi.M_720s','hmi.Ic_noLimbDark_720s']
  ;segment = ['field','inclination','azimuth','disambig','magnetogram','continuum']
  
  for i = 0, n_elements(ds)-1 do begin
    gx_box_download_jsoc_data_get_fits, t1, t2, ds[i], segment[i], out_dir, cache_dir = cache_dir
  endfor
 
end