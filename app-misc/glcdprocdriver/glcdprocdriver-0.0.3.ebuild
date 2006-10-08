# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/glcdprocdriver/glcdprocdriver-0.0.3.ebuild,v 1.1 2006/10/08 11:37:04 jokey Exp $

inherit eutils flag-o-matic

DESCRIPTION="Glue library for the glcdlib LCDproc driver based on GraphLCD"
HOMEPAGE="http://www.muresan.de/graphlcd/lcdproc"
SRC_URI="http://www.muresan.de/graphlcd/lcdproc/${P}.tar.bz2"

KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-2"

S=${WORKDIR}/${P}

DEPEND=">=app-misc/graphlcd-base-0.1.3"
RDEPEND=${DEPEND}

IUSE=""

src_unpack()
{
	unpack ${A}
	cd "${S}"

	# use CFLAGS defined in /etc/make.conf instead of the ones in Make.config
	sed -i ${S}/Make.config -e "s:FLAGS *=:FLAGS ?=:"
}

src_compile()
{
	append-flags -fPIC

	emake || die "make failed"
}

src_install()
{
	emake DESTDIR=${D}/usr install || die "make install failed"
	dodoc AUTHORS README INSTALL TODO ChangeLog
}
