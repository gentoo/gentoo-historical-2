# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kdevelop/kdevelop-3.0.4.ebuild,v 1.8 2005/01/21 20:50:33 gustavoz Exp $

inherit python kde

IUSE="doc java python ruby"
DESCRIPTION="KDevelop is an easy to use C/C++ IDE for Unix. It supports KDE/Qt, GNOME, plain C and C++ projects."
SRC_URI="mirror://kde/stable/3.2.3/src/${P}.tar.bz2"
HOMEPAGE="http://www.kdevelop.org"
LICENSE="GPL-2"
KEYWORDS="x86 sparc ppc amd64"
SLOT=3

DEPEND="dev-lang/perl
	sys-devel/flex
	sys-devel/gdb
	java? ( virtual/jdk dev-java/ant )
	python? ( dev-lang/python )
	doc? ( app-doc/doxygen )"
need-kde 3.1

myconf="$myconf --with-kdelibsdoxy-dir=${KDEDIR}/share/doc/HTML/en/kdelibs-apidocs"

src_compile() {
	python_version
	use java && myconf="$myconf --enable-javasupport --with-java=`java-config --jdk-home`" || myconf="$myconf --disable-javasupport"
	use python && myconf="$myconf --enable-scripting --with-pythondir=/usr/lib/python${PYVER}" || myconf="$myconf --disable-scripting"
	use ruby || myconf="$myconf --disable-ruby"
	kde_src_compile
}

pkg_postinst() {

einfo "kdevelop can use a wide range of apps for extra functionality. This is an almost"
einfo "complete list. If you want subversion support, you must emerge it and then re-emerge"
einfo "kdevelop; all other packages can be emerged after kdevelop."
einfo
einfo "dev-util/cvs:		provide frontend for cvs version control system"
einfo "net-misc/x11-ssh-askpass		for use with SSH protected CVS systems"
einfo "dev-util/subversion		ditto for subversion."
einfo ">=dev-util/ctags-5		faster and more powerful code browsing logic"
einfo "dev-util/kdoc		tools to generate KDE-style documentation for your project"
einfo "app-misc/glimpse		index and search your project's documentation"
einfo "net-www/htdig		ditto. yet another supported indexing/searching backend"
einfo "dev-util/kdbg		kde frontend to gdb"
einfo "app-arch/rpm			supports creating RPMs of your project"
einfo "kde-base/kdebase		embed konsole kpart in kdevelop ide"
einfo "kde-base/kdesdk		use kompare widget for showing the output of diff"
einfo "dev-util/valgrind		integrates valgrind (memory debugger) commands"
einfo "app-emulation/		create and run projects for this gameboy"
einfo "	visualboyadvance	/gameboy color/gameboy advance emulator"
einfo
einfo "Support for GNU-style make, tmake, qmake and probably jam and other systems is included."
einfo "There is also php, fortran, etc. support - use your favourite package, I suppose."

}

