# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/sqsh/sqsh-2.1-r1.ebuild,v 1.8 2005/01/01 17:43:36 eradicator Exp $

DESCRIPTION="Replacement for the venerable 'isql' program supplied by Sybase."
HOMEPAGE="http://www.sqsh.org/"
LICENSE="GPL-2"
DEPEND="dev-db/freetds
	readline? ( sys-libs/readline )
	X? ( virtual/x11 )
	motif? ( x11-libs/openmotif )
	virtual/libc"
SLOT="0"
SRC_URI="http://www.sqsh.org/${P}-src.tar.gz"
KEYWORDS="x86 ~amd64"
IUSE="readline X motif"

src_compile() {
	export SYBASE=/usr

	local myconf

	use readline \
		&& myconf="${myconf} --with-readline"

	use X \
		&& myconf="${myconf} --with-x"

	use motif \
		&& myconf="${myconf} --with-motif"

	./configure \
		${myconf} \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"

	patch src/config.h ${FILESDIR}/config.patch

	emake SQSHRC_GLOBAL=/etc/sqshrc || die
}

src_install () {
	make \
		DESTDIR=${D} \
		RPM_BUILD_ROOT=${D} \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install install.man || die
	# fix the silly placement of sqshrc
	mkdir -p ${D}/etc
	mv ${D}/usr/etc/sqshrc ${D}/etc/
	rmdir ${D}/usr/etc
	dodoc COPYING INSTALL README doc/*
}
