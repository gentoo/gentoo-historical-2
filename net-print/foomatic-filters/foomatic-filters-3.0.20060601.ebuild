# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/foomatic-filters/foomatic-filters-3.0.20060601.ebuild,v 1.1 2006/06/04 14:53:45 genstef Exp $

inherit eutils versionator autotools

MY_P=${PN}-$(replace_version_separator 2 '-')
DESCRIPTION="Foomatic wrapper scripts"
HOMEPAGE="http://www.linuxprinting.org/foomatic.html"
SRC_URI="http://gentooexperimental.org/~genstef/dist/${MY_P}.tar.gz"
# http://www.linuxprinting.org/download/foomatic/

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="cups"

RDEPEND="cups? ( >=net-print/cups-1.1.19 )
	dev-lang/perl
	|| (
		app-text/enscript
		net-print/cups
		app-text/a2ps
		app-text/mpage
	)
	virtual/ghostscript"
S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${S}
	# Search for libs in ${libdir}, not just /usr/lib
	epatch ${FILESDIR}/${P}-multilib.patch
	eautoreconf || die "eautoreconf failed"
}

src_compile() {
	export CUPS_BACKENDS=$(cups-config --serverbin)/backend \
		CUPS_FILTERS=$(cups-config --serverbin)/filter CUPS=$(cups-config --serverbin)
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	dosym /usr/bin/foomatic-rip /usr/bin/lpdomatic

	if use cups; then
		dosym /usr/bin/foomatic-gswrapper $(cups-config --serverbin)/filter/foomatic-gswrapper
		dosym /usr/bin/foomatic-rip $(cups-config --serverbin)/filter/cupsomatic
	else
		rm -r ${D}/$(cups-config --serverbin)/filter
	fi
}
