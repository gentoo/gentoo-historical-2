# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/qt4-qtruby/qt4-qtruby-1.4.9.ebuild,v 1.2 2007/07/11 05:23:08 mr_bones_ Exp $

inherit toolchain-funcs eutils qt4

DESCRIPTION="Ruby bindings for QT4"
HOMEPAGE="http://rubyforge.org/projects/korundum"
SRC_URI="http://rubyforge.org/frs/download.php/21951/${P}.tgz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""
DEPEND=">=virtual/ruby-1.8
	=x11-libs/qt-4*"
RDEPEND="${DEPEND}
	>=dev-util/cmake-2.4.6"

SLOT="0"

QT4_BUILT_WITH_USE_CHECK="opengl dbus"

pkg_setup() {
	qt4_pkg_setup
}

src_unpack() {
	unpack $A
	cd ${S}
	epatch ${FILESDIR}/libCMakeLists.diff
	epatch ${FILESDIR}/FindQwt5.cmake.diff
}

src_compile() {
	cd ${S} && cmake -DCMAKE_INSTALL_PREFIX=/usr/ . && make || die
}

src_install() {
	make DESTDIR=${D} install || die
}
