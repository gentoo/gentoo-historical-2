# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/tdb/tdb-1.0.0.ebuild,v 1.2 2009/10/11 20:15:17 dev-zero Exp $

EAPI="2"

DESCRIPTION="Virtual for tdb"
HOMEPAGE="http://tdb.samba.org/"
SRC_URI=""
LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64 ~x86"
IUSE=""

RDEPEND="|| ( >=net-fs/samba-libs-3.4.2[tdb] sys-libs/tdb )"
DEPEND=""
