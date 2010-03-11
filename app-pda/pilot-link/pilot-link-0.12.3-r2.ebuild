# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/pilot-link/pilot-link-0.12.3-r2.ebuild,v 1.7 2010/03/11 13:19:42 ssuominen Exp $

EAPI=2

inherit perl-module java-pkg-opt-2 eutils autotools distutils

DESCRIPTION="suite of tools for moving data between a Palm device and a desktop"
HOMEPAGE="http://www.pilot-link.org/"
SRC_URI="http://pilot-link.org/source/${P}.tar.bz2"

LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"

IUSE="perl java python png readline threads bluetooth usb debug"

BOTH_DEPEND="virtual/libiconv
	>=sys-libs/ncurses-5.6-r1
	>=dev-libs/popt-1.10.7
	perl? ( >=dev-lang/perl-5.8.8-r2 )
	python? ( >=dev-lang/python-2.4.4-r4 )
	png? ( >=media-libs/libpng-1.2.40 )
	readline? ( >=sys-libs/readline-5.2_p4 )
	usb? ( virtual/libusb:0 )
	bluetooth? ( || ( >=net-wireless/bluez-libs-3.10 net-wireless/bluez ) )"

DEPEND="${BOTH_DEPEND}
	java? ( >=virtual/jdk-1.4 )"

RDEPEND="${BOTH_DEPEND}
	java? ( >=virtual/jre-1.4 )"

src_prepare() {
	# Fixing some broken configure switches and automagic deps.
	epatch "${FILESDIR}/${PN}-0.12.2-readline.patch"
	epatch "${FILESDIR}/${PN}-0.12.2-threads.patch"
	epatch "${FILESDIR}"/${P}-png.patch \
		"${FILESDIR}"/${P}-libpng14.patch

	# Upstream's check for Werror was wrong. Fixes bug 194921.
	epatch "${FILESDIR}/${PN}-0.12.2-werror_194921.patch"

	# We install the Java bindings using the eclass functions so we disable
	# their installation here.
	use java && epatch "${FILESDIR}/${P}-java-install.patch"

	# We install the Python bindings using the eclass functions so we disable
	# their makefile.am rules here
	use python && epatch  "${FILESDIR}/${P}-distutils.patch"

	# Upstream patch to fix 64-bit issues.
	epatch "${FILESDIR}/${P}-int_types.patch"

	# Fix Glibc open without mode error
	epatch "${FILESDIR}/${P}-glibc-open.patch"

	# Respect JAVACFLAGS bug #267445
	epatch "${FILESDIR}/${P}-respect-javacflags.patch"

	# libusb-compat requires you to check the return value of usb_open!
	epatch "${FILESDIR}/${P}-libusb-compat-usb_open.patch"

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	use prefix || EPREFIX=
	# tcl/tk support is disabled as per upstream request.
	econf \
		--includedir="${EPREFIX}"/usr/include/libpisock \
		--enable-conduits \
		--with-tcl=no \
		--without-included-popt \
		--disable-compile-werror \
		$(use_enable threads) \
		$(use_enable usb libusb) \
		$(use_enable debug) \
		$(use_with png libpng "${EPREFIX}"/usr) \
		$(use_with bluetooth bluez) \
		$(use_with readline) \
		$(use_with perl) \
		$(use_with java) \
		$(use_with python)
}

src_compile() {
	# Unfortunately, parallel compilation is badly broken. cf. bug  202857.
	emake -j1 || die "emake failed"

	if use perl ; then
		cd "${S}/bindings/Perl"
		perl-module_src_prep
		perl-module_src_compile
	fi

	if use python; then
		cd "${S}/bindings/Python"
		distutils_src_compile
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc ChangeLog README doc/README* doc/TODO NEWS AUTHORS || die "installing docs failed"

	if use java ; then
		cd "${S}/bindings/Java"
		java-pkg_newjar ${PN}.jar
		java-pkg_doso libjpisock.so
	fi

	if use perl ; then
		cd "${S}/bindings/Perl"
		perl-module_src_install
	fi

	if use python; then
		cd "${S}/bindings/Python"
		distutils_src_install
	fi
}

pkg_preinst() {
	perl-module_pkg_preinst
	java-pkg-opt-2_pkg_preinst
}

pkg_postinst() {
	if use python; then
		python_version
		python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages
	fi
}

pkg_postrm() {
	use python && distutils_pkg_postrm
}
