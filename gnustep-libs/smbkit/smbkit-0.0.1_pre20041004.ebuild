# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-libs/smbkit/smbkit-0.0.1_pre20041004.ebuild,v 1.2 2004/10/17 09:41:18 dholm Exp $

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="savannah.gnu.org:/cvsroot/gnustep"
ECVS_USER="anoncvs"
ECVS_AUTH="ext"
ECVS_MODULE="gnustep/dev-libs/${PN/smbk/SMBK}"
ECVS_CO_OPTS="-D ${PV/*_pre}"
ECVS_UP_OPTS="-D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/savannah.gnu.org-gnustep"
inherit gnustep cvs

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="SMBKit offers a samba library and headers for GNUstep."
HOMEPAGE="http://www.gnustep.org"

KEYWORDS="~x86 ~ppc"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}
	net-fs/samba"
RDEPEND="${GS_RDEPEND}
	net-fs/samba"

