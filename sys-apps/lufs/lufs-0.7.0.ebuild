# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lufs/lufs-0.7.0.ebuild,v 1.1 2002/11/01 10:29:43 aliz Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="User-mode filesystem implementation"
SRC_URI="mirror://sourceforge/lufs/${P}.tar.gz"
HOMEPAGE="http://switch.dl.sourceforge.net/sourceforge/lufs"
LICENSE="GPL-2"
DEPEND="virtual/linux-sources"

src_unpack() {
	unpack ${A}

	cd ${S}/lufsd
	mv Makefile.in Makefile.in.orig
	sed -e '416s/install-exec-hook//' Makefile.in.orig > Makefile.in

	cd ${S}/util
	mv Makefile.in Makefile.in.orig
	sed -e '332s/install-exec-hook//' Makefile.in.orig > Makefile.in

	cd ${S}/kernel2.4
	mv Makefile.in Makefile.in.orig
	sed -s '291s/install-data-hook//' Makefile.in.orig > Makefile.in
}

src_install () {
	exeinto /etc/init.d
	newexe ${FILESDIR}/${P}-init lufs

	dodoc AUTHORS COPYING ChangeLog Contributors INSTALL \
		NEWS README THANKS TODO 
	dohtml docs/lufs.html
	make DESTDIR=${D} install

	dosym /usr/bin/auto.sshfs /etc/auto.sshfs
	dosym /usr/bin/auto.ftpfs /etc/auto.ftpfs
	dosym /sbin/mount.lufs /usr/bin/lufsd
	
}

pkg_postinst() {
	id lufs || useradd -g nobody -d /home/lufs -m -s /bin/sh -c "LUFS user" lufs
}

pkg_postrm() {
	userdel lufs
}
