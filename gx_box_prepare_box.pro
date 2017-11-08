;+
  ; :Description:
  ;    Prepares a GX-simulator comptible box filled with the potential field.
  ;    All required data are download automatically.
  ;
  ; :Params:
  ;    time - Requested time
  ;    centre - [x0,y0], position of the box centre in arcseconds from the disk centre
  ;    size_pix - [nx,ny,nz], size of the box in voxel
  ;    dx_km - spatial resolution in kilometers
  ;
  ; :Keywords:
  ;    out_dir - directory where to save the data (default: current directory)
  ;    tmp_dir - temporary dierectory where to keep downloaded data segments
  ;                (default: IDL temporary directory as returned by GETENV('IDL_TMPDIR'))
  ;    aia_euv - Download images in AIA EUV channels and add them to the box as reference maps
  ;    aia_uv  - Download images in AIA UV channels and add them to the box as reference maps
  ;    auto_delete - Automatically delete all FITS files from the workind diectory
  ;                  (OUT_DIR).The cached data segments will remain in TMP_DIR for future usage
  ;
  ; :Author: Sergey Anfinigentov (sergey.istp@gmail.com)
  ;-
pro gx_box_prepare_box, time, centre, size_pix, dx_km, out_dir = out_dir, tmp_dir = tmp_dir,$
  aia_euv = aia_euv, aia_uv = aia_uv, auto_delete = auto_delete
  if not keyword_set(out_dir) then cd, current = out_dir
  if not keyword_set(tmp_dir) then tmp_dir = filepath('jsoc_cache',root = GETENV('IDL_TMPDIR'))
  if not keyword_set(dx_km) then dx_km = 1000d
  if not keyword_Set(size_pix) then size_pix = [128,128,64]
  
  gx_box_download_hmi_data, time, out_dir, cache_dir = tmp_dir
  
  file_field  =     gx_box_get_file(out_dir, /field)
  file_inclination= gx_box_get_file(out_dir, /inclination)
  file_azimuth=     gx_box_get_file(out_dir, /azimuth)
  file_disambig=    gx_box_get_file(out_dir, /disambig)
  file_continuum=   gx_box_get_file(out_dir, /continuum)
  file_los =        gx_box_get_file(out_dir, /magnetogram)

  box = gx_box_create(file_field, file_inclination, file_azimuth,file_disambig, file_continuum, centre, size_pix, dx_km, /top)
  gx_box_add_refmap, box, file_continuum, id = 'Continuum'
  gx_box_add_refmap, box, file_los, id = 'LOS_magnetogram'
  
  if keyword_set(auto_delete) then begin
    file_delete, [file_field, file_inclination, file_azimuth,file_disambig, file_continuum, file_los]
  endif
  
  gx_box_make_potential_field, box
  
  ;Downloading AIA data in EUV channels
  if keyword_set(AIA_EUV) then begin
    gx_box_download_AIA_data, time, out_dir, cache_dir = tmp_dir, /euv
    
    file_94 =  gx_box_get_file(out_dir, /AIA_94)
    file_131 = gx_box_get_file(out_dir, /AIA_131)
    file_171 = gx_box_get_file(out_dir, /AIA_171)
    file_193 = gx_box_get_file(out_dir, /AIA_193)
    file_211 = gx_box_get_file(out_dir, /AIA_211)
    file_304 = gx_box_get_file(out_dir, /AIA_304)
    file_335 = gx_box_get_file(out_dir, /AIA_335)
    
    gx_box_add_refmap, box, file_94,  id = 'AIA_94'
    gx_box_add_refmap, box, file_131, id = 'AIA_131'
    gx_box_add_refmap, box, file_171, id = 'AIA_171'
    gx_box_add_refmap, box, file_193, id = 'AIA_193'
    gx_box_add_refmap, box, file_211, id = 'AIA_211'
    gx_box_add_refmap, box, file_304, id = 'AIA_304'
    gx_box_add_refmap, box, file_335, id = 'AIA_335'
    
    if keyword_set(auto_delete) then begin
      file_delete, [file_94, file_131, file_171, file_193, file_211, file_304, file_335]
    endif
  endif
  
  if keyword_set(AIA_UV) then begin
    gx_box_download_AIA_data, time, out_dir, cache_dir = tmp_dir, /uv

    file_1600 =  gx_box_get_file(out_dir, /AIA_1600)
    file_1700 =  gx_box_get_file(out_dir, /AIA_1700)


    gx_box_add_refmap, box, file_1600,  id = 'AIA_1600'
    gx_box_add_refmap, box, file_1700,  id = 'AIA_1700'
    

    if keyword_set(auto_delete) then begin
      file_delete, [file_1600, file_1700]
    endif
  endif
  
  save, box, file = out_dir+"/"+box.id+".sav"
  ;stop
end