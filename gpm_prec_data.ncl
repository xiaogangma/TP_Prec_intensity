load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

dir1     = "/home/mxgang/obs/GPM/original/"
dir2     = "/home/mxgang/obs/GPM/diurnal/"

do mon   = 6, 8

if ((mon .eq. 7) .or. (mon .eq. 8)) then
    days  = 31
else if (mon .eq. 6) then 
    days  = 30
end if
end if

do day   = 1, days
do hh    = 0, 23

fil1     = systemfunc (" ls -1 " + dir1 + "3B-HHR.3IMERG.2019" + sprinti("%0.2i",mon) + sprinti("%0.2i",day) + \
                                          "-S" + sprinti("%0.2i",hh) + "*.V07B.nc4")
setfileoption("nc","SuppressClose",False)
f1       = addfiles   (fil1,"r")
; print(f1)
ListSetType(f1, "join")

; irpre1   = f1[:]->IRprecipitation(:,0,:,:)
; mwpre1   = f1[:]->MWprecipitation(:,0,:,:)
; unpre1   = f1[:]->precipitationUncal(:,0,:,:)
pre1     = f1[:]->precipitation(:,0,:,:)

; irpre    = 0.5*(irpre1(0,:,:) + irpre1(1,:,:))
; mwpre    = 0.5*(mwpre1(0,:,:) + mwpre1(1,:,:))
; unpre    = 0.5*(unpre1(0,:,:) + unpre1(1,:,:))
pre      = 0.5*(pre1(0,:,:) + pre1(1,:,:))

lat      = f1[0]->lat;({25:40.05})
lon      = f1[0]->lon;({70:110.05})

pre!0 = "lon"
pre!1 = "lat"
pre&lat = (/lat/)
pre&lon = (/lon/)
pre&lat@units = "degree_north"
pre&lon@units = "degree_east"

; irprec    = irpre(lat|:,lon|:)
; mwprec    = mwpre(lat|:,lon|:)
; unprec    = unpre(lat|:,lon|:)
prec      = pre(lat|:,lon|:)

prec!0  = "lat"                           
prec!1  = "lon"
prec&lat= lat
prec&lon= lon
; copy_VarCoords(irprec, mwprec)
; copy_VarCoords(irprec, unprec)
; copy_VarCoords(irprec, prec)

c    = addfile(dir2 + "gpm_hourly_prec_2019-" + sprinti("%0.2i",mon) + "-" + sprinti("%0.2i",day) + "-" + sprinti("%0.2i",hh) + ".nc", "c")
; c->IRprecipitation     = irprec
; c->MWprecipitation     = mwprec
; c->precipitationUncal  = unprec
c->precipitation       = prec
c->lat                 = lat
c->lon                 = lon

end do
end do
end do
end
