# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/rsync/rsync-2.5.6-r1.ebuild,v 1.4 2003/03/06 21:29:19 lu_zero Exp $

DESCRIPTION="File transfer program to keep remote files into sync"
HOMEPAGE="http://rsync.samba.org/"
SRC_URI="http://rsync.samba.org/ftp/rsync/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 hppa arm"
SLOT="0"

DEPEND="virtual/glibc
	!build? ( >=dev-libs/popt-1.5 )"

src_unpack() {
	unpack ${A}
	cd ${S}

	# change confdir to /etc/rsync rather than just /etc (the --sysconfdir
	# configure option doesn't work
	mv rsync.h rsync.h.orig
	sed <rsync.h.orig >rsync.h \
		-e 's|/etc/rsyncd.conf|/etc/rsync/rsyncd.conf|g'

	# yes, updating the man page is very important.
	mv rsyncd.conf.5 rsyncd.conf.5.orig
	sed <rsyncd.conf.5.orig >rsyncd.conf.5 \
		-e 's|/etc/rsyncd|/etc/rsync/rsyncd|g'
} 

src_compile() {
	[ -n "$(use build)" ] \
		&& POPTSETTING="--with-included-popt" \
		|| POPTSETTING=""
	[ -z "${CC}" ] && CC=gcc
	if [ "`${CC} -dumpversion | cut -d. -f1,2`" = "2.95" ] ; then
		export LDFLAGS="${LDFLAGS} -lpthread"
	fi
	econf ${POPTSETTING} || die
	use static && export LDFLAGS="${LDFLAGS} -static"
	emake || die
}

src_install() {
	einstall || die
	insinto /etc/conf.d && newins ${FILESDIR}/rsyncd.conf.d rsyncd
	exeinto /etc/init.d && newexe ${FILESDIR}/rsyncd.init.d rsyncd
	keepdir /etc/rsync
	if [ -z "`use build`" ] ; then
		dodir /etc/rsync
		dodoc COPYING NEWS OLDNEWS README TODO tech_report.tex
	else
		rm -rf ${D}/usr/share
	fi
}
