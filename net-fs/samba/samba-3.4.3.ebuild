# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/samba/samba-3.4.3.ebuild,v 1.4 2009/11/30 16:38:54 armin76 Exp $

EAPI="2"

DESCRIPTION="Meta package for samba-{libs,client,server}"
HOMEPAGE="http://www.samba.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="+client +server"

DEPEND=""
RDEPEND="~net-fs/samba-libs-${PV}
	client? ( ~net-fs/samba-client-${PV} )
	server? ( ~net-fs/samba-server-${PV} )"
