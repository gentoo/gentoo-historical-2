# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/silvametadata/silvametadata-0.8.ebuild,v 1.1.1.1 2005/11/30 10:11:02 chriswhite Exp $

inherit zproduct

DESCRIPTION="Silva Metadata can be used to create metadata sets and associate these with Zope object types."
HOMEPAGE="http://www.infrae.com/download/SilvaMetadata"
SRC_URI="${HOMEPAGE}/${PV}/SilvaMetadata-${PV}.tgz"
LICENSE="ZPL"
KEYWORDS="x86 ~ppc ~amd64"
IUSE=""

ZPROD_LIST="SilvaMetadata"
