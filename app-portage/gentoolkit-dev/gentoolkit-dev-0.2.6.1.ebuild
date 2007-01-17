# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/gentoolkit-dev/gentoolkit-dev-0.2.6.1.ebuild,v 1.4 2007/01/17 19:19:34 grobian Exp $

DESCRIPTION="Collection of developer scripts for Gentoo"
HOMEPAGE="http://www.gentoo.org/~karltk/projects/gentoolkit/"
SRC_URI="http://dev.gentoo.org/~agriffis/dist//${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=sys-apps/portage-2.0.50
	>=dev-lang/python-2.0
	>=dev-util/dialog-0.7
	>=dev-lang/perl-5.6
	>=sys-apps/grep-2.4"

src_install() {
	make DESTDIR=${D} install-gentoolkit-dev
}
