# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/mingetty/mingetty-1.07.3.ebuild,v 1.1 2004/11/20 08:31:58 mrness Exp $

inherit rpm eutils

MY_WORK=${PN}-${PV%.*}
S=${WORKDIR}/${MY_WORK}
MY_P=${MY_WORK}-${PV##*.}
DESCRIPTION="A compact getty program for virtual consoles only."
SRC_URI="ftp://rpmfind.net/linux/fedora/core/3/SRPMS/${MY_P}.src.rpm"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~hppa ~amd64 ~alpha ~sparc ~ia64 ~mips ~ppc64 ~s390"
IUSE=""

RDEPEND="virtual/libc"

src_unpack() {
	rpm_src_unpack

	cd ${S}
	epatch ../mingetty-1.00-opt.patch
}

src_compile() {
	emake RPM_OPTS="${CFLAGS}" || die "compile failed"
}

src_install () {
	dodir /sbin /usr/share/man/man8
	emake DESTDIR=${D} install || die "install failed"
}
