# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-im/licq/licq-1.0.4-r1.ebuild,v 1.2 2002/01/09 21:02:03 danarmak Exp $
. /usr/portage/eclass/inherit.eclass || die
use kde && inherit kde-base

S=${WORKDIR}/${P}

SRC_URI="http://download.sourceforge.net/licq/${P}.tar.bz2"
DESCRIPTION="KDE/QT ICQ Client with v6 support only (UDP)" 

DEPEND="$DEPEND
	ssl? ( >=dev-libs/openssl-0.9.6 )"

use kde && need-kde 2.1
use kde && need-qt 2.2.2

src_unpack() {
    cd ${WORKDIR}
    unpack ${A}
}

src_compile() {
	local first_conf

	cd ${S}
	make -f Makefile.cvs || die

	use ssl			|| first_conf = "${first_conf} --disable-openssl"
	use socks5		&& first_conf = "${first_conf} --enable-socks5"
	
	./configure --host=${CHOST} --prefix=/usr ${first_conf} || die
	emake || die

	if [ "`use qt`" ] 
	then
	    
	    export QTDIR=/usr/qt/2
	    cd plugins/qt-gui-1.0.4
	    make -f Makefile.cvs || die
	    use kde && kde_src_compile myconf
	    use kde && second_conf="${second_conf} ${myconf} --with-kde"
	    # note! watch the --prefix=/usr placement; licq itself installs into /usr, but the
	    # optional kde/qt interface (to which second_conf belogns) installs its files in 
	    # $KDE2DIR/{lib,share}/licq
	    ./configure --host=${CHOST} ${second_conf} --prefix=/usr || die
	    emake || die

	fi

}

src_install() {

	cd ${S}
	make DESTDIR=${D} install || die
	if [ "`use qt`" ] 
	then
	  cd plugins/qt-gui-1.0.4
	  make DESTDIR=${D} install || die	
	fi

}
