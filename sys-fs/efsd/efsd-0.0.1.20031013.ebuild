# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/efsd/efsd-0.0.1.20031013.ebuild,v 1.4 2004/06/24 22:50:52 agriffis Exp $

inherit enlightenment

DESCRIPTION="daemon that provides commonly needed file system functionality to clients"
HOMEPAGE="http://www.enlightenment.org/pages/efsd.html"

DEPEND="${DEPEND}
	dev-lang/perl"
RDEPEND="${DEPEND}
	app-admin/fam
	>=dev-libs/libxml2-2.3.10
	>=dev-db/edb-1.0.4.20031013"
