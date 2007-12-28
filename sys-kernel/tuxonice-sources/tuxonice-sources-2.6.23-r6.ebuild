# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/tuxonice-sources/tuxonice-sources-2.6.23-r6.ebuild,v 1.2 2007/12/28 12:31:50 maekke Exp $

ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="6"

inherit kernel-2
detect_version
detect_arch

DESCRIPTION="TuxOnIce + Gentoo patchset sources"
HOMEPAGE="http://dev.gentoo.org/~dsd/genpatches http://www.tuxonice.net"

TUXONICE_VERSION="3.0-rc3"
TUXONICE_TARGET="2.6.23.9"
TUXONICE_SRC="tuxonice-${TUXONICE_VERSION}-for-${TUXONICE_TARGET}"
TUXONICE_URI="http://www.tuxonice.net/downloads/all/${TUXONICE_SRC}.patch.bz2"

UNIPATCH_LIST="${DISTDIR}/${TUXONICE_SRC}.patch.bz2"
UNIPATCH_STRICTORDER="yes"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${TUXONICE_URI}"

KEYWORDS="~amd64 x86"

RDEPEND="${RDEPEND}
		>=sys-apps/tuxonice-userui-0.7.2
		>=sys-power/hibernate-script-1.97"

K_EXTRAEINFO="If there are issues with this kernel, please direct any
queries to the tuxonice-users mailing list:
http://lists.tuxonice.net/mailman/listinfo/tuxonice-users/"

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}
