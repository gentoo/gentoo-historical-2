# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/dash/dash-0.4.24.ebuild,v 1.6 2004/06/24 22:23:59 agriffis Exp $

IUSE=""

MY_P="${P/-/_}"
S=${WORKDIR}/${PN}
DESCRIPTION="Debian-version of NetBSD's lightweight bourne shell"
HOMEPAGE="http://ftp.debian.org/debian/pool/main/d/dash/"
SRC_URI="http://ftp.debian.org/debian/pool/main/d/dash/${MY_P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 ppc"

DEPEND="sys-devel/pmake
	sys-apps/sed
	dev-util/yacc"

src_compile() {
	# pmake name conflicts, use full path
	/usr/bin/pmake CFLAGS:="-Wall -DBSD=1 -DSMALL -D_GNU_SOURCE -DGL \
		-DIFS_BROKEN -D__COPYRIGHT\(x\)= -D__RCSID\(x\)= \
		-D_DIAGASSERT\(x\)= -g -O2 -fstrict-aliasing" YACC:=bison
}

src_install() {
	exeinto /bin
	newexe sh dash

	newman sh.1 dash.1
	#dosym /usr/share/man/man1/ash.1.gz /usr/share/man/man1/sh.1.gz

	dodoc TOUR debian/changelog
}
