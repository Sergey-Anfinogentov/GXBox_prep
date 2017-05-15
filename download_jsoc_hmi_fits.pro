function strreplace,str,find,replace
  compile_opt idl2
  if n_elements(str) gt 1 then begin
    n=n_elements(str)
    result=strarr(n)
    for i=0,n-1 do begin
      result[i]=strreplace(str[i],find,replace)
    endfor
    return,result
  endif  
    pos=0
    n=strlen(find)
    found=0
    res=''
    while 1 do begin
      index=strpos(str,find,pos)
      if index eq -1 then begin      
        return,res+strmid(str,pos)
      endif 
      res=res+strmid(str,pos,index-pos)+replace
      pos=index+n      
    endwhile
end

function get_jsoc_urls,response
  compile_opt idl2
  files = response.data.filename
  dir = strreplace(response.dir,'\/','/')
  jsoc = 'http://jsoc.stanford.edu'
  return, jsoc+dir+'/'+files
end

pro download_jsoc_query, query, email = email, out_dir = out_dir
  compile_opt idl2
  filenamefmt ='{seriesname}.{T_OBS:A}.{CAMERA}.{segment}'
  request = ssw_jsoc(ds = query,/export,method = 'url', notify=email,$
                      protocol = 'fits', filenamefmt = filenamefmt)
  print,'   Data export request has been submited to JSOC, REQUEST ID  '+request.requestid
  for i =1, 1000 do begin
    print,'   waiting 5 seconds...'
    wait,5
    print,'   Checking export status...'
    response = ssw_jsoc(/exp_status, requestid = request.requestid, status = status)  
    if status eq 1 then begin 
      if  not tag_exist(response,'wait') then break
    endif
  endfor
  
  urls = get_jsoc_urls(response)
  for i = 0, n_elements(urls) - 1 do begin
    print,'   Dowloading '+urls[i] +' ...'
    sock_copy, urls[i], out_dir = out_dir
  endfor
  
end

;+
  ; :Description:
  ;    Downloads from JSOC all SDO/HMI files required to produce GX-simulator box
  ;
  ; :Params:
  ;    time - time of the magnetogram (any format recognised by ANYTIM)
  ;
  ; :Keywords:
  ;    out_dir - path to the directory, where FITS files will be saved
  ;    email - notify e-mail address registered in JSOC
  ;
  ; :Author: Sergey Anfinogentov (sergey.istp@gmail.com)
  ;-
pro download_jsoc_hmi_fits, time, email = email, out_dir = out_dir
  compile_opt idl2
  ds_field = 'hmi.B_720s'
  ds_velocity = 'hmi.Ic_noLimbDark_720s'
  ds_LOS = 'hmi.M_720s'
  jsoc_time = ssw_time2jsoc(time)
  if not keyword_set(out_dir) then cd,current = out_dir
  segments ='{field,inclination,azimuth,disambig}'
  
  print,'Requesting Vector Field from JSOC...'
  query = ds_field + '[' + jsoc_time + ']'+segments
  download_jsoc_query, query, out_dir = out_dir, email = email
  
  print,'Requesting LOS velocity from JSOC...'
  query = ds_velocity + '[' + jsoc_time + ']'
  download_jsoc_query, query, out_dir = out_dir, email = email
  
  print,'Requesting LOS field from JSOC...'
  query = ds_LOS + '[' + jsoc_time + ']'
  download_jsoc_query, query, out_dir = out_dir, email = email


end