# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libelf/libelf-0.8.2.ebuild,v 1.12 2003/11/11 12:50:04 vapier Exp $

DESCRIPTION="A ELF object file access library"
SRC_URI="http://www.stud.uni-hannover.de/~michael/software/${P}.tar.gz"
HOMEPAGE="http://www.stud.uni-hannover.de/~michael/software/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha hppa"
IUSE="nls"

DEPEND="!dev-libs/elfutils
	nls? ( sys-devel/gettext )"

src_compile() {
	econf \
		`use_enable nls` \
		--enable-shared \
		${myconf} || die
	emake || die
}

src_install() {
	make prefix=${D}/usr \
		libdir=${D}usr/lib \
		includedir=${D}usr/include \
		install \
		install-compat || die
	dodoc COPYING.LIB ChangeLog VERSION README
}
