# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/rpm2targz/rpm2targz-8.0.ebuild,v 1.9 2002/10/20 18:36:20 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Convert a .rpm file to a .tar.gz archive"
SRC_URI="ftp://ftp.slackware.com/pub/slackware/slackware-${PV}/source/a/bin/rpm2targz
	ftp://ftp.slackware.com/pub/slackware/slackware-${PV}/source/a/bin/rpmoffset.c
	ftp://ftp.slackware.com/pub/slackware/slackware-${PV}/source/a/bin/rpm2targz.README"
HOMEPAGE="http://www.slackware.com/config/packages.php"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 sparc sparc64 ppc"

DEPEND="virtual/glibc"

src_unpack() {
	cd ${WORKDIR} && mkdir ${P}
	cp ${DISTDIR}/rpm2targz ${S}
	cp ${DISTDIR}/rpm2targz.README ${S}
	cp ${DISTDIR}/rpmoffset.c ${S}
}

src_compile() {
	gcc ${CFLAGS} -o rpmoffset rpmoffset.c || die
}

src_install() {
	dobin rpmoffset rpm2targz
	dodoc rpm2targz.README
}
