# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/rdiff-backup/rdiff-backup-0.13.4.ebuild,v 1.8 2005/01/21 21:11:29 gustavoz Exp $

inherit distutils

DESCRIPTION="Remote incremental file backup utility, similar to rsync but more reliable"
HOMEPAGE="http://rdiff-backup.stanford.edu/"
SRC_URI="http://rdiff-backup.stanford.edu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc sparc x86"
IUSE=""

RDEPEND=">=net-libs/librsync-0.9.6"
