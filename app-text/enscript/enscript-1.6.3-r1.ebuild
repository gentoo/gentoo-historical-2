# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-text/enscript/enscript-1.6.3-r1.ebuild,v 1.1 2002/03/12 23:18:18 seemant Exp $

S=${WORKDIR}/${P}
SRC_URI="http://www.iki.fi/mtr/genscript/${P}.tar.gz"

HOMEPAGE="http:/www.gnu.org/software/enscript/enscript.html"
DESCRIPTION="GNU's enscript is a powerful text-to-postsript converter"

DEPEND="sys-devel/flex
	sys-devel/bison
	nls? ( sys-devel/gettext )"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	local myopts 
	
	if [ -z "`use nls`" ] 
	then
		myopts="--disable-nls"
	else
		myopts="--enable-nls"
	fi

	./configure 	--host=${CHOST} \
			--prefix=/usr \
			--mandir=/usr/share/man \
			--infodir=/usr/share/info \
			--sysconfdir=/etc \
			${myopts}
	assert

	emake || die
}

src_install () {
	make 	prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		sysconfdir=${D}/etc \
		install || die
	
	dodoc AUTHORS COPYING ChangeLog FAQ.html NEWS README* THANKS TODO
}

pkg_postinst() {
	echo "
	Now, customize /etc/enscript.cfg.
	"
}
