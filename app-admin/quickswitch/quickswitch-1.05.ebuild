# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/quickswitch/quickswitch-1.05.ebuild,v 1.3 2004/02/22 22:11:55 lu_zero Exp $

IUSE="ncurses"

DESCRIPTION="Utility to switch network profiles on the fly"
SRC_URI="mirror://sourceforge/quickswitch/${P}.tar.gz"
HOMEPAGE="http://quickswitch.sf.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc "

DEPEND=">=dev-lang/perl-5.6.0"
RDEPEND="ncurses? ( dev-perl/CursesWidgets )"

src_install() {
	dobin switchto
	dosed "s:/etc/switchto.conf:/etc/quickswitch/switchto.conf:" \
		/usr/bin/switchto
	dosed "s:/etc/switchto.last:/etc/quickswitch/switchto.last:" \
		/usr/bin/switchto
	if [ "`use ncurses`" ]; then
		dobin switcher
		dosed "s:/etc/switchto.conf:/etc/quickswitch/switchto.conf:" \
			/usr/bin/switcher
	fi

	dodir /etc/quickswitch
	insinto /etc/quickswitch
	newins switchto.conf switchto.conf.sample

	dosed "s:/etc/switchto.last:/etc/quickswitch/switchto.last:" \
		/etc/quickswitch/switchto.conf.sample
	dosed "s:/etc/switchto.last:/etc/quickswitch/switchto.last:" \
		/etc/quickswitch/switchto.conf
	
	dodoc README LICENSE
}
