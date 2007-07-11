# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/qt4-qtruby/qt4-qtruby-1.4.7.ebuild,v 1.3 2007/07/11 05:23:08 mr_bones_ Exp $

inherit toolchain-funcs eutils

DESCRIPTION="Ruby bindings for QT4"
HOMEPAGE="http://rubyforge.org/projects/korundum"
SRC_URI="http://rubyforge.org/frs/download.php/14263/qt4-qtruby-1.4.7.tgz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""
DEPEND=">=virtual/ruby-1.8
	=x11-libs/qt-4*"

SLOT="0"

src_unpack() {
	unpack $A
	cd ${S}
	epatch ${FILESDIR}/${P}.diff
}

src_compile() {
	myconf="--with-qt-dir=/usr --with-qt-libraries=/usr/$(get_libdir)/qt4 --with-qt-includes=/usr/include/qt4"
	myconf="${myconf} --with-threshold=5"
	econf ${myconf} || die
	emake -j1 || die
}

src_install() {
	make DESTDIR=${D} install || die
}
