# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gtk/ruby-gtk-0.30.ebuild,v 1.8 2004/07/01 10:26:11 usata Exp $

S=${WORKDIR}/ruby-gnome-all-${PV}/gtk
DESCRIPTION="Ruby Gtk+ bindings"
HOMEPAGE="http://ruby-gnome.sourceforge.net/"
SRC_URI="mirror://sourceforge/ruby-gnome/ruby-gnome-all-${PV}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="x86 alpha"

DEPEND="virtual/ruby
	=x11-libs/gtk+-1.2*"

src_compile() {
	ruby extconf.rb || die "ruby extconf.rb failed"
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR=${D} || die "make install failed"
	dodoc [A-Z]*
	cp -dr sample doc ${D}/usr/share/doc/${PF}
}
