# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/keepalived/keepalived-1.1.6.ebuild,v 1.3 2004/06/24 22:38:45 agriffis Exp $

DESCRIPTION="add a strong & robust keepalive facility to the Linux Virtual Server project"
HOMEPAGE="http://keepalived.sourceforge.net/"
SRC_URI="http://keepalived.sourceforge.net/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~amd64 ~ppc"
IUSE="debug"

DEPEND="dev-libs/popt
	sys-apps/iproute2"

src_compile() {
	local myconf

	myconf="--prefix=/"

	use debug && myconf="${myconf} --enable-debug"
#	use profile && myconf="${myconf} --enable-profile"

	./configure ${myconf} || die "configure failed"
	emake || die "make failed (myconf=${myconf})"
}

src_install() {
	einstall || die

	exeinto /etc/init.d
	newexe ${FILESDIR}/init-keepalived keepalived

	dodoc doc/keepalived.conf.SYNOPSIS
	doman doc/man/man*/*
}

pkg_postinst() {
	einfo ""
	einfo "If you want Linux Virtual Server support in keepalived then you must emerge an"
	einfo "LVS patched kernel, compile with ipvs support either as a module or built into"
	einfo "the kernel, emerge the ipvsadm userland tools, and reemerge keepalived."
	einfo ""
	einfo "For debug support add USE=\"debug\" to your /etc/make.conf"
	einfo ""
}
