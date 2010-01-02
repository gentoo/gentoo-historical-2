# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/aiksaurus/aiksaurus-1.2.1.ebuild,v 1.15 2010/01/02 10:54:45 fauli Exp $

inherit flag-o-matic eutils libtool

IUSE="gtk"

DESCRIPTION="A thesaurus lib, tool and database"
HOMEPAGE="http://sourceforge.net/projects/aiksaurus"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"

RDEPEND="gtk? ( >=x11-libs/gtk+-2 )"
DEPEND="${RDEPEND}
	gtk? ( dev-util/pkgconfig )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fixes bug 214248.
	epatch "${FILESDIR}/${P}-gcc43.patch"

	# Needed to make relink work on FreeBSD, without it won't install.
	# Also needed for a sane .so versionning there.
	elibtoolize
}

src_compile() {
	filter-flags -fno-exceptions

	econf $(use_with gtk) || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README* ChangeLog || die "Installing docs failed."
}
