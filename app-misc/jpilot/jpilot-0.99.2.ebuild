# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-misc/jpilot/jpilot-0.99.2.ebuild,v 1.4 2002/07/11 06:30:16 drobbins Exp $

SYNCMAL="0.62.2"
MALSYNC="2.0.7"
S=${WORKDIR}/${P}
DESCRIPTION="Desktop Organizer Software for the Palm Pilot"
SRC_URI="http://jpilot.org/${P}.tar.gz http://www.tomw.org/malsync/malsync_${MALSYNC}.src.tar.gz http://people.atl.mediaone.net/jasonday/code/syncmal/jpilot-syncmal_${SYNCMAL}.tar.gz"
HOMEPAGE="http://jpilot.org/"

# In order to use the malsync plugin you'll need to refer to the homepage
# for jpilot-syncmal http://people.atl.mediaone.net/jasonday/code/syncmal/
# And you'll also need an avangto account. 

DEPEND="=x11-libs/gtk+-1.2* >=dev-libs/pilot-link-0.9.5"

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}
	unpack jpilot-syncmal_${SYNCMAL}.tar.gz
	cd ${S}/jpilot-syncmal_${SYNCMAL}
	unpack malsync_${MALSYNC}.src.tar.gz
}

src_compile() {

	if [ -z "`use nls`" ] ; then
		NLS_OPTION="--disable-nls"
	fi

	./configure --prefix=/usr --host=${CHOST} ${NLS_OPTION} || die

	# make sure we use $CFLAGS
	mv Makefile Makefile.old
	sed -e "s/-g -O2/${CFLAGS}/" Makefile.old > Makefile

	emake || die

	# build malsync plugin
	cd ${S}/jpilot-syncmal_${SYNCMAL}
	./configure --prefix=/usr --host=${CHOST} || die
	emake || die
}

src_install() {

	# work around for broken Makefile
	dodir /usr/bin

	make prefix=${D}/usr install

	insinto /usr/lib/jpilot/plugins
	doins jpilot-syncmal_${SYNCMAL}/.libs/libsyncmal.so

	dodoc README TODO UPGRADING ABOUT-NLS BUGS CHANGELOG COPYING \
	      CREDITS INSTALL
	doman docs/*.1

	newdoc jpilot-syncmal_${SYNCMAL}/ChangeLog ChangeLog.jpilot-syncmal
	newdoc jpilot-syncmal_${SYNCMAL}/README README.jpilot-syncmal
	dodoc jpilot-syncmal_${SYNCMAL}/malsync/Doc/README_AvantGo 
	dodoc jpilot-syncmal_${SYNCMAL}/malsync/Doc/README_malsync

}

