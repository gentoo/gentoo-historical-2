# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/g-wrap/g-wrap-1.9.7-r1.ebuild,v 1.1 2007/01/18 17:58:45 hkbst Exp $

inherit eutils autotools

DESCRIPTION="A tool for exporting C libraries into Scheme"
HOMEPAGE="http://www.nongnu.org/g-wrap/"
SRC_URI="http://download.savannah.gnu.org/releases/g-wrap/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="glib"

DEPEND="=dev-scheme/guile-1.6*
	glib? ( =dev-libs/glib-2* )"
# seems not to work. g-wrap builds its own libffi-4.0.1
# dev-libs/libffi

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch ${FILESDIR}/glib_automagic.patch
	AT_M4DIR="${S}/m4" eautoreconf
}

#looks like parallel build and install fails occasionally
src_compile() {
	econf $(use_with glib)
	emake -j1 || die 'make failed'
}

src_install () {
	emake -j1 DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS
}
