# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/esearch/esearch-0.7.1-r5.ebuild,v 1.1 2008/12/30 05:29:12 fuzzyray Exp $

inherit eutils

DESCRIPTION="Replacement for 'emerge --search' with search-index"
HOMEPAGE="http://david-peter.de/esearch.html"
SRC_URI="http://david-peter.de/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
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
	epatch "${FILESDIR}/97462-esearch-metadata.patch" || die "Failed to patch sources!"
	epatch "${FILESDIR}/97969-ignore-missing-ebuilds.patch" || die "Failed to patch sources!"
	epatch "${FILESDIR}/120817-unset-emergedefaultopts.patch" || die "Failed to patch sources!"
	epatch "${FILESDIR}/132548-multiple-overlay.patch" || die "Failed to patch sources!"
	epatch "${FILESDIR}/244450-deprecated.patch" || die "Failed to patch sources!"
	echo "Fixing deprecated emerge syntax."
	sed -i -e 's:/usr/bin/emerge sync:/usr/bin/emerge --sync:g' esync.py
}

src_install() {
	dodir /usr/bin/ /usr/sbin/ || die "dodir failed"

	exeinto /usr/lib/esearch
	doexe eupdatedb.py esearch.py esync.py common.py || die "doexe failed"

	dosym /usr/lib/esearch/esearch.py /usr/bin/esearch || die "dosym failed"
	dosym /usr/lib/esearch/eupdatedb.py /usr/sbin/eupdatedb || die "dosym failed"
	dosym /usr/lib/esearch/esync.py /usr/sbin/esync || die "dosym failed"

	doman en/{esearch,eupdatedb,esync}.1 || die "doman failed"
	dodoc ChangeLog "${FILESDIR}/eupdatedb.cron" || die "dodoc failed"

	if use linguas_it ; then
		insinto /usr/share/man/it/man1
		doins it/{esearch,eupdatedb,esync}.1 || die "doins failed"
	fi
}
