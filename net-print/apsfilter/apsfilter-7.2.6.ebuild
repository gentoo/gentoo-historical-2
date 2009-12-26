# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/apsfilter/apsfilter-7.2.6.ebuild,v 1.2 2009/12/26 17:42:26 pva Exp $

DESCRIPTION="Apsfilter Prints So Fine, It Leads To Extraordinary Results"
HOMEPAGE="http://www.apsfilter.org"
KEYWORDS="~x86 ~ppc ~alpha ~sparc"
IUSE="cups"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/lpr
	app-text/ghostscript-gpl
	>=app-text/psutils-1.17
	>=media-gfx/imagemagick-5.4.5
	>=app-text/a2ps-4.13b-r4
	>=sys-apps/gawk-3.1.0-r1
	virtual/mta"

SRC_URI="http://www.apsfilter.org/download/${P}.tar.bz2"
S=${WORKDIR}/apsfilter

src_compile() {
	cd ${S}

	# assume thet lprng is installed if cups isn't USEd
	use cups && \
	    myconf="--with-printcap=/etc/cups/printcap --with-spooldir=/var/spool/cups" || \
	    myconf="--with-printcap=/etc/lprng/printcap"
	./configure --prefix=/usr ${myconf} || die 'configure failed'

	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dosym /usr/share/apsfilter/SETUP /usr/bin/apsfilter
	use cups && \
	    dosym /etc/cups/printcap /etc/printcap || \
	    dosym /etc/lprng/printcap /etc/printcap
}
