# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/qof/qof-0.7.5.ebuild,v 1.3 2008/03/10 07:12:21 opfer Exp $

inherit eutils

DESCRIPTION="A Query Object Framework"
HOMEPAGE="http://qof.sourceforge.net/"
SRC_URI="mirror://sourceforge/qof/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc x86"

IUSE="doc nls sqlite"

# Raise dependency to gnome-extra/libgda-3* once it is unmasked
DEPEND="gnome-extra/libgda
	dev-libs/libxml2
	sqlite? ( =dev-db/sqlite-2* )
	doc? ( app-doc/doxygen )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Upstream not willing to remove those stupid flags...
	epatch "${FILESDIR}/${PN}-0.7.4-remove_spurious_CFLAGS.patch"
}

src_compile() {
	econf $(use_enable doc html-docs) --disable-error-on-warning $(use_enable nls) $(use_enable sqlite) $(use_enable doc doxygen) --disable-dot || die
	emake -j1 || die
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die
}
