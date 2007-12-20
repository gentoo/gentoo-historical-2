# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/pilot-link/pilot-link-0.12.3.ebuild,v 1.2 2007/12/20 23:08:58 philantrop Exp $

inherit perl-module java-pkg-opt-2 eutils autotools

DESCRIPTION="suite of tools for moving data between a Palm device and a desktop"
HOMEPAGE="http://www.pilot-link.org/"
SRC_URI="http://pilot-link.org/source/${P}.tar.bz2"

LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"

IUSE="perl java python png readline threads bluetooth usb debug"

BOTH_DEPEND="virtual/libiconv
	>=sys-libs/ncurses-5.6-r1
	>=dev-libs/popt-1.10.7
	perl? ( >=dev-lang/perl-5.8.8-r2 )
	python? ( >=dev-lang/python-2.4.4-r4 )
	png? ( >=media-libs/libpng-1.2.18-r1 )
	readline? ( >=sys-libs/readline-5.2_p4 )
	usb? ( >=dev-libs/libusb-0.1.12 )
	bluetooth? ( >=net-wireless/bluez-libs-3.10 )"

DEPEND="${BOTH_DEPEND}
	java? ( >=virtual/jdk-1.4 )"

RDEPEND="${BOTH_DEPEND}
	java? ( >=virtual/jre-1.4 )"

# Unfortunately, parallel compilation is badly broken. cf. bug  202857.
MAKEOPTS="${MAKEOPTS} -j1"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fixing some broken configure switches and automagic deps.
	epatch "${FILESDIR}/${PN}-0.12.2-readline.patch"
	epatch "${FILESDIR}/${PN}-0.12.2-threads.patch"
	epatch "${FILESDIR}/${P}-png.patch"

	# Upstream's check for Werror was wrong. Fixes bug 194921.
	epatch "${FILESDIR}/${PN}-0.12.2-werror_194921.patch"

	# We install the Java bindings using the eclass functions so we disable
	# their installation here.
	use java && epatch "${FILESDIR}/${P}-java-install.patch"

	# Upstream patch to fix 64-bit issues.
	epatch "${FILESDIR}/${P}-int_types.patch"

	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	# tcl/tk support is disabled as per upstream request.
	econf \
		--includedir=/usr/include/libpisock \
		--enable-conduits \
		--with-tcl=no \
		--without-included-popt \
		--disable-compile-werror \
		$(use_enable threads) \
		$(use_enable usb libusb) \
		$(use_enable debug) \
		$(use_with png libpng $(libpng-config --prefix)) \
		$(use_with bluetooth bluez) \
		$(use_with readline) \
		$(use_with perl) \
		$(use_with java) \
		$(use_with python) \
		|| die "econf failed"

	emake || die "emake failed"

	if use perl ; then
		cd "${S}/bindings/Perl"
		perl-module_src_prep
		perl-module_src_compile
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
}
