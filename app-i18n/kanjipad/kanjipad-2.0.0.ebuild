# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/kanjipad/kanjipad-2.0.0.ebuild,v 1.7 2004/10/27 03:10:19 tgall Exp $

DESCRIPTION="Japanese handwriting recognition tool"
HOMEPAGE="http://fishsoup.net/software/kanjipad/"
SRC_URI="http://fishsoup.net/software/kanjipad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc64"
IUSE=""

DEPEND=">=x11-libs/gtk+-2
	>=dev-libs/glib-2"

src_compile() {
	perl -i -pe "s|PREFIX=/usr/local|PREFIX=/usr|;
		s|-DG.*DISABLE_DEPRECATED||g" Makefile || die

	emake || die
}

src_install() {
	dobin kanjipad kpengine || die
	insinto /usr/share/kanjipad
	doins jdata.dat || die
	dodoc ChangeLog README TODO jstroke/README-kanjipad
}
