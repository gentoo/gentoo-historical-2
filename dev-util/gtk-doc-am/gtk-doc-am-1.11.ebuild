# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gtk-doc-am/gtk-doc-am-1.11.ebuild,v 1.11 2010/01/15 21:42:17 fauli Exp $

MY_PN="gtk-doc"
MY_P=${MY_PN}-${PV}
DESCRIPTION="Automake files from gtk-doc"
HOMEPAGE="http://www.gtk.org/gtk-doc/"
SRC_URI="mirror://gnome/sources/${MY_PN}/${PV}/${MY_P}.tar.bz2"

LICENSE="GPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}
	!<=dev-util/gtk-doc-1.10"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README TODO"

src_compile() {
	:
}

src_install() {
	insinto /usr/share/aclocal
	doins gtk-doc.m4
}
