# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/x11-base/opengl-update/opengl-update-1.3.ebuild,v 1.3 2002/07/11 06:30:56 drobbins Exp $

S=${WORKDIR}/${P}
SLOT="0"
KEYWORDS="x86"
DESCRIPTION="Utility to change the OpenGL interface being used."
SRC_URI=""
HOMEPAGE="http://"

DEPEND=""


src_install() {

	newsbin ${FILESDIR}/opengl-update-${PV} opengl-update
}

