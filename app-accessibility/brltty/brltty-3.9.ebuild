# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/brltty/brltty-3.9.ebuild,v 1.1 2008/01/05 22:46:49 williamh Exp $

inherit eutils multilib toolchain-funcs

DESCRIPTION="Daemon that provides access to the Linux/Unix console for a blind person"
HOMEPAGE="http://mielke.cc/brltty/"
SRC_URI="http://mielke.cc/brltty/releases/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="bluetooth doc gpm iconv java nls ocaml python usb tcl X"

DEPEND="bluetooth? ( net-wireless/bluez-libs )
	gpm? ( >=sys-libs/gpm-1.20 )
	iconv? ( virtual/libiconv )
	java? ( virtual/jdk )
	nls? ( virtual/libintl )
	ocaml? ( >=dev-lang/ocaml-3.09.3-r1 )
	python? ( >=dev-python/pyrex-0.9.4.1 )
	tcl? ( >=dev-lang/tcl-8.4.15 )
	usb? ( >=dev-libs/libusb-0.1.12-r1 )
	X? ( x11-libs/libXaw )"

src_compile() {
	econf --prefix=/ \
		$(use_enable bluetooth) \
		$(use_enable gpm) \
		$(use_enable iconv) \
		$(use_enable java java-bindings) \
		$(use_enable nls i18n) \
		$(use_enable ocaml caml-bindings) \
		$(use_enable python python-bindings) \
		$(use_enable usb usb-support) \
		$(use_enable tcl tcl-bindings) \
		$(use_with X x) \
		--includedir=/usr/include || die
	emake || die
}

src_install() {
	make INSTALL_PROGRAM="\${INSTALL_SCRIPT}" INSTALL_ROOT="${D}" install || die


	cd Documents
	rm *.made
	dodoc ChangeLog README* Manual.* TODO
	dohtml -r Manual-HTML
	if use doc; then
		dodoc BrlAPI.* BrlAPIref.doxy
		dohtml -r BrlAPI-HTML BrlAPIref-HTML
	fi

	insinto /etc
	doins brltty.conf
	newinitd "${FILESDIR}"/brltty.rc brltty

	libdir="$(get_libdir)"
	mkdir -p "${D}"/usr/${libdir}/
	mv "${D}"/${libdir}/*.a "${D}"/usr/${libdir}/
	gen_usr_ldscript libbrlapi.so
#	TMPDIR=../../Programs scanelf -RBXr "${D}" -o /dev/null
}

pkg_postinst() {
	elog
	elog please be sure "${ROOT}"etc/brltty.conf is correct for your system.
	elog
	elog To make brltty start on boot, type this command as root:
	elog
	elog rc-update add brltty boot
}
