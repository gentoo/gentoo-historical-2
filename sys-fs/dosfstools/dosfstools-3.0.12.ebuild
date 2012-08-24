# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/dosfstools/dosfstools-3.0.12.ebuild,v 1.8 2012/08/24 14:06:03 jer Exp $

EAPI="3"

inherit toolchain-funcs flag-o-matic eutils

DESCRIPTION="DOS filesystem tools - provides mkdosfs, mkfs.msdos, mkfs.vfat"
HOMEPAGE="http://www.daniel-baumann.ch/software/dosfstools/"
SRC_URI="http://www.daniel-baumann.ch/software/dosfstools/${P}.tar.bz2 -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""
RESTRICT="test" # there is no test target #239071

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.0.12-name-ext.patch
	sed -i \
		-e '/^PREFIX/s:/local::' \
		-e '/^OPTFLAGS/s:=.*:=:' \
		Makefile || die
	append-lfs-flags
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install || die
	dodir /sbin
	mv "${ED}"/usr/sbin/*fsck* "${ED}"/sbin/ || die
	mv "${ED}"/usr/share/doc/{${PN},${PF}} || die
	prepalldocs
}
