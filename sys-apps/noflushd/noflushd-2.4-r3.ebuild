# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/sys-apps/noflushd/noflushd-2.4-r3.ebuild,v 1.3 2002/07/14 19:20:18 aliz Exp $
# Note: the daemon's current 2.4 version has nothing to do with kernel versions

A=noflushd_2.4.orig.tar.gz
S=${WORKDIR}/${P}.orig
SRC_URI="http://download.sourceforge.net/noflushd/${A}"

HOMEPAGE="http://noflushd.sourceforge.net"
KEYWORDS="x86"
SLOT="0"
LICENSE="GPL-2"
DESCRIPTION="A daemon to spin down your disks and force accesses to be cached"

DEPEND="virtual/glibc
	sys-devel/ld.so"

src_compile() {

	./configure --prefix=/usr --host=${CHOST} --mandir=/usr/share/man \
	--infodir=/usr/share/info --with-docdir=/usr/share/doc/${PF} || die

	emake || die
}

src_install () {

	dosbin src/noflushd
	doman man/noflushd.8
	dodoc README NEWS

	insinto /etc/rc.d/config ; doins ${FILESDIR}/noflushd.conf

	exeinto /etc/rc.d/init.d ; newexe ${FILESDIR}/noflushd.rc5 noflushd
}

pkg_postinst() {
    
	echo "
	Run 'rc-update add noflushd' to add it to runlevels 2 3 4.

	Edit /etc/rc.d/config/noflushd.conf to change the default spindown
	timeout and the disks handled; the defaults are 60 minutes
	and /dev/discs/disc0/disc (i.e. hda).

	Updaters from early versions of ebuild (r0): note new location
	of config file (now in /etc/rc.d/config, previously in /etc).

	WARNING:
	WARNING: Do NOT use with SCSI, unstable!
	WARNING: Has possible problems with reiserfs, too.
	WARNING:
	"
}
