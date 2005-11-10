# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pcmcia-cs-cis/pcmcia-cs-cis-3.2.8-r1.ebuild,v 1.2 2005/11/10 13:26:03 brix Exp $

inherit linux-info

MY_P=${P/-cis/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="PCMCIA CIS files for use with pcmciautils"
HOMEPAGE="http://pcmcia-cs.sourceforge.net"
SRC_URI="mirror://sourceforge/pcmcia-cs/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

IUSE=""
DEPEND=">=sys-apps/hotplug-20040920
		!sys-apps/pcmcia-cs"

CONFIG_CHECK="PCMCIA_LOAD_CIS"
ERROR_PCMCIA_LOAD_CIS="${P} requires support for loading CIS updates from userspace (CONFIG_PCMCIA_LOAD_CIS)"

src_compile () {
	einfo "No compilation necessary."
}

src_install () {
	insinto /lib/firmware

	cd ${S}/etc/cis
	for file in *.dat; do
		newins ${file} ${file/.dat/.cis}
	done
}
