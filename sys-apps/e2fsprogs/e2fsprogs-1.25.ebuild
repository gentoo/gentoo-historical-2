# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: System Team <system@gentoo.org>
# Author: Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/e2fsprogs/e2fsprogs-1.25.ebuild,v 1.1 2001/10/12 00:05:08 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Standard ext2 and ext3 filesystem utilities"
SRC_URI="http://prdownloads.sourceforge.net/${PN}/${P}.tar.gz"
HOMEPAGE="http://e2fsprogs.sourceforge.net/"

DEPEND="virtual/glibc nls? ( sys-devel/gettext ) sys-apps/texinfo"
RDEPEND="virtual/glibc"

src_compile() {
	local myconf
	if [ "`use nls`" ]
	then
		myconf="--enable-nls"
	else
		myconf="--disable-nls"
	fi
	./configure --host=${CHOST} --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --enable-elf-shlibs ${myconf} || die
	# Parallel make sometimes fails
	make || die
}

src_install() {
	local myopts
	myopts="${myopts} mandir=/usr/share/man infodir=/usr/share/info"

	make DESTDIR=${D} ${myopts} install || die
	make DESTDIR=${D} ${myopts} install-libs || die

	if [ "`use nls`" ]
	then
		( cd po; make DESTDIR=${D} install || die )
	fi
	dodir /sbin
	mv ${D}/usr/sbin/fsck* ${D}/sbin
	
	dodoc COPYING ChangeLog README RELEASE-NOTES SHLIBS
	docinto e2fsck
	dodoc e2fsck/ChangeLog e2fsck/CHANGES

	local i
	for i in e2p et ext2fs ss uuid
	do
		docinto lib/${i}
		dodoc lib/${i}/ChangeLog
	done
	docinto misc
	dodoc misc/ChangeLog
	docinto resize
	dodoc resize/ChangeLog
	docinto util
	dodoc util/ChangeLog
}
