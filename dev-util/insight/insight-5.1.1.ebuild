# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/insight/insight-5.1.1.ebuild,v 1.10 2004/06/25 02:36:29 agriffis Exp $

IUSE="nls"

DESCRIPTION="A graphical interface to the GNU debugger"
HOMEPAGE="http://sources.redhat.com/insight/index.html"
SRC_URI="ftp://sources.redhat.com/pub/gdb/releases/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="x86 sparc "

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}
	nls? ( sys-devel/gettext )"

INSIGHTDIR="/opt/insight"

src_compile() {
	local myconf
	use nls || myconf="--disable-nls"

	econf ${myconf} || die
	emake || die
}

src_install () {
	make prefix="${D}${INSIGHTDIR}" install || die
	dosym /opt/insight/bin/gdb /opt/insight/bin/insight
	insinto /etc/env.d
	doins "${FILESDIR}/99insight"
}
