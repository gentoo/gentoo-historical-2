# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-panel-applet/ruby-panel-applet-0.27.ebuild,v 1.7 2003/02/13 11:44:41 vapier Exp $

S=${WORKDIR}/ruby-gnome-all-${PV}/panel-applet
DESCRIPTION="Ruby Gnome Panel bindings"
SRC_URI="mirror://sourceforge/ruby-gnome/ruby-gnome-all-${PV}.tar.gz"
HOMEPAGE="http://ruby-gnome.sourceforge.net/"
LICENSE="Ruby"
KEYWORDS="x86"
SLOT="0"

DEPEND=">=dev-lang/ruby-1.6.4-r1
		>=dev-ruby/ruby-gnome-${PV}"

src_compile() {
	ruby extconf.rb || die "ruby extconf.rb failed"
	emake || die "emake failed"
}

src_install () {
	make site-install DESTDIR=${D}
	dodoc [A-Z]*
	cp -dr sample ${D}/usr/share/doc/${PF}
}
