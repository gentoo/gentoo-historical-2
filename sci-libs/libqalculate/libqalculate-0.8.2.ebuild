# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libqalculate/libqalculate-0.8.2.ebuild,v 1.1 2005/10/18 17:05:17 ribosome Exp $

DESCRIPTION="A modern multi-purpose calculator library"
LICENSE="GPL-2"
HOMEPAGE="http://qalculate.sourceforge.net/"
SRC_URI="mirror://sourceforge/qalculate/${P}.tar.gz"

SLOT="0"
IUSE="nls readline"
KEYWORDS="~amd64 ~sparc ~x86"

DEPEND="dev-lang/perl
	dev-perl/XML-Parser
	>=dev-util/pkgconfig-0.12.0"

RDEPEND=">=sci-libs/cln-1.1
	dev-libs/libxml2
	>=dev-libs/glib-2.4
	>=media-gfx/gnuplot-3.7
	net-misc/wget
	nls? ( sys-devel/gettext )
	readline? ( sys-libs/readline )"

src_compile() {
	CONFIG="$(use_with readline)"
	econf ${CONFIG} || die "Configuration failed."
	emake || die "Compilation failed."
}

src_install() {
	einstall || die "Installation failed."
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	dodoc ${DOCS} || die "Documentation installation failed."
}
