# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/acl/acl-2.0.18.ebuild,v 1.6 2002/10/20 18:54:50 vapier Exp $

S=${WORKDIR}/${P}

DESCRIPTION="XFS dump/restore utilities"

SRC_URI="ftp://oss.sgi.com/projects/xfs/download/cmd_tars/${P}.src.tar.gz"
HOMEPAGE="http://oss.sgi.com/projects/xfs"

KEYWORDS="~x86"
SLOT="0"
LICENSE="LGPL-2.1"

DEPEND="sys-apps/attr"

src_compile() {
	OPTIMIZER="${CFLAGS}"
	DEBUG=-DNDEBUG
	
	autoconf || die
	
	./configure --prefix=/usr --libexecdir=/lib || die
	
	cp include/builddefs include/builddefs.orig
	sed -e 's:^PKG_\(.*\)_DIR = \(.*\)$:PKG_\1_DIR = ${DESTDIR}\2:' \
		-e "s:/usr/share/doc/${PN}:/usr/share/doc/${PF}:" \
		-e 's:-O1::' \
		include/builddefs.orig > include/builddefs || die
	
	emake || die
}

src_install() {
	make DESTDIR=${D} install install-dev install-lib || die
	
	dosym /usr/lib/libacl.so /lib/libacl.so
	dosym /lib/libacl.la /usr/lib/libacl.la
	dosym /lib/libacl.a /usr/lib/libacl.a
}
