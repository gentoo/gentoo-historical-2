# Copyright 2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/distcc/distcc-0.13.ebuild,v 1.1 2002/11/12 10:04:23 bcowan Exp $

HOMEPAGE="http://distcc.samba.org/"
SRC_URI="http://distcc.samba.org/ftp/distcc/distcc-${PV}.tar.gz"
DESCRIPTION="a program to distribute compilation of C code across several machines on a network"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="dev-libs/popt"

src_compile() {
	econf
	emake || die "emake failed"
}

src_install() {
	einstall
	exeinto /etc/init.d
	doexe ${FILESDIR}/distccd
}

