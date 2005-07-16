# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/gorm/gorm-0.9.10.ebuild,v 1.2 2005/07/16 15:48:33 swegener Exp $

inherit gnustep

S=${WORKDIR}/${P/g/G}

IUSE="doc"
DESCRIPTION="Gorm is a clone of the NeXTstep Interface Builder application for GNUstep."
HOMEPAGE="http://www.gnustep.org/experience/Gorm.html"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/dev-apps/${P/g/G}.tar.gz"

KEYWORDS="~x86 ~ppc"
LICENSE="GPL-2"
SLOT="0"

DEPEND="${GS_DEPEND}
	doc? ( sys-apps/sed )"
RDEPEND="${GS_RDEPEND}"

egnustep_install_domain "Local"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "/DOCUMENT_NAME =.*/a \Gorm_DOC_INSTALL_DIR=Developer/Gorm" \
		-e "/DOCUMENT_TEXT_NAME =.*/a \ANNOUNCE_DOC_INSTALL_DIR=Developer/Gorm/ReleaseNotes" \
		-e "/DOCUMENT_TEXT_NAME =.*/a \README_DOC_INSTALL_DIR=Developer/Gorm/ReleaseNotes" \
		-e "/DOCUMENT_TEXT_NAME =.*/a \NEWS_DOC_INSTALL_DIR=Developer/Gorm/ReleaseNotes" \
		-e "/DOCUMENT_TEXT_NAME =.*/a \INSTALL_DOC_INSTALL_DIR=Developer/Gorm/ReleaseNotes" \
		${S}/Documentation/GNUmakefile
}
