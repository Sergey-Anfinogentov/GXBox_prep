
pro prepare_box_gx, file_bp, file_bt, file_br, file_ic, file_Bcube, dx_km, file_box

  
  ;Read magnetic field data and translae it into cartezian components
  if !version.os_family eq 'Windows' then noshell=1 else noshell=0
  read_sdo, file_bp, bxindex, bx, noshell=noshell,/use_shared_lib
  read_sdo, file_bt, byindex, by, noshell=noshell,/use_shared_lib
  read_sdo, file_br, index, bz, noshell=noshell,/use_shared_lib
  bx=bx
  by=-by
  bz=bz
  
  ;Read CEA IC  dark limb removed IC map
   read_sdo, file_ic, icindex, ic, noshell=noshell,/use_shared_lib
  
  ;this are base images
  base={bx:bx,by:by,bz:bz,ic:ic}


;  ;Prepare a dummy object for LOS reference maps
  refmaps=obj_new('map')
  
 
  restore,file_Bcube
  
  ;The resolution of the extrapolation must be defind here in SOLAR RADIUS UNITS (RSUN=1): 
  default,dr,[dx_km*1d3,dx_km*1d3,dx_km*1d3]/wcs_rsun()
  
  wcs = FITSHEAD2WCS( index)
  
  
  
  box={bx:bx,by:by,bz:bz,dr:dr, add_base_layer:0,base:base,index:index}
  stop
  save, box, file = file_box

end