# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/ewl/ewl-0.0.3.20031206.ebuild,v 1.1 2003/12/07 08:39:57 vapier Exp $

EHACKAUTOGEN=y
inherit enlightenment flag-o-matic

DESCRIPTION="simple-to-use general purpose widget library"
HOMEPAGE="http://www.enlightenment.org/pages/ewl.html"

DEPEND=">=media-libs/edje-0.0.1.20031013
	>=dev-db/edb-1.0.4.20031013
	>=x11-libs/evas-1.0.0.20031020_pre12
	>=x11-libs/ecore-1.0.0.20031013_pre4
	>=dev-libs/ewd-0.0.1.20031013
	>=media-libs/etox-0.0.2.20031013"
