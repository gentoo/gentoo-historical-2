# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/insight/insight-6.4.ebuild,v 1.10 2006/09/25 08:44:07 blubb Exp $

inherit eutils

IUSE="nls"

DESCRIPTION="A graphical interface to the GNU debugger"
HOMEPAGE="http://sources.redhat.com/insight/"
LICENSE="GPL-2 LGPL-2"
DEPEND="|| ( ( x11-libs/libXt x11-libs/libX11 ) virtual/x11 )
	nls? ( sys-devel/gettext )
	sys-libs/ncurses"
RDEPEND="sys-libs/ncurses
	|| ( x11-libs/libX11 virtual/x11 )"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc sparc ~x86"
SRC_URI="ftp://sources.redhat.com/pub/${PN}/releases/${P}.tar.bz2"

INSIGHTDIR="/opt/insight"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s/relid'/relid/" {tcl,tk}/unix/configure
}

src_compile() {
	local myconf
	myconf="$(use_enable nls)"

	./configure --prefix="${INSIGHTDIR}" \
		--mandir="${D}${INSIGHTDIR}/share/man"	\
		--infodir="${D}${INSIGHTDIR}/share/info"	\
		${myconf} || die
	emake || die
}

src_install () {
	make \
		prefix="${D}${INSIGHTDIR}" \
		mandir="${D}${INSIGHTDIR}/share/man" \
		infodir="${D}${INSIGHTDIR}/share/info" \
		install || die
	insinto /etc/env.d
	doins "${FILESDIR}/99insight"
}
