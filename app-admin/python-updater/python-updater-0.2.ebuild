# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/python-updater/python-updater-0.2.ebuild,v 1.17 2007/09/07 18:33:12 hawking Exp $

DESCRIPTION="Script used to remerge python packages when changing Python version."
HOMEPAGE="http://dev.gentoo.org/"
SRC_URI="http://dev.gentoo.org/~kloeri/${P}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="!<dev-lang/python-2.3.6-r2
	|| ( >=sys-apps/portage-2.1.2 sys-apps/pkgcore sys-apps/paludis )"

src_install()
{
	cd "${WORKDIR}"
	newsbin ${P} ${PN}
}
