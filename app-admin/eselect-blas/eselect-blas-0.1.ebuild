# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-blas/eselect-blas-0.1.ebuild,v 1.22 2011/08/17 16:40:20 chithanh Exp $

DESCRIPTION="BLAS module for eselect"
HOMEPAGE="http://www.gentoo.org/proj/en/eselect/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE=""

# Need skel.bash lib
RDEPEND=">=app-admin/eselect-1.0.5"
DEPEND="${RDEPEND}"

src_install() {
	local MODULEDIR="/usr/share/eselect/modules"
	local MODULE="blas"
	insinto ${MODULEDIR}
	newins "${FILESDIR}"/${MODULE}.eselect-${PVR} ${MODULE}.eselect
	doman "${FILESDIR}"/blas.eselect.5
}
