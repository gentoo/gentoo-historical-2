# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/desktop/desktop-0.7_pre20041203.ebuild,v 1.2 2005/01/10 16:27:04 fafhrd Exp $

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="savannah.gnu.org:/cvsroot/gnustep"
ECVS_USER="anoncvs"
ECVS_AUTH="ext"
ECVS_MODULE="gnustep/usr-apps/gworkspace/${PN/d/D}"
ECVS_CO_OPTS="-P -D ${PV/*_pre}"
ECVS_UP_OPTS="-dP -D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/savannah.gnu.org-gnustep"
inherit gnustep cvs

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="A desktop manager for GNUstep."
HOMEPAGE="http://www.gnustep.it/enrico/gworkspace/"

KEYWORDS="~x86 ~ppc"
LICENSE="GPL-2"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}
	gnustep-apps/gworkspace"
RDEPEND="${GS_RDEPEND}
	gnustep-apps/gworkspace
	gnustep-apps/recycler"

egnustep_install_domain "System"

src_compile() {
	egnustep_env
	EPATCH_OPTIONS="-d ${S}" epatch ${FILESDIR}/seperate-build.patch
	egnustep_make
}

