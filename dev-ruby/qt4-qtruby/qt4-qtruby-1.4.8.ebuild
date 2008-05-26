# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/qt4-qtruby/qt4-qtruby-1.4.8.ebuild,v 1.4 2008/05/26 11:20:21 drac Exp $

inherit toolchain-funcs eutils qt4

DESCRIPTION="Ruby bindings for QT4"
HOMEPAGE="http://rubyforge.org/projects/korundum"
SRC_URI="http://rubyforge.org/frs/download.php/21925/qt4-qtruby-1.4.8.tgz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""
RDEPEND=">=virtual/ruby-1.8
	=x11-libs/qt-4*"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.6"

SLOT="0"

QT4_BUILT_WITH_USE_CHECK="opengl dbus"

pkg_setup() {
	qt4_pkg_setup
}

src_unpack() {
	unpack $A
	cd ${S}
	epatch ${FILESDIR}/FindQwt.cmake.diff
	epatch ${FILESDIR}/libCMakeLists.diff
}

src_compile() {
	cd ${S} && cmake -DCMAKE_INSTALL_PREFIX=/usr/ . && make || die
}

src_install() {
	make DESTDIR=${D} install || die
}
