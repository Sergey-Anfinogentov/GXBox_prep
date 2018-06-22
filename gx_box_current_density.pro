function VxV , A , B , NORM=NORM

	C = A*0

	C[0] = A[1]*B[2] - A[2]*B[1]
	C[1] = A[2]*B[0] - A[0]*B[2]
	C[2] = A[0]*B[1] - A[1]*B[0]

	if keyword_set( NORM ) then C /= sqrt( C[0]^2 + C[1]^2 + C[2]^2 )

	return, C

end



;Jr = Current_Density( B0_pp_crt , B1_pp_crt , B2_pp_crt , CRPIX1-index[0] , CRPIX2-index[1] , CDELT1 , CDELT2 , RSun ); * mask
function GX_box_Current_Density, B0,B1,B2 ,$
                          CRPIX1 , CRPIX2 , CDELT1 , CDELT2 , RSun

	Jr = B0*0
	sz = size( B0 )

	for i1 = 1 , sz[1]-2 do $
	for i2 = 1 , sz[2]-2 do begin

		x1 = ( i1 - CRPIX1 ) * CDELT1 / RSun
		x2 = ( i2 - CRPIX2 ) * CDELT2 / RSun
		if ( sqrt( x1^2 + x2^2 ) ge .95 ) then continue
		x0 = sqrt( 1. - x1^2 - x2^2 )

		e0 = [ x0 , x1 , x2 ]
		e1 = VxV( [ 0. , 0. , 1. ] , e0 , /NORM )
		e2 = VxV( e0 , e1 )

		delta = 0.5 * CDELT1 / RSun
;[ e1_m , e1_p , e2_m , e2_p ]
		x1 = [-e1[1] , e1[1] ,-e2[1] , e2[1] ] * delta + x1
		x2 = [-e1[2] , e1[2] ,-e2[2] , e2[2] ] * delta + x2

		xx1 = x1 * RSun / CDELT1 + CRPIX1
		xx2 = x2 * RSun / CDELT2 + CRPIX2

		B0_int = interpolate( B0 , xx1 , xx2 ) * 1e-4
		B1_int = interpolate( B1 , xx1 , xx2 ) * 1e-4
		B2_int = interpolate( B2 , xx1 , xx2 ) * 1e-4

		Jr[ i1,i2 ] = ( ( B0_int[1] * e2[0] + B1_int[1] * e2[1] + B2_int[1] * e2[2] ) -$
		                ( B0_int[0] * e2[0] + B1_int[0] * e2[1] + B2_int[0] * e2[2] ) ) -$
		              ( ( B0_int[3] * e1[0] + B1_int[3] * e1[1] + B2_int[3] * e1[2] ) -$
		                ( B0_int[2] * e1[0] + B1_int[2] * e1[1] + B2_int[2] * e1[2] ) )

		Jr[ i1,i2 ] /= 2 * ( delta * 696d6 ) * ( 4*!pi*1e-7 )

	endfor

	return, Jr

end