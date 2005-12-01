# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/aiksaurus/aiksaurus-1.2.1.ebuild,v 1.5 2005/12/01 04:20:48 tgall Exp $

inherit flag-o-matic eutils

IUSE="gtk"

DESCRIPTION="A thesaurus lib, tool and database"
HOMEPAGE="http://sourceforge.net/projects/aiksaurus"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ppc64 ~sparc ~x86"

RDEPEND="gtk? ( >=x11-libs/gtk+-2 )"
DEPEND="${RDEPEND}
	gtk? ( dev-util/pkgconfig )"

src_compile() {
	filter-flags -fno-exceptions

	econf `use_with gtk` || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS README* ChangeLog
}
