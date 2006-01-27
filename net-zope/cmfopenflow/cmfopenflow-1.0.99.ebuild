# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/cmfopenflow/cmfopenflow-1.0.99.ebuild,v 1.3 2006/01/27 02:29:27 vapier Exp $

inherit zproduct

DESCRIPTION="CMFOpenflow, also known as: 'reflow' Activity based workflow, is an object oriented workflow engine"
HOMEPAGE="http://www.reflab.com/community/Openprojects/CMFOpenflow/"
SRC_URI="http://www.reflab.com/community/Openprojects/CMFOpenflow/Reflow.downloads/Reflow_${PV}"

LICENSE="GPL-2"
KEYWORDS="~x86"

ZPROD_LIST="CMFOpenflow"

src_unpack() {
	tar -xzf ${DISTDIR}/Reflow_${PV} || die
}
