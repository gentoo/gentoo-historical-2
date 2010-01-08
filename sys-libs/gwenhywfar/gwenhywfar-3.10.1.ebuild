# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/gwenhywfar/gwenhywfar-3.10.1.ebuild,v 1.4 2010/01/08 19:20:52 ssuominen Exp $

EAPI="2"

DESCRIPTION="A multi-platform helper library for other libraries"
HOMEPAGE="http://gwenhywfar.sourceforge.net"
SRC_URI="http://www2.aquamaniac.de/sites/download/download.php?package=01&release=27&file=01&dummy=${P}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~sparc x86"

IUSE="debug doc"

RDEPEND="net-libs/gnutls"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_configure() {
	econf \
		--enable-visibility \
		--enable-ssl \
		$(use_enable debug) \
		$(use_enable doc full-doc) \
		--with-docpath="/usr/share/doc/${PF}/apidoc" || die "configure failed"
}

src_compile() {
	emake || die "emake failed"
	if use doc ; then
		emake srcdoc || die "emake failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README* AUTHORS ChangeLog TODO || die "dodoc failed"
	if use doc ; then
		make DESTDIR="${D}" install-srcdoc || die "install doc failed"
	fi
	find "${D}" -name '*.la' -delete
}
