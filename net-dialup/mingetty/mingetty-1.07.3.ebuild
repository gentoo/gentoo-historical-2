# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/mingetty/mingetty-1.07.3.ebuild,v 1.6 2005/03/28 03:05:26 eradicator Exp $

inherit rpm eutils toolchain-funcs

MY_WORK=${PN}-${PV%.*}
S=${WORKDIR}/${MY_WORK}
MY_P=${MY_WORK}-${PV##*.}
DESCRIPTION="A compact getty program for virtual consoles only."
SRC_URI="ftp://rpmfind.net/linux/fedora/core/3/SRPMS/${MY_P}.src.rpm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 ~mips ~ppc ~ppc64 s390 sparc x86"
IUSE=""

RDEPEND=""

src_unpack() {
	rpm_src_unpack

	cd ${S}
	epatch ../mingetty-1.00-opt.patch
}

src_compile() {
	emake RPM_OPTS="${CFLAGS}" CC="$(tc-getCC)" || die "compile failed"
}

src_install () {
	dodir /sbin /usr/share/man/man8
	emake DESTDIR=${D} install || die "install failed"
}
