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
  ;    aia_uv  - Download images in AIA UV  channels and add them to the box as reference maps
  ;    carrington - set this keyword if the box center is given as carrington longitude and latitude in degrees
  ;    cea - set this keyword to use the CEA projection for the base of the box
  ;    top - set this keyword to use the TOP VIEW projection for the base of the box
  ;
  ; :Author: Sergey Anfinigentov (sergey.istp@gmail.com)
  ;-
pro gx_box_prepare_box, time, centre, size_pix, dx_km, out_dir = out_dir, tmp_dir = tmp_dir,$
  aia_euv = aia_euv, aia_uv = aia_uv, top = top, cea = cea,$
   carrington = carrington, sfq = sfq
  if not keyword_set(out_dir) then cd, current = out_dir
  if not keyword_set(tmp_dir) then tmp_dir = filepath('jsoc_cache',root = GETENV('IDL_TMPDIR'))
  if not keyword_set(dx_km) then dx_km = 1000d
  if not keyword_Set(size_pix) then size_pix = [128,128,64]
  
  files = gx_box_download_hmi_data(time, out_dir, cache_dir = tmp_dir)
  
;  download_data, time, tmp_dir, $
;    field_index, field_data, $
;    inclination_index, inclination_data, $
;    azimuth_index, azimuth_data, $
;    disambig_index, disambig_data, $
;    bz_index, bz_data, $
;    ic_index, ic_data
  
;  file_field  =     ;gx_box_get_file(out_dir, /field)
;  file_inclination= ;gx_box_get_file(out_dir, /inclination)
;  file_azimuth=     ;gx_box_get_file(out_dir, /azimuth)
;  file_disambig=    ;gx_box_get_file(out_dir, /disambig)
;  file_continuum=   ;gx_box_get_file(out_dir, /continuum)
;  file_los =       ; gx_box_get_file(out_dir, /magnetogram)

  box = gx_box_create(files.field, files.inclination, files.azimuth,files.disambig,$
     files.continuum, centre, size_pix, dx_km,top = top, cea = cea, carrington = carrington, sfq = sfq)
  gx_box_add_refmap, box, files.continuum, id = 'Continuum'
  gx_box_add_refmap, box, files.magnetogram, id = 'LOS_magnetogram'
  
  gx_box_make_potential_field, box
  
  ;Downloading AIA data in EUV channels
  if keyword_set(AIA_EUV) then begin
    files = gx_box_download_AIA_data(time, out_dir, cache_dir = tmp_dir, /euv)
    
   
    
    gx_box_add_refmap, box, files.aia_94,  id = 'AIA_94'
    gx_box_add_refmap, box, files.aia_131, id = 'AIA_131'
    gx_box_add_refmap, box, files.aia_171, id = 'AIA_171'
    gx_box_add_refmap, box, files.aia_193, id = 'AIA_193'
    gx_box_add_refmap, box, files.aia_211, id = 'AIA_211'
    gx_box_add_refmap, box, files.aia_304, id = 'AIA_304'
    gx_box_add_refmap, box, files.aia_335, id = 'AIA_335'
    
  endif
  
  if keyword_set(AIA_UV) then begin
    files=gx_box_download_AIA_data(time, out_dir, cache_dir = tmp_dir, /uv)

    gx_box_add_refmap, box, files.aia_1600,  id = 'AIA_1600'
    gx_box_add_refmap, box, files.aia_1700,  id = 'AIA_1700'
    

  endif
  
  save, box, file =filepath(box.id+".sav",root_dir = out_dir)
  ;stop
end