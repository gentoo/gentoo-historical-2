# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/raggle/raggle-0.2.5.ebuild,v 1.3 2004/06/25 01:10:59 agriffis Exp $

DESCRIPTION="A console RSS aggregator, written in Ruby"
HOMEPAGE="http://www.raggle.org/"
SRC_URI="http://www.raggle.org/files/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~sparc ~mips ~alpha ~hppa"
IUSE=""
DEPEND="|| ( >=dev-lang/ruby-1.8.0 dev-lang/ruby-cvs )
	dev-ruby/ncurses-ruby"

src_install() {
	dobin raggle
	doman raggle.1
	dodoc AUTHORS BUGS ChangeLog README doc/*
	insinto /usr/share/raggle/themes
	doins themes/*
}
