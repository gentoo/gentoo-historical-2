# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/gwnet/gwnet-0.1.0.7.1.ebuild,v 1.2 2005/06/06 07:12:48 fafhrd Exp $

inherit gnustep

S=${WORKDIR}/GWorkspace-${PV/0.1.}/${PN/gwn/GWN}

DESCRIPTION="A GNUstep network filesystem file browser."
HOMEPAGE="http://www.gnustep.it/enrico/gworkspace/"
SRC_URI="http://www.gnustep.it/enrico/gworkspace/gworkspace-${PV/0.1.}.tar.gz"

KEYWORDS="x86 ~ppc"
LICENSE="GPL-2"
SLOT="0"

IUSE="${IUSE}"
# Yes, currently this app does not optional depend on smb, it requires it
DEPEND="${GS_DEPEND}
	gnustep-libs/smbkit"
RDEPEND="${GS_RDEPEND}
	gnustep-libs/smbkit"

egnustep_install_domain "System"

