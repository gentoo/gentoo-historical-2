# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/tora/tora-1.3.13.ebuild,v 1.7 2004/06/24 22:02:02 agriffis Exp $

use debug && inherit debug

IUSE="kde oci8 debug"
DESCRIPTION="TOra - Toolkit For Oracle"
HOMEPAGE="http://www.globecom.se/tora/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-alpha-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~hppa ~amd64"

DEPEND=">=x11-libs/qt-3.0.0
	dev-lang/perl
	kde? ( >=kde-base/kdelibs-3.1 )"

pkg_setup() {
	if use oci8 && [ -z "$ORACLE_HOME" ] ; then
		eerror "ORACLE_HOME variable is not set."
		eerror
		eerror "You must install Oracle >= 8i client for Linux in"
		eerror "order to compile TOra with Oracle support."
		eerror
		eerror "Otherwise specify -oci8 in your USE variable."
		eerror
		eerror "You can download the Oracle software from"
		eerror "http://otn.oracle.com/software/content.html"
		die
	fi
}

src_compile() {

	# Need to fake out Qt or we'll get sandbox problems
	REALHOME="$HOME"
	mkdir -p $T/fakehome/.kde
	mkdir -p $T/fakehome/.qt
	export HOME="$T/fakehome"
	addwrite "${QTDIR}/etc/settings"

	local myconf
	myconf="--prefix=/usr --with-mono"

	use kde \
		&& myconf="$myconf --with-kde" \
		|| myconf="$myconf --without-kde"
	use oci8 || myconf="$myconf --without-oracle"

	./configure $myconf || die "configure failed"
	emake || die "emake failed"
}

src_install() {
	#dodir ${D}/usr/bin
	einstall ROOT=${D}
	dodoc LICENSE.txt BUGS INSTALL NEWS README TODO
}
