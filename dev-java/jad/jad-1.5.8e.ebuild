# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jad/jad-1.5.8e.ebuild,v 1.2 2004/05/19 04:26:44 zx Exp $

DESCRIPTION="Jad - The fast JAva Decompiler"
HOMEPAGE="http://www.kpdus.com/jad"
SRC_URI="http://www.kpdus.com/jad/linux/jadls158.zip"
DEPEND=""
KEYWORDS="x86"
SLOT="0"
LICENSE="freedist"
IUSE=""

S=${WORKDIR}

src_install () {
	into /opt
	dobin jad
	dodoc Readme.txt
}
