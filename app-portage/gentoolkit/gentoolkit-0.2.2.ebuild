# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/gentoolkit/gentoolkit-0.2.2.ebuild,v 1.7 2006/06/10 18:48:32 weeve Exp $

inherit eutils python

DESCRIPTION="Collection of administration scripts for Gentoo"
HOMEPAGE="http://www.gentoo.org/proj/en/portage/tools/index.xml"
SRC_URI="mirror://gentoo/${P}.tar.gz http://dev.gentoo.org/~fuzzyray/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~m68k ~mips ppc ~ppc-macos ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"

DEPEND=">=sys-apps/portage-2.0.51_pre21
	>=dev-lang/python-2.0
	>=dev-lang/perl-5.6
	>=sys-apps/grep-2.4
	userland_GNU? ( sys-apps/debianutils )"

src_install() {
	make DESTDIR=${D} install-gentoolkit || die
}

pkg_preinst() {
	# FIXME: Remove from future ebuilds after gentoolkit-0.2.2 is stable
	rm -f ${ROOT}/usr/lib/gentoolkit/pym/gentoolkit.py[co] ${ROOT}/usr/lib/gentoolkit/pym/gentoolkit/*.py[co]
}

pkg_postinst() {
	python_mod_optimize ${ROOT}usr/lib/gentoolkit
	echo
	ewarn "The qpkg and etcat tools are deprecated in favor of equery and"
	ewarn "are no longer installed in ${ROOT}usr/bin in this release."
	ewarn "They are still available in ${ROOT}usr/share/doc/${PF}/deprecated/"
	ewarn "if you *really* want to use them."
	echo
	einfo "Another alternative to qpkg and equery are the q applets in"
	einfo "app-portage/portage-utils"
	echo
}

pkg_postrm() {
	python_mod_cleanup ${ROOT}usr/lib/gentoolkit
}
