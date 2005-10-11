# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/sword/sword-1.5.8.ebuild,v 1.2 2005/10/11 10:33:49 greg_g Exp $

DESCRIPTION="Library for Bible reading software."
HOMEPAGE="http://www.crosswire.org/sword/"
SRC_URI="http://www.crosswire.org/ftpmirror/pub/sword/source/v1.5/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="curl icu debug"

RDEPEND="sys-libs/zlib
	curl? ( net-misc/curl )
	icu? ( dev-libs/icu )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	local myconf="--without-lucene --with-zlib --with-conf
	              $(use_enable debug) $(use_with curl)"

	econf ${myconf} || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS CODINGSTYLE ChangeLog README

	cp -R samples examples ${D}/usr/share/doc/${PF}/
}

pkg_postinst() {
	echo
	einfo "Check out http://www.crosswire.org/sword/modules/"
	einfo "to download modules that you would like to use the"
	einfo "library with.  Follow module installation instructions"
	einfo "found on the web or in /usr/share/doc/${PF}/INSTALL.gz."
	echo
}
