# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lufs/lufs-0.9.3.ebuild,v 1.1 2003/02/12 22:33:06 lu_zero Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="User-mode filesystem implementation"
SRC_URI="mirror://sourceforge/lufs/${P}.tar.gz"
HOMEPAGE="http://lufs.sourceforge.net/lufs/"
LICENSE="GPL-2"
DEPEND="virtual/linux-sources"
#RDEPEND
KEYWORDS="~x86"
SLOT="0"
IUSE=""

src_unpack() {
	unpack ${A}

	cd ${S}/lufsd
	mv Makefile.in Makefile.in.orig
	sed -e 's/install-exec-hook//' Makefile.in.orig > Makefile.in || die

	cd ${S}/util
	mv Makefile.in Makefile.in.orig
	sed -e 's/install-exec-hook//' Makefile.in.orig > Makefile.in || die

	cd ${S}/kernel/Linux/2.4
	mv Makefile.in Makefile.in.orig
	sed -e 's/install-data-hook//' Makefile.in.orig > Makefile.in || die
}

src_install () {
	exeinto /etc/init.d
	newexe ${FILESDIR}/${P} lufs

	dodoc AUTHORS COPYING ChangeLog Contributors INSTALL \
		NEWS README THANKS TODO 
	dohtml docs/lufs.html
	make DESTDIR=${D} install

	dosym /usr/bin/auto.sshfs /etc/auto.sshfs
	dosym /usr/bin/auto.ftpfs /etc/auto.ftpfs
	dodir /sbin
	dosym /usr/bin/lufsd /sbin/mount.lufs
	
}

pkg_postinst() {
	id lufs 2>/dev/null || useradd -g nobody -d /home/lufs -m -s /bin/sh -c "LUFS user" lufs
}

pkg_postrm() {
	userdel lufs
}
