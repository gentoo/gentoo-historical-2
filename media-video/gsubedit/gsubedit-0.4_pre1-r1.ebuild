# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/gsubedit/gsubedit-0.4_pre1-r1.ebuild,v 1.2 2004/06/18 20:04:22 dholm Exp $

inherit eutils

DESCRIPTION="A tool for editing and converting DivX ;-) subtitles"
HOMEPAGE="http://gsubedit.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P/_}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE="nls"

DEPEND="=x11-libs/gtk+-1.2*
		=gnome-base/gnome-libs-1*"

S=${WORKDIR}/${P/_}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/crashes.patch
}

src_compile() {
	econf `use_with nls` || die
	emake || die
}

src_install() {
	make DESTDIR=${D} gsubeditdocdir=/usr/share/doc/${PF} install || die
}
