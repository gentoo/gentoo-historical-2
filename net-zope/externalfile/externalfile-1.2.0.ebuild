# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/externalfile/externalfile-1.2.0.ebuild,v 1.2 2004/06/25 01:20:20 agriffis Exp $

inherit zproduct

NEW_PV="${PV//./-}"

RESTRICT="nomirror"
DESCRIPTION="ExternalFile extends Zope to work with files in the filesystem. You can create instances of ExternalFile that behave like standard Zope objects except that they get their contents from a file located anywhere in a Zope-accessable filesystem."
HOMEPAGE="http://www.zope.org/Members/arielpartners/ExternalFile"
SRC_URI="${HOMEPAGE}/${PV}/ExternalFile-${NEW_PV}.zip"
LICENSE="ZPL"
KEYWORDS="x86 ~ppc"
RDEPEND=">=net-zope/zope
	${RDEPEND}"
