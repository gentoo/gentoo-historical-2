# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/mdadm/mdadm-1.9.0.ebuild,v 1.1 2005/02/19 17:42:07 vapier Exp $

inherit eutils

DESCRIPTION="A useful tool for running RAID systems - it can be used as a replacement for the raidtools"
HOMEPAGE="http://cgi.cse.unsw.edu.au/~neilb/mdadm"
SRC_URI="mirror://kernel/utils/raid/mdadm/${P}.tgz
	http://neilb.web.cse.unsw.edu.au/source/mdadm/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="static"

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	>=sys-apps/portage-2.0.51"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}"/${P}-dont-make-man.patch
	if use static ; then
		sed -i \
			-e "/^# LDFLAGS = -static/s:#::" \
			Makefile || die "sed Makefile failed"
	fi
}

src_compile() {
	emake CXFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc INSTALL TODO "ANNOUNCE-${PV}"

	insinto /etc
	newins mdadm.conf-example mdadm.conf
	newinitd ${FILESDIR}/mdadm.rc mdadm
}
