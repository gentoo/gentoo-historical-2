# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/rdiff-backup/rdiff-backup-1.0.1-r1.ebuild,v 1.1 2005/09/21 20:43:51 robbat2 Exp $

inherit distutils

DESCRIPTION="Remote incremental file backup utility; uses librsync's rdiff utility to create concise, versioned backups."
HOMEPAGE="http://www.nongnu.org/rdiff-backup/"
SRC_URI="http://savannah.nongnu.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acl xattr"

DEPEND=">=net-libs/librsync-0.9.7
		xattr? ( dev-python/pyxattr )
		acl? ( dev-python/pylibacl )"
RDEPEND="${DEPEND}"
