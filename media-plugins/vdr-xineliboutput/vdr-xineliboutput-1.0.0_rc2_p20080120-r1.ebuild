# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-xineliboutput/vdr-xineliboutput-1.0.0_rc2_p20080120-r1.ebuild,v 1.2 2008/02/18 00:40:05 mr_bones_ Exp $

inherit vdr-plugin eutils multilib versionator

#MY_PV=${PV/_/}
#MY_P=${PN}-${MY_PV}
MY_PV=${PV##*_p}
MY_P=${PN}-cvs-${MY_PV}

SO_VERSION="${PV%_p*}"
SO_VERSION="${SO_VERSION/_/}"

DESCRIPTION="Video Disk Recorder Xinelib PlugIn"
HOMEPAGE="http://sourceforge.net/projects/xineliboutput/"
#SRC_URI="mirror://sourceforge/${PN#vdr-}/${MY_P}.tar.bz2"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2
	http://dev.gentoo.org/~zzam/distfiles/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="fbcon X"

RDEPEND=">=media-video/vdr-1.3.42
		>=media-libs/xine-lib-1.1.1
		media-libs/jpeg
		X? (
			x11-proto/xextproto
			x11-proto/xf86vidmodeproto
			x11-proto/xproto
		)"

DEPEND="${RDEPEND}
		sys-kernel/linux-headers
		X? (
			x11-libs/libX11
			x11-libs/libXv
			x11-libs/libXext
		)"

S=${WORKDIR}/${MY_P#vdr-}

VDR_CONFD_FILE=${FILESDIR}/confd-1.0.0_pre6
#PATCHES="${FILESDIR}/${P}-vdr-1.5.3.diff
#	${FILESDIR}/${P}-vdr-1.5.9.diff"

NO_GETTEXT_HACK=1

set_var_in_makefile() {
	local opt="XINELIBOUTPUT_$1"
	local value="$2"
	sed -i "s-^#${opt}.*= 1-${opt} = ${value}-" Makefile
}

apply_useflag() {
	local opt="$1"
	local flag="$2"
	local value=0
	use $flag && value=1
	set_var_in_makefile "$opt" "$value"
}

src_unpack() {
	vdr-plugin_src_unpack

	cd "${S}"

	XINE_LIB_VERSION=$(awk -F'"' '/XINE_VERSION/ {print $2}' /usr/include/xine.h)
	XINE_LIB_VERSION=$(get_version_component_range 1-3 "${XINE_LIB_VERSION}")
	einfo "Compiling against xine-lib version ${XINE_LIB_VERSION}"

	set_var_in_makefile VDRPLUGIN 1
	set_var_in_makefile XINEPLUGIN 1
	apply_useflag FB fbcon
	apply_useflag X11 X

	# patching makefile to work with this
	# $ rm ${outdir}/file; cp file ${outdir}/file
	# work in the sandbox
	sed -i Makefile \
		-e 's:XINEPLUGINDIR.*=.*:XINEPLUGINDIR = '"${WORKDIR}/lib:" \
		-e 's:VDRINCDIR.*=.*:VDRINCDIR ?= /usr/include:'
	mkdir -p "${WORKDIR}/lib"
}

src_install() {
	vdr-plugin_src_install

	use fbcon && dobin vdr-fbfe
	use X && dobin vdr-sxfe

	insinto ${VDR_PLUGIN_DIR}
	doins *.so.${SO_VERSION} || die "could not install sub-plugins"

	insinto /usr/$(get_libdir)/xine/plugins/${XINE_LIB_VERSION}
	doins xineplug_inp_*.so

	insinto /usr/$(get_libdir)/xine/plugins/${XINE_LIB_VERSION}/post
	doins xineplug_post_*.so
}
