# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/daemontools/daemontools-0.76-r4.ebuild,v 1.19 2005/02/11 05:41:02 vapier Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Collection of tools for managing UNIX services"
HOMEPAGE="http://cr.yp.to/daemontools.html"
SRC_URI="http://cr.yp.to/daemontools/${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sparc x86"
IUSE="selinux static doc"

DEPEND="virtual/libc"
RDEPEND="selinux? ( sec-policy/selinux-daemontools )
	doc? ( app-doc/daemontools-man )"

S=${WORKDIR}/admin/${P}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-errno.patch
	epatch ${FILESDIR}/${PV}-head-1.patch

	use static && LDFLAGS="${LDFLAGS} -static"

	echo "$(tc-getCC) ${CFLAGS}" > src/conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > src/conf-ld
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
	for x in `cat ../package/commands` ; do
		doexe $x || die
	done

	dodoc CHANGES ../package/README TODO

	newinitd ${FILESDIR}/svscan-0.76-r4 svscan
}

pkg_postinst() {
	einfo "You can run daemontools using the svscan init.d script,"
	einfo "or you could run it through inittab."
	einfo "To use inittab, emerge supervise-scripts and run:"
	einfo "svscan-add-to-inittab"
	einfo "Then you can hup init with the command telinit q"
}
