# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/daemontools/daemontools-0.76-r4.ebuild,v 1.14 2004/09/03 21:03:23 pvdabeel Exp $

inherit eutils gcc

DESCRIPTION="Collection of tools for managing UNIX services"
HOMEPAGE="http://cr.yp.to/daemontools.html"
SRC_URI="http://cr.yp.to/daemontools/${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~x86 ppc ~sparc mips alpha arm hppa ~amd64 ~ia64 ppc64"
IUSE="selinux static"

DEPEND="virtual/libc"
RDEPEND="selinux? ( sec-policy/selinux-daemontools )"

S=${WORKDIR}/admin/${P}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-errno.patch
	epatch ${FILESDIR}/${PV}-head-1.patch

	use static && LDFLAGS="${LDFLAGS} -static"

	echo "$(gcc-getCC) ${CFLAGS}" > src/conf-cc
	echo "$(gcc-getCC) ${LDFLAGS}" > src/conf-ld
	echo ${S} > src/home
}

src_compile() {
	cd ${S}/src
	emake || die "make failed"
}

src_install() {
	einfo "Creating service directory ..."
	keepdir /service

	einfo "Installing package ..."
	cd ${S}/src
	exeinto /usr/bin
	for x in `cat ../package/commands`
	do
		doexe $x || die
	done

	dodoc CHANGES ../package/README TODO

	exeinto /etc/init.d
	newexe ${FILESDIR}/svscan-0.76-r4 svscan
}
