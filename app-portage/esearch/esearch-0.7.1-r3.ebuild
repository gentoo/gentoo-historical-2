# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/esearch/esearch-0.7.1-r3.ebuild,v 1.2 2007/02/11 15:13:09 truedfx Exp $

inherit eutils

DESCRIPTION="Replacement for 'emerge --search' with search-index"
HOMEPAGE="http://david-peter.de/esearch.html"
SRC_URI="http://david-peter.de/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="linguas_it"

RDEPEND=">=dev-lang/python-2.2
	>=sys-apps/portage-2.0.50"

pkg_setup() {
	if ! built_with_use dev-lang/python readline ; then
		eerror "Python has to be build with 'readline' support!"
		eerror "To do so: USE=\"readline\" emerge python"
		eerror "Or, add \"readline\" to your USE string in"
		eerror "/etc/make.conf"
		die "Works only with python readline support"
	fi
}

src_compile() {
	epatch ${FILESDIR}/97462-esearch-metadata.patch || die "Failed to patch sources!"
	epatch ${FILESDIR}/97969-ignore-missing-ebuilds.patch || die "Failed to patch sources!"
	epatch ${FILESDIR}/120817-unset-emergedefaultopts.patch || die "Failed to patch sources!"
	epatch ${FILESDIR}/105234-fix-2.1-cache.patch || die "Failed to patch sources!"
	echo "Fixing deprecated emerge syntax."
	sed -i -e 's:/usr/bin/emerge sync:/usr/bin/emerge --sync:g' esync.py
}

src_install() {
	dodir /usr/bin/ /usr/sbin/

	exeinto /usr/lib/esearch
	doexe eupdatedb.py esearch.py esync.py common.py || die "doexe failed"

	dosym /usr/lib/esearch/esearch.py /usr/bin/esearch
	dosym /usr/lib/esearch/eupdatedb.py /usr/sbin/eupdatedb
	dosym /usr/lib/esearch/esync.py /usr/sbin/esync

	doman en/{esearch,eupdatedb,esync}.1
	dodoc ChangeLog "${FILESDIR}/eupdatedb.cron"

	if use linguas_it ; then
		insinto /usr/share/man/it/man1
		doins it/{esearch,eupdatedb,esync}.1
	fi
}
