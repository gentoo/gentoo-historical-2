# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/heirloom-devtools/heirloom-devtools-070527.ebuild,v 1.2 2013/06/10 00:14:03 ryao Exp $

EAPI=4

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Original UNIX development tools"
HOMEPAGE="http://heirloom.sourceforge.net/devtools.html"
SRC_URI="http://downloads.sourceforge.net/project/heirloom/${PN}/${PV}/${P}.tar.bz2"

LICENSE="BSD BSD-4 CDDL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-shells/heirloom-sh"
RDEPEND="${DEPEND}"

src_prepare() {

	sed -i \
		-e 's:\(SHELL =\) \(.*\):\1 /bin/jsh:' \
		-e 's:\(POSIX_SHELL =\) \(.*\):\1 /bin/sh:' \
		-e "s:\(PREFIX=\)/\(.*\):\1${ED}\2:" \
		-e "s:\(SUSBIN=\)/\(.*\):\1${ED}\2:" \
		-e "s:\(LDFLAGS=\):\1${LDFLAGS}:" \
		-e 's:\(STRIP=\)\(.*\):\1true:' \
		-e "s:\(CXX = \)\(.*\):\1$(tc-getCXX):" \
		./mk.config

	epatch "${FILESDIR}/${P}-64-bit.patch"

}

src_compile() {
	emake -j1
}

pkg_postinst() {
	elog "You may want to add /usr/5bin or /usr/ucb to \$PATH"
	elog "to enable using the apps of heirloom toolchest by default."
	elog "Man pages are installed in /usr/share/man/5man/"
	elog "You may need to set \$MANPATH to access them."
}
