# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/noflushd/noflushd-2.6.3.ebuild,v 1.1 2005/03/06 19:19:20 ciaranm Exp $

DESCRIPTION="A daemon to spin down your disks and force accesses to be cached"
HOMEPAGE="http://noflushd.sourceforge.net"
SRC_URI="mirror://sourceforge/noflushd/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 -ppc"
IUSE=""
SLOT="0"

DEPEND="virtual/libc"

src_compile() {
	./configure --prefix=/usr \
		--host=${CHOST} \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--with-docdir=/usr/share/doc/${PF} || die "configure problem"
	emake || die "compile problem"
}

src_install () {
	dosbin src/noflushd
	doman man/noflushd.8
	dodoc README NEWS

	exeinto /etc/init.d ; newexe ${FILESDIR}/noflushd.rc6 noflushd
	insinto /etc/conf.d ; newins ${FILESDIR}/noflushd.confd noflushd
}

pkg_postinst() {
	einfo 'Run "rc-update add noflushd default" to add it to the'
	einfo "default runlevel."

	ewarn "noflushd works with IDE devices only."
	ewarn "It has possible problems with reiserfs, too."
}
