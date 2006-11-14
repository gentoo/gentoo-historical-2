# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/rox-base/rox-clib/rox-clib-2.1.7.ebuild,v 1.4 2006/11/14 20:55:54 lack Exp $

MY_PN="ROX-CLib"
DESCRIPTION="A library for ROX applications written in C."
HOMEPAGE="http://rox.sourceforge.net/"
SRC_URI="http://www.kerofin.demon.co.uk/rox/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=rox-base/rox-2.1.0"

S=${WORKDIR}/ROX-CLib
APPNAME=${MY_PN}

src_compile() {
	chmod 0755 AppRun

	# Most rox self-compiles have a 'read' call to wait for the user to
	# press return if the compile fails.
	# Find and remove this:
	sed -i.bak -e 's/\<read WAIT\>/#read/' AppRun

	./AppRun --compile || die "Could not make ROX-CLib. Sorry."

	# Restore the original AppRun
	mv AppRun.bak AppRun
}

src_install() {
	#  clean up source instead of remove it!
	( cd src && make clean )
	# remove silly .cvs files
	find . -name '.cvs*' | xargs rm -f >/dev/null 2>&1
	dodoc /usr/lib/${APPNAME}
	dodir /usr/lib/${APPNAME}
	cp -r . ${D}/usr/lib/${APPNAME}
	( cd Help
	dodoc Authors Changes ToDo COPYING README Versions
	)
	#finally link the html and latex dirs
	( cd ${D}/usr/share/doc/${P}
	ln -s /usr/lib/${APPNAME}/Help/rox-clib.html rox-clib.html
	ln -s /usr/lib/${APPNAME}/Help/libdir.html libdir.html
	ln -s /usr/lib/${APPNAME}/Help/html html
	)
}

pkg_postinst() {
	einfo "This version of ROX-CLib might be incompatible with the previous one";
	einfo "You might need to reemerge some of your ROX applications";
}
