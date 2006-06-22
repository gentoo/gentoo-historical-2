# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gdkpixbuf/ruby-gdkpixbuf-0.34.ebuild,v 1.14 2006/06/22 22:37:57 gustavoz Exp $

inherit ruby

S=${WORKDIR}/ruby-gnome-all-${PV}/gdkpixbuf
DESCRIPTION="Ruby GdkPixbuf bindings"
HOMEPAGE="http://ruby-gnome.sourceforge.net/"
SRC_URI="mirror://sourceforge/ruby-gnome/ruby-gnome-all-${PV}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="alpha ia64 ppc sparc x86"
IUSE=""
USE_RUBY="ruby16 ruby18 ruby19"

DEPEND="virtual/ruby
	>=dev-ruby/ruby-gtk-${PV}"

src_compile() {
	ruby extconf.rb || die "ruby extconf.rb failed"
	emake || die "emake failed"
}

src_install() {
	make site-install DESTDIR=${D}
	dodoc [A-Z]*
	cp -r sample ${D}/usr/share/doc/${PF}
}
