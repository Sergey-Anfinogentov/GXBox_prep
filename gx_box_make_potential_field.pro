pro gx_box_make_potential_field, box

  sz = size(box.bx)
  bz0 = box.bz[*,*,0]
  field = fft_pot_open(bz0, sz[3])

  
  box.bx[*,*,1:*] = field.bx[*,*,1:*]
  box.by[*,*,1:*] = field.by[*,*,1:*]
  box.bz[*,*,1:*] = field.bz[*,*,1:*]
  


end