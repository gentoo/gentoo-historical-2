# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-libs/gdl2/gdl2-0.9.2_pre20050312.ebuild,v 1.2 2005/08/25 19:03:48 swegener Exp $

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="savannah.gnu.org:/cvsroot/gnustep"
ECVS_USER="anoncvs"
ECVS_AUTH="ext"
ECVS_MODULE="gnustep/dev-libs/${PN}"
ECVS_CO_OPTS="-P -D ${PV/*_pre}"
ECVS_UP_OPTS="-dP -D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/savannah.gnu.org-gnustep"
inherit gnustep cvs eutils

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="The GNUstep Database Library 2 (GDL2) is a set of libraries to map Objective-C objects to rows of relational database management systems (RDBMS)."
HOMEPAGE="http://www.gnustep.org"

KEYWORDS="~ppc"
LICENSE="LGPL-2.1"
SLOT="0"

IUSE=""
DEPEND="${GS_DEPEND}
	!gnustep-apps/sope
	dev-db/postgresql"
RDEPEND="${GS_RDEPEND}
	!gnustep-apps/sope
	dev-db/postgresql"

egnustep_install_domain "System"

src_compile() {
	cd ${S}
	egnustep_env
	econf "--prefix=$(egnustep_prefix)" || die "./configure failed"
	egnustep_make || die
}
