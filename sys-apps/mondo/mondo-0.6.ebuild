# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/mondo/mondo-0.6.ebuild,v 1.1 2002/05/15 19:32:06 agenkin Exp $

DESCRIPTION="A System Health Monitor"
HOMEPAGE="http://mondo-daemon.sourceforge.net/"

DEPEND=">=sys-apps/lm_sensors-2.6.3"

SRC_URI="http://telia.dl.sourceforge.net/sourceforge/mondo-daemon/${P}.tar.gz"
S=${WORKDIR}/${P}


src_compile() {
	./configure --prefix=/usr \
		--sysconfdir=/etc \
		--mandir=/usr/share/man \
		--host=${CHOST} || die
	make || die
}

src_install () {
	make prefix=${D}/usr \
		sysconfdir=${D}/etc \
		mandir=${D}/usr/share/man \
		docdir=${D}/usr/share/doc/${PF} \
		install || die

		dodoc AUTHORS COPYING ChangeLog INSTALL README TODO

		exeinto /etc/init.d
		newexe ${FILESDIR}/mondo.sh mondo
}

pkg_postinst() {
	einfo
	einfo "The mondo system health monitor has been installed."
	einfo
	einfo "Don't forget to setup lm_sensors before starting mondo."
	einfo "Run mondo-setup or edit /etc/mondo.conf manually and run"
	einfo "'rc-update add mondo <runlevel>' to add mondo to a runlevel."
	einfo
}
