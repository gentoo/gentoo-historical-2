# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/joe/joe-3.0-r1.ebuild,v 1.5 2004/05/18 00:27:09 kloeri Exp $

IUSE=""

inherit flag-o-matic

DESCRIPTION="A free ASCII-Text Screen Editor for UNIX"
SRC_URI="mirror://sourceforge/joe-editor/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/joe-editor/"

SLOT="0"
KEYWORDS="x86 ~ppc sparc alpha ~mips ~amd64"
LICENSE="GPL-1"

DEPEND=">=sys-libs/ncurses-5.2-r2"

PROVIDE="virtual/editor"

src_unpack() {
	unpack ${A}
	cd ${S}
	# Fix bug #50271 (joe 3.0 documentation doesn't reflect new config file location)
	for i in jmacsrc.in jpicorc.in jstarrc.in rjoerc.in joe.1.in
	do
		sed -e 's:@sysconfdir@/:@sysconfdir@/joe/:' -i ${i}
	done
}

src_compile() {
	# Bug 34609 (joe 2.9.8 editor seg-faults on 'find and replace' when compiled with -Os)
	replace-flags "-Os" "-O2"

	econf || die
	emake || die
}

src_install() {
	einstall || die
	dodoc COPYING ChangeLog HINTS INFO LIST NEWS README README.cvs TODO
}

pkg_postinst() {
	echo
	einfo "Global configuration has been moved from /etc to /etc/joe."
	einfo "You should move or remove your old configuration files."
	echo
}
