# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/coldsync/coldsync-2.2.5-r1.ebuild,v 1.4 2003/02/13 10:35:05 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A command-line tool to synchronize PalmOS PDAs with Unix workstations"
SRC_URI="http://www.coldsync.org/download/${P}.tar.gz"
HOMEPAGE="http://www.coldsync.org/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 sparc "

src_compile() {
	cd ${S}
	local myconf
	use nls || myconf="${myconf} --without-i18n"
	use perl || myconf="${myconf} --without-perl"

	patch -p1 < ${FILESDIR}/coldsync-2.2.5-gcc3.diff

	econf ${myconf} || die "configuring coldsync failed"
	make || die "couldn't make coldsync"
}

src_install() {
	make \
		PREFIX=${D}/usr \
		MANDIR=${D}/usr/share/man \
		SYSCONFDIR=${D}/etc \
		DATADIR=${D}/usr/share \
		INFODIR=${D}/usr/share/info \
		INSTALLMAN3DIR=${D}/usr/share/man/man3 \
		INSTALLSITEMAN3DIR=${D}/usr/share/man/man3 \
		INSTALLVENDORMAN3DIR=${D}/usr/share/man/man3 \
		install || die "couldn't install coldsync"

	dodoc AUTHORS Artistic ChangeLog HACKING INSTALL NEWS README TODO
}
