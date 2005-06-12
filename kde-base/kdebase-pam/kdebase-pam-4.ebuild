# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebase-pam/kdebase-pam-4.ebuild,v 1.11 2005/06/12 23:29:53 kloeri Exp $

DESCRIPTION="pam.d files used by several kdebase-derived packages"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ~ppc ppc64 sparc x86"
IUSE=""
HOMEPAGE="http://www.kde.org"

DEPEND="sys-libs/pam"

src_install() {
	insinto /etc/pam.d
	newins "${FILESDIR}"/kde.pam kde
	newins "${FILESDIR}"/kde-np.pam kde-np
}
