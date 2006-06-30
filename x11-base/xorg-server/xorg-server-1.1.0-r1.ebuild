# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-base/xorg-server/xorg-server-1.1.0-r1.ebuild,v 1.9 2006/06/30 22:05:52 spyderous Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular multilib

OPENGL_DIR="xorg-x11"

MESA_PN="Mesa"
MESA_PV="6.5"
MESA_P="${MESA_PN}-${MESA_PV}"
MESA_SRC_P="${MESA_PN}Lib-${MESA_PV}"

PATCHES="${FILESDIR}/${PN}-1.0.2-xprint-init.patch
	${FILESDIR}/1.0.99.901-Xprint-xprintdir.patch
	${FILESDIR}/${P}-setuid.diff"

SRC_URI="${SRC_URI}
	mirror://sourceforge/mesa3d/${MESA_SRC_P}.tar.bz2
	http://xorg.freedesktop.org/snapshots/individual/xserver/${P}.tar.bz2"
DESCRIPTION="X.Org X servers"
# It's suid and has lazy bindings, so FEATURES="stricter" doesn't work
RESTRICT="stricter"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE_INPUT_DEVICES="
	input_devices_acecad
	input_devices_aiptek
	input_devices_calcomp
	input_devices_citron
	input_devices_digitaledge
	input_devices_dmc
	input_devices_dynapro
	input_devices_elo2300
	input_devices_elographics
	input_devices_evdev
	input_devices_fpit
	input_devices_hyperpen
	input_devices_jamstudio
	input_devices_joystick
	input_devices_keyboard
	input_devices_magellan
	input_devices_magictouch
	input_devices_microtouch
	input_devices_mouse
	input_devices_mutouch
	input_devices_palmax
	input_devices_penmount
	input_devices_spaceorb
	input_devices_summa
	input_devices_tek4957
	input_devices_ur98
	input_devices_vmmouse
	input_devices_void

	input_devices_synaptics
	input_devices_wacom"
IUSE_VIDEO_CARDS="
	video_cards_apm
	video_cards_ark
	video_cards_chips
	video_cards_cirrus
	video_cards_cyrix
	video_cards_dummy
	video_cards_epson
	video_cards_fbdev
	video_cards_glint
	video_cards_i128
	video_cards_i740
	video_cards_i810
	video_cards_impact
	video_cards_imstt
	video_cards_mach64
	video_cards_mga
	video_cards_neomagic
	video_cards_newport
	video_cards_nsc
	video_cards_nv
	video_cards_r128
	video_cards_radeon
	video_cards_rendition
	video_cards_s3
	video_cards_s3virge
	video_cards_savage
	video_cards_siliconmotion
	video_cards_sis
	video_cards_sisusb
	video_cards_sunbw2
	video_cards_suncg14
	video_cards_suncg3
	video_cards_suncg6
	video_cards_sunffb
	video_cards_sunleo
	video_cards_suntcx
	video_cards_tdfx
	video_cards_tga
	video_cards_trident
	video_cards_tseng
	video_cards_v4l
	video_cards_vesa
	video_cards_vga
	video_cards_via
	video_cards_vmware
	video_cards_voodoo"

#	video_cards_nvidia
#	video_cards_fglrx"
IUSE_SERVERS="dmx kdrive xorg"
IUSE="${IUSE_VIDEO_CARDS}
	${IUSE_INPUT_DEVICES}
	${IUSE_SERVERS}
	3dfx
	dri ipv6 minimal nptl sdl xprint"
RDEPEND="x11-libs/libXfont
	x11-libs/xtrans
	x11-libs/libXau
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libxkbfile
	x11-libs/libXdmcp
	x11-libs/libXmu
	x11-libs/libXrender
	x11-libs/libXi
	media-libs/freetype
	>=media-libs/mesa-6.5-r2
	media-fonts/font-adobe-75dpi
	media-fonts/font-misc-misc
	media-fonts/font-cursor-misc
	x11-misc/xbitmaps
	|| ( x11-misc/xkeyboard-config x11-misc/xkbdata )
	x11-apps/iceauth
	x11-apps/rgb
	x11-apps/xauth
	x11-apps/xinit
	app-admin/eselect-opengl
	x11-libs/libXaw
	x11-libs/libXpm
	x11-libs/libXxf86misc
	x11-libs/libXxf86vm
	!minimal? ( x11-libs/libdmx
		x11-libs/libXtst
		x11-libs/libXres )
	>=x11-libs/libxkbui-1.0.2
	x11-libs/liblbxutil
	kdrive? ( sdl? ( media-libs/libsdl ) )
	!media-video/nvidia-glx
	!x11-drivers/ati-drivers"
	# Xres is dmx-dependent, xkbui is xorgcfg-dependent
	# Xaw is dmx- and xorgcfg-dependent
	# Xpm is dmx- and xorgcfg-dependent, pulls in Xt
	# Xxf86misc and Xxf86vm are xorgcfg-dependent
	# liblbxutil is lbx- dependent
