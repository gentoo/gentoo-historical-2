# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-cblas/eselect-cblas-0.1.ebuild,v 1.16 2007/09/26 14:23:25 armin76 Exp $

inherit eutils

DESCRIPTION="C-language BLAS module for eselect"
HOMEPAGE="http://www.gentoo.org/proj/en/eselect/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"

IUSE=""
# Need skel.bash lib
RDEPEND=">=app-admin/eselect-1.0.5"
DEPEND="${RDEPEND}"

src_install() {
	local MODULEDIR="/usr/share/eselect/modules"
	local MODULE="cblas"
	dodir ${MODULEDIR}
	insinto ${MODULEDIR}
	newins ${FILESDIR}/${MODULE}.eselect-${PVR} ${MODULE}.eselect
	doman ${FILESDIR}/cblas.eselect.5
}
