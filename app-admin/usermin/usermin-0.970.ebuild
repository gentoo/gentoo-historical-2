# Copyright 2002, Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/usermin/usermin-0.970.ebuild,v 1.2 2002/11/12 08:18:30 cretin Exp $

IUSE="ssl"

DESCRIPTION="Usermin, a web-based user administration interface"

SRC_URI="http://twtelecom.dl.sourceforge.net/sourceforge/webadmin/${P}.tar.gz"

HOMEPAGE="http://www.webmin.com/index6.html"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 sparc sparc64 alpha ppc"

DEPEND="sys-devel/perl
	ssl? ( dev-perl/Net-SSLeay )
	dev-perl/Authen-PAM"

src_install() {
	dodir /usr/libexec/usermin
	dodir /usr/sbin
	mv *.* ${D}/usr/libexec/usermin
	mv * ${D}/usr/libexec/usermin
	exeinto /etc/init.d
	newexe ${FILESDIR}/patch/usermin usermin
	exeinto /usr/libexec/usermin
	newexe ${FILESDIR}/patch/setup.sh setup.sh
	newexe ${FILESDIR}/patch/usermin-init usermin-init
	dosym /usr/libexec/usermin /etc/usermin
	dosym /usr/libexec/usermin/usermin-init /usr/sbin/usermin
}

pkg_postinst() {
	einfo "**********************************************************"
	einfo "*   NOTE: To use usermin go into a web browser and type  *"
	einfo "*    http://localhost:20000 and you will be in usermin.  *"
	einfo "**********************************************************"
	echo  ""
	einfo "***********************************************"
	einfo "*        You Need To Run The Configure        *"
	einfo "*      Configure by running usermin setup     *"
	einfo "***********************************************"
	einfo "*     To start usermin type usermin start     *"
	einfo "*      To stop usermin type usermin stop      *"
	einfo "*   To restart usermin type usermin restart   *"
	einfo "***********************************************"
}

pkg_prerm() {
	echo "Uninstalling usermin 0.970 .."
	usermin stop;
}

pkg_postrm() {
	/usr/libexec/usermin/uninstall.sh;
}