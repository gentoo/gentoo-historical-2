# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/tora/tora-1.3.11-r2.ebuild,v 1.9 2004/01/22 21:57:03 rizzo Exp $

IUSE="kde oci8"
DESCRIPTION="TOra - Toolkit For Oracle"
HOMEPAGE="http://www.globecom.se/tora/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-alpha-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"

DEPEND=">=x11-libs/qt-3.0.0
	dev-lang/perl
	kde? ( >=kde-base/kdelibs-3.1 )"

pkg_setup() {
	if [ "`use oci8`" -a ! $ORACLE_HOME ] ; then
		ewarn "ORACLE_HOME variable is not set."
		ewarn ""
		ewarn "You must install Oracle >= 8i client for Linux in"
		ewarn "order to compile TOra with Oracle support."
		ewarn ""
		ewarn "Otherwise specify -oci8 in your USE variable."
		ewarn ""
		ewarn "You can download the Oracle software from"
		ewarn "http://otn.oracle.com/software/content.html"
		die
	fi
}

src_unpack() {
	unpack ${PN}-alpha-${PV}.tar.gz
	cd ${P}
	epatch ${FILESDIR}/tora-index-segfault.patch
	epatch ${FILESDIR}/tora-clipboard.patch
}

src_compile() {
	local myconf

	use kde \
		&& myconf="$myconf --with-kde" \
		|| myconf="$myconf --without-kde"
	use oci8 || myconf="$myconf --without-oracle"

	./configure --prefix=/usr --with-mono $myconf || die "conf failed"
	emake || die "emake failed"
}

src_install() {
	dodir ${D}/usr/bin
	einstall ROOT=${D}
	dodoc LICENSE.txt BUGS INSTALL NEWS README TODO
}