DEPEND="${RDEPEND}
	x11-proto/randrproto
	x11-proto/renderproto
	>=x11-proto/fixesproto-4
	x11-proto/damageproto
	x11-proto/xextproto
	x11-proto/xproto
	x11-proto/xf86dgaproto
	x11-proto/xf86miscproto
	x11-proto/xf86rushproto
	x11-proto/xf86vidmodeproto
	x11-proto/xf86bigfontproto
	>=x11-proto/compositeproto-0.3
	x11-proto/recordproto
	x11-proto/resourceproto
	x11-proto/videoproto
	>=x11-proto/scrnsaverproto-1.1.0
	x11-proto/evieext
	x11-proto/trapproto
	>=x11-proto/xineramaproto-1.1-r1
	x11-proto/fontsproto
	>=x11-proto/kbproto-1.0-r1
	x11-proto/inputproto
	x11-proto/bigreqsproto
	x11-proto/xcmiscproto
	>=x11-proto/glproto-1.4.6
	!minimal? ( x11-proto/dmxproto )
	dri? ( x11-proto/xf86driproto
		>=x11-libs/libdrm-2 )
	xprint? ( x11-proto/printproto
		x11-apps/mkfontdir
		x11-apps/mkfontscale )"

# Drivers
###############################################################################
###############################################################################
##                                                                           ##
##   REMEMBER TO EDIT USE.MASK FILES IF CHANGING ARCHITECTURE DEPENDENCIES   ##
##                                                                           ##
###############################################################################
###############################################################################
PDEPEND="
	xorg? ( || (
			(
				input_devices_acecad? ( >=x11-drivers/xf86-input-acecad-1.1.0 )
				input_devices_aiptek? ( >=x11-drivers/xf86-input-aiptek-1.0.1 )
				input_devices_calcomp? ( >=x11-drivers/xf86-input-calcomp-1.1.0 )
				input_devices_citron? ( >=x11-drivers/xf86-input-citron-2.2.0 )
				input_devices_digitaledge? ( >=x11-drivers/xf86-input-digitaledge-1.1.0 )
				input_devices_dmc? ( >=x11-drivers/xf86-input-dmc-1.1.0 )
				input_devices_dynapro? ( >=x11-drivers/xf86-input-dynapro-1.1.0 )
				input_devices_elo2300? ( >=x11-drivers/xf86-input-elo2300-1.1.0 )
				input_devices_elographics? ( >=x11-drivers/xf86-input-elographics-1.1.0 )
				input_devices_evdev? ( >=x11-drivers/xf86-input-evdev-1.1.1 )
				input_devices_fpit? ( >=x11-drivers/xf86-input-fpit-1.1.0 )
				input_devices_hyperpen? ( >=x11-drivers/xf86-input-hyperpen-1.1.0 )
				input_devices_jamstudio? ( >=x11-drivers/xf86-input-jamstudio-1.1.0 )
				input_devices_joystick? ( >=x11-drivers/xf86-input-joystick-1.1.0 )
				input_devices_keyboard? ( >=x11-drivers/xf86-input-keyboard-1.1.0 )
				input_devices_magellan? ( >=x11-drivers/xf86-input-magellan-1.1.0 )
				input_devices_magictouch? ( x11-drivers/xf86-input-magictouch )
				input_devices_microtouch? ( >=x11-drivers/xf86-input-microtouch-1.1.0 )
				input_devices_mouse? ( >=x11-drivers/xf86-input-mouse-1.1.0 )
				input_devices_mutouch? ( >=x11-drivers/xf86-input-mutouch-1.1.0 )
				input_devices_palmax? ( >=x11-drivers/xf86-input-palmax-1.1.0 )
				input_devices_penmount? ( >=x11-drivers/xf86-input-penmount-1.1.0 )
				input_devices_spaceorb? ( >=x11-drivers/xf86-input-spaceorb-1.1.0 )
				input_devices_summa? ( >=x11-drivers/xf86-input-summa-1.1.0 )
				input_devices_tek4957? ( >=x11-drivers/xf86-input-tek4957-1.1.0 )
				input_devices_ur98? ( >=x11-drivers/xf86-input-ur98-1.1.0 )
				input_devices_vmmouse? ( >=x11-drivers/xf86-input-vmmouse-12.4.0 )
				input_devices_void? ( >=x11-drivers/xf86-input-void-1.1.0 )

				input_devices_synaptics? ( x11-drivers/synaptics )
				input_devices_wacom? ( x11-misc/linuxwacom )
			)
			!minimal? (
				>=x11-drivers/xf86-input-acecad-1.1.0
				>=x11-drivers/xf86-input-calcomp-1.1.0
				>=x11-drivers/xf86-input-citron-2.2.0
				>=x11-drivers/xf86-input-digitaledge-1.1.0
				>=x11-drivers/xf86-input-dmc-1.1.0
				>=x11-drivers/xf86-input-dynapro-1.1.0
				>=x11-drivers/xf86-input-elo2300-1.1.0
				>=x11-drivers/xf86-input-elographics-1.1.0
				>=x11-drivers/xf86-input-fpit-1.1.0
				>=x11-drivers/xf86-input-hyperpen-1.1.0
				>=x11-drivers/xf86-input-jamstudio-1.1.0
				>=x11-drivers/xf86-input-joystick-1.1.0
				>=x11-drivers/xf86-input-keyboard-1.1.0
				>=x11-drivers/xf86-input-magellan-1.1.0
				x11-drivers/xf86-input-magictouch
				>=x11-drivers/xf86-input-microtouch-1.1.0
				>=x11-drivers/xf86-input-mouse-1.1.0
				>=x11-drivers/xf86-input-mutouch-1.1.0
				>=x11-drivers/xf86-input-palmax-1.1.0
				>=x11-drivers/xf86-input-penmount-1.1.0
				>=x11-drivers/xf86-input-spaceorb-1.1.0
				>=x11-drivers/xf86-input-summa-1.1.0
				>=x11-drivers/xf86-input-tek4957-1.1.0
				>=x11-drivers/xf86-input-void-1.1.0

				kernel_linux? (
					>=x11-drivers/xf86-input-aiptek-1.0.1
					>=x11-drivers/xf86-input-evdev-1.1.1
					>=x11-drivers/xf86-input-ur98-1.1.0
				)

				x86? ( >=x11-drivers/xf86-input-vmmouse-12.4.0
					x11-drivers/synaptics
					x11-misc/linuxwacom
				)
				x86-fbsd? ( >=x11-drivers/xf86-input-vmmouse-12.4.0 )
				amd64? ( >=x11-drivers/xf86-input-vmmouse-12.4.0
					x11-drivers/synaptics
					x11-misc/linuxwacom
				)
				ppc? ( x11-drivers/synaptics
					x11-misc/linuxwacom
				)
				ppc64? ( x11-drivers/synaptics
					x11-misc/linuxwacom
				)
			)
		)
	input_devices_synaptics? ( >=x11-drivers/synaptics-0.14.4-r2 )
	|| (
			(
				video_cards_apm? ( >=x11-drivers/xf86-video-apm-1.1.1 )
				video_cards_ark? ( >=x11-drivers/xf86-video-ark-0.6.0 )
				video_cards_chips? ( >=x11-drivers/xf86-video-chips-1.1.1 )
				video_cards_cirrus? ( >=x11-drivers/xf86-video-cirrus-1.1.0 )
				video_cards_cyrix? ( >=x11-drivers/xf86-video-cyrix-1.1.0 )
				video_cards_dummy? ( >=x11-drivers/xf86-video-dummy-0.2.0 )
				video_cards_fbdev? ( >=x11-drivers/xf86-video-fbdev-0.2.0 )
				video_cards_glint? ( >=x11-drivers/xf86-video-glint-1.1.1 )
				video_cards_i128? ( >=x11-drivers/xf86-video-i128-1.2.0 )
				video_cards_i740? ( >=x11-drivers/xf86-video-i740-1.1.0 )
				video_cards_i810? ( >=x11-drivers/xf86-video-i810-1.6.0 )
				video_cards_impact? ( >=x11-drivers/xf86-video-impact-0.2.0 )
				video_cards_imstt? ( >=x11-drivers/xf86-video-imstt-1.1.0 )
				video_cards_mach64? ( >=x11-drivers/xf86-video-ati-6.6.0 )
				video_cards_mga? ( >=x11-drivers/xf86-video-mga-1.4.1 )
				video_cards_neomagic? ( >=x11-drivers/xf86-video-neomagic-1.1.1 )
				video_cards_newport? ( >=x11-drivers/xf86-video-newport-0.2.0 )
				video_cards_nsc? ( >=x11-drivers/xf86-video-nsc-2.8.1 )
				video_cards_nv? ( >=x11-drivers/xf86-video-nv-1.1.1 )
				video_cards_r128? ( >=x11-drivers/xf86-video-ati-6.6.0 )
				video_cards_radeon? ( >=x11-drivers/xf86-video-ati-6.6.0 )
				video_cards_rendition? ( >=x11-drivers/xf86-video-rendition-4.1.0 )
				video_cards_s3? ( >=x11-drivers/xf86-video-s3-0.4.1 )
				video_cards_s3virge? ( >=x11-drivers/xf86-video-s3virge-1.9.1 )
				video_cards_savage? ( >=x11-drivers/xf86-video-savage-2.1.1 )
				video_cards_siliconmotion? ( >=x11-drivers/xf86-video-siliconmotion-1.4.1 )
				video_cards_sis? ( >=x11-drivers/xf86-video-sis-0.9.1 )
				video_cards_sisusb? ( >=x11-drivers/xf86-video-sisusb-0.8.1 )
				video_cards_sunbw2? ( >=x11-drivers/xf86-video-sunbw2-1.1.0 )
				video_cards_suncg14? ( >=x11-drivers/xf86-video-suncg14-1.1.0 )
				video_cards_suncg3? ( >=x11-drivers/xf86-video-suncg3-1.1.0 )
				video_cards_suncg6? ( >=x11-drivers/xf86-video-suncg6-1.1.0 )
				video_cards_sunffb? ( >=x11-drivers/xf86-video-sunffb-1.1.0 )
				video_cards_sunleo? ( >=x11-drivers/xf86-video-sunleo-1.1.0 )
				video_cards_suntcx? ( >=x11-drivers/xf86-video-suntcx-1.1.0 )
				video_cards_tdfx? ( >=x11-drivers/xf86-video-tdfx-1.2.1 )
				video_cards_tga? ( >=x11-drivers/xf86-video-tga-1.1.0 )
				video_cards_trident? ( >=x11-drivers/xf86-video-trident-1.2.1 )
				video_cards_tseng? ( >=x11-drivers/xf86-video-tseng-1.1.0 )
				video_cards_v4l? ( >=x11-drivers/xf86-video-v4l-0.1.1 )
				video_cards_vesa? ( >=x11-drivers/xf86-video-vesa-1.1.0 )
				video_cards_vga? ( >=x11-drivers/xf86-video-vga-4.1.0 )
				video_cards_via? ( >=x11-drivers/xf86-video-via-0.2.1 )
				video_cards_vmware? ( >=x11-drivers/xf86-video-vmware-10.13.0 )
				video_cards_voodoo? ( >=x11-drivers/xf86-video-voodoo-1.1.0 )

				video_cards_tdfx? ( 3dfx? ( >=media-libs/glide-v3-3.10 ) )
			)
			!minimal? (
				>=x11-drivers/xf86-video-dummy-0.2.0
				>=x11-drivers/xf86-video-fbdev-0.2.0

				!hppa? (
					kernel_linux? ( >=x11-drivers/xf86-video-v4l-0.1.1 )
				)

				3dfx? ( >=media-libs/glide-v3-3.10 )

				alpha? ( >=x11-drivers/xf86-video-cirrus-1.1.0
					>=x11-drivers/xf86-video-ati-6.6.0
					>=x11-drivers/xf86-video-glint-1.1.1
					>=x11-drivers/xf86-video-mga-1.4.1
					>=x11-drivers/xf86-video-nv-1.1.1
					>=x11-drivers/xf86-video-rendition-4.1.0
					>=x11-drivers/xf86-video-s3-0.4.1
					>=x11-drivers/xf86-video-s3virge-1.9.1
					>=x11-drivers/xf86-video-savage-2.1.1
					>=x11-drivers/xf86-video-siliconmotion-1.4.1
					>=x11-drivers/xf86-video-sisusb-0.8.1
					>=x11-drivers/xf86-video-tdfx-1.2.1
					>=x11-drivers/xf86-video-tga-1.1.0
					>=x11-drivers/xf86-video-vga-4.1.0
					>=x11-drivers/xf86-video-voodoo-1.1.0 )
				amd64? ( >=x11-drivers/xf86-video-apm-1.1.1
					>=x11-drivers/xf86-video-ark-0.6.0
					>=x11-drivers/xf86-video-ati-6.6.0
					>=x11-drivers/xf86-video-chips-1.1.1
					>=x11-drivers/xf86-video-cirrus-1.1.0
					>=x11-drivers/xf86-video-cyrix-1.1.0
					>=x11-drivers/xf86-video-glint-1.1.1
					>=x11-drivers/xf86-video-i128-1.2.0
					>=x11-drivers/xf86-video-i810-1.6.0
					>=x11-drivers/xf86-video-mga-1.4.1
					>=x11-drivers/xf86-video-neomagic-1.1.1
					>=x11-drivers/xf86-video-nv-1.1.1
					>=x11-drivers/xf86-video-rendition-4.1.0
					>=x11-drivers/xf86-video-s3-0.4.1
					>=x11-drivers/xf86-video-s3virge-1.9.1
					>=x11-drivers/xf86-video-savage-2.1.1
					>=x11-drivers/xf86-video-siliconmotion-1.4.1
					>=x11-drivers/xf86-video-sis-0.9.1
					>=x11-drivers/xf86-video-sisusb-0.8.1
					>=x11-drivers/xf86-video-tdfx-1.2.1
					>=x11-drivers/xf86-video-tga-1.1.0
					>=x11-drivers/xf86-video-trident-1.2.1
					>=x11-drivers/xf86-video-tseng-1.1.0
					>=x11-drivers/xf86-video-vesa-1.1.0
					>=x11-drivers/xf86-video-vga-4.1.0
					>=x11-drivers/xf86-video-via-0.2.1
					>=x11-drivers/xf86-video-vmware-10.13.0
					>=x11-drivers/xf86-video-voodoo-1.1.0 )
				arm? ( >=x11-drivers/xf86-video-ati-6.6.0
					>=x11-drivers/xf86-video-chips-1.1.1
					>=x11-drivers/xf86-video-glint-1.1.1
					>=x11-drivers/xf86-video-mga-1.4.1
					>=x11-drivers/xf86-video-nv-1.1.1
					>=x11-drivers/xf86-video-s3-0.4.1
					>=x11-drivers/xf86-video-s3virge-1.9.1
					>=x11-drivers/xf86-video-savage-2.1.1
					>=x11-drivers/xf86-video-sis-0.9.1
					>=x11-drivers/xf86-video-sisusb-0.8.1
					>=x11-drivers/xf86-video-tdfx-1.2.1
					>=x11-drivers/xf86-video-trident-1.2.1
					>=x11-drivers/xf86-video-vga-4.1.0
					>=x11-drivers/xf86-video-voodoo-1.1.0 )
				ia64? ( >=x11-drivers/xf86-video-apm-1.1.1
					>=x11-drivers/xf86-video-ark-0.6.0
					>=x11-drivers/xf86-video-ati-6.6.0
					>=x11-drivers/xf86-video-chips-1.1.1
					>=x11-drivers/xf86-video-cirrus-1.1.0
					>=x11-drivers/xf86-video-cyrix-1.1.0
					>=x11-drivers/xf86-video-glint-1.1.1
					>=x11-drivers/xf86-video-i128-1.2.0
					>=x11-drivers/xf86-video-i740-1.1.0
					>=x11-drivers/xf86-video-i810-1.6.0
					>=x11-drivers/xf86-video-imstt-1.1.0
					>=x11-drivers/xf86-video-mga-1.4.1
					>=x11-drivers/xf86-video-neomagic-1.1.1
					>=x11-drivers/xf86-video-nv-1.1.1
					>=x11-drivers/xf86-video-rendition-4.1.0
					>=x11-drivers/xf86-video-s3-0.4.1
					>=x11-drivers/xf86-video-s3virge-1.9.1
					>=x11-drivers/xf86-video-savage-2.1.1
					>=x11-drivers/xf86-video-siliconmotion-1.4.1
					>=x11-drivers/xf86-video-sis-0.9.1
					>=x11-drivers/xf86-video-sisusb-0.8.1
					>=x11-drivers/xf86-video-tdfx-1.2.1
					>=x11-drivers/xf86-video-tga-1.1.0
					>=x11-drivers/xf86-video-trident-1.2.1
					>=x11-drivers/xf86-video-tseng-1.1.0
					>=x11-drivers/xf86-video-vesa-1.1.0
					>=x11-drivers/xf86-video-vga-4.1.0
					>=x11-drivers/xf86-video-via-0.2.1
					>=x11-drivers/xf86-video-voodoo-1.1.0 )
				mips? ( >=x11-drivers/xf86-video-impact-0.2.0
					>=x11-drivers/xf86-video-newport-0.2.0 )
				ppc? ( >=x11-drivers/xf86-video-ati-6.6.0
					>=x11-drivers/xf86-video-chips-1.1.1
					>=x11-drivers/xf86-video-glint-1.1.1
					>=x11-drivers/xf86-video-imstt-1.1.0
					>=x11-drivers/xf86-video-mga-1.4.1
					>=x11-drivers/xf86-video-nv-1.1.1
					>=x11-drivers/xf86-video-s3-0.4.1
					>=x11-drivers/xf86-video-s3virge-1.9.1
					>=x11-drivers/xf86-video-savage-2.1.1
					>=x11-drivers/xf86-video-sis-0.9.1
					>=x11-drivers/xf86-video-sisusb-0.8.1
					>=x11-drivers/xf86-video-tdfx-1.2.1
					>=x11-drivers/xf86-video-trident-1.2.1
					>=x11-drivers/xf86-video-vga-4.1.0
					>=x11-drivers/xf86-video-voodoo-1.1.0 )
				ppc64? ( >=x11-drivers/xf86-video-ati-6.6.0
					>=x11-drivers/xf86-video-mga-1.4.1
					>=x11-drivers/xf86-video-nv-1.1.1
					>=x11-drivers/xf86-video-sisusb-0.8.1 )
				sparc? ( >=x11-drivers/xf86-video-ati-6.6.0
					>=x11-drivers/xf86-video-glint-1.1.1
					>=x11-drivers/xf86-video-mga-1.4.1
					>=x11-drivers/xf86-video-savage-2.1.1
					>=x11-drivers/xf86-video-sisusb-0.8.1
					>=x11-drivers/xf86-video-sunbw2-1.1.0
					>=x11-drivers/xf86-video-suncg14-1.1.0
					>=x11-drivers/xf86-video-suncg3-1.1.0
					>=x11-drivers/xf86-video-suncg6-1.1.0
					>=x11-drivers/xf86-video-sunffb-1.1.0
					>=x11-drivers/xf86-video-sunleo-1.1.0
					>=x11-drivers/xf86-video-suntcx-1.1.0
					>=x11-drivers/xf86-video-tdfx-1.2.1
					>=x11-drivers/xf86-video-voodoo-1.1.0 )
				x86? ( >=x11-drivers/xf86-video-apm-1.1.1
					>=x11-drivers/xf86-video-ark-0.6.0
					>=x11-drivers/xf86-video-ati-6.6.0
					>=x11-drivers/xf86-video-chips-1.1.1
					>=x11-drivers/xf86-video-cirrus-1.1.0
					>=x11-drivers/xf86-video-cyrix-1.1.0
					>=x11-drivers/xf86-video-glint-1.1.1
					>=x11-drivers/xf86-video-i128-1.2.0
					>=x11-drivers/xf86-video-i740-1.1.0
					>=x11-drivers/xf86-video-i810-1.6.0
					>=x11-drivers/xf86-video-imstt-1.1.0
					>=x11-drivers/xf86-video-mga-1.4.1
					>=x11-drivers/xf86-video-neomagic-1.1.1
					>=x11-drivers/xf86-video-nsc-2.8.1
					>=x11-drivers/xf86-video-nv-1.1.1
					>=x11-drivers/xf86-video-rendition-4.1.0
					>=x11-drivers/xf86-video-s3-0.4.1
					>=x11-drivers/xf86-video-s3virge-1.9.1
					>=x11-drivers/xf86-video-savage-2.1.1
					>=x11-drivers/xf86-video-siliconmotion-1.4.1
					>=x11-drivers/xf86-video-sis-0.9.1
					>=x11-drivers/xf86-video-sisusb-0.8.1
					>=x11-drivers/xf86-video-tdfx-1.2.1
					>=x11-drivers/xf86-video-tga-1.1.0
					>=x11-drivers/xf86-video-trident-1.2.1
					>=x11-drivers/xf86-video-tseng-1.1.0
					>=x11-drivers/xf86-video-vesa-1.1.0
					>=x11-drivers/xf86-video-vga-4.1.0
					>=x11-drivers/xf86-video-via-0.2.1
					>=x11-drivers/xf86-video-vmware-10.13.0
					>=x11-drivers/xf86-video-voodoo-1.1.0 )
				x86-fbsd? (
					>=x11-drivers/xf86-video-vmware-10.13.0 )
			)
		) )"
