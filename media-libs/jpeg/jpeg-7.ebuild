# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/jpeg/jpeg-7.ebuild,v 1.17 2009/10/26 19:38:12 armin76 Exp $

EAPI="2"

DEB_PV="7-1"
DEB_PN="libjpeg${PV}"
DEB="${DEB_PN}_${DEB_PV}"

inherit eutils libtool multilib

DESCRIPTION="Library to load, handle and manipulate images in the JPEG format"
HOMEPAGE="http://jpegclub.org/ http://www.ijg.org/"
SRC_URI="http://www.ijg.org/files/${PN}src.v${PV}.tar.gz
	mirror://debian/pool/main/libj/${DEB_PN}/${DEB}.diff.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${DEB}.diff
	cp "${FILESDIR}"/Makefile.in.extra debian/extra/Makefile.in
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-maxmem_sysconf.patch
	elibtoolize
	# hook the Debian extra dir into the normal jpeg build env
	sed -i '/all:/s:$:\n\t./config.status --file debian/extra/Makefile\n\t$(MAKE) -C debian/extra $@:' Makefile.in
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--enable-shared \
		--enable-static \
		--enable-maxmem=64
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc change.log example.c README *.txt
}

pkg_preinst() {
	has_version media-libs/jpeg-compat || preserve_old_lib /usr/$(get_libdir)/libjpeg.so.62
}

pkg_postinst() {
	has_version media-libs/jpeg-compat || preserve_old_lib_notify /usr/$(get_libdir)/libjpeg.so.62
}
