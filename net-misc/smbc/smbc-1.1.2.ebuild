# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/smbc/smbc-1.1.2.ebuild,v 1.1 2005/03/03 10:03:38 mglauche Exp $

DESCRIPTION="A text mode (ncurses) SMB network commander. Features: resume and UTF-8"
HOMEPAGE="http://smbc.airm.net/en/index.php"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls debug"

DEPEND="sys-devel/gcc
	net-fs/samba
	>=sys-devel/automake-1.8
	sys-libs/ncurses
	dev-libs/popt
	nls? ( sys-devel/gettext )"
#----------------------------------------------------------------------------
src_compile() {
	local myconf=""
	use nls && myconf="${myconf} `use_enable nls`"
	use debug && myconf="${myconf} --with-debug"
	econf  ${myconf} || die "Configuration failed"
	einfo "Configuration: ${myconf}"
	emake || die "Make failed"
}
#----------------------------------------------------------------------------
src_install() {
	make DESTDIR=${D} install || die
}