LICENSE="${LICENSE} MIT"

pkg_setup() {
	use minimal || ensure_a_server_is_building

	# localstatedir is used for the log location; we need to override the default
	# from ebuild.sh
	# sysconfdir is used for the xorg.conf location; same applies

	# --enable-xorg needed because darwin defaults off
	# --enable-install-setuid needed because sparcs default off

	# SDL only available in kdrive build
	if use kdrive && use sdl; then
		conf_opts="${conf_opts} --enable-xsdl"
	else
		conf_opts="${conf_opts} --disable-xsdl"
	fi

	# Only Xorg and Xgl support this, and we won't build Xgl
	# until it merges to trunk
	if use xorg; then
		conf_opts="${conf_opts} --with-mesa-source=${WORKDIR}/${MESA_P}"
	fi

	CONFIGURE_OPTIONS="
		$(use_enable ipv6)
		$(use_enable dmx)
		$(use_enable kdrive)
		$(use_enable !minimal xvfb)
		$(use_enable !minimal xnest)
		$(use_enable dri)
		$(use_enable xorg)
		$(use_enable xprint)
		$(use_enable nptl glx-tls)
		--sysconfdir=/etc/X11
		--localstatedir=/var
		--enable-install-setuid
		--with-default-font-path=/usr/share/fonts/misc,/usr/share/fonts/75dpi,/usr/share/fonts/100dpi,/usr/share/fonts/TTF,/usr/share/fonts/Type1
		${conf_opts}"

	local diemsg="You must build xorg-server and mesa with the same nptl USE setting."
	if built_with_use media-libs/mesa nptl; then
		use nptl || die "${diemsg}"
	else
		use nptl && die "${diemsg}"
	fi

	# (#121394) Causes window corruption
	filter-flags -fweb

	# Nothing else provides new enough glxtokens.h
	ewarn "Forcing on xorg-x11 for new enough glxtokens.h..."
	OLD_IMPLEM="$(eselect opengl show)"
	eselect opengl set --impl-headers ${OPENGL_DIR}
}

