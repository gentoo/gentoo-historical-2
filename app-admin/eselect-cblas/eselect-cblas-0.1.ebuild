# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-cblas/eselect-cblas-0.1.ebuild,v 1.8 2006/09/19 18:48:11 kugelfang Exp $

inherit eutils

DESCRIPTION="C-language BLAS module for eselect"
HOMEPAGE="http://www.gentoo.org/proj/en/eselect/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

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
