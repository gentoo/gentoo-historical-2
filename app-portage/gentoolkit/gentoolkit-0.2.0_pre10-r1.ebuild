# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/gentoolkit/gentoolkit-0.2.0_pre10-r1.ebuild,v 1.2 2005/01/01 15:52:50 eradicator Exp $

inherit eutils

DESCRIPTION="Collection of administration scripts for Gentoo"
HOMEPAGE="http://www.gentoo.org/proj/en/portage/tools/index.xml"
SRC_URI="mirror://gentoo/${P}.tar.gz http://dev.gentoo.org/~genone/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
#KEYWORDS="x86 ppc sparc mips alpha arm hppa amd64 ia64 ppc64 s390"
KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha ~arm ~hppa ~amd64 ~ia64 ~ppc64 ~s390 ~ppc-macos"

DEPEND=">=sys-apps/portage-2.0.51_pre21
	>=dev-lang/python-2.0
	>=dev-util/dialog-0.7
	>=dev-lang/perl-5.6
	>=sys-apps/grep-2.4
	sys-apps/debianutils"

src_install() {
	# patch taken from cvs
	epatch ${FILESDIR}/qpkg-security-fix-68846.diff
	make DESTDIR=${D} install-gentoolkit || die
}

pkg_postinst() {
	einfo "The following older scripts have been removed in this release:"
	einfo "    dep-clean, ewhich, mkebuild, pkg-clean, pkg-size"
}