src_unpack() {
	x-modular_specs_check
	x-modular_dri_check
	x-modular_unpack_source
	x-modular_patch_source

	# Set up kdrive servers to build
	if use kdrive; then
		einfo "Removing unused kdrive drivers ..."
		for card in ${IUSE_VIDEO_CARDS}; do
			# (bug #136370) Radeon needs fbdev and vesa
			if use video_cards_radeon; then
				if [[ ${card} = video_cards_fbdev ]] \
					|| [[ ${card} = video_cards_vesa ]]; then
					continue
				fi
			fi

			real_card=${card#video_cards_}

			# Differences between VIDEO_CARDS name and kdrive server name
			real_card=${real_card/glint/pm2}
			real_card=${real_card/radeon/ati}
			real_card=${real_card/nv/nvidia}
			real_card=${real_card/siliconmotion/smi}
			real_card=${real_card/%sis/sis300}
			if ! use ${card}; then
				ebegin "  ${real_card}"
				sed -i \
					-e "s:\b${real_card}\b::g" \
					${S}/hw/kdrive/Makefile.am \
					|| die "sed of ${real_card} failed"
				eend
			fi

		done

		# smi and via are the only things on line 2. If line 2 ends up blank,
		# we need to get rid of the backslash at the end of line 1.
		if ! use video_cards_siliconmotion && ! use video_cards_via; then
			sed -i \
				-e "s:^\(VESA_SUBDIRS.*\)\\\:\1:g" \
				${S}/hw/kdrive/Makefile.am
		fi
	fi

	# Make sure eautoreconf gets run if we need the autoconf/make
	# changes.
	if [[ ${SNAPSHOT} != "yes" ]]; then
		if use kdrive || use xprint; then
			eautoreconf
		fi
	fi
	x-modular_reconf_source
}

src_install() {
	x-modular_src_install

	dynamic_libgl_install

	server_based_install
}

pkg_postinst() {
	switch_opengl_implem
}

pkg_postrm() {
	# Get rid of module dir to ensure opengl-update works properly
	if ! has_version x11-base/xorg-server; then
		if [ -e ${ROOT}/usr/$(get_libdir)/xorg/modules ]; then
			rm -rf ${ROOT}/usr/$(get_libdir)/xorg/modules
		fi
	fi
}

dynamic_libgl_install() {
	# next section is to setup the dynamic libGL stuff
	ebegin "Moving GL files for dynamic switching"
		dodir /usr/$(get_libdir)/opengl/${OPENGL_DIR}/extensions
		local x=""
		for x in ${D}/usr/$(get_libdir)/xorg/modules/extensions/libglx*; do
			if [ -f ${x} -o -L ${x} ]; then
				mv -f ${x} ${D}/usr/$(get_libdir)/opengl/${OPENGL_DIR}/extensions
			fi
		done
	eend 0
}

server_based_install() {
	use xprint && xprint_src_install

	if ! use xorg; then
		rm ${D}/usr/share/man/man1/Xserver.1x \
			${D}/usr/$(get_libdir)/xserver/SecurityPolicy \
			${D}/usr/$(get_libdir)/pkgconfig/xorg-server.pc \
			${D}/usr/share/man/man1/Xserver.1x
	fi
}

switch_opengl_implem() {
		# Switch to the xorg implementation.
		# Use new opengl-update that will not reset user selected
		# OpenGL interface ...
		echo
#		eselect opengl set --use-old ${OPENGL_DIR}
		eselect opengl set ${OLD_IMPLEM}
}

xprint_src_install() {
	# RH-style init script, we provide a wrapper
	exeinto /usr/$(get_libdir)/misc
	doexe ${S}/Xprint/etc/init.d/xprint
	# Patch init script for fonts location
	sed -e 's:/lib/X11/fonts/:/share/fonts/:g' \
		-i ${D}/usr/$(get_libdir)/misc/xprint
	# Install the wrapper
	newinitd ${FILESDIR}/xprint.init xprint
	# Install profile scripts
	insinto /etc/profile.d
	doins ${S}/Xprint/etc/profile.d/xprint*
	insinto /etc/X11/xinit/xinitrc.d
	newins ${S}/Xprint/etc/Xsession.d/cde_xsessiond_xprint.sh \
		92xprint-xpserverlist.sh
	# Patch profile scripts
	sed -e "s:/bin/sh.*get_xpserverlist:/usr/$(get_libdir)/misc/xprint \
		get_xpserverlist:g" -i ${D}/etc/profile.d/xprint* \
		${D}/etc/X11/xinit/xinitrc.d/92xprint-xpserverlist.sh
	# Move profile scripts, we can't touch /etc/profile.d/ in Gentoo
	dodoc ${D}/etc/profile.d/xprint*
	rm -f ${D}/etc/profile.d/xprint*
}

ensure_a_server_is_building() {
	for server in ${IUSE_SERVERS}; do
		use ${server} && return;
	done
	eerror "You need to specify at least one server to build."
	eerror "Valid servers are: ${IUSE_SERVERS}."
	die "No servers were specified to build."
}
