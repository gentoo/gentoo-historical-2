# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-libart/ruby-libart-0.34.ebuild,v 1.12 2005/10/03 13:13:01 agriffis Exp $

inherit ruby

S=${WORKDIR}/ruby-gnome-all-${PV}/libart
DESCRIPTION="Ruby libart bindings"
HOMEPAGE="http://ruby-gnome.sourceforge.net/"
SRC_URI="mirror://sourceforge/ruby-gnome/ruby-gnome-all-${PV}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="alpha ~ia64 ppc ~sparc x86"
IUSE=""
USE_RUBY="ruby16 ruby18 ruby19"

DEPEND="virtual/ruby
	>=media-libs/libart_lgpl-2.3.10"

src_compile() {
	ruby extconf.rb || die "ruby extconf.rb failed"
	emake || die "emake failed"
}

src_install() {
	make site-install DESTDIR=${D}
	dodoc [A-Z]*
	cp -pPR sample ${D}/usr/share/doc/${PF}
}
