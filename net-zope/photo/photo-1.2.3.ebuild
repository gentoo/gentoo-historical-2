# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/photo/photo-1.2.3.ebuild,v 1.5 2003/09/08 06:53:31 msterret Exp $

inherit zproduct

DESCRIPTION="Zope product for managing photos and photo albums"

HOMEPAGE="http://www.zope.org/Members/rbickers/Photo"
SRC_URI="mirror://sourceforge/zopephoto/Photo-${PV}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
RDEPEND="dev-python/Imaging-py21
	media-gfx/imagemagick
	${RDEPEND}"

ZPROD_LIST="Photo"
MYDOC="FAQ.txt THANKS.txt UPGRADE.txt DEPENDENCIES.txt ${MYDOC}"

