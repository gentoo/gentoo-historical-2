# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/qt4-qtruby/qt4-qtruby-1.4.9-r3.ebuild,v 1.1 2007/12/31 18:35:03 caleb Exp $

inherit toolchain-funcs eutils qt4 cmake-utils

DESCRIPTION="Ruby bindings for QT4"
HOMEPAGE="http://rubyforge.org/projects/korundum"
SRC_URI="http://rubyforge.org/frs/download.php/21951/${P}.tgz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=virtual/ruby-1.8
	=x11-libs/qt-4*
	=x11-libs/qwt-5*"
RDEPEND="${DEPEND}
	>=dev-util/cmake-2.4.6"

SLOT="0"

QT4_BUILT_WITH_USE_CHECK="opengl dbus"

pkg_setup() {
	qt4_pkg_setup
}

src_unpack() {
	unpack $A
	cd "${S}"
	epatch "${FILESDIR}/libCMakeLists.diff"
	epatch "${FILESDIR}/FindQwt5.cmake.diff"
	epatch "${FILESDIR}/cmakefix.diff"
	epatch "${FILESDIR}/FindQScintilla.cmake.diff"
	epatch "${FILESDIR}/libsmoke-multilib.patch"
}
