# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Aron Griffis <agriffis@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-fs/nfs-utils/nfs-utils-0.3.3-r1.ebuild,v 1.2 2002/07/08 08:13:59 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="kernel NFS client and server daemons"
SRC_URI="http://download.sourceforge.net/nfs/${P}.tar.gz"
HOMEPAGE="http://nfs.sourceforge.net/"
DEPEND="virtual/glibc tcpd? ( sys-apps/tcp-wrappers )"
RDEPEND="virtual/glibc >=net-nds/portmap-5b-r6"
LICENSE="GPL-2"

src_compile() {
	./configure \
		--prefix=/ \
		--mandir=/usr/share/man \
		--with-statedir=/var/lib/nfs \
		--enable-nfsv3 || die
	if ! use tcpd; then
		cp config.mk config.mk.orig
		sed -e "s:-lwrap::" -e "s:-DHAVE_TCP_WRAPPER::" \
			config.mk.orig > config.mk
	fi
	emake || die
}

src_install() {
	# MANDIR doesn't pick up install_prefix
	make install install_prefix=$D MANDIR=$D/usr/share/man
	insinto /etc
	doins $FILESDIR/exports
	dodoc ChangeLog COPYING README
	docinto linux-nfs
	dodoc linux-nfs/*
	# using newexe/newins instead of doexe/doins allows us to specify
	# a new filename on the command-line.
	exeinto /etc/init.d
	newexe ${FILESDIR}/nfs nfs
	newexe ${FILESDIR}/nfsmount nfsmount
	insinto /etc/conf.d
	newins ${FILESDIR}/nfs.confd nfs
	# Don't create runlevels symlinks here.  NFS is not something that
	# should be enabled by default.  Administrators can use rc-update
	# to do it themselves.
}
