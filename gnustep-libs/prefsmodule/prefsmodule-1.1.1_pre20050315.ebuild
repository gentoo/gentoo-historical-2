# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-libs/prefsmodule/prefsmodule-1.1.1_pre20050315.ebuild,v 1.3 2006/03/25 19:53:32 grobian Exp $

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="cvs.savannah.nongnu.org:/sources/backbone"
ECVS_USER="anoncvs"
ECVS_PASS="anoncvs"
ECVS_AUTH="pserver"
ECVS_MODULE="System"
ECVS_CO_OPTS="-P -D ${PV/*_pre}"
ECVS_UP_OPTS="-dP -D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/cvs.savannah.nongnu.org-backbone"
inherit gnustep cvs

S=${WORKDIR}/${ECVS_MODULE}/Frameworks/${PN/prefsm/PrefsM}

DESCRIPTION="Preferences is the GNUstep program with which you define your own personal user experience."
HOMEPAGE="http://www.nongnu.org/backbone/apps.html"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
SLOT="0"

IUSE=""
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

egnustep_install_domain "System"
