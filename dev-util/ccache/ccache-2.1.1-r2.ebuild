# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ccache/ccache-2.1.1-r2.ebuild,v 1.1 2003/02/25 04:36:22 zwelch Exp $

DESCRIPTION="ccache is a fast compiler cache. It is used as a front end to your
compiler to safely cache compilation output. When the same code is compiled
again the cached output is used giving a significant speedup."
SRC_URI="http://ccache.samba.org/ftp/ccache/${P}.tar.gz"
HOMEPAGE="http://ccache.samba.org/"

IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha arm"
DEPEND="virtual/glibc"

# Note: this version is designed to be auto-detected and used if
# you happen to have Portage 2.0.X+ installed.

src_compile() {
	econf || die
	emake || die
}

src_install () {
	exeinto /usr/bin
	doexe ccache
	doman ccache.1
	dodoc COPYING README

	diropts -m0755
	dodir /usr/lib/ccache/bin

	exeinto /usr/bin
	doexe ${FILESDIR}/ccache-config

	diropts -m0700
	dodir /root/.ccache
	keepdir /root/.ccache
}

pkg_preinst() {
	# Portage doesn't handle replacing a non-empty dir with a file!
	test -d /usr/bin/ccache && mv -f /usr/bin/ccache /usr/bin/ccache.backup
}

pkg_postinst() {

	if [ "${ROOT}" = "/" ]; then
		einfo "Scanning for compiler front-ends..."
		/usr/bin/ccache-config --install-links
		/usr/bin/ccache-config --install-links ${CHOST}
	else
		ewarn "Install is incomplete; you must run the following commands:"
		ewarn " # ccache-config --install-links"
		ewarn " # ccache-config --install-links ${CHOST}"
		ewarn "after booting or chrooting to ${ROOT} to complete installation."
	fi

	einfo "To use ccache with **non-Portage** C compiling, add"
	einfo "/usr/lib/ccache/bin to your path before /usr/bin.  Portage 2.0.X+"
	einfo "will automatically take advantage of ccache with no additional"
	einfo "steps.  If this is your first install of ccache, type something"
	einfo "like this to set a maximum cache size of 2GB (or similar)"
	einfo "# ccache -M 2G"
}

