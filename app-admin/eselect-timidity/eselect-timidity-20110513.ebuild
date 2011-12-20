# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-timidity/eselect-timidity-20110513.ebuild,v 1.3 2011/12/20 20:54:45 jer Exp $

DESCRIPTION="Manages configuration of TiMidity++ patchsets"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/timidity.eselect-${PVR}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2.3"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}/timidity.eselect-${PVR}" timidity.eselect || die
}
