# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/ash/ash-1.6.ebuild,v 1.19 2005/05/17 11:30:05 ka0ttic Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="NetBSD's lightweight bourne shell"
HOMEPAGE="http://cvsweb.netbsd.org/bsdweb.cgi/src/bin/sh/"
SRC_URI="ftp://ftp.netbsd.org/pub/NetBSD/NetBSD-release-1-6/tar_files/src/bin.tar.gz
	mirror://gentoo/dash-ash-hetio-yacc.diff.bz2
	http://cvs.gentoo.org/~seemant/dash-ash-hetio-yacc.diff.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ppc sparc ~mips alpha arm ~amd64"
IUSE="static"

DEPEND="sys-devel/pmake
	sys-apps/sed
	dev-util/yacc"

S=${WORKDIR}/bin_NetBSD-1.6release/src/bin/sh

src_unpack() {
	mkdir ${WORKDIR}/bin_NetBSD-1.6release
	(cd ${WORKDIR}/bin_NetBSD-1.6release; tar zxv --no-same-owner \
	-f ${DISTDIR}/bin.tar.gz src/bin/sh)
	epatch ${DISTDIR}/dash-ash-hetio-yacc.diff.bz2

	cd ${S}
	epatch ${FILESDIR}/${P}-gcc4.diff
}

src_compile() {
	use static && append-ldflags -static
	append-flags "-Wall -DBSD=1 -D_GNU_SOURCE -DGLOB_BROKEN \
	-DHAVE_VASPRINTF=1 -DIFS_BROKEN -DGCC_BROKEN_NG -D__COPYRIGHT\(x\)=\
	-D__RCSID\(x\)= -D_DIAGASSERT\(x\)= -fstrict-aliasing"
	# pmake name conflicts, use full path
	/usr/bin/pmake CC="$(tc-getCC)" CFLAGS:="${CFLAGS}" \
		YACC:="sh ${S}/yaccfe.sh" || die "pmake failed"
}

src_install() {
	into /
	newbin sh ash || die
	newman sh.1 ash.1
}
