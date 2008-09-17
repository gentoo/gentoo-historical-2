# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-ecj/eselect-ecj-0.3.ebuild,v 1.2 2008/09/17 21:04:09 maekke Exp $

EAPI=1

DESCRIPTION="Manages ECJ symlinks"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=app-admin/eselect-1.0.10"
PDEPEND="
|| (
	dev-java/eclipse-ecj:3.4
	>=dev-java/eclipse-ecj-3.3.0-r2:3.3
	>=dev-java/eclipse-ecj-3.2.2-r1:3.2
)"

src_install() {
	insinto /usr/share/eselect/modules
	doins "${FILESDIR}/ecj.eselect" || die "doins failed"
}
