# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/esearch/esearch-0.7.ebuild,v 1.12 2005/02/25 20:14:54 vapier Exp $

DESCRIPTION="Replacement for 'emerge --search' with search-index"
HOMEPAGE="http://david-peter.de/esearch.html"
SRC_URI="http://david-peter.de/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 ppc-macos sparc x86"
IUSE=""

RDEPEND=">=dev-lang/python-2.2
	>=sys-apps/portage-2.0.50"

src_install() {
	dodir /usr/bin/ /usr/sbin/

	exeinto /usr/lib/esearch
	doexe eupdatedb.py esearch.py esync.py common.py || die "doexe failed"

	dosym /usr/lib/esearch/esearch.py /usr/bin/esearch
	dosym /usr/lib/esearch/eupdatedb.py /usr/sbin/eupdatedb
	dosym /usr/lib/esearch/esync.py /usr/sbin/esync

	doman en/{esearch,eupdatedb,esync}.1
	dodoc ChangeLog "${FILESDIR}/eupdatedb.cron"

	if use linguas_it; then
		insinto /usr/share/man/it/man1
		doins it/{esearch,eupdatedb,esync}.1
	fi
}
