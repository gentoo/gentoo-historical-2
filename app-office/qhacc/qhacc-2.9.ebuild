# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/qhacc/qhacc-2.9.ebuild,v 1.5 2003/09/17 09:29:41 seemant Exp $

inherit kde-base libtool
need-qt 3

IUSE="mysql xml"

DESCRIPTION="Personal Finance for QT"
HOMEPAGE="http://qhacc.sourceforge.net"
SRC_URI="mirror://sourceforge/sourceforge/qhacc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~hppa ~mips ~arm"

DEPEND="mysql? ( dev-db/mysql++ )
	xml? ( dev-libs/libxml sys-libs/zlib )"

src_unpack() {

	unpack ${A}
	epatch ${FILESDIR}/${P}-gentoo.patch
	epatch ${FILESDIR}/${P}-mysqlplugin-gcc-3.3.patch

}

src_compile() {

	elibtoolize

	local myconf=""
	use mysql || myconf="${myconf} --disable-mysql"
	use xml || myconf="${myconf} --disable-xml"

	econf ${myconf} || die "configure failed"

	make || die "make failed"

}

src_install() {

	einstall || die "install failed"

	dodir /etc/qhacc
	cp -R ${S}/contrib/easysetup/* ${D}/etc/qhacc/
}

pkg_postinst() {
	einfo "Copy the files in /etc/qhacc to ~/.qhacc,
	You have to run this program with the command:
	qhacc -f ~/.qhacc/
	I prefer to put this in my .bashrc
	alias qhacc=\"qhacc -f ~/.qhacc\""
}
