# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gdkimlib/ruby-gdkimlib-0.27.ebuild,v 1.9 2003/08/07 03:10:35 vapier Exp $

S=${WORKDIR}/ruby-gnome-all-${PV}/gdkimlib
DESCRIPTION="Ruby GdkImlib bindings"
HOMEPAGE="http://ruby-gnome.sourceforge.net/"
SRC_URI="mirror://sourceforge/ruby-gnome/ruby-gnome-all-${PV}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=dev-lang/ruby-1.6.4-r1
	=x11-libs/gtk+-1.2*
	>=dev-ruby/ruby-gtk-0.27"

src_compile() {
	ruby extconf.rb || die "ruby extconf.rb failed"
	emake || die "emake failed"
}

src_install() {
	make site-install DESTDIR=${D}
	dodoc [A-Z]*
	cp -dr sample ${D}/usr/share/doc/${PF}
}
