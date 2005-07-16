# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/gnumail/gnumail-1.2.0_pre20050414.ebuild,v 1.3 2005/07/16 15:43:56 swegener Exp $

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="Sophos.ca:/opt/cvsroot"
ECVS_USER="anoncvs"
ECVS_PASS="anoncvs"
ECVS_AUTH="pserver"
ECVS_MODULE="${PN/gnum/GNUM}"
ECVS_CO_OPTS="-P -D ${PV/*_pre}"
ECVS_UP_OPTS="-dP -D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/Sophos.ca-collaborationworld"
inherit gnustep cvs

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="A fully featured mail application for GNUstep"
HOMEPAGE="http://www.collaboration-world.com/gnumail/"

KEYWORDS="~x86 ~ppc"
LICENSE="GPL-2"
SLOT="0"

IUSE="crypt doc emoticon xface"
DEPEND="${GS_DEPEND}
	=gnustep-libs/pantomime-${PV}
	gnustep-apps/addresses"
RDEPEND="${GS_RDEPEND}
	crypt? ( app-crypt/gnupg )
	=gnustep-libs/pantomime-${PV}
	gnustep-apps/addresses"

egnustep_install_domain "Local"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	epatch ${FILESDIR}/Emoticon-dont-break-C.patch
}
src_compile() {
	egnustep_env
	egnustep_make

	if use xface ; then
		cd Bundles/Face
		egnustep_make
		cd ../..
	fi

	if use crypt ; then
		cd Bundles/PGP
		egnustep_make
		cd ../..
	fi

	if use emoticon ; then
		cd Bundles/Emoticon
		egnustep_make
		cd ../..
	fi
}

src_install() {
	egnustep_env
	egnustep_install
	if use doc ; then
		egnustep_env
		egnustep_doc || die
	fi

	use xface && cp -a ${S}/Bundles/Face/Face.bundle ${D}$(egnustep_install_domain)/Library/GNUMail/
	use crypt && cp -a ${S}/Bundles/PGP/PGP.bundle ${D}$(egnustep_install_domain)/Library/GNUMail/
	use emoticon && cp -a ${S}/Bundles/Emoticon/Emoticon.bundle ${D}$(egnustep_install_domain)/Library/GNUMail/

	egnustep_package_config
}

