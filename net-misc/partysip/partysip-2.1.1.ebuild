# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/partysip/partysip-2.1.1.ebuild,v 1.2 2004/06/10 00:50:14 agriffis Exp $

#IUSE="gdbm berkdb debug"
IUSE="debug"

DESCRIPTION="Modular and extensible SIP proxy"
HOMEPAGE="http://savannah.nongnu.org/projects/partysip/"
SRC_URI="http://osip.atosc.org/download/partysip/${P}.tar.gz"

# disable automatic striping of libs and executables
RESTRICT="nostrip"

SLOT="0"
LICENSE="LGPL-2" # not 100% about -2, but core is LGPL
KEYWORDS="~x86"

DEPEND="virtual/glibc
	>=net-libs/libosip-2.0.0"
#	gdbm?   ( >=sys-libs/gdbm-1.8.0 )
#	berkdb? ( >=sys-libs/db-4.1.20 )"

src_compile() {
	local myconf

	use debug \
		&& myconf="${myconf} --enable-debug --enable-trace" \
		|| myconf="${myconf} --disable-debug --disable-trace"

	# preference for berkdb...
	# (doesn't work atm, looks like it's always trying to use ndbm)
#	if use berkdb; then
#		myconf="${myconf} --with-db=db"
#	else
#		use gdbm \
#			&& myconf="${myconf} --with-db=gdbm"
#	fi

	econf \
		--enable-semaphore \
		--enable-sysv \
		${myconf} || die
	emake || die
}

src_install () {
	emake DESTDIR=${D} install || die

	insinto /etc/partysip
	doins conf/partysip.conf

	exeinto /etc/init.d
	newexe ${FILESDIR}/partysip.rc6 partysip

	insinto /etc/conf.d
	newins ${FILESDIR}/partysip.confd partysip

	dodoc README ChangeLog COPYING COPYING-2 TODO AUTHORS INSTALL NEWS
}
