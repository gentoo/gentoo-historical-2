# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-common/gnome-common-2.26.0.ebuild,v 1.7 2009/12/03 16:53:41 ranger Exp $

inherit base gnome.org

DESCRIPTION="Common files for development of Gnome packages"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND=""

src_install() {
	base_src_install
	mv doc-build/README README.doc-build || die "renaming doc-build/README failed"
	dodoc ChangeLog README* doc/usage.txt || die "dodoc failed"
}
