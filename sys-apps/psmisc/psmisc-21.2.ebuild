# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/psmisc/psmisc-21.2.ebuild,v 1.2 2002/12/09 04:37:26 manson Exp $

DESCRIPTION="A set of tools that use the proc filesystem"
SRC_URI="mirror://sourceforge/psmisc/${P}.tar.gz"
HOMEPAGE="http://psmisc.sourceforge.net/"

KEYWORDS="~x86 ~ppc ~sparc  ~alpha"
SLOT="0"
LICENSE="GPL-2"
IUSE="nls pic"

DEPEND=">=sys-libs/ncurses-5.2-r2"

src_compile() {
	local myconf="--with-gnu-ld"
	use nls || myconf="${myconf} --disable-nls"
	use pic && myconf="${myconf} --with-pic"

	econf ${myconf}
	emake || die
}

src_install() {
	einstall
	dosym killall /usr/bin/pidof
	dodoc ABOUT-NLS AUTHORS ChangeLog NEWS README

	# some packages expect these to use /usr, others to use /
	dodir /bin
	mv ${D}/usr/bin/* ${D}/bin/
	cd ${D}/bin
	for f in * ; do
		dosym /bin/${f} /usr/bin/${f}
	done
}
