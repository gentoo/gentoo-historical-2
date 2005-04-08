# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/sane-backends/sane-backends-1.0.15.ebuild,v 1.10 2005/04/08 17:28:57 corsair Exp $

inherit eutils

IUSE="usb gphoto2 ipv6"

DESCRIPTION="Scanner Access Now Easy - Backends"
HOMEPAGE="http://www.sane-project.org/"

DEPEND=">=media-libs/jpeg-6b
	x86? ( sys-libs/libieee1284 )
	=sys-apps/sed-4*
	usb? ( dev-libs/libusb )
	gphoto2? ( media-gfx/gphoto2 )"

BROTHERMFCDRIVER="sane-backends-1.0.15-brothermfc.patch"

SRC_URI="ftp://ftp.mostang.com/pub/sane/${P}/${P}.tar.gz
	ftp://ftp.mostang.com/pub/sane/old-versions/${P}/${P}.tar.gz
	usb? ( mirror://gentoo/${BROTHERMFCDRIVER}.bz2 )"
SLOT="0"
LICENSE="GPL-2 public-domain"
KEYWORDS="x86 sparc ppc ppc64 amd64 alpha"


src_unpack() {
	unpack ${A}
	if use usb; then
		unpack ${BROTHERMFCDRIVER}.bz2
	fi
	cp ${FILESDIR}/linux_sg3_err.h ${S}/sanei

	cd ${S}

	epatch ${FILESDIR}/canoscan-focus.patch

	#only generate the .ps and not the fonts
	sed -i -e 's:$(DVIPS) sane.dvi -o sane.ps:$(DVIPS) sane.dvi -M1 -o sane.ps:' \
		doc/Makefile.in
	#compile errors when using NDEBUG otherwise
	sed -i -e 's:function_name:__FUNCTION__:g' backend/artec_eplus48u.c
	use usb && epatch ${WORKDIR}/${BROTHERMFCDRIVER}
	use usb && epatch ${FILESDIR}/libusbscanner-device-r1.patch
}

src_compile() {
	local myconf
	myconf="$(use_enable usb libusb) $(use_with gphoto2) $(use_enable ipv6)"
	./configure --prefix=/usr \
		--sysconfdir=/etc \
		--mandir=/usr/share/man \
		--host=${CHOST} ${myconf} || die
	make || die
	if use usb; then
		cd tools/hotplug
		grep < libsane.usermap -v '^$' > libsane.usermap.new
		mv libsane.usermap.new libsane.usermap
	fi
}

src_install () {


	make prefix=${D}/usr \
		sysconfdir=${D}/etc \
		mandir=${D}/usr/share/man \
		docdir=${D}/usr/share/doc/${PF} \
		libdir=${D}/usr/$(get_libdir) \
		install || die

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

pkg_postinst() {
	if use usb; then
		einfo "There are some problems with the hotplug script when"
		einfo "restarting hotplug with some kernel versions."
		einfo "If you have trouble, please edit"
		einfo "/etc/hotplug/usb/libusbscanner"
		einfo "and see bug #50934 for details."
	fi
}
