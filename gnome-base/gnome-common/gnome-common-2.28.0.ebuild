# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-common/gnome-common-2.28.0.ebuild,v 1.4 2010/07/20 01:49:39 jer Exp $

inherit base gnome.org

DESCRIPTION="Common files for development of Gnome packages"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND=""

src_install() {
	base_src_install
	mv doc-build/README README.doc-build || die "renaming doc-build/README failed"
	dodoc ChangeLog README* doc/usage.txt || die "dodoc failed"
}
