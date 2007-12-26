# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/brltty/brltty-3.7.2-r1.ebuild,v 1.7 2007/12/26 22:11:25 phreak Exp $

inherit eutils multilib toolchain-funcs

DESCRIPTION="Daemon that provides access to the Linux/Unix console for a blind person"
HOMEPAGE="http://mielke.cc/brltty/"
SRC_URI="http://mielke.cc/brltty/releases/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="doc gpm usb X"

DEPEND=" gpm? ( >=sys-libs/gpm-1.20 )
	X? ( x11-libs/libXaw )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-nostrip.patch
	epatch "${FILESDIR}"/${P}-linux-compiler-h.patch
}

src_compile() {
	econf $(use_enable gpm) \
		$(use_with X x) \
		$(use_enable usb usb-support) \
		--prefix=/ \
		--includedir=/usr/include || die
	make || die
}

src_install() {
	make INSTALL_ROOT="${D}" install || die
	TMPDIR=../../Programs scanelf -RBXr "${D}" -o /dev/null
	libdir="$(get_libdir)"
	mkdir -p "${D}"/usr/${libdir}/
	mv "${D}"/${libdir}/*.a "${D}"/usr/${libdir}/
	gen_usr_ldscript libbrlapi.so
	cd Documents
	rm *.made
	dodoc ChangeLog README* Manual.* TODO brltty.conf
	dohtml -r Manual-HTML
	newinitd "${FILESDIR}"/brltty.rc brltty
	if use doc; then
		dodoc BrlAPI.* BrlAPIref.doxy
		dohtml -r BrlAPI-HTML BrlAPIref-HTML
	fi
}

pkg_postinst() {
	elog
	elog There is a sample config file in /usr/share/doc/${P}/brltty.conf.
	elog To use this file, uncompress it into /etc/brltty
	elog
	elog To make brltty start on boot, type this command as root:
	elog
	elog rc-update add brltty boot
}
