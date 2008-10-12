# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libqalculate/libqalculate-0.9.6-r1.ebuild,v 1.4 2008/10/12 15:56:42 nixnut Exp $

inherit eutils autotools

DESCRIPTION="A modern multi-purpose calculator library"
LICENSE="GPL-2"
HOMEPAGE="http://qalculate.sourceforge.net/"
SRC_URI="mirror://sourceforge/qalculate/${P}.tar.gz"

SLOT="0"
IUSE="readline"
KEYWORDS="amd64 ppc ~sparc x86"

COMMON_DEPEND=">=sci-libs/cln-1.1
	dev-libs/libxml2
	>=dev-libs/glib-2.4
	sys-libs/zlib
	readline? ( sys-libs/readline )"

DEPEND="${COMMON_DEPEND}
	>=dev-util/pkgconfig-0.12.0
	dev-util/intltool
	sys-devel/gettext"

RDEPEND="${COMMON_DEPEND}
	>=sci-visualization/gnuplot-3.7
	net-misc/wget"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-check-fix.patch
	epatch "${FILESDIR}"/${P}-cl_abort.patch
	epatch "${FILESDIR}"/${P}-cln-config.patch
	epatch "${FILESDIR}"/${P}-gcc4.3.patch
	eautoconf
}

src_compile() {
	# The CLN test is buggy and will often fail though an appropriate version
	# of the library is installed.
	CONFIG="$(use_with readline) --disable-clntest"
	econf ${CONFIG} || die "Configuration failed."
	emake || die "Compilation failed."
}

src_install() {
	einstall || die "Installation failed."
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	dodoc ${DOCS} || die "Documentation installation failed."
}
