# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/vlevel/vlevel-0.5.ebuild,v 1.1 2004/10/06 14:38:38 trapni Exp $

DESCRIPTION="VLevel is a dynamic compressor which amplifies the quiet parts of music. It's currently a LADSPA plugin and a command-line filter."
HOMEPAGE="http://vlevel.sourceforge.net/"
SRC_URI="mirror://sourceforge/vlevel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86"
IUSE=""

DEPEND="media-libs/ladspa-sdk"

src_compile() {
	emake CXXFLAGS="$CXXFLAGS -fPIC -DPIC" || die "emake failed"
}

src_install() {
	dodir "/usr/bin" || die
	einstall PREFIX="${D}/usr/bin/" LADSPA_PREFIX="${D}/usr/lib/ladspa/" || die
	dodoc COPYING INSTALL README TODO docs/notes.txt docs/technical.txt || die
	dodir "/usr/share/doc/${P}/examples" || die
	cp utils/* "${D}/usr/share/doc/${P}/examples/" || die
	chmod 644 "${D}/usr/share/doc/${P}/examples/"* || die
	gzip -9 "${D}/usr/share/doc/${P}/examples/README" || die
}

