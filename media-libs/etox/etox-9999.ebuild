# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/etox/etox-9999.ebuild,v 1.2 2004/12/27 14:41:52 vapier Exp $

EHACKAUTOGEN=yes
inherit enlightenment

DESCRIPTION="type setting and text layout library"
HOMEPAGE="http://www.enlightenment.org/pages/etox.html"

DEPEND=">=x11-libs/evas-1.0.0.20041031_pre13
	>=x11-libs/ecore-1.0.0.20041031_pre7
	>=dev-db/edb-1.0.5.20041031"
