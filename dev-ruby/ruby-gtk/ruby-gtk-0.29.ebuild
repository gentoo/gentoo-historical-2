# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gtk/ruby-gtk-0.29.ebuild,v 1.6 2003/08/07 03:13:53 vapier Exp $

S=${WORKDIR}/ruby-gnome-all-${PV}/gtk
DESCRIPTION="Ruby Gtk+ bindings"
HOMEPAGE="http://ruby-gnome.sourceforge.net/"
SRC_URI="mirror://sourceforge/ruby-gnome/ruby-gnome-all-${PV}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=dev-lang/ruby-1.6.4-r1
        =x11-libs/gtk+-1.2*"

src_compile() {
	ruby extconf.rb || die "ruby extconf.rb failed"
	emake || die "emake failed"
}

src_install() {
	make install DESTDIR=${D}
	dodoc [A-Z]*
	cp -dr sample doc ${D}/usr/share/doc/${PF}
}
