# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-timidity/eselect-timidity-20061203.ebuild,v 1.2 2006/12/06 03:33:46 weeve Exp $

DESCRIPTION="Manages configuration of TiMidity++ patchsets"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/timidity.eselect-${PVR}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=app-admin/eselect-1.0.2"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}/timidity.eselect-${PVR}" timidity.eselect || die
}
