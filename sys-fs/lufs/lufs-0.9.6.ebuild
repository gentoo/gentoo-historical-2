# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/lufs/lufs-0.9.6.ebuild,v 1.2 2004/04/27 21:53:44 agriffis Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="User-mode filesystem implementation"
SRC_URI="mirror://sourceforge/lufs/${P}.tar.gz"
HOMEPAGE="http://lufs.sourceforge.net/lufs/"
LICENSE="GPL-2"
DEPEND="virtual/linux-sources"
RDEPEND=""
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="lufsusermount"

src_unpack() {
	unpack ${A}

	# Fix some sandbox failures
	cd ${S}/lufsd
	mv Makefile.in Makefile.in.orig
	sed -e 's/install-exec-hook//' Makefile.in.orig > Makefile.in || die

	cd ${S}/util
	mv Makefile.in Makefile.in.orig
	sed -e 's/install-exec-hook//' Makefile.in.orig > Makefile.in || die

	cd ${S}/kernel/Linux/2.4
	mv Makefile.in Makefile.in.orig
	sed -e 's/install-data-hook//' Makefile.in.orig > Makefile.in || die

	cd ${S}/kernel/Linux/2.5
	mv Makefile.in Makefile.in.orig
	sed -e 's/install-data-hook//' Makefile.in.orig > Makefile.in || die
}

src_install () {
	dodoc AUTHORS COPYING ChangeLog Contributors INSTALL \
		NEWS README THANKS TODO
	dohtml docs/lufs.html
	make DESTDIR=${D} install

	dosym /usr/bin/auto.sshfs /etc/auto.sshfs
	dosym /usr/bin/auto.ftpfs /etc/auto.ftpfs
	dodir /sbin
	dosym /usr/bin/lufsd /sbin/mount.lufs
	use lufsusermount && chmod +s ${D}/usr/bin/lufs{mnt,umount}
}

pkg_postinst() {
	/usr/sbin/update-modules
	if ! use lufsusermount
	then
		einfo If you want regular users to be able to mount lufs filesystems,
		einfo you need to run the following command as root:
		einfo \# chmod +s /usr/bin/lufsmnt /usr/bin/lufsumount
		einfo You can also set the lufsusermount USE flag to do this
		einfo automatically.
	fi
}

pkg_postrm() {
	/sbin/modprobe -r lufs
}
