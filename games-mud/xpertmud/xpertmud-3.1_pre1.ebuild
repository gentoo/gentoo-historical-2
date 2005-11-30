# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-mud/xpertmud/xpertmud-3.1_pre1.ebuild,v 1.1.1.1 2005/11/30 10:06:15 chriswhite Exp $

inherit kde

MY_PV="${PV/_pre/preview}"
DESCRIPTION="the eXtensible Python pErl Ruby scripTable MUD client"
HOMEPAGE="http://xpertmud.sourceforge.net/"
SRC_URI="mirror://sourceforge/xpertmud/xpertmud-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE="python ruby"

DEPEND=">=sys-devel/libperl-5.6.1
	python? ( >=dev-lang/python-2.2 )
	ruby? ( >=dev-lang/ruby-1.8.0 )
	kde-base/arts"
need-kde 3

S=${WORKDIR}/xpertmud-${MY_PV}

src_compile() {
	econf \
		$(use_with python python) \
		$(use_with ruby ruby) \
		|| die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog DESIGN NEWS README TODO
}
