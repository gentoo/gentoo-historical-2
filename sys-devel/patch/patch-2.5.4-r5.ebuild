# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/patch/patch-2.5.4-r5.ebuild,v 1.8 2004/06/24 22:48:48 agriffis Exp $

DESCRIPTION="Utility to apply diffs to files"
HOMEPAGE="http://www.gnu.org/software/patch/patch.html"
SRC_URI="mirror://gnu/patch/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha mips hppa"
IUSE="build static"

DEPEND="virtual/glibc"

src_compile() {
	CFLAGS="$CFLAGS -DLINUX -D_XOPEN_SOURCE=500"
	ac_cv_sys_long_file_names=yes \
		./configure --host=${CHOST} --prefix=/usr --mandir=/usr/share/man
	if ! use static; then
		emake || die "emake failed"
	else
		emake LDFLAGS=-static || die "emake failed"
	fi
}

src_install() {
	einstall
	if ! use build; then
		dodoc AUTHORS COPYING ChangeLog NEWS README
	else
		rm -rf ${D}/usr/share/man
	fi
}
