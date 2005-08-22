# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/sane-backends/sane-backends-1.0.16.ebuild,v 1.2 2005/08/22 07:26:48 phosphan Exp $

inherit eutils

IUSE="usb gphoto2 ipv6 v4l"

DESCRIPTION="Scanner Access Now Easy - Backends"
HOMEPAGE="http://www.sane-project.org/"

DEPEND=">=media-libs/jpeg-6b
	amd64? ( sys-libs/libieee1284 )
	x86? ( sys-libs/libieee1284 )
	usb? ( dev-libs/libusb )
	gphoto2? ( media-libs/libgphoto2 )
	v4l? ( sys-kernel/linux-headers )"

BROTHERMFCDRIVER="sane-backends-1.0.15-brothermfc.patch"

SRC_URI="ftp://ftp.sane-project.org/pub/sane/${P}/${P}.tar.gz
	ftp://ftp.sane-project.org/pub/sane/old-versions/${P}/${P}.tar.gz"
	#usb? ( mirror://gentoo/${BROTHERMFCDRIVER}.bz2 )"
SLOT="0"
LICENSE="GPL-2 public-domain"
KEYWORDS="~x86 ~sparc ~ppc ~ppc64 ~amd64 ~alpha ~ia64"

# To enable specific backends, define SANE_BACKENDS with the backends you want
# in those:
#   abaton agfafocus apple artec as6e avision bh canon canon630u coolscan
#   coolscan2 dc25 dmc epson fujitsu genesys gt68xx hp leo matsushita microtek
#   microtek2 mustek mustek_usb nec pie plustek plustek_pp ricoh s9036
#   sceptre sharp sp15c st400 tamarack test teco1 teco2 teco3 umax umax_pp
#   umax1220u artec_eplus48u ma1509 ibm hp5400 u12 sm3840 snapscan niash dc210 dc240
#   pint net
#
# Note that some backends has specific dependencies which make the compilation
# fail because not supported on your current platform.
pkg_setup() {
	IEEE1284_BACKENDS="canon_pp hpsj5s mustek_pp"

	if [[ "${SANE_BACKENDS}" != "" ]]; then
		use gphoto2 && SANE_BACKENDS="${SANE_BACKENDS} gphoto2"
		use v4l && SANE_BACKENDS="${SANE_BACKENDS} v4l"
		use usb && SANE_BACKENDS="${SANE_BACKENDS} sm3600"
	fi

	if ! use x86 && ! use amd64; then
		tmp="${SANE_BACKENDS}"
		for backend in ${IEEE1284_BACKENDS}; do
			if [[ "${tmp/$backend/}" != "${SANE_BACKENDS}" ]]; then
				ewarn "You selected a backend which is disabled because it's not usable in your arch."
			fi
		done
	fi
}

src_unpack() {
	if [ -z "${SANE_BACKENDS}" ]; then
		einfo "You can use the variable SANE_BACKENDS to pick backends"
		einfo "instead of building all of them."
	fi
	unpack ${A}
	#if use usb; then
	#	unpack ${BROTHERMFCDRIVER}.bz2
	#fi
	#cp ${FILESDIR}/linux_sg3_err.h ${S}/sanei

	cd ${S}

	#epatch ${FILESDIR}/canoscan-focus.patch
	#epatch ${WORKDIR}/gt68xx-71.patch

	#only generate the .ps and not the fonts
	sed -i -e 's:$(DVIPS) sane.dvi -o sane.ps:$(DVIPS) sane.dvi -M1 -o sane.ps:' \
		doc/Makefile.in
	#compile errors when using NDEBUG otherwise
	sed -i -e 's:function_name:__FUNCTION__:g' backend/artec_eplus48u.c \
		|| die "function_name fix failed"

	if use usb; then
		#epatch ${WORKDIR}/${BROTHERMFCDRIVER}
		epatch ${FILESDIR}/libusbscanner-device-r1.patch
		:
	fi
}

src_compile() {
	SANEI_JPEG="sanei_jpeg.o" SANEI_JPEG_LO="sanei_jpeg.lo" \
	BACKENDS="${SANE_BACKENDS}" \
	econf \
		$(use_enable usb libusb) \
		$(use_with gphoto2) \
		$(use_enable ipv6) \
		${myconf} || die "econf failed"

	emake || die

	if use usb; then
		cd tools/hotplug
		grep -v '^$' libsane.usermap > libsane.usermap.new
		mv libsane.usermap.new libsane.usermap
	fi
}

src_install () {
	einstall docdir=${D}/usr/share/doc/${PF}

	if use usb; then
		cd tools/hotplug
		insinto /etc/hotplug/usb
		exeinto /etc/hotplug/usb
		doins libsane.usermap
		doexe libusbscanner
		newdoc README README.hotplug
		cd ../..
	fi

	docinto backend
	cd backend
	dodoc GUIDE *.README *.BUGS *.CHANGES *.FAQ *.TODO

	echo "SANE_CONFIG_DIR=/etc/sane.d" > 30sane
	insinto /etc/env.d
	doins 30sane

}

pkg_preinst() {
	enewgroup scanner
}

