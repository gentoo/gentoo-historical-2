# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/jpeg/jpeg-8a.ebuild,v 1.2 2010/03/19 13:27:46 pacho Exp $

EAPI="2"

DEB_PV="7-1"
DEB_PN="libjpeg7"
DEB="${DEB_PN}_${DEB_PV}"

inherit eutils libtool multilib

DESCRIPTION="Library to load, handle and manipulate images in the JPEG format"
HOMEPAGE="http://jpegclub.org/ http://www.ijg.org/"
SRC_URI="http://www.ijg.org/files/${PN}src.v${PV}.tar.gz
	mirror://debian/pool/main/libj/${DEB_PN}/${DEB}.diff.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${DEB}.diff
	cp "${FILESDIR}"/Makefile.in.extra debian/extra/Makefile.in
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-7-maxmem_sysconf.patch
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
	preserve_old_lib /usr/$(get_libdir)/libjpeg.so.7
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/libjpeg.so.7
}
